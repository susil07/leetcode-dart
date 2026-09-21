# 🚀 LeetCode 0012 - Integer to Roman

## 📝 Problem Statement

Seven different symbols represent Roman numerals with the following values:

| Symbol | Value |
| :---: | :---: |
| **I** | 1 |
| **V** | 5 |
| **X** | 10 |
| **L** | 50 |
| **C** | 100 |
| **D** | 500 |
| **M** | 1000 |

Roman numerals are formed by appending the conversions of decimal place values from highest to lowest. Converting a decimal place value into a Roman numeral follows these rules:

1. **Standard Form**: If the value does not start with 4 or 9, select the symbol of the maximal value that can be subtracted from the input, append that symbol to the result, subtract its value, and convert the remainder.
2. **Subtractive Form**: If the value starts with 4 or 9, use the subtractive form representing one symbol subtracted from the following symbol:
   - $4 \rightarrow \text{IV}$ ($1$ less than $5$)
   - $9 \rightarrow \text{IX}$ ($1$ less than $10$)
   - $40 \rightarrow \text{XL}$ ($10$ less than $50$)
   - $90 \rightarrow \text{XC}$ ($10$ less than $100$)
   - $400 \rightarrow \text{CD}$ ($100$ less than $500$)
   - $900 \rightarrow \text{CM}$ ($100$ less than $1000$)
3. **Repetition Limit**: Only powers of 10 (`I`, `X`, `C`, `M`) can be appended consecutively at most 3 times. You cannot append `V`, `L`, or `D` multiple times.

Given an integer `num`, convert it to a Roman numeral.

---

## 🔒 Constraints

- $1 \le \text{num} \le 3999$

---

## Examples

### Example 1:
**Input:** `num = 3749`  
**Output:** `"MMMDCCXLIX"`  
*Explanation:*  
- $3000 = \text{MMM}$  
- $700 = \text{DCC}$  
- $40 = \text{XL}$  
- $9 = \text{IX}$  
- $\text{Result} = \text{MMMDCCXLIX}$

---

### Example 2:
**Input:** `num = 58`  
**Output:** `"LVIII"`  
*Explanation:*  
- $50 = \text{L}$  
- $8 = \text{VIII}$  

---

### Example 3:
**Input:** `num = 1994`  
**Output:** `"MCMXCIV"`  
*Explanation:*  
- $1000 = \text{M}$  
- $900 = \text{CM}$  
- $90 = \text{XC}$  
- $4 = \text{IV}$  

---

# 💡 Core Concept: The 13 Unique Roman Values

Instead of treating the 6 subtractive forms (`IV`, `IX`, `XL`, `XC`, `CD`, `CM`) as special exceptions with complex conditional checks, we treat them as **first-class symbols in our numeral system**:

```text
Value:   1000  900  500  400  100   90   50   40   10    9    5    4    1
Symbol:    M   CM    D   CD    C   XC    L   XL    X   IX    V   IV    I
           ─────────────────────────────────────────────────────────────
           Highest Value (Greedy Choice) ──────────────► Lowest Value
```

By greedily matching the highest possible value from this list of 13 tokens, the problem reduces to simple division / repeated subtraction.

---

# 🧠 Evolution of Solutions: How We Make It Better

```text
┌────────────────────────────────────────────────────────────────────────┐
│  1. Naive Conditional Decomposition (Sprawling if/else)                │
│     • Extract each digit, write manual switch/cases for 4, 9, 40, etc. │
│     • Bottleneck: Error-prone, hard to maintain, excessive branching   │
└──────────────────────────────────┬─────────────────────────────────────┘
                                   │
                                   ▼ Greedily Consume Top Values
┌────────────────────────────────────────────────────────────────────────┐
│  2. Greedy 13-Token Decomposition (Optimal Interview Standard)         │
│     • Match and subtract from 1000 down to 1 in a simple loop          │
│     • Time: O(1) (at most 15 steps) | Space: O(1)                      │
│     • Improvement: Extremely clean, treats subtractive forms as tokens │
└──────────────────────────────────┬─────────────────────────────────────┘
                                   │
                                   ▼ Eliminate Loops Completely
┌────────────────────────────────────────────────────────────────────────┐
│  3. Hardcoded Place-Value Arrays (Branchless / Loopless)               │
│     • Separate precomputed strings for thousands, hundreds, tens, ones │
│     • Time: O(1) in exactly 4 operations | Space: O(1)                 │
│     • Improvement: Direct index access, zero loops                     │
└────────────────────────────────────────────────────────────────────────┘
```

