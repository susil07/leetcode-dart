# 🚀 LeetCode 0043 - Multiply Strings

## 📝 Problem Statement

Given two non-negative integers `num1` and `num2` represented as strings, return the product of `num1` and `num2`, also represented as a string.

**Note:** You must not use any built-in `BigInteger` library or convert the inputs to integer directly.

---

## 🔒 Constraints

- $1 \le \text{num1.length}, \text{num2.length} \le 200$
- `num1` and `num2` consist of digits only.
- Both `num1` and `num2` do not contain any leading zero, except the number `0` itself.

---

## 💡 Examples

### Example 1
```text
Input: num1 = "2", num2 = "3"
Output: "6"
```

### Example 2
```text
Input: num1 = "123", num2 = "456"
Output: "56088"
```

### Example 3
```text
Input: num1 = "0", num2 = "52"
Output: "0"
```

---

# 📐 Core Mathematical Intuition: Position Mapping

### 1. Maximum Number of Digits
The product of an $M$-digit number and an $N$-digit number has at most **$M + N$ digits** (and at least $M + N - 1$ digits).
$$\text{Max Product: } (10^M - 1) \times (10^N - 1) = 10^{M+N} - 10^M - 10^N + 1 < 10^{M+N}$$

Hence, an array of length $M + N$ is guaranteed to hold the entire result without overflow or out-of-bounds access.

### 2. Index Arithmetic ($i + j$ and $i + j + 1$)

When multiplying `num1[i]` with `num2[j]`:
- `num1[i]` represents $d_1 \times 10^{(M - 1 - i)}$
- `num2[j]` represents $d_2 \times 10^{(N - 1 - j)}$
- Their product is $(d_1 \times d_2) \times 10^{(M + N - 2 - (i + j))}$

In an array `pos` of size $M + N$:
- Position $i + j + 1$ corresponds to power $10^{(M + N - 2 - (i + j))}$ (the **units digit**).
- Position $i + j$ corresponds to power $10^{(M + N - 1 - (i + j))}$ (the **carry digit**).

```text
                  index:   0   1   2
                 num1  =   1   2   3  (M = 3)
                 num2  =       4   5  (N = 2)
              ----------------------
                          p1  p2
                  i=2, j=1 ->  3 * 5 = 15  --> pos[3], pos[4]
                  i=1, j=1 ->  2 * 5 = 10  --> pos[2], pos[3]
                  i=0, j=1 ->  1 * 5 =  5  --> pos[1], pos[2]
              ----------------------
  Array size = M + N = 5:  [0,  1,  2,  3,  4]
```

---

# 🧠 Evolution of Solutions: How We Make It Better

```text
┌────────────────────────────────────────────────────────────────────────┐
│  1. Grade-School Long Multiplication with String Addition              │
│     • Multiply num1 by each single digit of num2, append zeros         │
│     • Accumulate each partial product using a big-integer string add   │
│     • Time: O(M * N + N^2) | Space: O(M + N) per partial string        │
│     • Bottleneck: Repeated allocations of intermediate strings         │
└──────────────────────────────────┬─────────────────────────────────────┘
                                   │
                                   ▼ Eliminate Partial String Allocations
┌────────────────────────────────────────────────────────────────────────┐
│  2. Column Convolution with Deferred Carry Propagation                 │
│     • Accumulate all d1 * d2 into pos[i + j + 1] in one pass           │
│     • In a second pass, normalize carries right-to-left                │
│     • Time: O(M * N) | Space: O(M + N) integer array                   │
│     • Bottleneck: Two distinct traversals; temporary integer values    │
│       in array cells can reach up to 9 * 9 * min(M, N) = 16,200        │
└──────────────────────────────────┬─────────────────────────────────────┘
                                   │
                                   ▼ Immediate In-Place Carry Propagation
┌────────────────────────────────────────────────────────────────────────┐
│  3. In-Place Position Accumulation with Code Units (Optimal)           │
│     • Compute d1 * d2 and immediately resolve sum % 10 and carry       │
│     • Single pass over (i, j) pairs; pos values never exceed 89        │
│     • Convert result directly via String.fromCharCodes                 │
│     • Time: O(M * N) | Space: O(M + N)                                 │
│     • Improvement: Maximum cache locality, zero string manipulation    │
└──────────────────────────────────┬─────────────────────────────────────┘
                                   │
                                   ▼ Sub-Quadratic for Massive Inputs
┌────────────────────────────────────────────────────────────────────────┐
│  4. Karatsuba Multiplication / FFT (Advanced Follow-Up)                │
│     • Divide-and-conquer: split numbers into halves                    │
│     • Replaces 4 sub-multiplications with 3: O(N^1.585)                │
│     • Crucial for inputs with thousands/millions of digits             │
└────────────────────────────────────────────────────────────────────────┘
```

