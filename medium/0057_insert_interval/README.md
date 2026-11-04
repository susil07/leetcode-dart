# 🚀 LeetCode 0057 - Insert Interval

## 📝 Problem Statement

You are given an array of non-overlapping intervals `intervals` where $\text{intervals}[i] = [\text{start}_i, \text{end}_i]$ represent the start and the end of the $i^{\text{th}}$ interval and `intervals` is sorted in **ascending order** by $\text{start}_i$. You are also given an interval $\text{newInterval} = [\text{start}, \text{end}]$ that represents the start and end of another interval.

Insert `newInterval` into `intervals` such that `intervals` is still sorted in ascending order by $\text{start}_i$ and `intervals` still does not have any overlapping intervals (merge overlapping intervals if necessary).

Return *`intervals` after the insertion*.

**Note:** You don't need to modify `intervals` in-place. You can make a new array and return it.

---

## 🔒 Constraints

- $0 \le \text{intervals.length} \le 10^4$
- $\text{intervals}[i].\text{length} == 2$
- $0 \le \text{start}_i \le \text{end}_i \le 10^5$
- `intervals` is sorted by $\text{start}_i$ in **ascending order**.
- `intervals` has no overlapping intervals.
- $\text{newInterval.length} == 2$
- $0 \le \text{start} \le \text{end} \le 10^5$

---

## 💡 Examples

### Example 1
```text
Input: intervals = [[1,3],[6,9]], newInterval = [2,5]
Output: [[1,5],[6,9]]
Explanation: Because [2,5] overlaps with [1,3], merge them into [1,5].
```

### Example 2
```text
Input: intervals = [[1,2],[3,5],[6,7],[8,10],[12,16]], newInterval = [4,8]
Output: [[1,2],[3,10],[12,16]]
Explanation: Because [4,8] overlaps with [3,5],[6,7],[8,10], merge them into [3,10].
```

---

# 🔄 Contrast: LeetCode 56 (Merge) vs LeetCode 57 (Insert)

| Feature | LeetCode 56 (Merge Intervals) | LeetCode 57 (Insert Interval) |
| :--- | :--- | :--- |
| **Initial State** | Completely **unsorted** & arbitrarily overlapping | **Pre-sorted** & strictly pairwise **disjoint** |
| **Optimal Time Complexity**| $O(N \log N)$ (Sorting bound) | **$O(N)$ (Strictly Linear Scan)** |
| **New Elements** | None (internal merge) | Exactly one new interval to insert |
| **Key Invariant** | Must sort upfront before linear scan | Already sorted; split directly into 3 natural phases |

---

# 📐 Core Three-Phase Partitioning Architecture

Because `intervals` is already sorted and disjoint, any insertion splits the existing intervals into exactly **three disjoint contiguous zones**:

```text
Existing:     [1, 2]     [3, 5]     [6, 7]     [8, 10]     [12, 16]
newInterval:                 [4 --------------- 8]
             └──────┘   └─────────────────────────────┘   └────────┘
             Phase 1:               Phase 2:               Phase 3:
          Left Disjoint         Overlapping Zone        Right Disjoint
        (end < newStart)       (start <= newEnd)       (start > newEnd)
```

1. **Phase 1 — Left Disjoint Intervals:**
   - Any interval where $\text{end}_i < \text{newInterval}[0]$ ends strictly before the new interval begins.
   - Cannot overlap $\to$ directly copy into `result`.
2. **Phase 2 — Overlapping Intervals:**
   - As long as $\text{start}_i \le \text{newInterval}[1]$, the interval overlaps with `newInterval`.
   - Continually absorb:
     $$\text{newInterval}[0] = \min(\text{newInterval}[0], \; \text{start}_i)$$
     $$\text{newInterval}[1] = \max(\text{newInterval}[1], \; \text{end}_i)$$
   - When the loop terminates, push the single merged `newInterval` into `result`.
3. **Phase 3 — Right Disjoint Intervals:**
   - All remaining intervals start strictly after the merged `newInterval` ends.
   - Cannot overlap $\to$ directly copy all remaining intervals into `result`.

---

# 🧠 Evolution of Solutions: How We Make It Better

