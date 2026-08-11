# 35. Search Insert Position

**Difficulty:** Easy  
**LeetCode Link:** https://leetcode.com/problems/search-insert-position/

---

## Problem Statement

Given a sorted array of distinct integers and a target value, return the index if the target is found.

If the target is not found, return the index where it should be inserted in order.

The solution must have **O(log n)** runtime complexity.

---

## Example

### Example 1

**Input**

```text
nums = [1,3,5,6]
target = 5
```

**Output**

```text
2
```

---

### Example 2

**Input**

```text
nums = [1,3,5,6]
target = 2
```

**Output**

```text
1
```

---

### Example 3

**Input**

```text
nums = [1,3,5,6]
target = 7
```

**Output**

```text
4
```

---

## Approach

Since the array is sorted, Binary Search is the optimal solution.

- Initialize two pointers:
  - `left = 0`
  - `right = nums.length - 1`
- Find the middle element.
- If the target is found, return its index.
- If the target is greater, search the right half.
- Otherwise, search the left half.
- If the target doesn't exist, `left` will point to the correct insertion position.

---

## Algorithm

1. Initialize `left` and `right`.
2. Repeat while `left <= right`.
3. Calculate `mid`.
4. Compare `nums[mid]` with `target`.
5. Adjust search space accordingly.
6. Return `left`.

---

## Dry Run

Input

```text
nums = [1,3,5,6]
target = 2
```

| Left | Right | Mid | nums[mid] | Action |
|------|-------|-----|-----------|--------|
|0|3|1|3|Search Left|
|0|0|0|1|Search Right|

Loop ends:

```text
left = 1
```

Return:

```text
1
```

---

## Complexity Analysis

### Time Complexity

```text
O(log n)
```

The search space is reduced by half in every iteration.

### Space Complexity

```text
O(1)
```

No extra memory is required.

---

## Technique Used

- Binary Search
- Divide and Conquer

---

## Key Takeaways

- Binary Search works only on sorted data.
- Each iteration removes half of the remaining search space.
- If the target isn't found, `left` automatically points to the correct insertion index.
- This is the optimal solution with **O(log n)** time complexity.

---

## Dart Solution

```dart
class Solution {
  int searchInsert(List<int> nums, int target) {
    int left = 0;
    int right = nums.length - 1;

    while (left <= right) {
      int mid = left + (right - left) ~/ 2;

      if (nums[mid] == target) {
        return mid;
      } else if (nums[mid] < target) {
        left = mid + 1;
      } else {
        right = mid - 1;
      }
    }

    return left;
  }
}
```