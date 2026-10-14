# 🚀 LeetCode 0047 - Permutations II

## 📝 Problem Statement

Given a collection of numbers, `nums`, that might contain duplicates, return *all possible unique permutations in **any order***.

---

## 🔒 Constraints

- $1 \le \text{nums.length} \le 8$
- $-10 \le \text{nums}[i] \le 10$

---

## 💡 Examples

### Example 1
```text
Input: nums = [1,1,2]
Output:
[[1,1,2],
 [1,2,1],
 [2,1,1]]
```

### Example 2
```text
Input: nums = [1,2,3]
Output: 
[[1,2,3],[1,3,2],[2,1,3],[2,3,1],[3,1,2],[3,2,1]]
```

---

# 🔄 Contrast: Permutations I vs Permutations II

| Feature | LeetCode 46 (Permutations I) | LeetCode 47 (Permutations II) |
| :--- | :--- | :--- |
| **Input Elements** | All numbers are **distinct** | May contain **duplicate numbers** |
| **Total Permutations** | Always $N!$ | $\frac{N!}{n_1! \, n_2! \dots n_k!}$ unique permutations |
| **In-Place Swap** | Pure swap works without extra tracking | Requires local `Set<int>` at each level or sorting |
| **Deduplication** | Not needed (every element unique) | Enforced via **predecessor-used check** (`!used[i - 1]`) |

---

# 🧠 Evolution of Solutions: How We Make It Better

```text
┌────────────────────────────────────────────────────────────────────────┐
│  1. Backtracking with Global HashSet Deduplication                     │
│     • Generate all N! permutations ignoring duplicates                 │
│     • Store serialized strings into Set<String> to filter duplicates   │
│     • Time: O(N * N!) | Space: O(N * N!) for set of all permutations   │
│     • Bottleneck: Explores all duplicate subtrees; heavy string hashes │
└──────────────────────────────────┬─────────────────────────────────────┘
                                   │
                                   ▼ Eliminate Global String Hashes
┌────────────────────────────────────────────────────────────────────────┐
│  2. In-Place Swap Backtracking with Local Level HashSets               │
│     • Swap nums[first] with nums[i]; track swapped values in Set<int>  │
│     • If nums[i] was already swapped at this level, skip it            │
│     • Time: O(N * P) | Space: O(N^2) for sets across stack levels      │
│     • Bottleneck: Allocates and queries Set<int> at every recursion level│
└──────────────────────────────────┬─────────────────────────────────────┘
                                   │
                                   ▼ Eliminate All Hash Sets via Sorting
┌────────────────────────────────────────────────────────────────────────┐
│  3. Sorted Backtracking with Predecessor-Used Check (Optimal)          │
│     • Sort nums upfront so identical values are adjacent               │
│     • Skip: if (i > 0 && nums[i] == nums[i-1] && !used[i-1]) continue  │
│     • Enforces strict index ordering for identical values              │
│     • Time: O(N * P) | Space: O(N) recursion stack + used array        │
│     • Improvement: Zero hash allocations, early tree pruning           │
└──────────────────────────────────┬─────────────────────────────────────┘
                                   │
                                   ▼ Non-Recursive Iterative Alternative
┌────────────────────────────────────────────────────────────────────────┐
│  4. Lexicographical Generation (Next Permutation Loop)                 │
│     • Sort array ascending, generate next lexicographical permutation  │
│     • Inherently handles duplicates with zero duplicate generations    │
│     • Time: O(N * P) | Space: O(1) auxiliary (iterative)              │
│     • Trade-off: Non-recursive, but requires pivot scans & reversals   │
└────────────────────────────────────────────────────────────────────────┘
```

*Where $P = \frac{N!}{n_1! \, n_2! \dots n_k!}$ is the number of unique permutations.*

---

# 🌳 Why `!used[i - 1]` Prunes Duplicates

Consider `nums = [1, 1', 2]` where $1$ and $1'$ are identical values at index $0$ and $1$:

```text
                                       Root []
                        /                 |                 \
                  Pick nums[0] (1)   Pick nums[1] (1')     Pick nums[2] (2)
                  used[0] = true           SKIP!
                        |             nums[1] == nums[0]
                        |             && !used[0]
                        v             (1 was already explored
                  Pick nums[1] (1')    at this level!)
                  used[0] is true!
                  allowed!
                        |
                        v
                  Pick nums[2] (2)
                        |
                        v
                    [1, 1', 2]
```

### The Relative Order Invariant:
When there are identical elements $[x_1, x_2, \dots, x_k]$, we impose the rule:
$$\text{Element } x_j \text{ can only be picked if } x_{j-1} \text{ is ALREADY PICKED in the current branch.}$$

