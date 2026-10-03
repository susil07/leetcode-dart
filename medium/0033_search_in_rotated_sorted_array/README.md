# 🚀 LeetCode 0033 - Search in Rotated Sorted Array

## 📝 Problem Statement

There is an integer array `nums` sorted in ascending order (with **distinct** values).

Prior to being passed to your function, `nums` is **possibly left rotated** at an unknown index `k` ($1 \le k < nums.length$) such that the resulting array is:
$$[nums[k], nums[k+1], \dots, nums[n-1], nums[0], nums[1], \dots, nums[k-1]]$$

For example, `[0, 1, 2, 4, 5, 6, 7]` might be left rotated by 3 indices and become `[4, 5, 6, 7, 0, 1, 2]`.

Given the array `nums` after the possible rotation and an integer `target`, return the **index of `target`** if it is in `nums`, or **`-1`** if it is not in `nums`.

You must write an algorithm with **$O(\log n)$ runtime complexity**.

---

## 🔒 Constraints

- $1 \le nums.length \le 5000$
- $-10^4 \le nums[i] \le 10^4$
- All values of `nums` are **unique**.
- `nums` is an ascending array that is possibly rotated.
- $-10^4 \le target \le 10^4$

---

## 💡 Examples

### Example 1
```text
Input: nums = [4, 5, 6, 7, 0, 1, 2], target = 0
Output: 4
```

### Example 2
```text
Input: nums = [4, 5, 6, 7, 0, 1, 2], target = 3
Output: -1
```

### Example 3
```text
Input: nums = [1], target = 0
Output: -1
```

---

# 🧠 Evolution of Solutions: How We Make It Better

```text
┌────────────────────────────────────────────────────────────────────────┐
│  1. Linear Search                                                      │
│     • Iterate from i = 0 to n - 1 checking if nums[i] == target        │
│     • Time: O(N) | Space: O(1)                                         │
│     • Bottleneck: Fails the explicit interview requirement for O(log N)│
└──────────────────────────────────┬─────────────────────────────────────┘
                                   │
                                   ▼ Two-Pass Binary Search
┌────────────────────────────────────────────────────────────────────────┐
│  2. Two-Pass Binary Search (Find Pivot + Binary Search Subarray)       │
│     • Pass 1: Binary search to find smallest element index (pivot)     │
│     • Pass 2: Binary search on either [0 .. pivot-1] or [pivot .. n-1] │
│     • Time: O(log N) [2 binary searches] | Space: O(1)                 │
│     • Bottleneck: Two separate binary search implementations needed    │
└──────────────────────────────────┬─────────────────────────────────────┘
                                   │
                                   ▼ Exploit "One Half is Always Sorted"
┌────────────────────────────────────────────────────────────────────────┐
│  3. One-Pass Modified Binary Search (Optimal Interview Standard)       │
│     • In any rotated sorted array, AT LEAST ONE HALF is strictly sorted│
│     • If nums[left] <= nums[mid]: Left half is sorted                  │
│         - If target in [nums[left], nums[mid]): right = mid - 1        │
│         - Else: left = mid + 1                                         │
│     • Otherwise: Right half is sorted                                  │
│         - If target in (nums[mid], nums[right]]: left = mid + 1        │
│         - Else: right = mid - 1                                        │
│     • Time: O(log N) [Strictly 1 pass] | Space: O(1)                   │
└────────────────────────────────────────────────────────────────────────┘
```

---

# 💡 Core Concept: "At Least One Half Is Always Sorted"

When an ascending array is rotated once around a pivot, dividing it at any index `mid` **always yields at least one contiguous subarray that is completely sorted**:

```text
Array: [4, 5, 6, 7, 0, 1, 2]
               ▲
              mid (7)

Left Half:  [4, 5, 6, 7]  --> Strictly Sorted! (nums[left] <= nums[mid])
Right Half: [7, 0, 1, 2]  --> Contains the rotation drop (not sorted)
```

Because the left half is sorted, we can check whether `target` falls into it using simple boundary checks in $O(1)$:
$$\text{If } nums[left] \le target < nums[mid] \implies \text{Search LEFT } (right = mid - 1)$$
$$\text{Else } \implies \text{Search RIGHT } (left = mid + 1)$$

If the left half is not sorted (`nums[left] > nums[mid]`), then the **right half must be sorted**:
$$\text{If } nums[mid] < target \le nums[right] \implies \text{Search RIGHT } (left = mid + 1)$$
$$\text{Else } \implies \text{Search LEFT } (right = mid - 1)$$

---

# 💻 Solutions

## 1. Approach 1: Linear Scan ($O(N)$ Time, $O(1)$ Space)

Check every element linearly:

```dart
class SolutionLinear {
  int search(List<int> nums, int target) {
    for (int i = 0; i < nums.length; i++) {
      if (nums[i] == target) return i;
    }
    return -1;
  }
}
```

