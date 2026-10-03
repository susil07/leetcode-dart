# 🚀 LeetCode 0031 - Next Permutation

## 📝 Problem Statement

A **permutation** of an array of integers is an arrangement of its members into a sequence or linear order.

- For example, for `arr = [1, 2, 3]`, the following are all the permutations of `arr`: `[1, 2, 3]`, `[1, 3, 2]`, `[2, 1, 3]`, `[2, 3, 1]`, `[3, 1, 2]`, `[3, 2, 1]`.

The **next permutation** of an array of integers is the next lexicographically greater permutation of its integer. More formally, if all the permutations of the array are sorted in one container according to their lexicographical order, then the next permutation of that array is the permutation that follows it in the sorted container. If such arrangement is not possible, the array must be rearranged as the lowest possible order (i.e., sorted in ascending order).

- For example, the next permutation of `arr = [1, 2, 3]` is `[1, 3, 2]`.
- Similarly, the next permutation of `arr = [2, 3, 1]` is `[3, 1, 2]`.
- While the next permutation of `arr = [3, 2, 1]` is `[1, 2, 3]` because `[3, 2, 1]` does not have a lexicographical larger rearrangement.

Given an array of integers `nums`, find the next permutation of `nums`.

The replacement must be **in place** and use only **constant extra memory**.

---

## 🔒 Constraints

- $1 \le \text{nums.length} \le 100$
- $0 \le \text{nums}[i] \le 100$

---

## 💡 Examples

### Example 1
```text
Input: nums = [1, 2, 3]
Output: [1, 3, 2]
```

### Example 2
```text
Input: nums = [3, 2, 1]
Output: [1, 2, 3]
```

### Example 3
```text
Input: nums = [1, 1, 5]
Output: [1, 5, 1]
```

---

# 🧠 Evolution of Solutions: How We Make It Better

```text
┌────────────────────────────────────────────────────────────────────────┐
│  1. Brute Force (Generate All Permutations)                            │
│     • Generate all N! permutations recursively                         │
│     • Sort them lexicographically to find the current array's successor│
│     • Time: O(N! * N) | Space: O(N! * N)                               │
│     • Bottleneck: For N = 100, 100! > atoms in the observable universe │
└──────────────────────────────────┬─────────────────────────────────────┘
                                   │
                                   ▼ Identify Rightmost Decreasing Pivot
┌────────────────────────────────────────────────────────────────────────┐
│  2. Suffix Search + Sorting                                            │
│     • Scan from right to find pivot i where nums[i] < nums[i + 1]      │
│     • Swap with next greater element in suffix                         │
│     • Sort suffix nums[i + 1 .. n - 1] in ascending order              │
│     • Time: O(N log N) | Space: O(1) or O(N)                           │
│     • Bottleneck: Sorting takes O(N log N)                             │
└──────────────────────────────────┬─────────────────────────────────────┘
                                   │
                                   ▼ Suffix Inversion Property (No Sorting Needed)
┌────────────────────────────────────────────────────────────────────────┐
│  3. Narayana Pandita's In-Place Single-Pass Algorithm (Optimal)        │
│     • Step 1: Scan right-to-left for pivot i: nums[i] < nums[i + 1]   │
│     • Step 2: Scan right-to-left for successor j: nums[j] > nums[i]    │
│     • Step 3: Swap nums[i] and nums[j]                                 │
│     • Step 4: Reverse suffix [i + 1 .. n - 1] via Two Pointers         │
│     • Time: O(N) [at most 3 linear passes] | Space: O(1) In-Place      │
│     • Improvement: Reversing is O(N) because suffix is GUARANTEED      │
│       to be in non-increasing order!                                   │
└────────────────────────────────────────────────────────────────────────┘
```

---

# 💡 Core Concept: Narayana Pandita's Algorithm (14th Century)

To make a sequence *just slightly* larger lexicographically:
1. We must modify digits as far to the **right** as possible (lowest place values).
2. Any suffix that is strictly **descending** (e.g. `[7, 6, 5, 3, 1]`) is already in its **maximum possible permutation**—no internal reordering can make it larger without altering a digit to its left.

```text
Example: nums = [1, 5, 8, 4, 7, 6, 5, 3, 1]

Step 1: Find first decreasing element from the right (Pivot i = 3, nums[i] = 4)
                  Pivot (4)
                     │
  1,  5,  8,       [ 4 ],      7,  6,  5,  3,  1
                               └── Suffix is descending ──┘

Step 2: Find rightmost element strictly greater than Pivot (Successor j = 6, nums[j] = 5)
                               Successor (5)
                                     │
  1,  5,  8,       [ 4 ],      7,  6,[ 5 ], 3,  1

Step 3: Swap Pivot and Successor:
  1,  5,  8,       [ 5 ],      7,  6,[ 4 ], 3,  1
                               └── Suffix is STILL descending! ──┘

Step 4: Reverse the descending suffix to make it ascending (minimal):
  Reverse [7, 6, 4, 3, 1]  ──►  [1, 3, 4, 6, 7]

Final Next Permutation:
  [1, 5, 8, 5, 1, 3, 4, 6, 7] 🎉
```

---

# 💻 Solutions

## 1. Approach 1: Brute Force ($O(N! \cdot N)$ Time, $O(N! \cdot N)$ Space)

Generate all permutations, sort them, and pick the one immediately following `nums`:

