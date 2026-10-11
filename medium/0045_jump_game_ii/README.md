# 🚀 LeetCode 0045 - Jump Game II

## 📝 Problem Statement

You are given a **0-indexed** array of integers `nums` of length `n`. You are initially positioned at index `0`.

Each element `nums[i]` represents the maximum length of a forward jump from index `i`. In other words, if you are at index `i`, you can jump to any index `(i + j)` where:
- $0 \le j \le \text{nums}[i]$ and
- $i + j < n$

Return the *minimum number of jumps to reach index $n - 1$*. The test cases are generated such that you can reach index $n - 1$.

---

## 🔒 Constraints

- $1 \le \text{nums.length} \le 10^4$
- $0 \le \text{nums}[i] \le 1000$
- It's guaranteed that you can reach `nums[n - 1]`.

---

## 💡 Examples

### Example 1
```text
Input: nums = [2,3,1,1,4]
Output: 2
Explanation: The minimum number of jumps to reach the last index is 2. 
Jump 1 step from index 0 to 1, then 3 steps to the last index.
```

### Example 2
```text
Input: nums = [2,3,0,1,4]
Output: 2
```

---

# 🔄 Contrast: Jump Game I vs Jump Game II

| Feature | LeetCode 55 (Jump Game I) | LeetCode 45 (Jump Game II) |
| :--- | :--- | :--- |
| **Objective** | Can you reach the last index? (`bool`) | Minimum number of jumps to reach last index (`int`) |
| **Guaranteed Reach?** | No (can get stuck on zeros) | **Yes**, test cases guarantee reachability |
| **Greedy State** | Single variable `maxReach` | Two variables: `currentEnd` (jump boundary) & `farthest` |
| **Decision Rule** | Check if `i > maxReach` | Increment `jumps` when `i == currentEnd` |

---

# 🧠 Evolution of Solutions: How We Make It Better

```text
┌────────────────────────────────────────────────────────────────────────┐
│  1. Top-Down Recursive DFS with Memoization                            │
│     • Try every jump size j from 1 to nums[i], memoize min jumps       │
│     • Time: O(N * M) where M <= 1000 | Space: O(N) memo + call stack   │
│     • Bottleneck: Explores all outgoing transitions; recursion depth   │
└──────────────────────────────────┬─────────────────────────────────────┘
                                   │
                                   ▼ Eliminate Call Stack
┌────────────────────────────────────────────────────────────────────────┐
│  2. Bottom-Up Tabulation (1D DP)                                       │
│     • dp[i] = min jumps to reach index i from 0                        │
│     • For each i: update all j in [i+1, i+nums[i]]: dp[j] = dp[i] + 1  │
│     • Time: O(N * M) or O(N^2) | Space: O(N)                           │
│     • Bottleneck: Redundantly writes to dp[j] multiple times           │
└──────────────────────────────────┬─────────────────────────────────────┘
                                   │
                                   ▼ View as Breadth-First Search (BFS)
┌────────────────────────────────────────────────────────────────────────┐
│  3. Explicit Queue BFS on DAG                                          │
│     • Each level in BFS represents 1 additional jump                   │
│     • Skip already-visited indices using maxReached tracker            │
│     • Time: O(N) | Space: O(N) queue memory                            │
│     • Bottleneck: Queue allocations and element enqueue/dequeue steps  │
└──────────────────────────────────┬─────────────────────────────────────┘
                                   │
                                   ▼ Implicit Window (Greedy Two-Pointer)
┌────────────────────────────────────────────────────────────────────────┐
│  4. Greedy BFS Window Interval (Optimal)                               │
│     • Track [currentStart, currentEnd] window without a queue          │
│     • Expand `farthest` across current interval; jump when i==end      │
│     • Early exit when destination is reachable                         │
│     • Time: O(N) single pass | Space: O(1) auxiliary space             │
│     • Improvement: Absolute minimum memory, zero allocations           │
└────────────────────────────────────────────────────────────────────────┘
```

---

