# 70. Climbing Stairs

**Difficulty:** Easy  
**LeetCode Link:** https://leetcode.com/problems/climbing-stairs/

---

## Problem Statement

You are climbing a staircase with `n` steps.

Each time, you can climb either:

- 1 step
- 2 steps

Return the total number of distinct ways to reach the top.

---

## Example

### Example 1

**Input**

```text
n = 2
```

**Output**

```text
2
```

Explanation

```text
1 + 1
2
```

---

### Example 2

**Input**

```text
n = 3
```

**Output**

```text
3
```

Explanation

```text
1 + 1 + 1
1 + 2
2 + 1
```

---

## Approach

The number of ways to reach step `n` depends on:

- Ways to reach `n - 1`
- Ways to reach `n - 2`

Therefore,

```text
ways(n) = ways(n - 1) + ways(n - 2)
```

This is exactly the **Fibonacci sequence**.

Instead of storing every value, keep only the previous two values.

---

## Algorithm

1. If `n <= 2`, return `n`.
2. Initialize:
   - `first = 1`
   - `second = 2`
3. For each step from `3` to `n`:
   - `current = first + second`
   - Update:
     - `first = second`
     - `second = current`
4. Return `second`.

---

## Dry Run

Input

```text
n = 5
```

| Step | first | second | current |
|------|------|--------|---------|
|Start|1|2|-|
|3|2|3|3|
|4|3|5|5|
|5|5|8|8|

Return

```text
8
```

---

## Complexity Analysis

### Time Complexity

```text
O(n)
```

Traverse the steps once.

### Space Complexity

```text
O(1)
```

Only three integer variables are used.

---

## Technique Used

- Dynamic Programming
- Fibonacci Pattern
- Space Optimization

---

## Key Takeaways

- This problem follows the Fibonacci recurrence.
- Each answer depends only on the previous two answers.
- Space can be optimized from **O(n)** to **O(1)**.
- This is the optimal solution.

---

## Dart Solution

```dart
class Solution {
  int climbStairs(int n) {
    if (n <= 2) return n;

    int first = 1;
    int second = 2;

    for (int i = 3; i <= n; i++) {
      int current = first + second;
      first = second;
      second = current;
    }

    return second;
  }
}
```