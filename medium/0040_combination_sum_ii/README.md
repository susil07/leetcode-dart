# 🚀 LeetCode 0040 - Combination Sum II

## 📝 Problem Statement

Given a collection of candidate numbers (`candidates`) and a target number (`target`), find all **unique combinations** in `candidates` where the candidate numbers sum to `target`.

Each number in `candidates` may only be used **once** in the combination.

**Note:** The solution set must not contain duplicate combinations.

---

## 🔒 Constraints

- $1 \le \text{candidates.length} \le 100$
- $1 \le \text{candidates}[i] \le 50$
- $1 \le \text{target} \le 30$

---

## 💡 Examples

### Example 1
```text
Input: candidates = [10,1,2,7,6,1,5], target = 8
Output: 
[
  [1,1,6],
  [1,2,5],
  [1,7],
  [2,6]
]
```

### Example 2
```text
Input: candidates = [2,5,2,1,2], target = 5
Output: 
[
  [1,2,2],
  [5]
]
```

---

# 🔄 Contrast: Combination Sum I vs Combination Sum II

| Feature | LeetCode 39 (Combination Sum I) | LeetCode 40 (Combination Sum II) |
| :--- | :--- | :--- |
| **Input Elements** | All numbers are **distinct** | Can contain **duplicate numbers** |
| **Element Reuse** | **Unlimited** times per number | **At most once** per instance |
| **Recursive Call** | `backtrack(rem - c, i)` (stay on index $i$) | `backtrack(rem - c, i + 1)` (advance to $i + 1$) |
| **Deduplication** | Natural via non-decreasing index | Requires **sibling deduplication** `i > start && c[i] == c[i-1]` |

---

# 🧠 Evolution of Solutions: How We Make It Better

```text
┌────────────────────────────────────────────────────────────────────────┐
│  1. Backtracking with Global HashSet Deduplication                     │
│     • Recurse advancing to i + 1; serialize found combinations to Set  │
│     • Time: O(2^N) | Space: O(2^N * target) for Set of serialized keys │
│     • Bottleneck: Explores all duplicate subtrees; expensive string    │
│       hashing and memory allocation.                                   │
└──────────────────────────────────┬─────────────────────────────────────┘
                                   │
                                   ▼ Eliminate Set Hashing with Multiplicity
┌────────────────────────────────────────────────────────────────────────┐
│  2. Backtracking with Frequency Map (Element Multiplicities)           │
│     • Count occurrences of each unique number: Map<int, int>           │
│     • At unique index j: try taking 0, 1, ..., count[j] copies         │
│     • Time: O(2^U) where U = distinct elements | Space: O(U)           │
│     • Bottleneck: Extra Map allocations and nested loops per candidate │
└──────────────────────────────────┬─────────────────────────────────────┘
                                   │
                                   ▼ In-Place Array Deduplication & Pruning
┌────────────────────────────────────────────────────────────────────────┐
│  3. Sorted Backtracking with Level Deduplication (Optimal)             │
│     • Sort candidates ascending: O(N log N)                            │
│     • Pruning: if candidates[i] > remaining -> BREAK                   │
│     • Level Deduplication: if i > startIndex && c[i] == c[i-1] -> SKIP │
│     • Single-Use: recurse with i + 1                                   │
│     • Time: O(2^N) (tightly pruned) | Space: O(N) recursion stack     │
│     • Improvement: Zero extra collections, zero redundant subtrees     │
└──────────────────────────────────┬─────────────────────────────────────┘
                                   │
                                   ▼ Alternative Non-Recursive Knapsack
┌────────────────────────────────────────────────────────────────────────┐
│  4. 0/1 Knapsack Bottom-Up Dynamic Programming                         │
│     • Reverse iteration: for t from target down to candidate c         │
│     • Stores unique combinations for each intermediate sum 1..target   │
│     • Time: O(N * target * num_combinations) | Space: O(target * combs)│
│     • Trade-off: Non-recursive, but heavy intermediate memory overhead │
└────────────────────────────────────────────────────────────────────────┘
```

---

# 🌳 Sibling vs Descendant Deduplication Explained

Why `if (i > startIndex && candidates[i] == candidates[i - 1]) continue;`?

Consider sorted candidates: `[1, 1, 2, 5, 6, 7, 10]` with target `8`.

```text
                                  [] (Depth 0)
                 /             /         \         \
          Pick 1 (idx 0)  Pick 1 (idx 1)  Pick 2  Pick 5...
              /             ^
       Pick 1 (idx 1)       │ SKIP! (i = 1 > startIndex = 0 && c[1] == c[0])
            /               │ This would generate identical combinations as idx 0!
     Pick 6 (idx 4)         │
          v                 │
       [1, 1, 6]            └───── Horizontal/Sibling Duplicate Prevented!
     <-- VALID!
  (Vertical/Descendant
   duplicate ALLOWED because
   at next depth, startIndex = 1,
   and i = 1 == startIndex)
```

