# 🚀 LeetCode 0055 - Jump Game

## 📝 Problem Statement

You are given an integer array `nums`. You are initially positioned at the array's **first index**, and each element in the array represents your maximum jump length at that position.

Return `true` *if you can reach the last index, or `false` otherwise*.

---

## 🔒 Constraints

- $1 \le \text{nums.length} \le 10^4$
- $0 \le \text{nums}[i] \le 10^5$

---

## 💡 Examples

### Example 1
```text
Input: nums = [2,3,1,1,4]
Output: true
Explanation: Jump 1 step from index 0 to 1, then 3 steps to the last index.
```

### Example 2
```text
Input: nums = [3,2,1,0,4]
Output: false
Explanation: You will always arrive at index 3 no matter what. 
Its maximum jump length is 0, which makes it impossible to reach the last index.
```

---

# 🔄 Contrast: Jump Game I vs Jump Game II

| Feature | LeetCode 55 (Jump Game I) | LeetCode 45 (Jump Game II) |
| :--- | :--- | :--- |
| **Objective** | Can you reach the last index? (`bool`) | Minimum number of jumps to reach last index (`int`) |
| **Guaranteed Reach?** | **No** (can get trapped by zeros) | **Yes**, test cases guarantee reachability |
| **Greedy State** | Single variable: `maxReach` | Two variables: `currentEnd` (jump boundary) & `farthest` |
| **Failure Condition** | If `i > maxReach` $\implies$ trapped (`false`) | Never fails (guaranteed solvable) |

---

# 📐 Core Greedy Intuition: The Reachability Horizon

At each index $i$, `nums[i]` allows us to jump to any index in the range $[i, i + \text{nums}[i]]$.

As we traverse from left to right:
1. If the current index $i$ exceeds our maximum reach achieved so far ($i > \text{maxReach}$), we have encountered an impassable barrier (a chain of zeros) and can never reach $i$. We immediately return `false`.
2. Otherwise, we expand our reachability horizon:
   $$\text{maxReach} = \max(\text{maxReach}, \; i + \text{nums}[i])$$
3. If at any point $\text{maxReach} \ge n - 1$, the destination is already reachable, allowing an **immediate early exit**.

```text
Example 1: nums = [2, 3, 1, 1, 4]
i = 0: nums[0] = 2 -> maxReach = max(0, 0 + 2) = 2
i = 1: nums[1] = 3 -> maxReach = max(2, 1 + 3) = 4 >= 4 -> RETURN TRUE (Early Exit!)

Example 2: nums = [3, 2, 1, 0, 4]
i = 0: nums[0] = 3 -> maxReach = 3
i = 1: nums[1] = 2 -> maxReach = max(3, 1 + 2) = 3
i = 2: nums[2] = 1 -> maxReach = max(3, 2 + 1) = 3
i = 3: nums[3] = 0 -> maxReach = max(3, 3 + 0) = 3
i = 4: i (4) > maxReach (3) -> CANNOT REACH INDEX 4 -> RETURN FALSE!
```

---

# 🧠 Evolution of Solutions: How We Make It Better

