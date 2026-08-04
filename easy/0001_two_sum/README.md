# LeetCode Dart Solutions
# 0001. Two Sum
<!-- ⌘ + ⇧ + V -->
- **Difficulty:** Easy
- **Category:** Array, HashMap
- **Language:** Dart

---

# Problem Statement

Given an array of integers `nums` and an integer `target`, return the **indices** of the two numbers such that they add up to the target.

You may assume that each input has exactly one solution, and you may not use the same element twice.

## Example

```text
Input:
nums = [2,7,11,15]
target = 9

Output:
[0,1]
```

Explanation:

```text
nums[0] + nums[1] = 2 + 7 = 9
```

---

# Solution (Brute Force)

```dart
class Solution {
  List<int> twoSum(List<int> nums, int target) {
    for (int i = 0; i < nums.length; i++) {
      for (int j = i + 1; j < nums.length; j++) {
        if (nums[i] + nums[j] == target) {
          return [i, j];
        }
      }
    }
    return [];
  }
}
```

---

# Technique Used

**Brute Force**

A brute force approach means trying every possible combination until the correct answer is found.

For this problem, we compare every pair of numbers in the array.

---

# Algorithm

1. Start from the first element.
2. Compare it with every element after it.
3. If their sum equals the target, return their indices.
4. Otherwise, continue checking all remaining pairs.
5. If no pair is found, return an empty list.

---

# Dry Run

Input

```text
nums = [2,7,11,15]
target = 9
```

### Iteration 1

```text
i = 0

nums[i] = 2

j = 1

nums[j] = 7

2 + 7 = 9 ✅
```

Return

```text
[0,1]
```

---

Suppose

```text
nums = [2,7,11,15]
target = 26
```

The algorithm checks

```text
2 + 7
2 + 11
2 + 15
7 + 11
7 + 15
11 + 15
```

Eventually,

```text
11 + 15 = 26
```

Return

```text
[2,3]
```

---

# Why do we use `j = i + 1`?

Instead of

```dart
for (int j = 0; j < nums.length; j++)
```

we use

```dart
for (int j = i + 1; j < nums.length; j++)
```

### Reason 1

Avoid comparing the same element with itself.

Example

```text
2 + 2
```

This is not allowed because we cannot use the same element twice.

---

### Reason 2

Avoid duplicate comparisons.

Without `i + 1`

```text
2 + 7
7 + 2
```

Both are the same pair.

Using `i + 1` ensures each pair is checked only once.

---

# Time Complexity

There are two nested loops.

Outer loop runs

```text
n
```

times.

Inner loop runs

```text
n-1
n-2
n-3
...
1
```

Total comparisons

```text
(n-1) + (n-2) + ... + 1

= n(n-1)/2
```

Ignoring constants,

```text
Time Complexity = O(n²)
```

---

# Space Complexity

Extra memory used:

```text
i
j
```

Only two integer variables are created.

No extra array.

No HashMap.

No Stack.

No Queue.

Therefore,

```text
Space Complexity = O(1)
```

This is called **Constant Space**.

---

# Why don't we count the input array?

The input array is provided by the caller.

Space Complexity only measures the **extra memory** created by our algorithm.

So,

```text
nums
```

is **not counted**.

Only

```text
i
j
```

are counted.

---

# Visualization

```text
Index

0    1    2    3

↓

2    7    11   15

│
├────────► 7
├────────────────► 11
└────────────────────────► 15

Then

7
├────────►11
└────────────────►15

Then

11
└────────►15
```

Every element is compared with all elements after it.

---

# Advantages

- Easy to understand.
- Easy to implement.
- Uses constant extra memory.
- Good starting solution during interviews.

---

# Disadvantages

- Slow for large inputs.
- Performs many unnecessary comparisons.
- Not the optimal solution.

---

# Optimization

Instead of checking every pair, we can store previously visited numbers in a **HashMap**.

Example

```text
Map

2 -> 0
7 -> 1
11 -> 2
```

When visiting

```text
15
```

Compute

```text
target - current

26 - 15 = 11
```

Since `11` already exists in the map,

return

```text
[2,3]
```

immediately.

---

# Optimized Technique

**HashMap**

---

# Optimized Complexity

| Complexity | Value |
|------------|-------|
| Time | O(n) |
| Space | O(n) |

---

# Key Concepts Learned

- Brute Force
- Nested Loops
- Array Traversal
- Pair Comparison
- Time Complexity
- Space Complexity
- HashMap Optimization

---

# Interview Questions

### What technique is used?

Brute Force.

---

### Why use nested loops?

To compare every possible pair.

---

### Why start `j` from `i + 1`?

- Avoid comparing an element with itself.
- Avoid duplicate pairs.

---

### Why is Time Complexity O(n²)?

Because every element is compared with almost every other element.

---

### Why is Space Complexity O(1)?

Only two integer variables (`i` and `j`) are used.

---

### Can this solution be optimized?

Yes.

Using a HashMap, the Time Complexity becomes **O(n)**.

---

# Final Complexity

| Property | Value |
|----------|-------|
| Technique | Brute Force |
| Data Structure | Array |
| Time Complexity | O(n²) |
| Space Complexity | O(1) |
| Optimized Technique | HashMap |
| Optimized Time | O(n) |
| Optimized Space | O(n) |

---

# Takeaway

This problem teaches one of the most common interview patterns:

1. Solve the problem using **Brute Force**.
2. Analyze **Time Complexity** and **Space Complexity**.
3. Identify repeated work.
4. Use an appropriate **Data Structure (HashMap)** to optimize the solution from **O(n²)** to **O(n)**.