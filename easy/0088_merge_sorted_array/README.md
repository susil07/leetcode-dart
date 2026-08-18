# 88. Merge Sorted Array

**Difficulty:** Easy  
**LeetCode Link:** https://leetcode.com/problems/merge-sorted-array/

---

## Problem Statement

You are given two sorted integer arrays `nums1` and `nums2`, along with integers `m` and `n`.

Merge `nums2` into `nums1` so that `nums1` becomes one sorted array.

The final sorted array should be stored inside `nums1`.

---

## Example

### Example 1

**Input**

```text
nums1 = [1,2,3,0,0,0]
m = 3
nums2 = [2,5,6]
n = 3
```

**Output**

```text
[1,2,2,3,5,6]
```

---

## Approach

Since `nums1` has extra space at the end, we fill it from the back.

Use three pointers:

- `i` → last valid element in `nums1`
- `j` → last element in `nums2`
- `k` → last position of `nums1`

Compare the largest remaining values and place the larger one at `k`.

---

## Algorithm

1. Initialize three pointers.
2. Compare `nums1[i]` and `nums2[j]`.
3. Place the larger element at `nums1[k]`.
4. Move pointers accordingly.
5. Copy any remaining elements from `nums2`.

---

## Dry Run

Input

```text
nums1 = [1,2,3,0,0,0]
nums2 = [2,5,6]
```

Start

```text
i = 2
j = 2
k = 5
```

Result

```text
[1,2,2,3,5,6]
```

---

## Complexity Analysis

### Time Complexity

```text
O(m + n)
```

### Space Complexity

```text
O(1)
```

---

## Technique Used

- Two Pointers
- Reverse Traversal
- In-place Merge

---

## Key Takeaways

- Traverse from the end to avoid overwriting values.
- No additional array is needed.
- Very common interview problem involving array manipulation.

---

## Dart Solution

```dart
class Solution {
  void merge(List<int> nums1, int m, List<int> nums2, int n) {
    int i = m - 1;
    int j = n - 1;
    int k = m + n - 1;

    while (i >= 0 && j >= 0) {
      if (nums1[i] > nums2[j]) {
        nums1[k] = nums1[i];
        i--;
      } else {
        nums1[k] = nums2[j];
        j--;
      }
      k--;
    }

    while (j >= 0) {
      nums1[k] = nums2[j];
      j--;
      k--;
    }
  }
}
```