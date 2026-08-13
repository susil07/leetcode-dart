# 66. Plus One

**Difficulty:** Easy  
**LeetCode Link:** https://leetcode.com/problems/plus-one/

---

## Problem Statement

You are given a large integer represented as an integer array `digits`, where each element is a digit.

The digits are stored from **most significant** to **least significant**.

Increment the integer by one and return the resulting array.

---

## Example

### Example 1

**Input**

```text
digits = [1,2,3]
```

**Output**

```text
[1,2,4]
```

Explanation

```text
123 + 1 = 124
```

---

### Example 2

**Input**

```text
digits = [4,3,2,1]
```

**Output**

```text
[4,3,2,2]
```

Explanation

```text
4321 + 1 = 4322
```

---

### Example 3

**Input**

```text
digits = [9]
```

**Output**

```text
[1,0]
```

Explanation

```text
9 + 1 = 10
```

---

## Approach

Traverse the array from the last digit.

- If the current digit is less than `9`, increment it and return.
- If the digit is `9`, change it to `0` and carry `1` to the previous digit.
- If all digits are `9`, insert `1` at the beginning.

---

## Algorithm

1. Start from the last digit.
2. If digit < 9:
   - Increment it.
   - Return the array.
3. Otherwise:
   - Change digit to `0`.
4. After the loop, insert `1` at the beginning.
5. Return the array.

---

## Dry Run

Input

```text
digits = [1,2,9]
```

| Index | Digit | Action | Array |
|------|------|--------|-------|
|2|9|Set to 0|[1,2,0]|
|1|2|Increment & Return|[1,3,0]|

Answer

```text
[1,3,0]
```

---

Input

```text
digits = [9,9,9]
```

| Index | Action |
|------|--------|
|2|9 → 0|
|1|9 → 0|
|0|9 → 0|

Insert `1`

Result

```text
[1,0,0,0]
```

---

## Complexity Analysis

### Time Complexity

```text
O(n)
```

Worst case: every digit is `9`.

### Space Complexity

```text
O(1)
```

Only constant extra space is used.

---

## Technique Used

- Array Traversal
- Carry Propagation
- Simulation

---

## Key Takeaways

- Traverse from right to left.
- Stop immediately once no carry is needed.
- Handle the special case where all digits are `9`.
- This is the optimal solution with **O(n)** time.

---

## Dart Solution

```dart
class Solution {
  List<int> plusOne(List<int> digits) {
    for (int i = digits.length - 1; i >= 0; i--) {
      if (digits[i] < 9) {
        digits[i]++;
        return digits;
      }

      digits[i] = 0;
    }

    digits.insert(0, 1);
    return digits;
  }
}
```