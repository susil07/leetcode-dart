# 69. Sqrt(x)

**Difficulty:** Easy  
**LeetCode Link:** https://leetcode.com/problems/sqrtx/

---

## Problem Statement

Given a non-negative integer `x`, return the square root of `x` rounded down to the nearest integer.

You must not use any built-in exponent function or operator.

---

## Example

### Example 1

**Input**

```text
x = 4
```

**Output**

```text
2
```

Explanation

```text
√4 = 2
```

---

### Example 2

**Input**

```text
x = 8
```

**Output**

```text
2
```

Explanation

```text
√8 = 2.828...
```

Rounded down

```text
2
```

---

## Approach

Use **Binary Search**.

The square root always lies between:

- `1`
- `x / 2` (for x ≥ 2)

Binary search finds the largest number whose square is less than or equal to `x`.

To avoid integer overflow, compare:

```text
mid <= x / mid
```

instead of

```text
mid * mid <= x
```

---

## Algorithm

1. Handle `x < 2`.
2. Initialize:
   - left = 1
   - right = x / 2
3. Find middle.
4. If `mid <= x / mid`
   - Save answer
   - Search right half
5. Otherwise
   - Search left half
6. Return answer.

---

## Dry Run

Input

```text
x = 8
```

| Left | Right | Mid | Check | Answer |
|------|-------|-----|--------|--------|
|1|4|2|2 ≤ 8/2 ✅|2|
|3|4|3|3 ≤ 8/3 ❌|2|

Return

```text
2
```

---

## Complexity Analysis

### Time Complexity

```text
O(log x)
```

Binary Search halves the search space every iteration.

### Space Complexity

```text
O(1)
```

Only constant extra memory is used.

---

## Technique Used

- Binary Search
- Divide and Conquer

---

## Key Takeaways

- Never use `mid * mid` because it may overflow.
- Compare using `mid <= x / mid`.
- Binary Search is the optimal solution.
- Returns the floor value of the square root.

---

## Dart Solution

```dart
class Solution {
  int mySqrt(int x) {
    if (x < 2) return x;

    int left = 1;
    int right = x ~/ 2;
    int ans = 0;

    while (left <= right) {
      int mid = left + (right - left) ~/ 2;

      if (mid <= x ~/ mid) {
        ans = mid;
        left = mid + 1;
      } else {
        right = mid - 1;
      }
    }

    return ans;
  }
}
```