# 🌊 Visualizing Implicit BFS Windows

Consider `nums = [2, 3, 1, 1, 4]`:

```text
Index:     0    1    2    3    4
Nums:     [2,   3,   1,   1,   4]

Level 0:  [0]                                     -> Jump 0: Window [0, 0]
          From index 0: can reach max index 0 + 2 = 2

Level 1:       [1,   2]                           -> Jump 1: Window [1, 2]
          From index 1: can reach 1 + 3 = 4 (Destination!)
          From index 2: can reach 2 + 1 = 3
          Farthest reach = max(4, 3) = 4

Level 2:                 [3,   4]                 -> Jump 2: Reached destination index 4!
```

---

# 💻 Solutions

## 1. Approach 1: Top-Down Recursion with Memoization ($O(N \cdot M)$ Time, $O(N)$ Space)

Tries every possible jump size from the current index and records the minimum steps required:

```dart
class SolutionMemo {
  int jump(List<int> nums) {
    final int n = nums.length;
    final List<int> memo = List<int>.filled(n, -1);

    int dfs(int i) {
      if (i >= n - 1) return 0;
      if (memo[i] != -1) return memo[i];

      int minSteps = 1000000;
      final maxJump = nums[i];
      for (int step = 1; step <= maxJump; step++) {
        if (i + step < n) {
          final res = dfs(i + step);
          if (res != 1000000 && res + 1 < minSteps) {
            minSteps = res + 1;
          }
        }
      }

      return memo[i] = minSteps;
    }

    return dfs(0);
  }
}
```

### 🔴 Bottlenecks:
- Incurs substantial function call stack overhead.
- Redundant checks when multiple indices can reach the same target index.

---

## 2. Approach 2: Bottom-Up Tabulation ($O(N \cdot M)$ Time, $O(N)$ Space)

Maintains an array `dp[i]` representing the minimum jumps from index 0 to index `i`:

```dart
class SolutionDP {
  int jump(List<int> nums) {
    final int n = nums.length;
    final List<int> dp = List<int>.filled(n, 1000000);
    dp[0] = 0;

    for (int i = 0; i < n - 1; i++) {
      if (dp[i] == 1000000) continue;
      final maxReach = (i + nums[i] < n - 1) ? i + nums[i] : n - 1;
      for (int j = i + 1; j <= maxReach; j++) {
        if (dp[i] + 1 < dp[j]) {
          dp[j] = dp[i] + 1;
        }
      }
    }

    return dp[n - 1];
  }
}
```

### 🔴 Bottlenecks:
- Repeatedly updates entries `dp[j]`, resulting in $O(N \cdot M)$ operations (up to $10^7$ iterations).

---

## 3. Approach 3: Greedy BFS Window Interval (Optimal)

Notice that in an unweighted graph, finding the minimum jumps to reach a node is identical to **Breadth-First Search (BFS)**. Instead of using a queue data structure, we maintain the boundary of the current BFS level using two integer variables:
- `farthest`: The maximum index reachable by any jump from the current BFS level.
- `currentEnd`: The end of the current BFS level. When the loop index `i` reaches `currentEnd`, we are forced to commit to 1 jump (`jumps++`), and advance `currentEnd` to `farthest`.

```dart
// LeetCode 0045: Jump Game II
// Optimal Solution: Greedy BFS Window Interval
// Time Complexity: O(N) single-pass traversal
// Space Complexity: O(1) auxiliary space

class Solution {
  int jump(List<int> nums) {
    // If the array has 0 or 1 elements, we are already at the destination
    if (nums.length <= 1) return 0;

    int jumps = 0;
    int currentEnd = 0;
    int farthest = 0;

    // We only iterate up to nums.length - 2 because once we reach or pass
    // the last index, we do not need to make another jump.
    for (int i = 0; i < nums.length - 1; i++) {
      // Greedily update the farthest reach achievable from any index visited so far
      if (i + nums[i] > farthest) {
        farthest = i + nums[i];
      }

      // When we hit the boundary of the current jump, we MUST commit to a jump
      if (i == currentEnd) {
        jumps++;
        currentEnd = farthest;

        // Early exit: destination is already reachable
        if (currentEnd >= nums.length - 1) {
          break;
        }
      }
    }

    return jumps;
  }
}
```