1. **Vertical / Parent-Child (Allowed):**
   - At depth 0, we pick $x_1$ (`used[0] = true`).
   - At depth 1, we look at $x_2$. Because `used[0]` is **true**, `!used[0]` is **false**. The check does NOT trigger, and $x_2$ is successfully picked!
2. **Horizontal / Siblings (Blocked):**
   - After exploring all permutations starting with $x_1$, backtracking finishes and sets `used[0] = false`.
   - The loop at depth 0 moves to $x_2$ (`i = 1`).
   - Here, $nums[1] == nums[0]$ and `used[0]` is **false** (`!used[0]` is **true**).
   - Picking $x_2$ here would generate the exact same set of permutations as picking $x_1$.
   - **`!used[i - 1]` immediately skips this entire duplicate branch!**

---

# 💻 Solutions

## 1. Approach 1: Backtracking with Global HashSet ($O(N \cdot N!)$ Time, $O(N \cdot N!)$ Space)

Generates all $N!$ permutations and filters out duplicates using a `Set<String>`:

```dart
class SolutionHashSet {
  List<List<int>> permuteUnique(List<int> nums) {
    final List<List<int>> results = [];
    final List<int> current = [];
    final List<bool> used = List<bool>.filled(nums.length, false);
    final Set<String> seen = {};

    void backtrack() {
      if (current.length == nums.length) {
        final key = current.join(',');
        if (seen.add(key)) {
          results.add(List<int>.from(current));
        }
        return;
      }

      for (int i = 0; i < nums.length; i++) {
        if (!used[i]) {
          used[i] = true;
          current.add(nums[i]);
          backtrack();
          current.removeLast();
          used[i] = false;
        }
      }
    }

    backtrack();
    return results;
  }
}
```

### 🔴 Bottlenecks:
- Explores all $N!$ permutations, many of which are identical (e.g., for `[1, 1, 1, 1, 1]`, it explores $120$ states to find $1$ unique permutation).
- Allocates and hashes strings for every single permutation.

---

## 2. Approach 2: Swap Backtracking with Local Level HashSets ($O(N \cdot P)$ Time, $O(N^2)$ Space)

Extends the in-place swap method by tracking which values have already been swapped into position `first` at the current recursion level:

```dart
class SolutionSwapSet {
  List<List<int>> permuteUnique(List<int> nums) {
    final List<List<int>> results = [];

    void backtrack(int first) {
      if (first == nums.length) {
        results.add(List<int>.from(nums));
        return;
      }

      final Set<int> seenAtThisLevel = {};
      for (int i = first; i < nums.length; i++) {
        // If this value has already been placed at index `first`, skip
        if (seenAtThisLevel.contains(nums[i])) continue;
        seenAtThisLevel.add(nums[i]);

        final temp = nums[first];
        nums[first] = nums[i];
        nums[i] = temp;

        backtrack(first + 1);

        nums[i] = nums[first];
        nums[first] = temp;
      }
    }

    backtrack(0);
    return results;
  }
}
```

### 🔴 Bottlenecks:
- Allocates a new `Set<int>` at every recursive call, causing unnecessary GC allocations.
- Permutations are not generated in lexicographical order.

---

## 3. Approach 3: Sorted Backtracking with Predecessor-Used Deduplication (Optimal)

Sorts the input array first so identical numbers are grouped. Uses a simple boolean `used` array with the `!used[i - 1]` condition:

```dart
// LeetCode 0047: Permutations II
// Optimal Solution: Backtracking with Sorting and Predecessor-Used Deduplication
// Time Complexity: O(N * (N! / (n1! * n2! * ... * nk!))) where N = nums.length
// Space Complexity: O(N) auxiliary space for recursion stack and used array

class Solution {
  List<List<int>> permuteUnique(List<int> nums) {
    // Sorting clusters identical elements together so duplicates are adjacent
    nums.sort();

    final List<List<int>> results = [];
    final List<int> current = [];
    final List<bool> used = List<bool>.filled(nums.length, false);

    void backtrack() {
      // Base case: a complete unique permutation of length N has been formed
      if (current.length == nums.length) {
        results.add(List<int>.from(current));
        return;
      }

      for (int i = 0; i < nums.length; i++) {
        // Skip already selected elements in the current permutation path
        if (used[i]) continue;

        // Deduplication rule:
        // If the current element equals the previous element, we only permit
        // picking it if the previous identical element is ALREADY USED in the current branch.
        // If !used[i - 1], it means nums[i - 1] was previously picked and backtracked out,
        // so picking nums[i] here would begin an identical duplicate subtree at this level.
        if (i > 0 && nums[i] == nums[i - 1] && !used[i - 1]) {
          continue;
        }

        used[i] = true;
        current.add(nums[i]);

        backtrack();

        current.removeLast(); // Backtrack
        used[i] = false;
      }
    }

    backtrack();
    return results;
  }
}
```

