# 🚀 LeetCode 0046 - Permutations

## 📝 Problem Statement

Given an array `nums` of **distinct** integers, return all the possible **permutations**. You can return the answer in **any order**.

---

## 🔒 Constraints

- $1 \le \text{nums.length} \le 6$
- $-10 \le \text{nums}[i] \le 10$
- All the integers of `nums` are **unique**.

---

## 💡 Examples

### Example 1
```text
Input: nums = [1,2,3]
Output: [[1,2,3],[1,3,2],[2,1,3],[2,3,1],[3,1,2],[3,2,1]]
```

### Example 2
```text
Input: nums = [0,1]
Output: [[0,1],[1,0]]
```

### Example 3
```text
Input: nums = [1]
Output: [[1]]
```

---

# 🧠 Evolution of Solutions: How We Make It Better

```text
┌────────────────────────────────────────────────────────────────────────┐
│  1. Backtracking with Boolean `used` Array                             │
│     • Maintain a `used` boolean array and dynamic `current` list       │
│     • Scan 0..N-1 at each step, pick unused element, push, and pop     │
│     • Time: O(N * N!) | Space: O(N) path + O(N) boolean flags          │
│     • Bottleneck: Scans N elements at every level; allocates boolean   │
│       flags and dynamically appends/removes to working list            │
└──────────────────────────────────┬─────────────────────────────────────┘
                                   │
                                   ▼ Bit Manipulation (Register Optimization)
┌────────────────────────────────────────────────────────────────────────┐
│  2. Backtracking with Bitmask State                                    │
│     • Replace `used` array with an integer bitmask `mask | (1 << i)`   │
│     • Checks availability in a single CPU cycle: (mask & (1 << i)) == 0│
│     • Time: O(N * N!) | Space: O(N) path + O(1) bitmask                │
│     • Bottleneck: Still requires maintaining a dynamic `current` list  │
│       with append and pop operations                                   │
└──────────────────────────────────┬─────────────────────────────────────┘
                                   │
                                   ▼ Eliminate All Auxiliary State Collections
┌────────────────────────────────────────────────────────────────────────┐
│  3. In-Place Swap Backtracking (Optimal)                               │
│     • Divide array into [fixed prefix | available suffix]              │
│     • Swap element at `first` with each index in `first..N-1`          │
│     • Zero boolean flags, zero bitmasks, zero dynamic list resizing    │
│     • Time: O(N * N!) | Space: O(N) recursion stack (no auxiliary path)│
│     • Improvement: Absolute minimum memory footprint and max locality  │
└──────────────────────────────────┬─────────────────────────────────────┘
                                   │
                                   ▼ Non-Recursive Alternative
┌────────────────────────────────────────────────────────────────────────┐
│  4. Lexicographical Generation (Next Permutation Loop)                 │
│     • Sort array ascending, generate next permutation N! - 1 times     │
│     • Time: O(N * N!) | Space: O(1) auxiliary (iterative)              │
│     • Trade-off: Non-recursive and sorted, but performs pivot scans    │
│       and sub-array reversals at every step                            │
└────────────────────────────────────────────────────────────────────────┘
```

---

# 🌳 State Space Tree: In-Place Swapping

For `nums = [1, 2, 3]`:

```text
                                  [1, 2, 3] (first = 0)
                 /                         |                        \
          swap(0, 0)                   swap(0, 1)                swap(0, 2)
              v                            v                         v
          [1, 2, 3] (first=1)          [2, 1, 3] (first=1)       [3, 2, 1] (first=1)
           /        \                   /        \                /        \
       swap(1,1)  swap(1,2)         swap(1,1)  swap(1,2)      swap(1,1)  swap(1,2)
          v          v                 v          v              v          v
      [1, 2, 3]  [1, 3, 2]         [2, 1, 3]  [2, 3, 1]      [3, 2, 1]  [3, 1, 2]
```

At each level `first`:
- Elements before `first` (`0 .. first - 1`) are already finalized in the current permutation.
- Elements at `first .. n - 1` are the available pool of remaining numbers.
- Swapping `first` with `i` picks `nums[i]` as the next element.
- Swapping back restores the original arrangement for sibling branches.

---

# 💻 Solutions

## 1. Approach 1: Backtracking with Boolean `used` Array ($O(N \cdot N!)$ Time, $O(N)$ Space)

Uses a boolean array to track which elements are currently included in the path:

```dart
class SolutionVisitedArray {
  List<List<int>> permute(List<int> nums) {
    final List<List<int>> results = [];
    final List<int> current = [];
    final List<bool> used = List<bool>.filled(nums.length, false);

    void backtrack() {
      if (current.length == nums.length) {
        results.add(List<int>.from(current));
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
- Allocates a `used` boolean array on the heap.
- Incurs continuous dynamic list resizes via `add` and `removeLast`.

---

## 2. Approach 2: Bitmask Backtracking ($O(N \cdot N!)$ Time, $O(N)$ Space)

Replaces the `used` array with an integer bitmask, passing state by value without unsetting flags manually:

```dart
class SolutionBitmask {
  List<List<int>> permute(List<int> nums) {
    final List<List<int>> results = [];
    final List<int> current = [];
    final int n = nums.length;

    void backtrack(int mask) {
      if (current.length == n) {
        results.add(List<int>.from(current));
        return;
      }

      for (int i = 0; i < n; i++) {
        if ((mask & (1 << i)) == 0) {
          current.add(nums[i]);
          backtrack(mask | (1 << i));
          current.removeLast();
        }
      }
    }

    backtrack(0);
    return results;
  }
}
```

### 🔴 Bottlenecks:
- While bit testing is instantaneous in CPU registers, it still requires maintaining a separate `current` working list.

---

## 3. Approach 3: In-Place Swap Backtracking (Optimal)

Operates directly within the input array `nums`. Partitioning `nums` into fixed elements (`0 .. first - 1`) and candidate elements (`first .. n - 1`) completely eliminates all auxiliary tracking structures:

```dart
// LeetCode 0046: Permutations
// Optimal Solution: In-Place Swap Backtracking
// Time Complexity: O(N * N!) where N = nums.length
// Space Complexity: O(N) auxiliary space for recursion stack (excluding output)

class Solution {
  List<List<int>> permute(List<int> nums) {
    final List<List<int>> results = [];
    final int n = nums.length;

    // Recursively fix elements from index `first` to `n - 1`
    void backtrack(int first) {
      // Base case: all positions fixed, record a snapshot copy
      if (first == n) {
        results.add(List<int>.from(nums));
        return;
      }

      for (int i = first; i < n; i++) {
        // Place nums[i] at position `first`
        final temp = nums[first];
        nums[first] = nums[i];
        nums[i] = temp;

        // Recurse to place remaining candidates at position `first + 1`
        backtrack(first + 1);

        // Backtrack: restore original array state for subsequent iterations
        nums[i] = nums[first];
        nums[first] = temp;
      }
    }

    backtrack(0);
    return results;
  }
}
```

### 🟢 Why This is Optimal:
- **Zero Auxiliary Data Structures:** No `used` flags, sets, or separate path lists.
- **Cache-Friendly In-Place Swaps:** Swapping two array elements requires two primitive read-write operations in L1 CPU cache.
- **Exact Branching:** At depth `k`, exactly $N - k$ recursive branches are spawned without iterating over already-used indices.

---

## 4. Approach 4: Lexicographical Iteration via Next Permutation ($O(N \cdot N!)$ Time, $O(1)$ Space)

Sorts `nums` initially and iteratively computes the next lexicographical permutation (LeetCode 31 algorithm) until all $N!$ permutations are generated:

```dart
class SolutionNextPermutation {
  List<List<int>> permute(List<int> nums) {
    final List<List<int>> results = [];
    nums.sort(); // Start with lowest lexicographical order

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
- **Zero Recursion Depth:** Completely eliminates call stack frames ($O(1)$ auxiliary space).
- Guarantees strict lexicographical ordering of permutations.

---

# 📊 Comprehensive Comparison Matrix

| Metric | 1. Visited Array | 2. Bitmask | 3. In-Place Swap (Optimal) | 4. Next Permutation Iteration |
| :--- | :--- | :--- | :--- | :--- |
| **Time Complexity** | $O(N \cdot N!)$ | $O(N \cdot N!)$ | **$O(N \cdot N!)$** | $O(N \cdot N!)$ |
| **Auxiliary Space** | $O(N)$ path + $O(N)$ bools | $O(N)$ path | **$O(N)$ Stack only** | **$O(1)$ (No stack)** |
| **Tracking Mechanism** | `List<bool>` | 32-bit `int` mask | **In-place boundary index** | None (lexicographical scan) |
| **List Manipulations** | `add` & `removeLast` | `add` & `removeLast` | **Primitive index swap** | Reverse & 2-pointer swap |
| **Execution Order** | Lexicographical | Lexicographical | Non-lexicographical | Strictly Lexicographical |
| **Interview Rating** | Standard | Clean | 🏆 **Gold Standard Expected** | 🚀 **Outstanding Follow-Up** |

*Where $N = \text{nums.length} \le 6$ and $N! \le 720$.*

---

# ⚠️ Key Interview Gotchas & Edge Cases

1. **Backtracking the Swap:**
   - Always remember to swap back:
     ```dart
     nums[first] = nums[i]; nums[i] = temp; // restore
     ```
     If you forget to restore, the array will remain scrambled for sibling branches, producing incorrect duplicate permutations.
2. **Deep Copy Required:**
   - When adding to `results`, write `results.add(List<int>.from(nums))` (or `List.of(nums)`).
   - Writing `results.add(nums)` adds a reference to the mutable working array, causing all entries in `results` to end up identical to the final array state!
3. **Distinct vs Duplicate Numbers:**
   - This in-place swap approach works specifically because all elements in `nums` are **distinct**.
   - If `nums` contains duplicates (LeetCode 47: Permutations II), in-place swapping requires tracking seen values at each level or sorting with skipping.