---

# 💻 Solutions

## 1. Approach 1: Grade-School Long Multiplication with String Add ($O(M \cdot N + N^2)$ Time, $O(M + N)$ Space)

Mimics pencil-and-paper arithmetic by computing $N$ partial product strings and adding them together sequentially:

```dart
class SolutionGradeSchool {
  String addStrings(String num1, String num2) {
    final buffer = StringBuffer();
    int i = num1.length - 1;
    int j = num2.length - 1;
    int carry = 0;

    while (i >= 0 || j >= 0 || carry > 0) {
      int sum = carry;
      if (i >= 0) sum += num1.codeUnitAt(i--) - 48;
      if (j >= 0) sum += num2.codeUnitAt(j--) - 48;
      carry = sum ~/ 10;
      buffer.write(sum % 10);
    }

    return buffer.toString().split('').reversed.join();
  }

  String multiplyOneDigit(String num, int digit, int zeroes) {
    if (digit == 0) return '0';
    final buffer = StringBuffer();
    int carry = 0;

    for (int i = num.length - 1; i >= 0; i--) {
      int prod = (num.codeUnitAt(i) - 48) * digit + carry;
      carry = prod ~/ 10;
      buffer.write(prod % 10);
    }
    if (carry > 0) buffer.write(carry);

    String rev = buffer.toString().split('').reversed.join();
    return rev + ('0' * zeroes);
  }

  String multiply(String num1, String num2) {
    if (num1 == '0' || num2 == '0') return '0';
    String result = '0';

    for (int i = num2.length - 1; i >= 0; i--) {
      final d = num2.codeUnitAt(i) - 48;
      final partial = multiplyOneDigit(num1, d, num2.length - 1 - i);
      result = addStrings(result, partial);
    }

    return result;
  }
}
```

### 🔴 Bottlenecks:
- Creates $N$ intermediate strings, reversing and formatting each one.
- Repeated calls to `addStrings` create substantial GC pressure.

---

## 2. Approach 2: Column Convolution with Deferred Carry ($O(M \cdot N)$ Time, $O(M + N)$ Space)

Treats multiplication as a polynomial convolution, accumulating products in place and normalizing carries in a second pass:

```dart
class SolutionColumnConvolution {
  String multiply(String num1, String num2) {
    if (num1 == '0' || num2 == '0') return '0';
    final m = num1.length, n = num2.length;
    final List<int> col = List<int>.filled(m + n, 0);

    // Pass 1: Polynomial convolution
    for (int i = 0; i < m; i++) {
      final d1 = num1.codeUnitAt(i) - 48;
      for (int j = 0; j < n; j++) {
        final d2 = num2.codeUnitAt(j) - 48;
        col[i + j + 1] += d1 * d2;
      }
    }

    // Pass 2: Right-to-left carry propagation
    for (int k = m + n - 1; k > 0; k--) {
      col[k - 1] += col[k] ~/ 10;
      col[k] %= 10;
    }

    // Trim leading zeros
    int start = 0;
    while (start < col.length && col[start] == 0) start++;
    if (start == col.length) return '0';

    for (int i = start; i < col.length; i++) col[i] += 48;
    return String.fromCharCodes(col, start, col.length);
  }
}
```

### 🔴 Bottlenecks:
- Requires two separate passes.
- Intermediate array cell values accumulate up to $9 \times 9 \times 200 = 16,200$, requiring larger integer widths.

---

## 3. Approach 3: Optimal In-Place Position Accumulation ($O(M \cdot N)$ Time, $O(M + N)$ Space)

Propagates the carry immediately during multiplication so array values never exceed $89$ ($9 \times 9 + 8$). Converts the output directly with `String.fromCharCodes`:

