# 🚀 LeetCode 0056 - Merge Intervals

## 📝 Problem Statement

Given an array of `intervals` where $\text{intervals}[i] = [\text{start}_i, \text{end}_i]$, merge all overlapping intervals, and return *an array of the non-overlapping intervals that cover all the intervals in the input*.

---

## 🔒 Constraints

- $1 \le \text{intervals.length} \le 10^4$
- $\text{intervals}[i].\text{length} == 2$
- $0 \le \text{start}_i \le \text{end}_i \le 10^4$

---

## 💡 Examples

### Example 1
```text
Input: intervals = [[1,3],[2,6],[8,10],[15,18]]
Output: [[1,6],[8,10],[15,18]]
Explanation: Since intervals [1,3] and [2,6] overlap, merge them into [1,6].
```

### Example 2
```text
Input: intervals = [[1,4],[4,5]]
Output: [[1,5]]
Explanation: Intervals [1,4] and [4,5] are considered overlapping (shared boundary).
```

### Example 3
```text
Input: intervals = [[4,7],[1,4]]
Output: [[1,7]]
Explanation: Unsorted input where [1,4] and [4,7] overlap to form [1,7].
```

---

# 📐 Core Mathematical Intuition: The 3 Overlap Configurations

When two intervals $A = [s_1, e_1]$ and $B = [s_2, e_2]$ are ordered such that **$s_1 \le s_2$**, there are only **3 mutually exclusive configurations**:

```text
Case 1: Disjoint (No Overlap)
   A: [-------]
   B:           [-------]
   Condition:  s2 > e1
   Action:     B starts a new independent interval.

Case 2: Partial Overlap
   A: [-----------]
   B:       [-----------]
   Condition:  s2 <= e1 AND e2 > e1
   Action:     Merge by extending the right bound: [s1, e2].

Case 3: Complete Enclosure
   A: [-----------------]
   B:       [-----]
   Condition:  s2 <= e1 AND e2 <= e1
   Action:     A fully absorbs B: [s1, e1] (end remains e1).
```

### The Invariant:
By sorting intervals primarily by **start time ascending**, we guarantee that for every subsequent interval $i$:
$$s_i \ge s_{\text{previous}}$$
Thus, interval $i$ can **only** overlap with the immediately preceding interval in our merged sequence. It can never reach back and overlap with earlier disjoint intervals!

---

# 🧠 Evolution of Solutions: How We Make It Better

```text
┌────────────────────────────────────────────────────────────────────────┐
│  1. Graph Connected Components                                         │
│     • Build an undirected graph where edge (u, v) exists if u and v    │
│       overlap: max(s_u, s_v) <= min(e_u, e_v)                          │
│     • Find connected components via BFS/DFS; merge each component      │
│     • Time: O(N^2) | Space: O(N^2) graph edges                         │
│     • Bottleneck: Excessive quadratic comparisons and graph allocation │
└──────────────────────────────────┬─────────────────────────────────────┘
                                   │
                                   ▼ Counting Sort / Bucket Array
┌────────────────────────────────────────────────────────────────────────┐
│  2. Direct Coordinate Buckets (Line Sweep)                             │
│     • For small coordinates (max <= 10^4): maxEnd[start] = max(ends)   │
│     • Sweep through coordinate range 0..10^4                           │
│     • Time: O(N + M) where M = max_coord | Space: O(M)                 │
│     • Bottleneck: Only works when coordinate values are small (<= 10^4)│
└──────────────────────────────────┬─────────────────────────────────────┘
                                   │
                                   ▼ Sorting + Linear Scan
┌────────────────────────────────────────────────────────────────────────┐
│  3. Sort by Start Time + Single Linear Pass (Optimal & Gold Standard)  │
│     • Sort intervals by start ascending: O(N log N)                    │
│     • Single pass: if current[0] <= last[1], merge; else push new      │
│     • Works universally for any coordinate range (even 64-bit ints)    │
│     • Time: O(N log N) | Space: O(N) output / O(log N) auxiliary       │
│     • Improvement: Clean, universally optimal, handles all edge cases  │
└────────────────────────────────────────────────────────────────────────┘
```

---

# 💻 Solutions

## 1. Approach 1: Graph Connected Components ($O(N^2)$ Time, $O(N^2)$ Space)

Treats each interval as a node in an undirected graph, adding an edge between any two intervals that overlap, and uses DFS to merge each connected component:

```dart
class SolutionGraph {
  bool _overlaps(List<int> a, List<int> b) {
    return a[0] <= b[1] && b[0] <= a[1];
  }

  List<List<int>> merge(List<List<int>> intervals) {
    final int n = intervals.length;
    final Map<int, List<int>> graph = {for (int i = 0; i < n; i++) i: []};

    // Build overlap graph
    for (int i = 0; i < n; i++) {
      for (int j = i + 1; j < n; j++) {
        if (_overlaps(intervals[i], intervals[j])) {
          graph[i]!.add(j);
          graph[j]!.add(i);
        }
      }
    }

    final List<bool> visited = List<bool>.filled(n, false);
    final List<List<int>> merged = [];

    for (int i = 0; i < n; i++) {
      if (!visited[i]) {
        int minStart = intervals[i][0];
        int maxEnd = intervals[i][1];

        // DFS to find all connected intervals
        final List<int> stack = [i];
        visited[i] = true;

        while (stack.isNotEmpty) {
          final curr = stack.removeLast();
          if (intervals[curr][0] < minStart) minStart = intervals[curr][0];
          if (intervals[curr][1] > maxEnd) maxEnd = intervals[curr][1];

          for (final neighbor in graph[curr]!) {
            if (!visited[neighbor]) {
              visited[neighbor] = true;
              stack.add(neighbor);
            }
          }
        }

        merged.add([minStart, maxEnd]);
      }
    }

    return merged;
  }
}
```