- **Vertical Duplicate (Allowed):** When $i = \text{startIndex}$, we pick the duplicate at the next depth. E.g., the first `1` picks the second `1` into the combination `[1, 1, 6]`.
- **Horizontal Duplicate (Blocked):** When $i > \text{startIndex}$ and $c[i] == c[i-1]$, we are at the same decision level attempting to start a brand new branch with the exact same value. Skipping it avoids identical combinations.

---

# 💻 Solutions

## 1. Approach 1: Backtracking with HashSet Deduplication ($O(2^N)$ Time, $O(2^N)$ Space)

Finds all combinations without level deduplication, relying on a `Set<String>` to eliminate identical combinations before output:

```dart
class SolutionHashSet {
  List<List<int>> combinationSum2(List<int> candidates, int target) {
    candidates.sort();
    final Set<String> seen = {};
    final List<List<int>> results = [];
    final List<int> current = [];

    void dfs(int remaining, int start) {
      if (remaining == 0) {
        final key = current.join(',');
        if (seen.add(key)) {
          results.add(List<int>.from(current));
        }
        return;
      }

      for (int i = start; i < candidates.length; i++) {
        if (candidates[i] > remaining) break;

        current.add(candidates[i]);
        dfs(remaining - candidates[i], i + 1);
        current.removeLast();
      }
    }

    dfs(target, 0);
    return results;
  }
}
```

### 🔴 Bottlenecks:
- Explores identical branches repeatedly (e.g. for input `[1, 1, 1, 1]`, it explores combinations of 1s across every index permutation).
- Allocates thousands of string keys and runs hash checks for dead ends.

---

## 2. Approach 2: Frequency Map Backtracking ($O(2^U)$ Time, $O(U)$ Space)

Groups duplicate numbers into `(value, count)` pairs and decides how many copies ($0, 1, \dots, \text{count}$) to take:

```dart
class SolutionFrequencyMap {
  List<List<int>> combinationSum2(List<int> candidates, int target) {
    final Map<int, int> counts = {};
    for (final c in candidates) {
      counts[c] = (counts[c] ?? 0) + 1;
    }

    final uniqueNums = counts.keys.toList()..sort();
    final List<List<int>> results = [];
    final List<int> current = [];

    void backtrack(int remaining, int index) {
      if (remaining == 0) {
        results.add(List<int>.from(current));
        return;
      }
      if (index >= uniqueNums.length) return;

      final val = uniqueNums[index];
      final maxAvailable = counts[val]!;

      // Try taking k instances of uniqueNums[index]
      for (int k = 0; k <= maxAvailable; k++) {
        if (k * val > remaining) break;

        for (int j = 0; j < k; j++) {
          current.add(val);
        }

        backtrack(remaining - k * val, index + 1);

        for (int j = 0; j < k; j++) {
          current.removeLast();
        }
      }
    }

    backtrack(target, 0);
    return results;
  }
}
```

### 🔴 Bottlenecks:
- Requires initializing `Map<int, int>` and extracting unique keys list.
- Nested loops add slight overhead compared to pure in-place array scanning.

---

## 3. Approach 3: Sorted Backtracking with Level Deduplication and Pruning (Optimal)

Sorts the raw array and applies:
1. `if (candidate > remainingTarget) break;` — Stops examining any larger candidates in this branch.
2. `if (i > startIndex && candidate == candidates[i - 1]) continue;` — Skips duplicate values at the current loop level in $O(1)$ without any extra collections.

```dart
// LeetCode 0040: Combination Sum II
// Optimal Solution: Backtracking with Sorting, Early Pruning, and Sibling Deduplication
// Time Complexity: O(2^N) in the worst case (tightly bounded by pruning)
// Space Complexity: O(N) auxiliary space for recursion call stack and current path

class Solution {
  List<List<int>> combinationSum2(List<int> candidates, int target) {
    // 1. Sorting clusters identical elements together and enables early pruning
    candidates.sort();

    final List<List<int>> results = [];
    final List<int> currentCombination = [];

    void backtrack(int remainingTarget, int startIndex) {
      // Base Case: Target sum matched
      if (remainingTarget == 0) {
        results.add(List<int>.from(currentCombination));
        return;
      }

      for (int i = startIndex; i < candidates.length; i++) {
        final candidate = candidates[i];

        // Pruning: Since the list is sorted in ascending order, if the current
        // candidate exceeds remainingTarget, all subsequent candidates will too.
        if (candidate > remainingTarget) {
          break;
        }

        // Deduplication: Skip duplicate candidates at the SAME recursion level/depth.
        // Elements are only skipped if i > startIndex (i.e. not the first candidate explored
        // in this loop), ensuring identical values can still be picked across DIFFERENT levels.
        if (i > startIndex && candidate == candidates[i - 1]) {
          continue;
        }

        currentCombination.add(candidate);
        // Each number may only be used ONCE, so advance to i + 1
        backtrack(remainingTarget - candidate, i + 1);
        currentCombination.removeLast(); // Backtrack
      }
    }

    backtrack(target, 0);
    return results;
  }
}
```

