# 🚀 LeetCode 0050 - Pow(x, n)

## 📝 Problem Statement

Implement `pow(x, n)`, which calculates `x` raised to the power `n` (i.e., $x^n$).

---

## 🔒 Constraints

- $-100.0 < x < 100.0$
- $-2^{31} \le n \le 2^{31} - 1$
- `n` is an integer.
- Either `x` is not zero or `n > 0`.
- $-10^4 \le x^n \le 10^4$

---

## 💡 Examples

### Example 1
```text
Input: x = 2.00000, n = 10
Output: 1024.00000
```

### Example 2
```text
Input: x = 2.10000, n = 3
Output: 9.26100
```

### Example 3
```text
Input: x = 2.00000, n = -2
Output: 0.25000
Explanation: 2^(-2) = 1 / (2^2) = 1 / 4 = 0.25
```

---

# 📐 Mathematical Foundation: Binary Exponentiation

### 1. The Power of Binary Decomposition
Any positive integer $n$ can be uniquely represented in binary as a sum of powers of 2:
$$n = \sum_{i=0}^{k} b_i \cdot 2^i, \quad b_i \in \{0, 1\}$$

Therefore, $x^n$ can be factored into a product of terms where each term is a repeated squaring of $x$:
$$x^n = x^{\sum b_i \cdot 2^i} = \prod_{b_i = 1} x^{2^i}$$

### 2. Walkthrough: Computing $x^{13}$
The binary representation of $13$ is $1101_2$ ($13 = 8 + 4 + 1$):
$$x^{13} = x^8 \cdot x^4 \cdot x^1$$

```text
Step | Power (n) | Bit (n & 1) | Action                         | Current Base | Result
-----+-----------+-------------+--------------------------------+--------------+--------
0    | 13 (1101) | 1           | Multiply result by base        | x            | x^1
1    | 6  (0110) | 0           | Skip multiplication            | x^2          | x^1
2    | 3  (0011) | 1           | Multiply result by base        | x^4          | x^5
3    | 1  (0001) | 1           | Multiply result by base        | x^8          | x^13
-----+-----------+-------------+--------------------------------+--------------+--------
Total multiplications: only 4 (instead of 13)!
```

For $n = 2^{31} - 1 \approx 2.14 \times 10^9$, binary exponentiation requires at most **31 squarings and multiplications**, converting a billion-iteration loop into an instantaneous calculation.

---

# 🧠 Evolution of Solutions: How We Make It Better

```text
┌────────────────────────────────────────────────────────────────────────┐
│  1. Linear Multiplication (Brute Force)                                │
│     • Multiply x by itself n times in a loop                           │
│     • Time: O(n) | Space: O(1)                                         │
│     • Bottleneck: For n = 2^31 - 1, requires 2.14 billion operations   │
│       causing Time Limit Exceeded (TLE)                                │
└──────────────────────────────────┬─────────────────────────────────────┘
                                   │
                                   ▼ Divide & Conquer Halving
┌────────────────────────────────────────────────────────────────────────┐
│  2. Recursive Binary Exponentiation                                    │
│     • x^n = (x^(n/2))^2 for even n; x * (x^(n/2))^2 for odd n          │
│     • Time: O(log n) | Space: O(log n) call stack                      │
│     • Bottleneck: Incurs function call overhead for up to 32 frames    │
└──────────────────────────────────┬─────────────────────────────────────┘
                                   │
                                   ▼ Bit Manipulation & Invert-at-End Precision
┌────────────────────────────────────────────────────────────────────────┐
│  3. Iterative Binary Exponentiation (Optimal & Gold Standard)          │
│     • Inspect bits with (power & 1) and shift right (power >>= 1)      │
│     • Invert at the END: n < 0 ? 1.0 / result : result                 │
│     • Prevents IEEE 754 reciprocal error compounding across squarings  │
│     • Time: O(log n) [max 32 steps] | Space: O(1) strictly scalar      │
│     • Improvement: Maximum precision, zero allocations, no overflow    │
└────────────────────────────────────────────────────────────────────────┘
```

---

# 💻 Solutions

## 1. Approach 1: Linear Multiplication ($O(N)$ Time, $O(1)$ Space)

Multiplies $x$ consecutively $n$ times:

```dart
class SolutionLinear {
  double myPow(double x, int n) {
    if (n == 0) return 1.0;

    int power = n < 0 ? -n : n;
    double result = 1.0;
    for (int i = 0; i < power; i++) {
      result *= x;
    }
    return n < 0 ? 1.0 / result : result;
  }
}
```

### 🔴 Bottlenecks:
- $O(N)$ time complexity. When $n = 2^{31} - 1$, the loop runs $2,147,483,647$ times, which will time out on any platform.

---

## 2. Approach 2: Recursive Binary Exponentiation ($O(\log N)$ Time, $O(\log N)$ Space)

Recursively halves the exponent:

```dart
class SolutionRecursive {
  double myPow(double x, int n) {
    if (n == 0) return 1.0;
    if (n < 0) {
      return 1.0 / _pow(x, -n);
    }
    return _pow(x, n);
  }

  double _pow(double x, int n) {
    if (n == 0) return 1.0;
    final half = _pow(x, n ~/ 2);
    if (n % 2 == 0) {
      return half * half;
    } else {
      return half * half * x;
    }
  }
}
```