---

# 💻 Solutions

## 1. Approach 1: Greedy Value-Symbol Decomposition (Optimal Standard)

Iterate through the 13 value-symbol pairs in descending order, subtracting as much as possible at each step.

```dart
class Solution {
  String intToRoman(int num) {
    // 13 unique Roman numeral values including subtractive forms
    const values = [
      1000, 900, 500, 400,
      100,  90,  50,  40,
      10,   9,   5,   4,
      1,
    ];

    const symbols = [
      'M',  'CM', 'D',  'CD',
      'C',  'XC', 'L',  'XL',
      'X',  'IX', 'V',  'IV',
      'I',
    ];

    final buffer = StringBuffer();

    // Greedily match and subtract the largest possible Roman value
    for (int i = 0; i < values.length && num > 0; i++) {
      while (num >= values[i]) {
        buffer.write(symbols[i]);
        num -= values[i];
      }
    }

    return buffer.toString();
  }
}
```

### 🟢 Complexity:
- **Time Complexity:** **$O(1)$** — Since `num <= 3999`, the inner loop executes at most 15 times (the longest Roman numeral is 3888: `MMMDCCCLXXXVIII`, length 15).
- **Space Complexity:** **$O(1)$** auxiliary space (only a fixed 13-element lookup table and a `StringBuffer`).

---

## 2. Approach 2: Hardcoded Place-Value Arrays (Loopless Direct Lookup)

### 💡 How We Make It Better:
Because decimal notation separates numbers into units, tens, hundreds, and thousands, we can map each place value directly to its Roman string without any loops:

```dart
class SolutionDirect {
  String intToRoman(int num) {
    const thousands = ['', 'M', 'MM', 'MMM'];
    const hundreds = ['', 'C', 'CC', 'CCC', 'CD', 'D', 'DC', 'DCC', 'DCCC', 'CM'];
    const tens = ['', 'X', 'XX', 'XXX', 'XL', 'L', 'LX', 'LXX', 'LXXX', 'XC'];
    const ones = ['', 'I', 'II', 'III', 'IV', 'V', 'VI', 'VII', 'VIII', 'IX'];

    return thousands[num ~/ 1000] +
           hundreds[(num % 1000) ~/ 100] +
           tens[(num % 100) ~/ 10] +
           ones[num % 10];
  }
}
```

### 🟢 Improvements Over Approach 1:
- Exactly **4 array lookups** and string concatenations.
- Zero loops, zero conditional branching.

---

# 📊 Comprehensive Comparison Matrix

| Metric | 1. Naive Switch/Case | 2. Greedy Decomposition (Optimal) | 3. Hardcoded Place-Value Arrays |
| :--- | :--- | :--- | :--- |
| **Time Complexity** | $O(1)$ | **$O(1)$** (at most 15 steps) | **$O(1)$** (exactly 4 lookups) |
| **Auxiliary Space** | $O(1)$ | **$O(1)$** | **$O(1)$** |
| **Loop Overhead** | Conditional branching | 13-step loop | **Zero loops (Branchless)** |
| **Maintainability** | ⚠️ Sprawling & error-prone | 🏆 Clean, concise & intuitive | 👍 Simple table lookup |
| **Interview Rating** | ❌ Naive | 🏆 **Gold Standard Expected** | 💡 Great follow-up demonstration |

---

# ⚠️ Key Interview Gotchas & Edge Cases

1. **Why `49` is `XLIX` and NOT `IL`**:
   Subtractive rules strictly apply to the next highest base in the same decimal place value. `I` can only precede `V` and `X`. It cannot precede `L` or `C`.
2. **Why Max is 3999**:
   The largest standard Roman numeral is 3999 (`MMMCMXCIX`). Representing 4000 requires symbols beyond `M` or vinculum notation ($\overline{\text{IV}}$), which are outside standard Roman ascii rules.
3. **Empty Strings for Zeroes**:
   In numbers like `1004` (`MIV`), the hundreds and tens place values are 0, which correctly contribute nothing (`""`) to the final result.