### 🔴 Bottlenecks:
- $O(N)$ time complexity. Explicitly rejected by the problem constraint requiring $O(\log N)$.

---

## 2. Approach 2: Two-Pass Binary Search ($O(\log N)$ Time, $O(1)$ Space)

First locate the rotation pivot (minimum element) using binary search, then binary search within the appropriate sorted half:

```dart
class SolutionTwoPass {
  int search(List<int> nums, int target) {
    int left = 0;
    int right = nums.length - 1;

    // Pass 1: Find the index of the minimum element (the pivot)
    while (left < right) {
      final mid = left + (right - left) ~/ 2;
      if (nums[mid] > nums[right]) {
        left = mid + 1;
      } else {
        right = mid;
      }
    }
    final int pivot = left;

    // Determine which half to search
    left = 0;
    right = nums.length - 1;
    if (target >= nums[pivot] && target <= nums[right]) {
      left = pivot;
    } else {
      right = pivot - 1;
    }

    // Pass 2: Standard Binary Search
    while (left <= right) {
      final mid = left + (right - left) ~/ 2;
      if (nums[mid] == target) return mid;
      if (nums[mid] < target) {
        left = mid + 1;
      } else {
        right = mid - 1;
      }
    }

    return -1;
  }
}
```

### 🔴 Bottlenecks:
- Requires two separate loops and more code lines during interviews.

---

## 3. Approach 3: One-Pass Modified Binary Search (Optimal)

Identify the sorted half on every step and eliminate half the search space in a single pass:

```dart
class Solution {
  int search(List<int> nums, int target) {
    int left = 0;
    int right = nums.length - 1;

    while (left <= right) {
      final mid = left + (right - left) ~/ 2;

      // Target found at mid
      if (nums[mid] == target) {
        return mid;
      }

      // Check if the left half [left .. mid] is sorted
      if (nums[left] <= nums[mid]) {
        // Check if target falls within the sorted left half
        if (nums[left] <= target && target < nums[mid]) {
          right = mid - 1;
        } else {
          left = mid + 1;
        }
      }
      // Otherwise, the right half [mid .. right] must be sorted
      else {
        // Check if target falls within the sorted right half
        if (nums[mid] < target && target <= nums[right]) {
          left = mid + 1;
        } else {
          right = mid - 1;
        }
      }
    }

    // Target does not exist in nums
    return -1;
  }
}
```

---

# 🧪 Step-by-Step Dry Run

Input: `nums = [4, 5, 6, 7, 0, 1, 2], target = 0`

| Iteration | `left` (`nums[l]`) | `right` (`nums[r]`) | `mid` (`nums[m]`) | Sorted Half | In Range Check | Action |
| :---: | :---: | :---: | :---: | :---: | :---: | :--- |
| **1** | `0` (`4`) | `6` (`2`) | `3` (`7`) | Left (`4 <= 7`) | $0 \in [4, 7)$? ❌ No | Search Right: `left = 4` |
| **2** | `4` (`0`) | `6` (`2`) | `5` (`1`) | Left (`0 <= 1`) | $0 \in [0, 1)$? ✅ Yes | Search Left: `right = 4` |
| **3** | `4` (`0`) | `4` (`0`) | `4` (`0`) | — | `nums[4] == 0` ✅ | **Return `4`** 🎉 |

---

# 📊 Comprehensive Comparison Matrix

| Metric | 1. Linear Search | 2. Two-Pass Binary Search | 3. One-Pass Binary Search (Optimal) |
| :--- | :--- | :--- | :--- |
| **Time Complexity** | $O(N)$ | $O(\log N)$ | **$O(\log N)$** |
| **Auxiliary Space** | $O(1)$ | $O(1)$ | **$O(1)$** |
| **Number of Passes** | 1 (Linear) | 2 (Binary searches) | **1 (Single binary search)** |
| **Code Simplicity** | Trivial | Complex (Pivot + Search) | **Clean single loop** |
| **Interview Suitability** | ❌ Fails $O(\log N)$ constraint | 👍 Acceptable | 🏆 **Gold Standard Expected** |

---

# ⚠️ Key Interview Gotchas & Edge Cases

1. **Why `nums[left] <= nums[mid]` (with `<=`) instead of `<`?**
   - When a subarray has only 2 elements (e.g. `[3, 1]`), `mid = left`.
   - If you used strict `<`, `nums[left] < nums[mid]` would be false, incorrectly treating the left half as unsorted.
2. **Distinct Elements Assumption**:
   - This $O(\log N)$ solution depends on elements being **strictly distinct**.
   - If duplicates were allowed (LeetCode 81: *Search in Rotated Sorted Array II*), `nums[left] == nums[mid] == nums[right]` makes it impossible to know which half is sorted without incrementing `left++` and decrementing `right--`, degrading worst-case time to $O(N)$.
3. **Mid Calculation without Overflow**:
   - Always write `left + (right - left) ~/ 2` instead of `(left + right) ~/ 2` to avoid integer overflow in fixed-width arithmetic.
