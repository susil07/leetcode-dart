# 🚀 LeetCode 0008 - String to Integer (atoi)

## 📝 Problem Statement

Implement the `myAtoi(string s)` function, which converts a string to a 32-bit signed integer.

The algorithm for `myAtoi(string s)` is as follows:

1. **Whitespace**: Ignore any leading whitespace (`" "`).
2. **Signedness**: Determine the sign by checking if the next character is `'-'` or `'+'`, assuming positivity if neither is present.
3. **Conversion**: Read the integer by skipping leading zeros until a non-digit character is encountered or the end of the string is reached. If no digits were read, then the result is `0`.
4. **Rounding**: If the integer is out of the 32-bit signed integer range $[-2^{31}, 2^{31} - 1]$, round the integer to remain in the range:
   - Integers less than $-2^{31}$ should be clamped to $-2^{31}$ (`-2147483648`).
   - Integers greater than $2^{31} - 1$ should be clamped to $2^{31} - 1$ (`2147483647`).

Return the integer as the final result.

---

## 🔒 Constraints

- `0 <= s.length <= 200`
- `s` consists of English letters (lower-case and upper-case), digits (`0-9`), `' '`, `'+'`, `'-'`, and `'.'`.

---

## Examples

### Example 1:
**Input:** `s = "42"`  
**Output:** `42`  
*Explanation:*  
- Step 1: `"42"` (no leading whitespace)  
- Step 2: `"42"` (neither `'-'` nor `'+'`, positive)  
- Step 3: `42` is read  

---

### Example 2:
**Input:** `s = "   -042"`  
**Output:** `-42`  
*Explanation:*  
- Step 1: `"   -042"` (leading whitespace ignored)  
- Step 2: `"-"` read $\rightarrow$ negative sign  
- Step 3: `"042"` read $\rightarrow$ leading zeros ignored $\rightarrow$ `-42`  

---

### Example 3:
**Input:** `s = "1337c0d3"`  
**Output:** `1337`  
*Explanation:*  
- Reading stops at `'c'` (first non-digit) $\rightarrow$ `1337`  

---

### Example 4:
**Input:** `s = "0-1"`  
**Output:** `0`  
*Explanation:*  
- `"0"` is read, reading stops at `'-'` $\rightarrow$ `0`  

---

### Example 5:
**Input:** `s = "words and 987"`  
**Output:** `0`  
*Explanation:*  
- First non-whitespace character is `'w'`, which is a non-digit $\rightarrow$ `0`  

---

# 🧠 State Machine / Lexing Flow

```text
       ┌──────────────┐
       │   START      │ ◄── Read leading ' ' (ignore)
       └──────┬───────┘
              │
    Read '+' or '-' (set sign)
              │
              ▼
       ┌──────────────┐
       │    SIGN      │
       └──────┬───────┘
              │
       Read '0'-'9' (accumulate digit)
              │
              ▼
       ┌──────────────┐
       │    NUMBER    │ ◄── Read '0'-'9' (check 32-bit overflow)
       └──────┬───────┘
              │
       Non-digit / End of String
              │
              ▼
       ┌──────────────┐
       │     END      │ ──► Return clamped result
       └──────────────┘
```

---

# 🧠 Evolution of Solutions: How We Make It Better

```text
┌────────────────────────────────────────────────────────────────────────┐
│  1. Regular Expressions (Brute Force / Naive)                          │
│     • Match ^\s*([+-]?\d+) via regex engine, parse with BigInt         │
│     • Bottleneck: Heavy regex engine overhead, parses beyond 32 bits   │
└──────────────────────────────────┬─────────────────────────────────────┘
                                   │
                                   ▼ Eliminate Regex Engine
┌────────────────────────────────────────────────────────────────────────┐
│  2. Deterministic Finite Automaton (DFA / State Machine)               │
│     • Explicit state table: (State, Input) -> NextState                │
│     • Improvement: Formal compiler design, clear separation of logic   │
│     • Bottleneck: State transition table overhead and extra boilerplate │
└──────────────────────────────────┬─────────────────────────────────────┘
                                   │
                                   ▼ Streamline to Single Pass Pointer
┌────────────────────────────────────────────────────────────────────────┐
│  3. Single-Pass Pointer Scan with 32-Bit Guard (Optimal Solution)     │
│     • Skip spaces -> check sign -> parse digits with immediate clamp   │
│     • Improvement: O(N) Time, O(1) Space, zero allocations, fast loop  │
└────────────────────────────────────────────────────────────────────────┘
```

---

# 💻 Solutions

## 1. Approach 1: Regular Expressions (Naive / Prototyping)

Use a regular expression to extract the optional sign and consecutive digits, then clamp.

```dart
class SolutionRegex {
  int myAtoi(String s) {
    final match = RegExp(r'^\s*([+-]?\d+)').firstMatch(s);
    if (match == null) return 0;

    final numStr = match.group(1)!;
    final value = BigInt.tryParse(numStr) ?? BigInt.zero;

    final intMax = BigInt.from(2147483647);
    final intMin = BigInt.from(-2147483648);

    if (value > intMax) return 2147483647;
    if (value < intMin) return -2147483648;

    return value.toInt();
  }
}
```

