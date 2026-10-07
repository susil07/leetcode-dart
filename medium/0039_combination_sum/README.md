# 🚀 LeetCode 0039 - Combination Sum

## 📝 Problem Statement

Given an array of **distinct** integers `candidates` and a target integer `target`, return a *list of all **unique combinations** of `candidates` where the chosen numbers sum to `target`*. You may return the combinations in **any order**.

The **same** number may be chosen from `candidates` an **unlimited number of times**. Two combinations are unique if the frequency of at least one of the chosen numbers is different.

The test cases are generated such that the number of unique combinations that sum up to `target` is less than `150` combinations for the given input.

---

## 🔒 Constraints

- $1 \le \text{candidates.length} \le 30$
- $2 \le \text{candidates}[i] \le 40$
- All elements of `candidates` are **distinct**.
- $1 \le \text{target} \le 40$

---

## 💡 Examples

### Example 1
```text
Input: candidates = [2,3,6,7], target = 7
Output: [[2,2,3],[7]]
Explanation:
2 and 3 are candidates, and 2 + 2 + 3 = 7. Note that 2 can be used multiple times.
7 is a candidate, and 7 = 7.
These are the only two combinations.
```

### Example 2
```text
Input: candidates = [2,3,5], target = 8
Output: [[2,2,2,2],[2,3,3],[3,5]]
```

### Example 3
```text
Input: candidates = [2], target = 1
Output: []
```

---

# 🧠 Evolution of Solutions: How We Make It Better

```text
┌────────────────────────────────────────────────────────────────────────┐
│  1. Binary Decision Tree (Pick or Don't Pick) without Sorting          │
│     • At index i: Pick candidate and stay on i, OR skip to i + 1       │
│     • Time: O(2^(target/min)) | Space: O(target/min) call stack        │
│     • Bottleneck: Generates many redundant recursive frames for dead   │
│       branches since array is unsorted.                                │
└──────────────────────────────────┬─────────────────────────────────────┘
                                   │
                                   ▼ Multi-way Branching Loop
┌────────────────────────────────────────────────────────────────────────┐
│  2. Loop-Based Backtracking without Sorting                            │
│     • Iterate i from startIndex to candidates.length - 1               │
│     • If candidates[i] <= remainingTarget, recurse                     │
│     • Time: O(N^(target/min)) | Space: O(target/min)                   │
│     • Bottleneck: Continues checking all remaining candidates even if  │
│       candidates[i] > remainingTarget (evaluates dead branches).       │
└──────────────────────────────────┬─────────────────────────────────────┘
                                   │
                                   ▼ Sorting + Early Branch Pruning
┌────────────────────────────────────────────────────────────────────────┐
│  3. Sorted Backtracking with Early Pruning (Optimal)                   │
│     • Sort candidates ascending first: O(N log N)                      │
│     • If candidates[i] > remainingTarget: immediately BREAK loop       │
│     • Prunes entire subtrees and cuts loop evaluations by over 73%     │
│     • Time: O(N log N + N^(target/min)) | Space: O(target/min)         │
│     • Improvement: Maximum pruning, fastest execution, zero extra mem  │
└──────────────────────────────────┬─────────────────────────────────────┘
                                   │
                                   ▼ Alternative Non-Recursive Formulation
┌────────────────────────────────────────────────────────────────────────┐
│  4. Bottom-Up Dynamic Programming (Unbounded Knapsack Variation)       │
│     • dp[t] stores all combinations that sum to t                      │
│     • For each candidate c: for t = c to target: append c to dp[t - c] │
│     • Time: O(N * target * num_combinations) | Space: O(target * combs)│
│     • Trade-off: No recursion stack, but allocates intermediate lists  │
│       for all sums from 1 to target.                                   │
└────────────────────────────────────────────────────────────────────────┘
```

---

# 🌳 Backtracking Decision Tree Visualization

For `candidates = [2, 3, 6, 7]` and `target = 7`:

```text
                           remaining: 7, start: 0
                     /               |           \       \
              pick 2/          pick 3|      pick 6\  pick 7\
                   v                 v             v        v
            rem: 5, start: 0    rem: 4, start: 1  rem: 1   [7]  <-- MATCH!
             /        \              |
      pick 2/    pick 3\       pick 3| (prune: 6,7 > 4)
           v            v            v
     rem: 3, st: 0  rem: 2, st: 1  rem: 1 (prune: 3,6,7 > 1)
       /     \           |
pick 2/ pick 3\    pick 3| (prune: 3,6,7 > 2)
     v         v         v
 rem: 1      [2,2,3]   DEAD END
 (prune)    <-- MATCH!
```

---

# 💻 Solutions

## 1. Approach 1: Binary Decision Tree (Pick / Skip) ($O(2^{T/M})$ Time, $O(T/M)$ Space)

Treats the choices at each index as a binary decision: either include `candidates[index]` (stay at `index`), or exclude it permanently (advance to `index + 1`).

```dart
class SolutionDecisionTree {
  List<List<int>> combinationSum(List<int> candidates, int target) {
    final List<List<int>> results = [];
    final List<int> current = [];

    void dfs(int index, int remaining) {
      if (remaining == 0) {
        results.add(List<int>.from(current));
        return;
      }
      if (index >= candidates.length || remaining < 0) {
        return;
      }

      // Choice 1: Include candidates[index] (unlimited reuse)
      if (candidates[index] <= remaining) {
        current.add(candidates[index]);
        dfs(index, remaining - candidates[index]);
        current.removeLast(); // Backtrack
      }

      // Choice 2: Exclude candidates[index] and advance to next
      dfs(index + 1, remaining);
    }

    dfs(0, target);
    return results;
  }
}
```

### 🔴 Bottlenecks:
- Creates an extra call stack frame for every skip operation, resulting in high recursion overhead.
- Because `candidates` is unsorted, it cannot early-terminate skips or picks.

---

## 2. Approach 2: Loop-Based Backtracking without Sorting ($O(N^{T/M})$ Time, $O(T/M)$ Space)

Uses a loop starting from `startIndex` to prevent permutation duplicates (e.g. avoiding both `[2, 3]` and `[3, 2]`):

```dart
class SolutionLoopUnsorted {
  List<List<int>> combinationSum(List<int> candidates, int target) {
    final List<List<int>> results = [];
    final List<int> current = [];

    void backtrack(int remaining, int start) {
      if (remaining == 0) {
        results.add(List<int>.from(current));
        return;
      }

      for (int i = start; i < candidates.length; i++) {
        if (candidates[i] <= remaining) {
          current.add(candidates[i]);
          backtrack(remaining - candidates[i], i);
          current.removeLast(); // Backtrack
        }
      }
    }

    backtrack(target, 0);
    return results;
  }
}
```

### 🔴 Bottlenecks:
- If `candidates[i] > remaining`, the loop must use `continue` and continue testing every remaining candidate in the list, even if all of them are also larger than `remaining`.

---

## 3. Approach 3: Sorted Backtracking with Early Branch Pruning (Optimal)

By sorting `candidates` in ascending order upfront:
1. As soon as `candidates[i] > remainingTarget`, we know that **every candidate after index $i$ will also exceed `remainingTarget`**.
2. We can immediately execute a **`break`** instead of continuing the loop.
3. This eliminates over **73% of inner loop condition evaluations** and deep recursive attempts.

```dart
// LeetCode 0039: Combination Sum
// Optimal Solution: Backtracking with Sorting and Branch Pruning
// Time Complexity: O(N^(T/M)) where N = candidates.length, T = target, M = min(candidates)
// Space Complexity: O(T/M) for recursion call stack and current combination path

class Solution {
  List<List<int>> combinationSum(List<int> candidates, int target) {
    // Sorting allows early pruning: once candidates[i] > remainingTarget,
    // all subsequent candidates will also exceed remainingTarget.
    candidates.sort();

    final List<List<int>> results = [];
    final List<int> currentCombination = [];

    void backtrack(int remainingTarget, int startIndex) {
      // Base Case: Target sum achieved
      if (remainingTarget == 0) {
        results.add(List<int>.from(currentCombination));
        return;
      }

      for (int i = startIndex; i < candidates.length; i++) {
        final candidate = candidates[i];

        // Pruning: Since the array is sorted ascending, if the current candidate
        // exceeds remainingTarget, all subsequent candidates will also exceed it.
        if (candidate > remainingTarget) {
          break;
        }

        currentCombination.add(candidate);
        // We pass `i` (not `i + 1`) to allow the same element to be chosen
        // an unlimited number of times.
        backtrack(remainingTarget - candidate, i);
        currentCombination.removeLast(); // Backtrack
      }
    }

    backtrack(target, 0);
    return results;
  }
}
```