### 🟢 Why This is Optimal:
- **Zero Hash Overhead:** Deduplication is achieved with an $O(1)$ index check `nums[i] == nums[i - 1] && !used[i - 1]`.
- **Optimal State Exploration:** Explores *only* valid unique branches without ever exploring duplicate subtrees.
- **Lexicographical Guarantee:** Permutations are produced in ascending lexicographical order naturally.
- **Minimal Auxiliary Footprint:** Uses a single `List<bool>` of size $N \le 8$ allocated once.

---

## 4. Approach 4: Lexicographical Generation (Next Permutation Loop) ($O(N \cdot P)$ Time, $O(1)$ Space)

The Next Permutation algorithm (LeetCode 31) inherently handles duplicates because it finds the next strictly greater lexicographical permutation:

```dart
class SolutionNextPermutation {
  List<List<int>> permuteUnique(List<int> nums) {
    nums.sort();
    final List<List<int>> results = [];

    bool nextPermutation(List<int> a) {
      int i = a.length - 2;
      while (i >= 0 && a[i] >= a[i + 1]) i--;
      if (i < 0) return false;

      int j = a.length - 1;
      while (a[j] <= a[i]) j--;

      final temp = a[i];
      a[i] = a[j];
      a[j] = temp;

      int l = i + 1, r = a.length - 1;
      while (l < r) {
        final t = a[l];
        a[l++] = a[r];
        a[r--] = t;
      }
      return true;
    }

    results.add(List<int>.from(nums));
    while (nextPermutation(nums)) {
      results.add(List<int>.from(nums));
    }

    return results;
  }
}
```

### 🟢 Value:
- **Zero Recursion Depth:** Completely eliminates recursion stack frames.
- **Zero Auxiliary Memory:** $O(1)$ auxiliary space beyond the output list.

---

# 📊 Comprehensive Comparison Matrix

| Metric | 1. Global HashSet | 2. Swap + Local Sets | 3. Sorted + Predecessor Check (Optimal) | 4. Next Permutation Iterative |
| :--- | :--- | :--- | :--- | :--- |
| **Time Complexity** | $O(N \cdot N!)$ | $O(N \cdot P)$ | **$O(N \cdot P)$** | $O(N \cdot P)$ |
| **Auxiliary Space** | $O(N \cdot N!)$ Set | $O(N^2)$ Local Sets | **$O(N)$ (Stack + 1 bool list)** | **$O(1)$ (No stack)** |
| **Deduplication Cost** | String serialize & hash | Set lookup per swap | **$O(1)$ boolean check `!used[i-1]`** | Implicit in pivot search |
| **Duplicate Subtrees** | Fully explored | Pruned at level | **Pruned immediately** | Never explored |
| **Output Ordering** | Arbitrary | Arbitrary | **Lexicographically sorted** | **Strictly lexicographical** |
| **Interview Rating** | Naive / Poor | Clever | 🏆 **Gold Standard Expected** | 🚀 **Outstanding Follow-Up** |

*Where $N = \text{nums.length} \le 8$ and $P = \frac{N!}{n_1! \, n_2! \dots n_k!}$.*

---

# ⚠️ Key Interview Gotchas & Edge Cases

1. **The Classic Interview Question: `!used[i - 1]` vs `used[i - 1]`:**
   - Both technically work to deduplicate, but:
     - `!used[i - 1]` means: *"Only pick duplicate $i$ if duplicate $i - 1$ is ALREADY used."* This enforces **forward relative ordering** and prunes branches immediately.
     - `used[i - 1]` means: *"Only pick duplicate $i$ if duplicate $i - 1$ is NOT used."* This traverses significantly deeper into redundant states before pruning, resulting in slower execution.
   - **Always write `!used[i - 1]` in interviews and explain the forward-ordering invariant.**
2. **Why In-Place Swap Alone Fails for Duplicates:**
   - In LeetCode 46, distinct elements can be swapped freely without a set.
   - In LeetCode 47, simply sorting before swap-backtracking does **not** prevent duplicates because swaps reorder elements, destroying the sorted property for subsequent recursive steps. To use swaps with duplicates, you must use a local `Set<int>` at each level (Approach 2).
3. **Snapshot Deep Copy:**
   - Always do `results.add(List<int>.from(current))` (or `List.of(...)`). Storing `results.add(current)` adds a pointer to the single mutable list, which empties out when backtracking unwinds.
