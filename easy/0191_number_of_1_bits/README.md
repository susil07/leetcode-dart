# 🚀 LeetCode 191 - Number of 1 Bits

## 📝 Problem Statement

Given a positive integer `n`, write a function that returns the number of set bits in its binary representation (also known as the **Hamming weight**).

---

## Examples

### Example 1:
**Input:**
```text
n = 11
```
**Output:**
```text
3
```
**Explanation:**
The input binary string `1011` has a total of three set bits (`1`s).

---

### Example 2:
**Input:**
```text
n = 128
```
**Output:**
```text
1
```
**Explanation:**
The input binary string `10000000` has a total of one set bit.

---

### Example 3:
**Input:**
```text
n = 2147483645
```
**Output:**
```text
30
```
**Explanation:**
The input binary string `01111111111111111111111111111101` has 30 set bits.

---

## 🎯 Follow-up

If this function is called many times, how would you optimize it?
*(See Approach 4 and 5 below for the Precomputed Lookup Table & Bit-Parallel Popcount)*

---

# 🧠 Evolution of Solutions: How We Make It Better

```text
┌────────────────────────────────────────────────────────────────────────┐
│  1. Naive String Conversion                                            │
│     • Convert to binary string -> filter characters == '1'             │
│     • Bottleneck: Memory allocations for strings and character lists   │
└──────────────────────────────────┬─────────────────────────────────────┘
                                   │
                                   ▼ Eliminate String Overhead
┌────────────────────────────────────────────────────────────────────────┐
│  2. Iterative Bit-by-Bit Shift                                         │
│     • Loop up to 32 times: count += (n & 1); n >>= 1;                  │
│     • Improvement: In-place bitwise arithmetic, zero heap allocation   │
│     • Bottleneck: Scans every bit up to MSB, even all the 0s           │
└──────────────────────────────────┬─────────────────────────────────────┘
                                   │
                                   ▼ Skip All 0s Directly
┌────────────────────────────────────────────────────────────────────────┐
│  3. Brian Kernighan's Algorithm (Most Optimal in Interviews)           │
│     • Loop: n &= (n - 1); count++;                                     │
│     • Improvement: Exactly k iterations (where k = number of 1-bits)   │
│     • e.g. for n = 128 (10000000), runs in exactly 1 iteration!        │
└──────────────────────────────────┬─────────────────────────────────────┘
                                   │
                                   ▼ High Throughput / Millions of Calls
┌────────────────────────────────────────────────────────────────────────┐
│  4. Precomputed Byte Lookup Table / Bit-Parallel Popcount              │
│     • 4 array lookups or parallel SIMD-like bitmask addition           │
│     • Improvement: Branchless, fixed 4 operations per call             │
└────────────────────────────────────────────────────────────────────────┘
```

---

# 💻 Solutions

## 1. Approach 1: Naive String Conversion (Brute Force)

Convert the integer into a binary string using `toRadixString(2)`, split into characters, and count occurrences of `'1'`.

```dart
class SolutionNaiveString {
  int hammingWeight(int n) {
    return n.toRadixString(2).split('').where((char) => char == '1').length;
  }
}
```

### 🔴 Bottlenecks:
- Allocates multiple heap objects (`String`, `List<String>`).
- Substantial CPU parsing overhead compared to native CPU register operations.

---

## 2. Approach 2: Bit-by-Bit Shift (Iterative $O(32)$)

### 💡 How We Make It Better:
Instead of allocating strings, inspect the least significant bit with `n & 1` and shift right by 1 (`n >>= 1` or `n >>>= 1`) on each iteration.

```dart
class SolutionBitByBit {
  int hammingWeight(int n) {
    int count = 0;
    while (n != 0) {
      count += (n & 1);
      n >>= 1;
    }
    return count;
  }
}
```

### 🟢 Improvements Over Approach 1:
- Zero heap allocations ($O(1)$ space).
- Operates entirely on integer registers.

### 🔴 Remaining Bottleneck:
- Scans all bits up to the most significant bit.
- For example, if $n = 2^{30}$ (`01000000 00000000 00000000 00000000`), it performs **31 iterations** just to find a single `1` bit!

---

## 3. Approach 3: Brian Kernighan's Algorithm (Most Optimal $O(k)$)

### 💡 How We Make It Better:
Can we jump directly from one set bit to the next, **completely skipping all zeroes**?

Yes! The bitwise trick `n & (n - 1)` always clears the **least significant (rightmost) set bit**:

```text
Suppose n = 12 (binary 1100):
   n       = 1 1 0 0  (12)
   n - 1   = 1 0 1 1  (11)
  ─────────────────────
   n&(n-1) = 1 0 0 0  (8)  <-- Rightmost 1-bit cleared in ONE step!

Next iteration:
   n       = 1 0 0 0  (8)
   n - 1   = 0 1 1 1  (7)
  ─────────────────────
   n&(n-1) = 0 0 0 0  (0)  <-- Terminated in only 2 iterations!
```

```dart
class Solution {
  int hammingWeight(int n) {
    int count = 0;

    // In each iteration, clears the lowest set bit
    while (n != 0) {
      n &= (n - 1);
      count++;
    }

    return count;
  }
}
```

### 🟢 Improvements Over Approach 2:
- Loops **only $k$ times**, where $k$ is the number of set bits ($k \le 32$, average 16).
- For powers of 2 (like `128`), it runs in **exactly 1 iteration** instead of 8 or 32!
- In technical interviews, this is considered the gold standard solution.

---

## 4. Approach 4: Bit-Parallel Popcount / SWAR ($O(1)$ Branchless)

### 💡 How We Make It Better (Divide & Conquer in Registers):
We can add adjacent bits in parallel using bitmasks (Single Instruction Multiple Data without SIMD hardware):
1. Add pairs of bits: `(n & 0x55555555) + ((n >> 1) & 0x55555555)`
2. Add nibbles: `(n & 0x33333333) + ((n >> 2) & 0x33333333)`
3. Add bytes: `(n + (n >> 4)) & 0x0F0F0F0F`
4. Sum all bytes together.

```dart
class SolutionBitParallel {
  int hammingWeight(int n) {
    n = n - ((n >> 1) & 0x55555555);
    n = (n & 0x33333333) + ((n >> 2) & 0x33333333);
    n = (n + (n >> 4)) & 0x0F0F0F0F;
    n = n + (n >> 8);
    n = n + (n >> 16);
    return n & 0x3F;
  }
}
```

### 🟢 Improvements:
- Branchless, loopless, fixed 5 arithmetic/bitwise operations.

---

## 5. Approach 5: Byte Lookup Table (Follow-Up for High Throughput)

> **Interview Follow-Up:** *"If this function is called millions of times, how would you optimize it?"*

Precompute the popcount for all 256 possible 8-bit bytes (`0..255`) once.
Then any 32-bit integer is resolved with **4 table lookups**:

```dart
class SolutionLookupTable {
  static final List<int> _table = _initTable();

  static List<int> _initTable() {
    final t = List<int>.filled(256, 0);
    for (int i = 0; i < 256; i++) {
      t[i] = (i & 1) + t[i >> 1];
    }
    return t;
  }

  int hammingWeight(int n) {
    return _table[n & 0xFF] +
           _table[(n >> 8) & 0xFF] +
           _table[(n >> 16) & 0xFF] +
           _table[(n >> 24) & 0xFF];
  }
}
```

---

# 📊 Comprehensive Comparison Matrix

| Approach | Time Complexity | Space Complexity | Iterations / Ops | Best Used For |
| :--- | :--- | :--- | :--- | :--- |
| **1. String Conversion** | $O(32)$ + allocation | $O(32)$ heap | Many string allocations | Quick prototyping |
| **2. Bit-by-Bit Shift** | $O(32)$ | **$O(1)$** | Up to 32 loop steps | Simple interview explanation |
| **3. Brian Kernighan's (Optimal)** | **$O(k)$** ($k \le 32$) | **$O(1)$** | **Only set bits ($k$)** | **Standard Interview Choice** |
| **4. Bit-Parallel Popcount** | **$O(1)$** | **$O(1)$** | 5 operations (Branchless) | Systems / Compiler implementations |
| **5. Byte Lookup Table** | **$O(1)$** | $O(1)$ (256 bytes) | 4 table lookups | **High-Throughput Streaming** |

---

# ⚠️ Key Interview Gotchas & Edge Cases

1. **Powers of 2**:
   Brian Kernighan's algorithm is also the basis of checking if a number is a power of 2:
   ```dart
   bool isPowerOfTwo(int n) => n > 0 && (n & (n - 1)) == 0;
   ```
2. **Input `n = 0`**:
   The loop condition `n != 0` immediately terminates and returns `0`.
3. **Large 32-bit Integers (`2^31 - 1`)**:
   In 64-bit Dart VM, integers are signed 64-bit, so all 32-bit positive numbers fit without overflowing. Using `while (n != 0)` cleanly handles unsigned representations.