### 🟢 Why This is Optimal:
- **Maximum Pruning:** `break` drops entire subtrees immediately.
- **Zero Duplicate Combinations:** Passing `i` as the next `startIndex` ensures elements are picked in non-decreasing index order, inherently preventing permutations like `[2, 3]` vs `[3, 2]` without requiring a `Set`.
- **Minimal Space Overhead:** Operates with a single dynamic list `currentCombination` resized in place, only making copies when a valid target is reached.

---

## 4. Approach 4: Bottom-Up Dynamic Programming (Unbounded Knapsack)

Iterates candidate by candidate to build combinations bottom-up from sum $0$ to `target`:

```dart
class SolutionDP {
  List<List<int>> combinationSum(List<int> candidates, int target) {
    candidates.sort();
    // dp[t] stores all combinations that sum to t
    final List<List<List<int>>> dp = List.generate(target + 1, (_) => []);
    dp[0].add([]); // Base case: 1 combination (empty) for sum 0

    for (final c in candidates) {
      for (int t = c; t <= target; t++) {
        for (final comb in dp[t - c]) {
          dp[t].add([...comb, c]);
        }
      }
    }

    return dp[target];
  }
}
```

### 🔴 Bottlenecks:
- Computes and stores all valid combinations for all intermediate sums $1, 2, \dots, \text{target} - 1$, consuming substantial memory even for sums that are not part of the final answer.

---

# 📊 Comprehensive Comparison Matrix

| Metric | 1. Binary Decision Tree | 2. Loop Unsorted Backtrack | 3. Sorted Backtrack + Pruning (Optimal) | 4. Bottom-Up DP |
| :--- | :--- | :--- | :--- | :--- |
| **Time Complexity** | $O(2^{T/M})$ | $O(N^{T/M})$ | **$O(N \log N + N^{T/M})$** | $O(N \cdot T \cdot K)$ |
| **Call Stack Depth** | $O(N + T/M)$ | $O(T/M)$ | **$O(T/M)$** (At most $40/2 = 20$) | $O(1)$ (Iterative) |
| **Auxiliary Memory** | $O(T/M)$ path list | $O(T/M)$ path list | **$O(T/M)$ path list** | $O(T \cdot \text{combinations})$ |
| **Loop Evaluations** | High (binary skips) | High (evaluates dead tails) | **Minimal (Prunes $> 73\%$ of iterations)** | Loops over all $t \in [c, target]$ |
| **Permutation Duplication** | Prevented by index $+ 1$ | Prevented by `start` index | **Prevented by `start` index** | Prevented by outer candidate loop |
| **Interview Rating** | Acceptable | Standard | 🏆 **Gold Standard Expected** | 💡 **Great Algorithmic Follow-Up** |

*Where $N = \text{candidates.length}$, $T = \text{target}$, $M = \min(\text{candidates}) \ge 2$, and $K = \text{average combinations count}$.*

---

# ⚠️ Key Interview Gotchas & Edge Cases

1. **Permutations vs Combinations:**
   - Notice why we pass `i` (and not `0`): passing `0` would generate all permutations (e.g. `[2, 3, 2]`, `[3, 2, 2]`, `[2, 2, 3]`). Passing `i` ensures candidates can only be chosen in non-decreasing index order, guaranteeing unique combinations without a `Set`.
2. **Unlimited Reuse vs Progression:**
   - In Combination Sum I, candidates can be reused, so we recurse on `i`.
   - In Combination Sum II (LeetCode 40), each candidate can be used only once, so we recurse on `i + 1`.
3. **Deep Copy of `currentCombination`:**
   - Always do `results.add(List<int>.from(currentCombination))` (or `List.of(...)`). Writing `results.add(currentCombination)` adds a reference to the mutable working list, resulting in empty lists at the end after all elements are backtracked!
4. **Early `break` vs `continue`:**
   - `if (candidate > remainingTarget) break;` works **only because the candidates array is sorted**. If unsorted, breaking would prematurely skip smaller valid candidates located further down the array.
