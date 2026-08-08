# 0026. Remove Duplicates from Sorted Array

- **Difficulty:** Easy
- **Category:** Array, Two Pointers
- **Language:** Dart

---

# Problem Statement

Given an integer array `nums` sorted in **non-decreasing order**, remove the duplicates **in-place** such that each unique element appears only once.

Return the number of unique elements `k`.

The first `k` elements of the array should contain all the unique elements in sorted order.

The remaining elements after index `k - 1` do not matter.

---

# Example

### Example 1

```text
Input:

nums = [1,1,2]

Output:

2

nums = [1,2,_]
```

Explanation

```text
There are 2 unique elements.

The first 2 positions become:

[1,2]
```

---

### Example 2

```text
Input:

nums = [0,0,1,1,1,2,2,3,3,4]

Output:

5

nums = [0,1,2,3,4,_,_,_,_,_]
```

Explanation

```text
There are 5 unique elements.

The first 5 positions become:

[0,1,2,3,4]
```

---

# Solution

```dart
class Solution {
  int removeDuplicates(List<int> nums) {
    if (nums.isEmpty) return 0;

    int i = 0;

    for (int j = 1; j < nums.length; j++) {
      if (nums[i] != nums[j]) {
        i++;
        nums[i] = nums[j];
      }
    }

    return i + 1;
  }
}
```

---

# Technique Used

- Two Pointers
- In-place Array Modification

---

# Understanding the Problem

The array is already sorted.

This means all duplicate values appear next to each other.

Instead of creating a new array, we move every unique value to the beginning of the same array.

Finally, we return the number of unique elements.

---

# Algorithm

1. If the array is empty, return `0`.
2. Initialize pointer `i = 0`.
3. Traverse the array using pointer `j` from index `1`.
4. Compare `nums[j]` with `nums[i]`.
5. If they are different:
   - Move `i` forward.
   - Copy `nums[j]` to `nums[i]`.
6. Continue until the end.
7. Return `i + 1`.

---

# Dry Run

Input

```text
nums = [1,1,2]
```

Initially

```text
i = 0

j = 1

nums

[1,1,2]
```

---

### Step 1

Compare

```text
nums[i] = 1

nums[j] = 1
```

Same value.

Move

```text
j++
```

---

### Step 2

Now

```text
i = 0

j = 2
```

Compare

```text
1

2
```

Different.

Move

```text
i++
```

Now

```text
i = 1
```

Copy

```text
nums[i] = nums[j]
```

Array becomes

```text
[1,2,2]
```

Return

```text
i + 1

2
```

The first two elements are

```text
[1,2]
```

which is the expected answer.

---

# Another Dry Run

Input

```text
[0,0,1,1,1,2,2,3,3,4]
```

Processing step by step gives

```text
[0,1,2,3,4,2,2,3,3,4]
```

Only the first

```text
5
```

elements matter.

Return

```text
5
```

---

# Visualization

```text
Original

[1,1,2,2,3,3,4]

 i
 j

Compare

1 == 1

Move j

--------------------

i
    j

Compare

1 != 2

Move i

Copy

[1,2,2,2,3,3,4]

--------------------

Continue...

Final

[1,2,3,4]
```

---

# Why Two Pointers?

We use two pointers with different responsibilities.

- **i** keeps track of the last unique element.
- **j** scans the array looking for the next unique value.

Whenever a new unique value is found, it is copied to the next position after `i`.

This keeps all unique values grouped at the beginning of the array.

---

# Why In-place?

The problem specifically asks us **not** to create another array.

Instead of allocating extra memory,

we modify the existing array itself.

This saves memory and makes the algorithm efficient.

---

# Time Complexity

Each element is visited exactly once.

```text
Time Complexity = O(n)
```

---

# Space Complexity

No additional array or data structure is created.

Only two integer variables are used.

```text
Space Complexity = O(1)
```

---

# Advantages

- Single traversal
- Constant extra space
- Efficient
- Simple implementation
- Preserves sorted order

---

# Disadvantages

- Works because the array is already sorted.
- Cannot be directly applied to unsorted arrays.

---

# Key Concepts Learned

- Arrays
- Two Pointers
- In-place Modification
- Efficient Traversal

---

# Interview Questions

### Why do we use Two Pointers?

One pointer tracks the position of the last unique element.

The other scans the array to find new unique elements.

---

### Why is the array required to be sorted?

Because duplicate values are adjacent.

Without sorting, duplicates could appear anywhere.

---

### Why don't we create another array?

The problem requires an in-place solution with constant extra memory.

---

### Why is Time Complexity O(n)?

Each element is processed exactly once.

---

### Why is Space Complexity O(1)?

Only two pointer variables are used.

No additional collection is created.

---

### What if the array is empty?

The function immediately returns

```text
0
```

---

# Final Complexity

| Property | Value |
|----------|-------|
| Technique | Two Pointers |
| Data Structure | Array |
| Time Complexity | O(n) |
| Space Complexity | O(1) |
| Difficulty | Easy |

---

# Takeaway

This problem introduces one of the most important **Two Pointer** patterns.

It teaches:

- Using one pointer to scan the array.
- Using another pointer to maintain the result.
- Performing modifications in-place.
- Achieving linear time with constant extra space.

This pattern is commonly used in interview problems such as:

- Remove Element
- Move Zeroes
- Squares of a Sorted Array
- Sort Colors
- Merge Sorted Array
- Container With Most Water
- Two Sum II