# 🚀 LeetCode 0029 - Divide Two Integers

## 📝 Problem Statement

Given two integers `dividend` and `divisor`, divide two integers **without** using multiplication, division, and mod operator (`*`, `/`, `%`).

The integer division should truncate toward zero, which means losing its fractional part. For example, $8.345 \to 8$, and $-2.7335 \to -2$.

Return the **quotient** after dividing `dividend` by `divisor`.

**Note:** Assume we are dealing with an environment that could only store integers within the **32-bit signed integer range**: $[-2^{31}, 2^{31} - 1]$. For this problem, if the quotient is strictly greater than $2^{31} - 1$, then return $2^{31} - 1$, and if the quotient is strictly less than $-2^{31}$, then return $-2^{31}$.

---

## 🔒 Constraints

- $-2^{31} \le \text{dividend}, \text{divisor} \le 2^{31} - 1$
- $\text{divisor} \ne 0$

---

## 💡 Examples

### Example 1
```text
Input: dividend = 10, divisor = 3
Output: 3
Explanation: 10/3 = 3.33333.. which is truncated to 3.
```

### Example 2
```text
Input: dividend = 7, divisor = -3
Output: -2
Explanation: 7/-3 = -2.33333.. which is truncated to -2.
```

### Example 3 (Overflow Case)
```text
Input: dividend = -2147483648, divisor = -1
Output: 2147483647
Explanation: -2147483648 / -1 = 2147483648, which exceeds 2^31 - 1, so it is clamped to 2147483647.
```

---

# 🧠 Evolution of Solutions: How We Make It Better

```text
┌────────────────────────────────────────────────────────────────────────┐
│  1. Repeated Linear Subtraction                                        │
│     • While dividend >= divisor: dividend -= divisor, count++          │
│     • Time: O(dividend) | Space: O(1)                                  │
│     • Bottleneck: For 2^31 / 1, takes 2,147,483,648 operations -> TLE  │
└──────────────────────────────────┬─────────────────────────────────────┘
                                   │
                                   ▼ Exponential Search (Doubling)
┌────────────────────────────────────────────────────────────────────────┐
│  2. Exponential Doubling Subtraction                                   │
│     • Double divisor each step: (divisor, 2*divisor, 4*divisor, ...)   │
│     • Subtract largest power of 2, repeat on remainder                 │
│     • Time: O(log^2(dividend)) | Space: O(1)                           │
│     • Bottleneck: Recalculates power-of-two multiples repeatedly       │
└──────────────────────────────────┬─────────────────────────────────────┘
                                   │
                                   ▼ Single-Pass Binary Long Division
┌────────────────────────────────────────────────────────────────────────┐
│  3. Binary Long Division via Bit Shifts (Optimal)                      │
│     • Every quotient is a sum of powers of 2: Q = sum(c_i * 2^i)       │
│     • Iterate i from 31 down to 0:                                     │
│         if ((dividend >> i) >= divisor):                               │
│             quotient += 1 << i; dividend -= divisor << i               │
│     • Time: O(1) [strictly 32 iterations] | Space: O(1)                │
│     • Improvement: Zero multiplication, zero TLE, zero overflow risk   │
└────────────────────────────────────────────────────────────────────────┘
```

---

# 💡 Core Concept: Binary Long Division

Any integer quotient $Q$ can be expressed in binary form as a linear combination of powers of 2:
$$Q = c_{31} \cdot 2^{31} + c_{30} \cdot 2^{30} + \dots + c_1 \cdot 2^1 + c_0 \cdot 2^0 \quad (c_i \in \{0, 1\})$$

Therefore:
$$\text{dividend} = Q \cdot \text{divisor} + \text{remainder}$$

Instead of checking `dividend >= (divisor << i)` (which could overflow 32-bit registers), we test:
$$(\text{dividend} \gg i) \ge \text{divisor}$$

Because right-shifting shrinks `dividend`, **this check can never overflow!**

```text
Example: dividend = 10, divisor = 3

i = 31 down to 2: (10 >> i) < 3   -> do nothing
i = 1: (10 >> 1) = 5 >= 3:
       quotient += (1 << 1) = 2
       dividend -= (3 << 1) = 10 - 6 = 4
i = 0: (4 >> 0) = 4 >= 3:
       quotient += (1 << 0) = 1
       dividend -= (3 << 0) = 4 - 3 = 1

Final Quotient = 2 + 1 = 3 🎉
```

---

# 💻 Solutions

## 1. Approach 1: Repeated Subtraction ($O(\text{dividend})$ Time, $O(1)$ Space)

Subtract `divisor` from `dividend` one by one:

```dart
class SolutionLinear {
  int divide(int dividend, int divisor) {
    if (dividend == -2147483648 && divisor == -1) return 2147483647;

    final bool isNegative = (dividend < 0) ^ (divisor < 0);
    int dvd = dividend.abs();
    final int dvs = divisor.abs();
    int quotient = 0;

    while (dvd >= dvs) {
      dvd -= dvs;
      quotient++;
    }

    return isNegative ? -quotient : quotient;
  }
}
```

### 🔴 Bottlenecks:
- $O(\text{dividend})$ time: When dividing $2^{31} - 1$ by $1$, runs $2 \times 10^9$ loops $\rightarrow$ **Time Limit Exceeded (TLE)**.

---

## 2. Approach 2: Exponential Doubling ($O(\log^2(\text{dividend}))$ Time, $O(1)$ Space)

Double the divisor in each iteration:

```dart
class SolutionDoubling {
  int divide(int dividend, int divisor) {
    if (dividend == -2147483648 && divisor == -1) return 2147483647;

    final bool isNegative = (dividend < 0) ^ (divisor < 0);
    int dvd = dividend.abs();
    final int dvs = divisor.abs();
    int quotient = 0;

    while (dvd >= dvs) {
      int tempDvs = dvs;
      int multiple = 1;

      while (dvd >= (tempDvs << 1) && (tempDvs << 1) > 0) {
        tempDvs <<= 1;
        multiple <<= 1;
      }

      dvd -= tempDvs;
      quotient += multiple;
    }

    return isNegative ? -quotient : quotient;
  }
}
```

### 🔴 Bottlenecks:
- $O(\log^2 N)$ time: Inner loop restarts from 1 on every outer iteration.

---

## 3. Approach 3: Binary Long Division via Bit Shifts ($O(1)$ Time, $O(1)$ Space) — Optimal

Directly extract quotient bits from 31 down to 0:

```dart
class Solution {
  int divide(int dividend, int divisor) {
    const int intMax = 2147483647;  //  2^31 - 1
    const int intMin = -2147483648; // -2^31

    // Overflow edge case: -2^31 / -1 = 2^31, which exceeds the 32-bit signed int max
    if (dividend == intMin && divisor == -1) {
      return intMax;
    }

    // Determine the sign of the quotient using XOR
    final bool isNegative = (dividend < 0) ^ (divisor < 0);

    // Convert to positive 64-bit values to perform safe binary long division
    int dvd = dividend.abs();
    final int dvs = divisor.abs();
    int quotient = 0;

    // Binary Long Division: Check powers of 2 from 31 down to 0
    for (int i = 31; i >= 0; i--) {
      // (dvd >> i) >= dvs is mathematically equivalent to dvd >= (dvs << i),
      // but shifting dvd right avoids potential overflow when dvs is shifted left.
      if ((dvd >> i) >= dvs) {
        quotient += 1 << i;
        dvd -= dvs << i;
      }
    }

    return isNegative ? -quotient : quotient;
  }
}
```

---

# 📊 Comprehensive Comparison Matrix

| Metric | 1. Linear Subtraction | 2. Exponential Doubling | 3. Binary Long Division (Optimal) |
| :--- | :--- | :--- | :--- |
| **Time Complexity** | $O(\text{dividend})$ | $O(\log^2(\text{dividend}))$ | **$O(32) = O(1)$** |
| **Auxiliary Space** | $O(1)$ | $O(1)$ | **$O(1)$** |
| **Max Iterations** | $\approx 2.14 \times 10^9$ | $\approx 32 \times 32 / 2 \approx 512$ | **Strictly $\le 32$** |
| **Overflow Safe?** | Yes | Needs overflow guard on `<< 1` | **Completely safe via `>> i`** |
| **Uses `*`, `/`, `%`?** | No | No | **No (Pure Bitwise Shifts)** |
| **Interview Rating** | ❌ TLE / Unacceptable | 👍 Good Intuition | 🏆 **Gold Standard Expected** |

---

# ⚠️ Key Interview Gotchas & Edge Cases

1. **The Only 32-Bit Overflow Case**:
   - The 32-bit signed integer range is $[-2147483648, 2147483647]$.
   - $-2147483648 / -1 = +2147483648$, which is $> 2147483647$.
   - Must explicitly clamp this case to `2147483647` (`intMax`).
2. **Preventing Bitshift Overflow**:
   - Checking `(dvd >> i) >= dvs` is strictly superior to checking `dvd >= (dvs << i)`, because shifting `dvs` left when $i = 31$ can cause bit truncation or negative values in 32-bit registers.
3. **Sign Determination via XOR**:
   - `(dividend < 0) ^ (divisor < 0)` is a clean, branchless way to determine if the result should be negative.