```text
┌────────────────────────────────────────────────────────────────────────┐
│  1. Append + Re-sort (LeetCode 56 Reduction)                           │
│     • Append newInterval to intervals, sort all by start, merge        │
│     • Time: O(N log N) | Space: O(N)                                   │
│     • Bottleneck: Completely wastes the pre-sorted invariant           │
└──────────────────────────────────┬─────────────────────────────────────┘
                                   │
                                   ▼ Binary Search for Overlapping Boundaries
┌────────────────────────────────────────────────────────────────────────┐
│  2. Binary Search + Array Slicing                                      │
│     • Binary search first overlap index: O(log N)                      │
│     • Binary search last overlap index: O(log N)                       │
│     • Slice and concatenate sublists: O(N)                             │
│     • Time: O(N) | Space: O(N)                                         │
│     • Bottleneck: Extra sublist allocations and binary search overhead │
└──────────────────────────────────┬─────────────────────────────────────┘
                                   │
                                   ▼ Three-Phase Linear Scan
┌────────────────────────────────────────────────────────────────────────┐
│  3. Three-Phase Linear Scan (Optimal & Gold Standard)                  │
│     • Single pass over intervals: Phase 1 -> Phase 2 -> Phase 3        │
│     • Time: O(N) strictly linear | Space: O(N) output memory           │
│     • Improvement: Single pointer pass, zero sorting, zero sublists    │
└────────────────────────────────────────────────────────────────────────┘
```

---

# 💻 Solutions

## 1. Approach 1: Append and Re-Sort ($O(N \log N)$ Time, $O(N)$ Space)

Treats the problem as a reduction to LeetCode 56 (Merge Intervals):

```dart
class SolutionAppendAndSort {
  List<List<int>> insert(List<List<int>> intervals, List<int> newInterval) {
    intervals.add(newInterval);
    intervals.sort((a, b) => a[0].compareTo(b[0]));

    final List<List<int>> merged = [intervals[0]];
    for (int i = 1; i < intervals.length; i++) {
      if (intervals[i][0] <= merged.last[1]) {
        if (intervals[i][1] > merged.last[1]) {
          merged.last[1] = intervals[i][1];
        }
      } else {
        merged.add(intervals[i]);
      }
    }

    return merged;
  }
}
```

### 🔴 Bottlenecks:
- Incurs $O(N \log N)$ sorting time, ignoring that `intervals` was already fully sorted.

---

## 2. Approach 2: Binary Search Boundaries ($O(N)$ Time, $O(N)$ Space)

Uses binary search to find the index of the first and last overlapping intervals in $O(\log N)$ time, then reconstructs the array:

```dart
class SolutionBinarySearch {
  List<List<int>> insert(List<List<int>> intervals, List<int> newInterval) {
    if (intervals.isEmpty) return [newInterval];

    final int n = intervals.length;

    // First interval with end >= newInterval.start
    int low = 0, high = n - 1, startIdx = n;
    while (low <= high) {
      final mid = (low + high) >> 1;
      if (intervals[mid][1] >= newInterval[0]) {
        startIdx = mid;
        high = mid - 1;
      } else {
        low = mid + 1;
      }
    }

    // Last interval with start <= newInterval.end
    low = 0; high = n - 1;
    int endIdx = -1;
    while (low <= high) {
      final mid = (low + high) >> 1;
      if (intervals[mid][0] <= newInterval[1]) {
        endIdx = mid;
        low = mid + 1;
      } else {
        high = mid - 1;
      }
    }

    final List<List<int>> result = [];
    for (int i = 0; i < startIdx; i++) result.add(intervals[i]);

    if (startIdx <= endIdx) {
      final minStart = intervals[startIdx][0] < newInterval[0] ? intervals[startIdx][0] : newInterval[0];
      final maxEnd = intervals[endIdx][1] > newInterval[1] ? intervals[endIdx][1] : newInterval[1];
      result.add([minStart, maxEnd]);
    } else {
      result.add(newInterval);
    }

    for (int i = endIdx + 1; i < n; i++) result.add(intervals[i]);
    return result;
  }
}
```

### 🟢 Value:
- Explores binary search optimization. Still $O(N)$ overall because copying elements into the result list requires linear time.

