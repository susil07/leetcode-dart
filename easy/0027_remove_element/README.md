# 27. Remove Element

**Difficulty:** Easy  
**LeetCode Link:** https://leetcode.com/problems/remove-element/

---

## Problem Statement

Given an integer array `nums` and an integer `val`, remove all occurrences of `val` **in-place**.

Return the number of elements that are **not equal** to `val`.

The first `k` elements of `nums` should contain all the elements that are not equal to `val`. The remaining elements beyond `k` are not important.

---

## Example

### Example 1

**Input**

```text
nums = [3,2,2,3], val = 3
```

**Output**

```text
2
```

**Updated Array**

```text
[2,2]
```

---

### Example 2

**Input**

```text
nums = [0,1,2,2,3,0,4,2], val = 2
```

**Output**

```text
5
```

**Updated Array**

```text
[0,1,3,0,4]
```

---

## Approach

This problem can be solved using the **Two Pointer** technique.

- Use one pointer `i` to traverse the array.
- Use another pointer `k` to keep track of the next position where a valid element should be placed.
- If the current element is **not equal** to `val`, copy it to index `k` and increment `k`.
- Ignore elements equal to `val`.

After the traversal, the first `k` elements of the array contain the required result.

---

## Algorithm

1. Initialize `k = 0`.
2. Traverse the array.
3. If `nums[i] != val`:
   - Assign `nums[k] = nums[i]`
   - Increment `k`
4. Return `k`.

---

## Dry Run

**Input**

```text
nums = [3,2,2,3]
val = 3
```

| i | nums[i] | k | Updated Array |
|---|----------|---|---------------|
|0|3|0|Skip|
|1|2|1|[2,2,2,3]|
|2|2|2|[2,2,2,3]|
|3|3|2|Skip|

Return:

```text
k = 2
```

Valid elements:

```text
[2,2]
```

---

## Complexity Analysis

### Time Complexity

```text
O(n)
```

Each element is visited exactly once.

### Space Complexity

```text
O(1)
```

No extra space is used since the array is modified in-place.

---

## Technique Used

- Two Pointers
- In-place Array Modification
- Array Traversal

---

## Key Takeaways

- Two pointers help solve in-place array modification problems efficiently.
- The first pointer scans the array.
- The second pointer maintains the position for valid elements.
- This achieves **O(n)** time and **O(1)** extra space.

---

## Dart Solution

```dart
class Solution {
  int removeElement(List<int> nums, int val) {
    int k = 0;

    for (int i = 0; i < nums.length; i++) {
      if (nums[i] != val) {
        nums[k] = nums[i];
        k++;
      }
    }

    return k;
  }
}
```