### 🟢 Why This is Optimal:
- **Strictly Single Pass:** Visits each array element at most once: $O(N)$ runtime.
- **$O(1)$ Auxiliary Memory:** Operates with three scalar integers without allocating arrays or queues.
- **Early Break:** Immediately terminates the loop as soon as `currentEnd >= nums.length - 1`.

---

## 4. Approach 4: Explicit Queue BFS on DAG ($O(N)$ Time, $O(N)$ Space)

Treats the array as an unweighted directed acyclic graph where edge $(u, v)$ exists if $u < v \le u + \text{nums}[u]$. Uses a queue to explore nodes level-by-level:

```dart
class SolutionQueueBFS {
  int jump(List<int> nums) {
    final int n = nums.length;
    if (n <= 1) return 0;

    final List<int> queue = [0];
    int head = 0;
    int jumps = 0;
    int maxReached = 0;

    while (head < queue.length) {
      final levelSize = queue.length - head;
      for (int k = 0; k < levelSize; k++) {
        final curr = queue[head++];
        if (curr >= n - 1) return jumps;

        final nextReach = curr + nums[curr];
        if (nextReach >= n - 1) return jumps + 1;

        // Enqueue only unvisited indices to maintain strict O(N)
        final start = (maxReached + 1 > curr + 1) ? maxReached + 1 : curr + 1;
        final end = (nextReach < n - 1) ? nextReach : n - 1;
        for (int next = start; next <= end; next++) {
          queue.add(next);
        }
        if (nextReach > maxReached) {
          maxReached = nextReach;
        }
      }
      jumps++;
    }

    return jumps;
  }
}
```

### 🟢 Value:
- Proves theoretically why the greedy solution works: the greedy algorithm is an $O(1)$-space compression of this exact level-by-level BFS.

---

# 📊 Comprehensive Comparison Matrix

| Metric | 1. Memoized DFS | 2. 1D DP Tabulation | 3. Greedy BFS Window (Optimal) | 4. Explicit Queue BFS |
| :--- | :--- | :--- | :--- | :--- |
| **Time Complexity** | $O(N \cdot M)$ | $O(N \cdot M)$ | **$O(N)$ Strictly Linear** | $O(N)$ |
| **Auxiliary Space** | $O(N)$ memo + stack | $O(N)$ array | **$O(1)$ Scalar Variables** | $O(N)$ queue |
| **Array Passes** | Multiple branches | Nested loops | **Single Pass ($\le N - 1$)** | Single level traversal |
| **Early Termination** | No | No | **Yes (break when $end \ge n - 1$)** | Yes (first to reach $n - 1$) |
| **Interview Rating** | Suboptimal | Standard DP | 🏆 **Gold Standard Expected** | 💡 **Graph Perspective** |

*Where $N = \text{nums.length} \le 10^4$ and $M = \max(\text{nums}[i]) \le 1000$.*

---

# ⚠️ Key Interview Gotchas & Edge Cases

1. **Loop Bound: `i < nums.length - 1` vs `i < nums.length`:**
   - **Crucial!** We must loop only up to `nums.length - 2`.
   - If we looped up to `nums.length - 1`, when `i` reaches `nums.length - 1 == currentEnd`, the condition `if (i == currentEnd)` would trigger an extraneous extra jump!
2. **Single Element Array ($N = 1$):**
   - If `nums = [0]` or `nums = [5]`, we are already at the destination index $0$. Zero jumps are required (`return 0`).
   - The loop `i < nums.length - 1` never executes for $N = 1$, correctly returning `0`.
3. **Guaranteed Reachability:**
   - Jump Game II guarantees that the last index is always reachable. Therefore, we never need to check if `farthest < i`.