---

## 3. Approach 3: Three-Phase Linear Scan (Optimal & Gold Standard)

Traverses the sorted input list in a single clean sweep:

```dart
// LeetCode 0057: Insert Interval
// Optimal Solution: Three-Phase Linear Scan
// Time Complexity: O(N) single-pass
// Space Complexity: O(N) auxiliary space to construct the result list

class Solution {
  List<List<int>> insert(List<List<int>> intervals, List<int> newInterval) {
    final List<List<int>> result = [];
    final int n = intervals.length;
    int i = 0;

    // Phase 1: Add all intervals that come strictly before newInterval (no overlap)
    // Condition: interval's end is strictly less than newInterval's start
    while (i < n && intervals[i][1] < newInterval[0]) {
      result.add(intervals[i]);
      i++;
    }

    // Phase 2: Merge all overlapping intervals into newInterval
    // Condition: interval's start is less than or equal to newInterval's end
    while (i < n && intervals[i][0] <= newInterval[1]) {
      if (intervals[i][0] < newInterval[0]) {
        newInterval[0] = intervals[i][0];
      }
      if (intervals[i][1] > newInterval[1]) {
        newInterval[1] = intervals[i][1];
      }
      i++;
    }
    // Add the merged newInterval
    result.add(newInterval);

    // Phase 3: Add all remaining intervals that come strictly after newInterval
    while (i < n) {
      result.add(intervals[i]);
      i++;
    }

    return result;
  }
}
```

### 🟢 Why This is Optimal:
- **Strictly Single-Pass ($O(N)$):** Every element is evaluated exactly once in sequentially increasing index order.
- **No Sorting Overhead:** Eliminates $O(N \log N)$ sorting altogether.
- **Zero Complex Edge Case Logic:** Empty array, insertions at start/end, and complete subsumption are all handled automatically by the three while-loop conditions.

---

# 📊 Comprehensive Comparison Matrix

| Metric | 1. Append + Re-sort | 2. Binary Search + Slicing | 3. Three-Phase Linear Scan (Optimal) |
| :--- | :--- | :--- | :--- |
| **Time Complexity** | $O(N \log N)$ | $O(N)$ ($O(\log N)$ search + $O(N)$ copy) | **$O(N)$ Strictly Linear** |
| **Auxiliary Space** | $O(N)$ | $O(N)$ | **$O(N)$ Output List** |
| **Leverages Sorted Input**| ❌ No (Re-sorts from scratch) | ✅ Yes | **✅ Yes (Single Pointer Sweep)** |
| **Comparisons per Item** | $O(\log N)$ | $O(\log N)$ for targets | **At most 2 comparisons** |
| **Cache Locality** | Moderate | Moderate | **Optimal (Sequential scan)** |
| **Interview Rating** | Suboptimal ($O(N \log N)$) | Acceptable | 🏆 **Gold Standard Expected** |

*Where $N = \text{intervals.length} \le 10^4$.*

---

# ⚠️ Key Interview Gotchas & Edge Cases

1. **Empty Intervals List (`intervals = []`):**
   - Phase 1 loop does not run ($i = 0 < 0$ false).
   - Phase 2 loop does not run.
   - Merged `newInterval` is pushed to `result`.
   - Returns `[newInterval]`. Handled flawlessly!
2. **Insertion at the Very Beginning / End:**
   - **At Start (`newInterval = [0, 0]`):** Phase 1 adds nothing, Phase 2 absorbs/adds `[0, 0]`, Phase 3 adds all original intervals.
   - **At End (`newInterval = [20, 25]`):** Phase 1 adds all original intervals, Phase 2 adds `[20, 25]`, Phase 3 is empty.
3. **Point Overlap / Touching Boundaries:**
   - `[1, 2]` and `[2, 5]` overlap at point 2.
   - The Phase 2 condition `intervals[i][0] <= newInterval[1]` uses **$\le$**, properly absorbing boundary points.
4. **Complete Subsumption:**
   - If `newInterval` is completely inside an existing interval (`intervals = [[1, 10]]`, `newInterval = [3, 5]`), Phase 2 absorbs `[1, 10]`, properly keeping `1` as min and `10` as max.