```dart
class SolutionBruteForce {
  void nextPermutation(List<int> nums) {
    // Generates all N! permutations
    // Unfeasible for N > 10 (10! = 3.6 million, 100! is astronomically impossible)
  }
}
```

### 🔴 Bottlenecks:
- $O(N!)$ time and space complexity $\rightarrow$ **Catastrophic TLE and Memory Limit Exceeded**.

---

## 2. Approach 2: Suffix Pivot + Subarray Sort ($O(N \log N)$ Time, $O(1)$ Space)

Find the pivot and swap, then sort the remaining suffix:

```dart
class SolutionSort {
  void nextPermutation(List<int> nums) {
    final int n = nums.length;
    int i = n - 2;
    while (i >= 0 && nums[i] >= nums[i + 1]) {
      i--;
    }

    if (i >= 0) {
      int j = n - 1;
      while (nums[j] <= nums[i]) {
        j--;
      }
      final temp = nums[i];
      nums[i] = nums[j];
      nums[j] = temp;
    }

    // Sorting the suffix takes O(N log N)
    final suffix = nums.sublist(i + 1)..sort();
    nums.replaceRange(i + 1, n, suffix);
  }
}
```

### 🔴 Bottlenecks:
- Calls `.sort()` on the suffix ($O(N \log N)$) and allocates an extra list ($O(N)$ space).

---

## 3. Approach 3: Narayana Pandita's In-Place Algorithm ($O(N)$ Time, $O(1)$ Space) — Optimal

Because the suffix is **guaranteed to be in descending order**, reversing it with two pointers takes **$O(N)$ time** and **$O(1)$ space**:

```dart
class Solution {
  void nextPermutation(List<int> nums) {
    final int n = nums.length;
    if (n <= 1) return;

    // Step 1: Find the first decreasing element from the right (the pivot)
    int i = n - 2;
    while (i >= 0 && nums[i] >= nums[i + 1]) {
      i--;
    }

    // Step 2: If a valid pivot was found, find the smallest element > nums[i] from the right
    if (i >= 0) {
      int j = n - 1;
      // Suffix nums[i + 1 .. n - 1] is non-increasing, so first element > nums[i] from right is successor
      while (nums[j] <= nums[i]) {
        j--;
      }
      _swap(nums, i, j);
    }

    // Step 3: Reverse the non-increasing suffix [i + 1 .. n - 1] to make it ascending (minimal)
    _reverse(nums, i + 1, n - 1);
  }

  void _swap(List<int> nums, int a, int b) {
    final temp = nums[a];
    nums[a] = nums[b];
    nums[b] = temp;
  }

  void _reverse(List<int> nums, int start, int end) {
    int left = start;
    int right = end;
    while (left < right) {
      _swap(nums, left, right);
      left++;
      right--;
    }
  }
}
```

---

# 🧪 Step-by-Step Dry Run

### Case 1: Standard Permutation `nums = [1, 2, 3]`
1. $i = 1$ (`nums[1] = 2 < nums[2] = 3`). Pivot = $2$ at index $1$.
2. $j = 2$ (`nums[2] = 3 > 2`). Swap $2$ and $3 \rightarrow [1, 3, 2]$.
3. Reverse suffix from $i + 1 = 2$ to $2$ (single element, unchanged).
4. **Result:** `[1, 3, 2]` ✅

### Case 2: Maximum Permutation `nums = [3, 2, 1]`
1. Scanning right-to-left, $i$ decreases past $0$ ($i = -1$). No pivot found!
2. Skip Step 2.
3. Step 3: Reverse entire array from $i + 1 = 0$ to $2$:
   - Swap $3$ and $1 \rightarrow [1, 2, 3]$.
4. **Result:** `[1, 2, 3]` ✅

---

# 📊 Comprehensive Comparison Matrix

| Metric | 1. Brute Force | 2. Suffix Sort | 3. Narayana's Algorithm (Optimal) |
| :--- | :--- | :--- | :--- |
| **Time Complexity** | $O(N! \cdot N)$ | $O(N \log N)$ | **$O(N)$** |
| **Auxiliary Space** | $O(N! \cdot N)$ | $O(N)$ sublist | **$O(1)$ Strictly in-place** |
| **Passes Over Array** | Multiple | 2 + Sort | **At most 3 linear passes ($2$ scans $+ 1$ reverse)** |
| **Handles Duplicates?** | Yes | Yes | **Yes (Weak inequality `nums[i] >= nums[i+1]`)** |
| **Interview Suitability** | ❌ Impossible | ⚠️ Suboptimal | 🏆 **Gold Standard Expected** |

---

# ⚠️ Key Interview Gotchas & Edge Cases

1. **Weak Inequality for Pivot Search (`nums[i] >= nums[i + 1]`):**
   - Must use `>=` and not `>`. If duplicates exist (e.g. `[1, 5, 1]`), checking `>=` ensures we keep moving left over equal values until a strictly smaller element is found.
2. **Weak Inequality for Successor Search (`nums[j] <= nums[i]`):**
   - Must find an element **strictly greater** than `nums[i]`. Equal elements cannot increase the permutation.
3. **Why Suffix Reversal Works Without Sorting:**
   - The suffix `nums[i + 1 .. n - 1]` was proven non-increasing in Step 1.
   - Swapping `nums[i]` with the rightmost element $> nums[i]$ preserves this non-increasing property.
   - Reversing a descending sequence directly yields an ascending (minimal) sequence in $O(N)$ time.
