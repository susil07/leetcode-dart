# 🚀 LeetCode 0007 - Reverse Integer

## 📝 Problem Statement

Given a signed 32-bit integer `x`, return `x` with its digits reversed. If reversing `x` causes the value to go outside the signed 32-bit integer range $[-2^{31}, 2^{31} - 1]$, then return `0`.

**Assume the environment does not allow you to store 64-bit integers (signed or unsigned).**

---

## 🔒 Constraints

- $-2^{31} \le x \le 2^{31} - 1$
- Range: `[-2147483648, 2147483647]`

---

## Examples

### Example 1:
**Input:**
```text
x = 123
```
**Output:**
```text
321
```

---

### Example 2:
**Input:**
```text
x = -123
```
**Output:**
```text
-321
```

---

### Example 3:
**Input:**
```text
x = 120
```
**Output:**
```text
21
```

---

# 🧠 Evolution of Solutions: How We Make It Better

```text
┌────────────────────────────────────────────────────────────────────────┐
│  1. String Conversion & Reversal (Brute Force)                         │
│     • Convert x to string -> reverse -> parse back to integer          │
│     • Bottleneck: Heavy string allocations + violates 32-bit rule      │
└──────────────────────────────────┬─────────────────────────────────────┘
                                   │
                                   ▼ Use Mathematical Digit Extraction
┌────────────────────────────────────────────────────────────────────────┐
│  2. 64-Bit Accumulator (The "Cheat" Approach)                          │
│     • Accumulate result in a 64-bit integer, check bounds at the end   │
│     • Bottleneck: Rejected in interviews ("Assume 64-bit not allowed") │
└──────────────────────────────────┬─────────────────────────────────────┘
                                   │
                                   ▼ Pre-Check Overflow in 32-Bit Range
┌────────────────────────────────────────────────────────────────────────┐
│  3. 32-Bit Mathematical Digit Reversal (Optimal & Compliant)           │
│     • Extract digit via remainder(10)                                  │
│     • Check overflow BEFORE multiplying result * 10                    │
│     • Improvement: O(log10 |x|) Time, O(1) Space, 100% 32-bit safe    │
└────────────────────────────────────────────────────────────────────────┘
```

---

# 💡 Mathematical Overflow Derivation

The maximum signed 32-bit integer is:
$$\text{INT\_MAX} = 2^{31} - 1 = 2147483647 \quad (\text{ends in } 7)$$
The minimum signed 32-bit integer is:
$$\text{INT\_MIN} = -2^{31} = -2147483648 \quad (\text{ends in } -8)$$

Before executing `result = result * 10 + digit`:
1. If $\text{result} > \lfloor \text{INT\_MAX} / 10 \rfloor = 214748364$, then $\text{result} \times 10$ will **overflow**.
2. If $\text{result} == 214748364$, it will overflow if $\text{digit} > 7$.
3. If $\text{result} < \lceil \text{INT\_MIN} / 10 \rceil = -214748364$, then $\text{result} \times 10$ will **underflow**.
4. If $\text{result} == -214748364$, it will underflow if $\text{digit} < -8$.

---

# 💻 Solutions

## 1. Approach 1: String Conversion (Brute Force)

```dart
class SolutionString {
  int reverse(int x) {
    final isNegative = x < 0;
    final str = x.abs().toString().split('').reversed.join();

    final reversedNum = int.tryParse(str) ?? 0;
    final result = isNegative ? -reversedNum : reversedNum;

    const int intMax = 2147483647;
    const int intMin = -2147483648;

    if (result > intMax || result < intMin) {
      return 0;
    }

    return result;
  }
}
```

### 🔴 Bottlenecks:
- Creates multiple heap objects (`String`, `List<String>`).
- Calling `int.parse` on large reversed strings relies on 64-bit integer parsing, violating the problem's strict constraint.

---

## 2. Approach 2: 64-Bit Integer Accumulator (Post-Check)

```dart
class Solution64Bit {
  int reverse(int x) {
    int result = 0;

    while (x != 0) {
      result = result * 10 + x.remainder(10);
      x ~/= 10;
    }

    // Post-check bounds
    if (result > 2147483647 || result < -2147483648) {
      return 0;
    }

    return result;
  }
}
```

### 🔴 Why Interviewers Reject This:
- The problem explicitly states: *"Assume the environment does not allow you to store 64-bit integers"*.
- In C/C++ or systems with fixed 32-bit registers, `result * 10` would trigger undefined behavior or hardware overflow **before** the post-check can run!

---

## 3. Approach 3: Mathematical Extraction with Pre-Overflow Guard (Optimal)

```dart
class Solution {
  int reverse(int x) {
    // 32-bit signed limits:
    // INT_MAX =  2147483647 (ends in 7)
    // INT_MIN = -2147483648 (ends in -8)
    const int maxThreshold = 214748364;  //  2147483647 ~/ 10
    const int minThreshold = -214748364; // -2147483648 ~/ 10

    int result = 0;

    while (x != 0) {
      // In Dart, remainder(10) preserves the negative sign, unlike %
      final digit = x.remainder(10);
      x ~/= 10;

      // 1. Positive 32-bit overflow check
      if (result > maxThreshold || (result == maxThreshold && digit > 7)) {
        return 0;
      }

      // 2. Negative 32-bit underflow check
      if (result < minThreshold || (result == minThreshold && digit < -8)) {
        return 0;
      }

      result = result * 10 + digit;
    }

    return result;
  }
}
```

### 🟢 Improvements Over Approach 1 & 2:
- **Zero 64-bit variables**: Operates strictly within 32-bit limits.
- **$O(1)$ Auxiliary Space**: No heap allocations or string conversions.
- **$O(\log_{10} |x|)$ Time**: Runs in at most 10 loop iterations (since 32-bit numbers have $\le 10$ digits).

---

# 📊 Comprehensive Comparison Matrix

| Metric | 1. String Conversion | 2. 64-Bit Accumulator | 3. 32-Bit Pre-Check (Optimal) |
| :--- | :--- | :--- | :--- |
| **Time Complexity** | $O(\log_{10} |x|)$ + String parsing | $O(\log_{10} |x|)$ | **$O(\log_{10} |x|)$** (at most 10 steps) |
| **Space Complexity** | $O(\log_{10} |x|)$ (heap memory) | $O(1)$ | **$O(1)$** |
| **32-Bit Compliant?** | ❌ No (Parses 64-bit int) | ❌ No (Uses 64-bit accumulator) | ✅ **100% Compliant** |
| **Extra Allocations** | Multiple Strings & Lists | Zero | **Zero** |
| **Interview Rating** | ⚠️ Naive / Disqualified | ⚠️ Disqualified if 64-bit banned | 🏆 **Gold Standard** |

---

# ⚠️ Key Interview Gotchas & Edge Cases

1. **Dart's `%` vs `.remainder()`**:
   - In Dart, `-123 % 10` returns `7` (Euclidean modulo, always non-negative).
   - Use `-123.remainder(10)` which returns `-3` (truncated division remainder), preserving the sign correctly.
2. **The `-2147483648` Negation Trap**:
   - If you attempt to make `x` positive via `x = -x`, doing so on `x = -2147483648` immediately overflows because `2147483648 > 2147483647`!
   - Working with negative numbers directly via `.remainder(10)` avoids this bug completely.
3. **Trailing Zeroes**:
   - Numbers like `120` naturally become `21` because `result = 0 * 10 + 2 = 2` without extra logic.