### 🔴 Bottlenecks:
- Compiles a regex DFA/NFA at runtime.
- Allocates heap substrings and `BigInt` objects.

---

## 2. Approach 2: Deterministic Finite Automaton (DFA)

Model the parser as a formal state machine with 4 states: `start`, `signed`, `in_number`, `end`.

```dart
enum State { start, signed, number, end }

class SolutionDFA {
  int myAtoi(String s) {
    State state = State.start;
    int sign = 1;
    int result = 0;
    const maxThreshold = 214748364;

    for (int i = 0; i < s.length; i++) {
      final ch = s[i];

      switch (state) {
        case State.start:
          if (ch == ' ') continue;
          if (ch == '+' || ch == '-') {
            sign = (ch == '-') ? -1 : 1;
            state = State.signed;
          } else if (_isDigit(ch)) {
            result = ch.codeUnitAt(0) - 48;
            state = State.number;
          } else {
            return 0;
          }
          break;

        case State.signed:
        case State.number:
          if (_isDigit(ch)) {
            final digit = ch.codeUnitAt(0) - 48;
            if (sign == 1 && (result > maxThreshold || (result == maxThreshold && digit > 7))) {
              return 2147483647;
            }
            if (sign == -1 && (result > maxThreshold || (result == maxThreshold && digit > 8))) {
              return -2147483648;
            }
            result = result * 10 + digit;
            state = State.number;
          } else {
            return sign * result;
          }
          break;

        case State.end:
          return sign * result;
      }
    }

    return sign * result;
  }

  bool _isDigit(String ch) => ch.codeUnitAt(0) >= 48 && ch.codeUnitAt(0) <= 57;
}
```

### 🟢 Improvements Over Approach 1:
- Zero regex engine overhead, formal and extensible.

---

## 3. Approach 3: Single-Pass Pointer Scan with 32-Bit Clamping (Optimal)

Follow the 4 problem steps sequentially using an index pointer `i`:
1. **Advance past whitespace**: `while (s[i] == ' ') i++;`
2. **Read sign**: check `'-'` or `'+'`.
3. **Parse digits**: guard 32-bit limits **before** accumulating `result = result * 10 + digit`.

```dart
class Solution {
  int myAtoi(String s) {
    const int intMax = 2147483647;
    const int intMin = -2147483648;
    const int maxThreshold = 214748364; // 2147483647 ~/ 10

    int i = 0;
    final n = s.length;

    // 1. Skip leading whitespaces
    while (i < n && s[i] == ' ') {
      i++;
    }
    if (i == n) return 0;

    // 2. Check for optional '+' or '-' sign
    int sign = 1;
    if (s[i] == '-') {
      sign = -1;
      i++;
    } else if (s[i] == '+') {
      i++;
    }

    // 3. Parse digits and clamp to 32-bit signed range
    int result = 0;
    while (i < n) {
      final code = s.codeUnitAt(i);
      // Stop reading if non-digit is encountered
      if (code < 48 || code > 57) {
        break;
      }
      final digit = code - 48;

      // Check overflow/underflow BEFORE multiplying by 10
      if (sign == 1) {
        if (result > maxThreshold || (result == maxThreshold && digit > 7)) {
          return intMax;
        }
      } else {
        if (result > maxThreshold || (result == maxThreshold && digit > 8)) {
          return intMin;
        }
      }

      result = result * 10 + digit;
      i++;
    }

    return sign * result;
  }
}
```

### 🟢 Improvements Over Approach 2:
- **Zero Allocations**: $O(1)$ auxiliary space.
- **$O(N)$ Single Pass**: Early termination upon non-digits or overflow.
- Cleanest and most expected implementation in FAANG interviews.

---

# 📊 Comprehensive Comparison Matrix

| Metric | 1. Regular Expressions | 2. State Machine (DFA) | 3. Single-Pass Scan (Optimal) |
| :--- | :--- | :--- | :--- |
| **Time Complexity** | $O(N)$ + Regex Engine overhead | $O(N)$ | **$O(N)$** (Single pass) |
| **Space Complexity** | $O(N)$ (Capturing group substrings) | $O(1)$ | **$O(1)$** |
| **Code Length** | Short | Verbose | **Concise & Readable** |
| **Overflow Safety** | Requires `BigInt` parsing | Pre-checked | **Pre-checked in-place** |
| **Interview Rating** | ⚠️ Discouraged | 👍 Impressive design | 🏆 **Gold Standard** |

---

# ⚠️ Key Interview Gotchas & Edge Cases

1. **Multiple Signs**:
   Inputs like `"+-12"` or `"-+12"` must return `0`. Only the very first character after spaces can be a sign.
2. **Trailing Non-Digits**:
   `"1337c0d3"` $\rightarrow$ stop at `'c'`, return `1337`.
   `"0-1"` $\rightarrow$ read `'0'`, stop at `'-'`, return `0`.
3. **Leading Whitespaces Only / Empty String**:
   `""` or `"    "` must safely return `0` without index out of bounds exceptions.
4. **32-Bit Overflow vs Underflow Limits**:
   - Positive overflow clamps to `2147483647` (`INT_MAX`).
   - Negative underflow clamps to `-2147483648` (`INT_MIN`).
