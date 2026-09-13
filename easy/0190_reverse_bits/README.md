# 🚀 LeetCode 190 - Reverse Bits

## 📝 Problem Statement

Reverse bits of a given 32 bits signed/unsigned integer.

**Note:**
- In some languages, such as Java or Dart, there is no unsigned integer type. In this case, both input and output will be given as signed integer types. They should not affect your implementation, as the integer's internal binary representation is the same, whether it is signed or unsigned.
- In Java, the compiler represents signed integers using 2's complement notation. Therefore, in Example 2 below, the input represents the signed integer `-3` and the output represents the signed integer `-1073741825`.

---

## Example 1

**Input:**
```text
n = 43261596
```

**Output:**
```text
964176192
```

**Explanation:**

| Integer | Binary Representation |
| :--- | :--- |
| **Input** (`43261596`) | `00000010100101000001111010011100` |
| **Output** (`964176192`) | `00111001011110000010100101000000` |

---

## Example 2

**Input:**
```text
n = 2147483644
```

**Output:**
```text
1073741822
```

**Explanation:**

| Integer | Binary Representation |
| :--- | :--- |
| **Input** (`2147483644`) | `01111111111111111111111111111100` |
| **Output** (`1073741822`) | `00111111111111111111111111111110` |

---

## 🎯 Follow-up

If this function is called many times, how would you optimize it?
*(See Approach 4 below for the Byte Lookup Table solution)*

---

# 🧠 Evolution of Solutions: How We Make It Better

```text
┌────────────────────────────────────────────────────────────────────────┐
│  1. Naive String Conversion                                            │
│     • Convert to binary string -> pad 32 -> reverse -> parse back      │
│     • Bottleneck: Heavy string allocations & string parsing            │
└──────────────────────────────────┬─────────────────────────────────────┘
                                   │
                                   ▼ Eliminate String Overhead
┌────────────────────────────────────────────────────────────────────────┐
│  2. Iterative Bit-by-Bit Shift                                         │
│     • Loop 32 times: (result << 1) | ((n >> i) & 1)                    │
│     • Improvement: Pure integer bit manipulation                       │
│     • Bottleneck: 32 loop iterations & branch counter checks           │
└──────────────────────────────────┬─────────────────────────────────────┘
                                   │
                                   ▼ Eliminate Loops with Parallel Swapping
┌────────────────────────────────────────────────────────────────────────┐
│  3. Divide & Conquer Bitmasking (Optimal Single-Call)                  │
│     • Swap 16-bit, 8-bit, 4-bit, 2-bit, 1-bit blocks in parallel       │
│     • Improvement: Exactly 5 operations, 0 loops, 0 branching          │
└──────────────────────────────────┬─────────────────────────────────────┘
                                   │
                                   ▼ Optimize For Millions of Calls
┌────────────────────────────────────────────────────────────────────────┐
│  4. Precomputed Byte Lookup Table (Optimal Multi-Call / Follow-up)     │
│     • Precompute 256-byte cache, reverse via 4 table lookups           │
│     • Improvement: Only 4 operations per call                          │
└────────────────────────────────────────────────────────────────────────┘
```

---

# 💻 Solutions

## 1. Approach 1: Naive String Manipulation (Brute Force)

The most intuitive beginner approach is to convert the number into a binary string, reverse the characters, and parse it back to an integer.

```dart
class SolutionNaiveString {
  int reverseBits(int n) {
    // 1. Convert to 32-bit binary string with leading zeros
    final binaryStr = (n & 0xFFFFFFFF).toRadixString(2).padLeft(32, '0');

    // 2. Reverse characters
    final reversedStr = binaryStr.split('').reversed.join();

    // 3. Parse back to integer
    return int.parse(reversedStr, radix: 2);
  }
}
```

### 🔴 Why This Is Suboptimal:
- **High Memory Allocations**: Creates multiple intermediate objects (`String`, `List<String>`).
- **Heavy Parsing Cost**: String conversion and base-2 radix parsing have significant CPU overhead compared to native CPU bitwise instructions.

---

## 2. Approach 2: Bit-by-Bit Shift (Iterative $O(32)$)

### 💡 How We Make It Better:
Instead of converting numbers to strings, we work directly at the **binary level** using bitwise operators (`>>`, `<<`, `|`, `&`).

For each of the 32 positions (from bit $0$ to bit $31$):
1. Extract the $i$-th bit: `(n >> i) & 1`
2. Shift our accumulated result left by 1: `result << 1`
3. Append the extracted bit: `result = (result << 1) | bit`

```dart
class SolutionIterative {
  int reverseBits(int n) {
    int result = 0;

    for (int i = 0; i < 32; i++) {
      result = (result << 1) | ((n >> i) & 1);
    }

    return result;
  }
}
```

### 🟢 Improvements Over Approach 1:
- Zero heap allocations ($O(1)$ memory).
- Runs directly inside CPU registers.

### 🔴 Remaining Bottleneck:
- Takes 32 loop iterations, with loop counter increments, branch checks, and single-bit movements.

---