### 🟢 Why This is Optimal:
- **Zero Allocation Deduplication:** Identifies duplicate sibling branches using a simple index comparison `i > startIndex && c[i] == c[i-1]`.
- **Early Termination:** Ascending sort guarantees that when `candidates[i] > remainingTarget`, no subsequent element can form a valid sum.
- **Minimal Auxiliary Footprint:** Uses only $O(N)$ stack frames and modifies one dynamic list in place.

---

## 4. Approach 4: 0/1 Knapsack Bottom-Up Dynamic Programming ($O(N \cdot T \cdot K)$ Time, $O(T \cdot K)$ Space)

Adopts the 0/1 Knapsack reverse traversal to ensure each candidate instance is included at most once:

```dart
class SolutionDP01Knapsack {
  List<List<int>> combinationSum2(List<int> candidates, int target) {
    candidates.sort();
    // dp[t] stores unique combinations for sum t
    final List<Set<String>> dpStr = List.generate(target + 1, (_) => {});
    final List<List<List<int>>> dp = List.generate(target + 1, (_) => []);

    dp[0].add([]);
    dpStr[0].add('');

    for (final c in candidates) {
      // 0/1 knapsack must traverse in reverse to use each element once
      for (int t = target; t >= c; t--) {
        for (final comb in dp[t - c]) {
          final newComb = [...comb, c];
          final key = newComb.join(',');
          if (dpStr[t].add(key)) {
            dp[t].add(newComb);
          }
        }
      }
    }

    return dp[target];
  }
}
```

### 🔴 Bottlenecks:
- Builds full combinations for every integer sum $1 \dots \text{target}$.
- Substantially more memory-intensive due to string key hashing and 3D list allocations.

---

# 📊 Comprehensive Comparison Matrix

| Metric | 1. Backtracking + HashSet | 2. Frequency Map | 3. Sorted Backtracking (Optimal) | 4. 0/1 Knapsack DP |
| :--- | :--- | :--- | :--- | :--- |
| **Time Complexity** | $O(2^N)$ | $O(2^U)$ | **$O(2^N)$ (Heavily Pruned)** | $O(N \cdot T \cdot K)$ |
| **Auxiliary Space** | $O(2^N)$ (String set) | $O(U)$ map + $O(N)$ stack | **$O(N)$ (Stack + Path only)** | $O(T \cdot K)$ 3D lists |
| **Deduplication Cost** | String joins + Hash set | Frequency loop count | **$O(1)$ index check `i > start`** | String joins + Hash set |
| **Pruning Mechanism** | `break` on `c > rem` | Loop limit on `k * val` | **Immediate `break` on `c > rem`** | Loop bound $t \ge c$ |
| **Heap Allocations** | Very High | Moderate | **Minimal (Working list only)** | Very High |
| **Interview Rating** | Naive | Good | 🏆 **Gold Standard Expected** | 💡 **Creative DP Alternative** |

*Where $N = \text{candidates.length} \le 100$, $U = \text{unique candidates} \le 50$, $T = \text{target} \le 30$, and $K = \text{combinations count}$.*

---

# ⚠️ Key Interview Gotchas & Edge Cases

1. **The Classic Bug: `i > 0` vs `i > startIndex`:**
   - Writing `if (i > 0 && candidates[i] == candidates[i - 1]) continue;` is a **critical bug**!
   - It will prevent using identical numbers across different depths (e.g. `[1, 1, 6]` would never be formed because the second `1` at depth 1 would be skipped!).
   - Using `i > startIndex` ensures we only skip duplicates among **siblings** (at the same recursion depth), not among **parent-child descendants**.
2. **`break` vs `continue` for Pruning:**
   - Because `candidates` is sorted ascending, once `candidates[i] > remainingTarget`, all elements after $i$ are guaranteed to be larger. We must use `break` to stop the entire loop, saving dozens of recursive checks.
3. **Deep Copy on Solution Discovery:**
   - Must write `results.add(List<int>.from(currentCombination))` (or `List.of(...)`). Writing `results.add(currentCombination)` stores a pointer to the single working list, resulting in a list of empty arrays once backtracking unwinds.
4. **Single-Use Semantics (`i + 1`):**
   - Remember to pass `i + 1` (not `i` as in Combination Sum I) because each candidate index can be used at most once.