```text
┌────────────────────────────────────────────────────────────────────────┐
│  1. Naive Recursive Backtracking (DFS)                                 │
│     • Try every jump size j from 1 to nums[i] recursively              │
│     • Time: O(2^N) | Space: O(N) call stack                            │
│     • Bottleneck: Exponential explosion on repeated branches (TLE)     │
└──────────────────────────────────┬─────────────────────────────────────┘
                                   │
                                   ▼ Memoize Visited States
┌────────────────────────────────────────────────────────────────────────┐
│  2. Top-Down Dynamic Programming with Memoization                      │
│     • memo[i] = can we reach destination from index i?                 │
│     • Time: O(N^2) | Space: O(N) memo array + call stack               │
│     • Bottleneck: Quadratic complexity on large arrays (10^8 ops)      │
└──────────────────────────────────┬─────────────────────────────────────┘
                                   │
                                   ▼ Eliminate Call Stack
┌────────────────────────────────────────────────────────────────────────┐
│  3. Bottom-Up Tabulation DP                                            │
│     • dp[i] = true if any j in [i+1, i+nums[i]] has dp[j] == true      │
│     • Time: O(N^2) | Space: O(N) array                                 │
│     • Bottleneck: Still nested loops; scans future indices repeatedly  │
└──────────────────────────────────┬─────────────────────────────────────┘
                                   │
                                   ▼ Reverse Target Shrinking
┌────────────────────────────────────────────────────────────────────────┐
│  4. Greedy Backward (Target Pulling)                                   │
│     • Start target = n - 1; loop backwards: if i + nums[i] >= target,  │
│       pull target = i                                                  │
│     • Time: O(N) single pass | Space: O(1) auxiliary                   │
│     • Value: Intuitive backwards proof, O(1) memory                    │
└──────────────────────────────────┬─────────────────────────────────────┘
                                   │
                                   ▼ Forward Horizon with Early Exit
┌────────────────────────────────────────────────────────────────────────┐
│  5. Greedy Forward Reachability (Optimal & Gold Standard)              │
│     • maxReach = max(maxReach, i + nums[i]); fail if i > maxReach      │
│     • Early exit: return true immediately when maxReach >= n - 1       │
│     • Time: O(N) single pass | Space: O(1) auxiliary                   │
│     • Improvement: Stops as soon as reachable without full scan        │
└────────────────────────────────────────────────────────────────────────┘
```

---

# 💻 Solutions

## 1. Approach 1: Top-Down Dynamic Programming with Memoization ($O(N^2)$ Time, $O(N)$ Space)

Caches whether each index can eventually reach the end:

```dart
class SolutionMemo {
  bool canJump(List<int> nums) {
    final int n = nums.length;
    // -1 = unvisited, 0 = false, 1 = true
    final List<int> memo = List<int>.filled(n, -1);
    memo[n - 1] = 1;

    bool dfs(int i) {
      if (memo[i] != -1) return memo[i] == 1;

      final int maxJump = (i + nums[i] < n - 1) ? i + nums[i] : n - 1;
      for (int next = i + 1; next <= maxJump; next++) {
        if (dfs(next)) {
          memo[i] = 1;
          return true;
        }
      }

      memo[i] = 0;
      return false;
    }

    return dfs(0);
  }
}
```

### 🔴 Bottlenecks:
- $O(N^2)$ time in the worst case (e.g. descending arrays where every step is tried).
- Incurs $O(N)$ recursion depth call stack frames.

---

## 2. Approach 2: Bottom-Up Dynamic Programming ($O(N^2)$ Time, $O(N)$ Space)

Evaluates indices from right to left:

```dart
class SolutionDP {
  bool canJump(List<int> nums) {
    final int n = nums.length;
    final List<bool> dp = List<bool>.filled(n, false);
    dp[n - 1] = true;

    for (int i = n - 2; i >= 0; i--) {
      final int maxJump = (i + nums[i] < n - 1) ? i + nums[i] : n - 1;
      for (int j = i + 1; j <= maxJump; j++) {
        if (dp[j]) {
          dp[i] = true;
          break;
        }
      }
    }

    return dp[0];
  }
}
```

### 🔴 Bottlenecks:
- $O(N^2)$ worst-case time complexity.
- Allocates an auxiliary `List<bool>` of size $N = 10^4$.

---

## 3. Approach 3: Greedy Backward (Target Shrinking) ($O(N)$ Time, $O(1)$ Space)

Starts at the goal `target = n - 1` and moves backward. Whenever an index `i` can reach `target`, we can safely reduce our goal to reaching `i` instead:

```dart
class SolutionGreedyBackward {
  bool canJump(List<int> nums) {
    int target = nums.length - 1;

    for (int i = nums.length - 2; i >= 0; i--) {
      if (i + nums[i] >= target) {
        target = i;
      }
    }

    return target == 0;
  }
}
```

### 🟢 Value:
- Eliminates the DP array entirely, running in $O(N)$ time and $O(1)$ memory.
- Clear mathematical proof: if position 0 can reach the reduced target, the final index is guaranteed reachable.

---

## 4. Approach 4: Greedy Forward Reachability with Early Exit (Optimal & Gold Standard)

Traverses forward from left to right, tracking the maximum reachable index horizon:

```dart
// LeetCode 0055: Jump Game
// Optimal Solution: Greedy Forward Reachability with Early Exit
// Time Complexity: O(N) single-pass
// Space Complexity: O(1) auxiliary space

class Solution {
  bool canJump(List<int> nums) {
    int maxReach = 0;
    final int n = nums.length;

    for (int i = 0; i < n; i++) {
      // If current index is beyond the farthest reachable index, we cannot proceed
      if (i > maxReach) {
        return false;
      }

      // Greedily update the farthest index we can reach
      final int currentReach = i + nums[i];
      if (currentReach > maxReach) {
        maxReach = currentReach;
      }

      // Early exit: if destination is already reachable, return true immediately
      if (maxReach >= n - 1) {
        return true;
      }
    }

    return true;
  }
}
```

### 🟢 Why This is Optimal:
- **Strictly Single-Pass ($O(N)$):** Visits each element at most once.
- **Fast Early Exit:** If a jump from index $0$ or $1$ already covers the entire array, returns `true` immediately without scanning remaining elements.
- **$O(1)$ Auxiliary Space:** Requires only a single scalar integer (`maxReach`).
- **Optimal Hardware Cache Locality:** Scans sequential memory in forward order.

---

# 📊 Comprehensive Comparison Matrix

| Metric | 1. Memoized DFS | 2. Bottom-Up DP | 3. Greedy Backward | 4. Greedy Forward (Optimal) |
| :--- | :--- | :--- | :--- | :--- |
| **Time Complexity** | $O(N^2)$ | $O(N^2)$ | $O(N)$ | **$O(N)$ Strictly Linear** |
| **Auxiliary Space** | $O(N)$ memo + stack | $O(N)$ array | **$O(1)$** | **$O(1)$ Pure Scalar** |
| **Early Exit?** | No | No | No (must scan to 0) | **Yes (as soon as $maxReach \ge n - 1$)** |
| **Direction** | Recursive (0 to end) | Right-to-Left | Right-to-Left | **Left-to-Right (Forward)** |
| **Cache Locality** | Poor | Backward sequential | Backward sequential | **Optimal (Forward prefetching)** |
| **Interview Rating** | Suboptimal | Standard DP | Great | 🏆 **Gold Standard Expected** |

*Where $N = \text{nums.length} \le 10^4$.*

---

# ⚠️ Key Interview Gotchas & Edge Cases

1. **Single-Element Array (`nums = [0]`):**
   - You start at index 0 and the destination is index 0 ($n - 1 = 0$).
   - `maxReach = 0 >= n - 1 (0)` triggers immediately, returning `true`!
   - You don't need to jump anywhere; you are already at the destination.
2. **Immediate Zero Trap (`nums = [0, 2, 3]`):**
   - $i = 0$: `maxReach = 0`.
   - $i = 1$: $i (1) > \text{maxReach} (0)$, immediately returns `false`.
3. **Large Jump Values:**
   - Constraints allow $\text{nums}[i] \le 10^5$, meaning $i + \text{nums}[i]$ can exceed $n$. The condition `maxReach >= n - 1` gracefully handles jumps well past the array boundary.
4. **All Non-Zero Elements:**
   - If an array contains no zeros, it is **always** possible to reach the end (since each step moves forward by at least 1).
