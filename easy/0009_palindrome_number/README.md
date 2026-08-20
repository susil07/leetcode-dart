# 🚀 LeetCode 9 - Palindrome Number

## 📝 Problem

Given an integer `x`, return `true` if `x` is a palindrome, and `false` otherwise.

A palindrome number reads the same backward as forward.

### Examples

#### Example 1

```
Input: x = 121
Output: true
```

#### Example 2

```
Input: x = -121
Output: false
```

#### Example 3

```
Input: x = 10
Output: false
```

---

## 💡 Approach

A negative number can never be a palindrome because of the '-' sign.

For positive numbers:

- Store the original number.
- Reverse the digits one by one.
- Compare the reversed number with the original.

If both are equal, it is a palindrome.

---

## 🛠️ Algorithm

1. If `x < 0`, return `false`.
2. Store the original value.
3. Reverse the number using modulo and division.
4. Compare the reversed number with the original.
5. Return the result.

---

## 🧪 Dry Run

Input:

```
x = 121
```

Initial:

```
original = 121
reversed = 0
```

Iteration 1

```
digit = 1
reversed = 1
x = 12
```

Iteration 2

```
digit = 2
reversed = 12
x = 1
```

Iteration 3

```
digit = 1
reversed = 121
x = 0
```

Finally

```
original == reversed

121 == 121

true
```

---

## 📊 Complexity Analysis

| Complexity | Value |
|------------|-------|
| Time | O(log₁₀ n) |
| Space | O(1) |

---

## ⚠️ Edge Cases

- Negative number

```
-121
```

Result:

```
false
```

---

- Ending with zero

```
10
```

Reverse becomes

```
01
```

Result:

```
false
```

---

- Single digit

```
7
```

Result:

```
true
```

---

- Zero

```
0
```

Result:

```
true
```

---

## ✅ Why This Approach?

- Constant extra space.
- Easy to understand.
- Accepted by LeetCode.
- Suitable for interviews.

---

## 🎯 Interview Follow-up

LeetCode asks:

> Can you solve it **without converting the integer to a string?**

This solution satisfies the requirement because it only uses arithmetic operations (`%` and `~/`) and does **not** convert the integer to a string.

---

## 📚 Concepts Used

- Math
- Integer Manipulation
- Modulo Operator
- Reverse Number
- Simulation

---

## 🔗 Related Problems

- 7. Reverse Integer
- 66. Plus One
- 67. Add Binary