```dart
// LeetCode 0043: Multiply Strings
// Optimal Solution: In-Place Position Accumulation with Code Units
// Time Complexity: O(M * N) where M = num1.length, N = num2.length
// Space Complexity: O(M + N) to store the product digits

class Solution {
  String multiply(String num1, String num2) {
    // Edge case: multiplying any number by zero results in zero
    if (num1 == '0' || num2 == '0') return '0';

    final int m = num1.length;
    final int n = num2.length;
    // An m-digit number times an n-digit number produces at most m + n digits
    final List<int> pos = List<int>.filled(m + n, 0);

    // Compute products right-to-left
    for (int i = m - 1; i >= 0; i--) {
      final int d1 = num1.codeUnitAt(i) - 48; // ASCII '0' is 48

      for (int j = n - 1; j >= 0; j--) {
        final int d2 = num2.codeUnitAt(j) - 48;
        final int mul = d1 * d2;

        // d1 * d2 contributes to indices (i + j) and (i + j + 1)
        final int p1 = i + j;
        final int p2 = i + j + 1;
        final int sum = mul + pos[p2];

        pos[p2] = sum % 10;
        pos[p1] += sum ~/ 10; // Carry over to p1
      }
    }

    // Skip leading zeros
    int start = 0;
    while (start < pos.length && pos[start] == 0) {
      start++;
    }

    if (start == pos.length) return '0';

    // Convert digits back to ASCII character codes in-place
    for (int i = start; i < pos.length; i++) {
      pos[i] += 48;
    }

    return String.fromCharCodes(pos, start, pos.length);
  }
}
```

### 🟢 Why This is Optimal:
- **Immediate Carry Normalization:** Values in `pos` never overflow; `sum` is at most $81 + 9 = 90$.
- **Zero String Allocations during Loop:** Uses `codeUnitAt(i) - 48` for single-cycle integer arithmetic.
- **Instantaneous String Construction:** `String.fromCharCodes(pos, start, len)` constructs the Dart `String` directly from the integer buffer in a single contiguous memory allocation.

---

## 4. Approach 4: Karatsuba Multiplication (Sub-Quadratic Follow-Up)

For arbitrary-precision arithmetic on massive inputs ($N \ge 1000$), Karatsuba's algorithm splits each number into two halves:
$$X = X_1 \cdot 10^{B} + X_0, \quad Y = Y_1 \cdot 10^{B} + Y_0$$
$$X \cdot Y = Z_2 \cdot 10^{2B} + (Z_1 - Z_2 - Z_0) \cdot 10^B + Z_0$$
where $Z_2 = X_1 Y_1$, $Z_0 = X_0 Y_0$, and $Z_1 = (X_1 + X_0)(Y_1 + Y_0)$.

- **Recurrence:** $T(N) = 3T(N/2) + O(N)$
- **Time Complexity:** $O(N^{\log_2 3}) \approx O(N^{1.585})$
- **Note:** For $N \le 200$, the overhead of string splitting and recursion makes standard $O(M \cdot N)$ accumulation faster in practice, but Karatsuba is an outstanding interview follow-up topic for scale.

---

# 📊 Comprehensive Comparison Matrix

| Metric | 1. Grade-School with String Add | 2. Column Convolution | 3. In-Place Position Accumulation (Optimal) | 4. Karatsuba |
| :--- | :--- | :--- | :--- | :--- |
| **Time Complexity** | $O(M \cdot N + N^2)$ | $O(M \cdot N)$ | **$O(M \cdot N)$** | $O(N^{1.585})$ |
| **Auxiliary Space** | $O(M \cdot N)$ (Intermediate strings) | $O(M + N)$ | **$O(M + N)$** | $O(N \log N)$ |
| **Passes Over Array** | $N$ additions | 2 passes (convolute then carry) | **1 unified pass** | Recursive |
| **Max Cell Value** | $0 \dots 9$ | Up to $16,200$ | **$\le 89$** | N/A |
| **Output String Build** | Repeated `join()` & string copies | `String.fromCharCodes` | **`String.fromCharCodes` (Zero-copy)** | String concatenations |
| **Interview Rating** | Suboptimal | Good | 🏆 **Gold Standard Expected** | 🚀 **Top-Tier Discussion** |

---

# ⚠️ Key Interview Gotchas & Edge Cases

1. **The Zero Multiplication Edge Case (`"0"`):**
   - If either input is `"0"`, the loops would produce an array full of zeros `[0, 0, ...]`. Trimming leading zeros would result in an empty string `""`.
   - Handling `if (num1 == '0' || num2 == '0') return '0';` at the top prevents unnecessary loop passes and guarantees correct `"0"` output.
2. **ASCII Character Code Offset (`48`):**
   - The ASCII value of `'0'` is `48`.
   - `codeUnitAt(i) - 48` converts digit character $\to$ integer in $O(1)$ without `int.parse()`.
   - `+ 48` converts integer $\to$ ASCII character code before calling `String.fromCharCodes()`.
3. **Array Size Bound ($M + N$):**
   - $99 \times 99 = 9801$ ($2 + 2 = 4$ digits).
   - $10 \times 10 = 100$ ($2 + 2 - 1 = 3$ digits).
   - The result has either $M + N$ or $M + N - 1$ digits. Therefore, scanning from index 0 to skip the potential leading zero is always sufficient.