### 🔴 Bottlenecks:
- Allocates up to $32$ stack frames.
- In languages with 32-bit signed integers (C++/Java), `-n` when $n = -2^{31}$ causes integer overflow unless promoted to 64-bit integer (`long long`).

---

## 3. Approach 3: Iterative Binary Exponentiation (Optimal & Gold Standard)

Uses bitwise shifts and repeated squaring iteratively in $O(1)$ auxiliary space, performing a single division at the end to guarantee full IEEE 754 precision:

```dart
// LeetCode 0050: Pow(x, n)
// Optimal Solution: Iterative Binary Exponentiation (Exponentiation by Squaring)
// Time Complexity: O(log |n|) - at most 32 loop iterations
// Space Complexity: O(1) auxiliary space (no recursion stack)

class Solution {
  double myPow(double x, int n) {
    // Base cases & fast paths
    if (n == 0) return 1.0;
    if (x == 1.0) return 1.0;
    if (x == -1.0) return (n % 2 == 0) ? 1.0 : -1.0;

    int power = n < 0 ? -n : n;
    double currentBase = x;
    double result = 1.0;

    // Binary exponentiation: process bits of the exponent from LSB to MSB
    while (power > 0) {
      // If the current bit is 1, multiply currentBase into the result
      if ((power & 1) == 1) {
        result *= currentBase;
      }

      // Square the base for the next bit position
      currentBase *= currentBase;

      // Shift to the next bit
      power >>= 1;
    }

    // Invert the result at the end for negative exponents:
    // Performing a single division at the end avoids compounding reciprocal floating-point
    // rounding errors across intermediate squaring multiplications.
    return n < 0 ? 1.0 / result : result;
  }
}
```

### 🟢 Why This is Optimal:
- **Maximum 32 Iterations:** Evaluates any 32-bit power in $\le 32$ steps.
- **Strictly $O(1)$ Space:** Zero recursion stack and zero memory allocations.
- **Full Floating-Point Precision:** Inverting at the end (`1.0 / result`) avoids compounding reciprocal errors across 30+ squaring steps.
- **Native 64-bit Precision:** Dart's `int` represents 64-bit integers natively, safely avoiding 32-bit overflow when negating $-2^{31}$.

---

# 📊 Comprehensive Comparison Matrix

| Metric | 1. Linear Multiplication | 2. Recursive Divide & Conquer | 3. Iterative Binary Exponentiation (Optimal) |
| :--- | :--- | :--- | :--- |
| **Time Complexity** | $O(N)$ | $O(\log N)$ | **$O(\log N)$ Strictly $\le 32$ iterations** |
| **Auxiliary Space** | $O(1)$ | $O(\log N)$ stack frames | **$O(1)$ Pure scalar registers** |
| **Iterations ($N = 2^{31} - 1$)** | $2,147,483,647$ (TLE) | $31$ function calls | **$31$ bitwise steps** |
| **Function Call Overhead** | None | Yes ($32$ frames) | **Zero (Single loop)** |
| **Precision Stability** | Inverts at end | Inverts at end | **Inverts at end (Guaranteed exact IEEE 754)** |
| **Bitwise Optimization** | None | Modulo arithmetic (`n % 2`) | **Bitwise AND (`& 1`) and shift (`>>= 1`)** |
| **Interview Rating** | Rejected (TLE) | Good | 🏆 **Gold Standard Expected** |

---

# ⚠️ Key Interview Gotchas & Edge Cases

1. **Floating-Point Reciprocal Error Compounding (The Precision Trap):**
   - If you invert the base *upfront* (`currentBase = 1.0 / x; power = -n;`), a small reciprocal rounding error $\epsilon$ is introduced.
   - During binary exponentiation, this initial error is repeatedly squared and multiplied across up to 31 operations, compounding the error:
     - Example: $x = -0.9999999968539456$, $n = -1669585506$.
     - Inverting upfront produces `191.06373` (Wrong Answer on LeetCode testcase 308).
     - Inverting at the **end** (`1.0 / result`) performs only a single division, preserving the exact expected value: `191.06370`!
2. **The $-2^{31}$ Overflow Trap (The Classic Interview Test):**
   - The minimum 32-bit signed integer is $-2,147,483,648$, but the maximum is $+2,147,483,647$.
   - In C++ and Java, executing `-n` on $-2^{31}$ causes integer overflow, keeping it negative!
   - In Dart, `int` is a 64-bit integer, so `-n` becomes $+2,147,483,648$ safely. Always explain this 32-bit vs 64-bit nuance to the interviewer.
3. **Bases $x = 1.0$ and $x = -1.0$:**
   - $1.0^n = 1.0$ for any $n$.
   - $(-1.0)^n = 1.0$ if $n$ is even, and $-1.0$ if $n$ is odd.
   - Checking these base cases upfront avoids unnecessary exponentiation loops.
4. **Floating-Point Underflow:**
   - When $|x| < 1$ (e.g. $0.00001$) and $n$ is large, values underflow cleanly to `0.0`.