## 3. Approach 3: Divide & Conquer / Bit Masking (Most Optimal for Single Call)

### 💡 How We Make It Better:
Just as Merge Sort sorts arrays by dividing and conquering, we can **swap bit blocks in parallel** instead of moving one bit at a time!

```text
Initial 32 bits:
[  16 bits A  |  16 bits B  ]
       ▼ Swap 16-bit blocks
[  16 bits B  |  16 bits A  ]
       ▼ Swap 8-bit blocks (bytes) inside each 16-bit block
[ B2 | B1 | A2 | A1 ]
       ▼ Swap 4-bit nibbles inside each byte
[ ... nibbles swapped ... ]
       ▼ Swap 2-bit pairs
[ ... 2-bit pairs swapped ... ]
       ▼ Swap adjacent 1-bit pairs
[ All 32 bits completely reversed! ]
```

```dart
class Solution {
  int reverseBits(int n) {
    // Mask to 32 bits
    n = n & 0xFFFFFFFF;

    // Step 1: Swap 16-bit halves
    n = ((n >> 16) & 0x0000FFFF) | ((n & 0x0000FFFF) << 16);

    // Step 2: Swap 8-bit bytes
    n = ((n >> 8) & 0x00FF00FF) | ((n & 0x00FF00FF) << 8);

    // Step 3: Swap 4-bit nibbles
    n = ((n >> 4) & 0x0F0F0F0F) | ((n & 0x0F0F0F0F) << 4);

    // Step 4: Swap 2-bit pairs
    n = ((n >> 2) & 0x33333333) | ((n & 0x33333333) << 2);

    // Step 5: Swap adjacent 1-bit pairs
    n = ((n >> 1) & 0x55555555) | ((n & 0x55555555) << 1);

    return n & 0xFFFFFFFF;
  }
}
```

### 🟢 Improvements Over Approach 2:
- Exactly **5 bitwise operations** total.
- **Zero loop overhead**, zero branch mispredictions, pure pipelineable CPU instructions.
- This is the algorithm implemented in hardware ALUs and high-performance graphics engines.

---

## 4. Approach 4: Precomputed Byte Lookup Table (Optimal for Millions of Calls)

### 💡 How We Make It Better (LeetCode Follow-Up):
> *"If this function is called many times, how would you optimize it?"*

If `reverseBits` is invoked in a high-throughput loop (e.g., networking packets or video decoding), even 5 operations per call add up.
We can precompute the reversed bit pattern for all 256 possible 8-bit bytes (`0` to `255`) into an array **once**.
Then, any 32-bit integer is split into 4 bytes and reversed with only **4 array lookups**:

```dart
class SolutionLookupTable {
  static final List<int> _byteTable = _initByteTable();

  static List<int> _initByteTable() {
    final table = List<int>.filled(256, 0);
    for (int i = 0; i < 256; i++) {
      int rev = 0;
      for (int b = 0; b < 8; b++) {
        rev = (rev << 1) | ((i >> b) & 1);
      }
      table[i] = rev;
    }
    return table;
  }

  int reverseBits(int n) {
    return (_byteTable[n & 0xFF] << 24) |
           (_byteTable[(n >> 8) & 0xFF] << 16) |
           (_byteTable[(n >> 16) & 0xFF] << 8) |
           (_byteTable[(n >> 24) & 0xFF]);
  }
}
```

---

# 📊 Comprehensive Comparison Matrix

| Metric | 1. String Conversion | 2. Bit-by-Bit Shift | 3. Divide & Conquer (Optimal) | 4. Byte Lookup Table (Follow-up) |
| :--- | :--- | :--- | :--- | :--- |
| **Time Complexity** | $O(32)$ with high constant factor | $O(1)$ (32 iterations) | **$O(1)$ (5 operations)** | **$O(1)$ (4 lookups)** |
| **Space Complexity** | $O(32)$ (String heap objects) | **$O(1)$** | **$O(1)$** | $O(1)$ (256-byte cache) |
| **Loop Overhead** | Yes (string traversal & parsing) | Yes (32 iterations) | **None (Branchless)** | **None (Branchless)** |
| **Memory Allocation** | Multiple objects per call | 0 bytes | **0 bytes** | 256 bytes total once |
| **Best Scenario** | Quick prototyping | Standard interview setting | **Production / Single Call** | **High-Throughput Streaming** |

---

# ⚠️ Key Interview Takeaways

1. **Fixed 32 Iterations**:
   Even if a number has leading zeros (e.g., `1`), all 32 bits must be processed because leading zeros become trailing zeros when reversed (e.g., `1` becomes $2^{31} = 2147483648$).
2. **Bitwise Operator Precedence**:
   Always wrap bitwise shifts and masks with parentheses:
   ```dart
   // CORRECT:
   ((n >> 1) & 0x55555555) | ((n & 0x55555555) << 1)
   ```
3. **Follow-Up Answer**:
   When the interviewer asks about handling repeated calls, immediately introduce the **Byte Lookup Table** (Trade 256 bytes of memory for 4 lookups per call).