### 🔴 Bottlenecks:
- $O(N^2)$ time to test all pairs of intervals.
- $O(N^2)$ space to store adjacency lists.

---

## 2. Approach 2: In-Place Mutation on Sorted List ($O(N \log N)$ Time, $O(1)$ Auxiliary Space)

Sorts the list and merges overlapping intervals directly into the existing list buffer using a write pointer, without allocating a separate list:

```dart
class SolutionInPlace {
  List<List<int>> merge(List<List<int>> intervals) {
    if (intervals.length <= 1) return intervals;

    intervals.sort((a, b) => a[0].compareTo(b[0]));

    int writeIdx = 0;

    for (int i = 1; i < intervals.length; i++) {
      if (intervals[i][0] <= intervals[writeIdx][1]) {
        if (intervals[i][1] > intervals[writeIdx][1]) {
          intervals[writeIdx][1] = intervals[i][1];
        }
      } else {
        writeIdx++;
        intervals[writeIdx] = intervals[i];
      }
    }

    return intervals.sublist(0, writeIdx + 1);
  }
}
```

### 🟢 Value:
- Demonstrates in-place array manipulation with $O(1)$ auxiliary memory (excluding the output slice).

---

## 3. Approach 3: Sort by Start Coordinate + Linear Scan (Optimal & Gold Standard)

The canonical, interview-standard algorithm:

```dart
// LeetCode 0056: Merge Intervals
// Optimal Solution: Sort by Start Coordinate + Single Linear Merge Scan
// Time Complexity: O(N log N) where N = intervals.length (dominated by sorting)
// Space Complexity: O(N) for the output list (or O(log N) auxiliary sorting space)

class Solution {
  List<List<int>> merge(List<List<int>> intervals) {
    if (intervals.length <= 1) return intervals;

    // 1. Sort intervals ascending by start time
    intervals.sort((a, b) => a[0].compareTo(b[0]));

    final List<List<int>> merged = [];
    // Initialize merged list with the first interval
    merged.add(intervals[0]);

    // 2. Iterate through remaining intervals and merge overlapping intervals
    for (int i = 1; i < intervals.length; i++) {
      final List<int> current = intervals[i];
      final List<int> last = merged.last;

      // If the current interval's start falls within the previous interval's range,
      // they overlap: extend the previous interval's end if current reaches further.
      if (current[0] <= last[1]) {
        if (current[1] > last[1]) {
          last[1] = current[1];
        }
      } else {
        // Disjoint interval: no overlap, push as a new merged segment
        merged.add(current);
      }
    }

    return merged;
  }
}
```

### 🟢 Why This is Optimal:
- **Optimal Time ($O(N \log N)$):** Matches the theoretical sorting lower bound for comparison-based interval scheduling.
- **Single Pass ($O(N)$):** After sorting, resolves all merges in a single sequential sweep.
- **Universal:** Unbounded by coordinate value magnitudes (works equally well for coordinates up to $10^9$ or negative values).

---

# 📊 Comprehensive Comparison Matrix

| Metric | 1. Connected Components Graph | 2. Coordinate Buckets | 3. Sort + Linear Scan (Optimal) |
| :--- | :--- | :--- | :--- |
| **Time Complexity** | $O(N^2)$ | $O(N + M)$ | **$O(N \log N)$** |
| **Auxiliary Space** | $O(N^2)$ | $O(M)$ | **$O(N)$ output / $O(\log N)$ sort** |
| **Coordinate Limit** | Any | Small only ($M \le 10^4$) | **Any (Arbitrary coordinates)** |
| **Implementation Complexity**| High (Graph + DFS) | Moderate (Array indexing) | **Low & Crystal Clear** |
| **Cache Locality** | Poor | Good | **Optimal (Sequential scan)** |
| **Interview Rating** | Overcomplicated | Niche optimization | 🏆 **Gold Standard Expected** |

*Where $N = \text{intervals.length} \le 10^4$ and $M = \max(\text{coordinate}) \le 10^4$.*

---

# ⚠️ Key Interview Gotchas & Edge Cases

1. **Boundary Touching Overlap ($[1, 4]$ and $[4, 5]$):**
   - The condition is `current[0] <= last[1]` (using **$\le$**, NOT strictly $<$).
   - Point overlaps share coordinate 4 and **must** be merged into $[1, 5]$.
2. **Complete Subsumption ($[1, 10]$ and $[2, 3]$):**
   - The second interval is fully inside the first.
   - Do **not** blindly set `last[1] = current[1]`. Always use `max(last[1], current[1])` (or `if (current[1] > last[1]) last[1] = current[1];`), otherwise $[1, 10]$ and $[2, 3]$ would incorrectly become $[1, 3]$!
3. **Unsorted Inputs:**
   - Never assume intervals are pre-sorted in interview questions (e.g. Example 3: `[[4, 7], [1, 4]]`). Always sort upfront.
4. **Single-Element / Zero-Length Intervals:**
   - Single intervals: `[[1, 4]]` $\to$ `[[1, 4]]`.
   - Point intervals: `[[0, 0], [1, 4]]` $\to$ `[[0, 0], [1, 4]]`.
