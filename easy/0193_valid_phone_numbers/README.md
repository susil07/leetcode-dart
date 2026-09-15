# 🚀 LeetCode 193 - Valid Phone Numbers

## 📝 Problem Statement

Given a text file `file.txt` that contains a list of phone numbers (one per line), write a one-liner bash script to print all valid phone numbers.

You may assume that a valid phone number must appear in one of the following two formats:
1. `(xxx) xxx-xxxx`
2. `xxx-xxx-xxxx`

*(where `x` denotes a digit `0-9`)*

You may also assume each line in the text file must not contain leading or trailing white spaces.

---

## Example

Assume that `file.txt` has the following content:

```text
987-123-4567
123 456 7890
(123) 456-7890
```

Your script should output the following valid phone numbers:

```text
987-123-4567
(123) 456-7890
```

---

# 💡 Core Concept: Regular Expression Decomposition

A valid phone number has two acceptable formats:
- **Format A**: `xxx-xxx-xxxx`
- **Format B**: `(xxx) xxx-xxxx`

Notice the common suffix: both end with `xxx-xxxx` (3 digits, hyphen, 4 digits).

### 🔍 Regex Anatomy:

```text
^([0-9]{3}-|\([0-9]{3}\) )[0-9]{3}-[0-9]{4}$
│├───────────────────────┤├───────┤─├───────┤│
│         Prefix           Middle      Suffix│
│                                            │
▲                                            ▲
Start of line                       End of line
```

1. **`^` and `$`**: Anchors ensuring the match covers the entire line (preventing partial matches like extra digits before or after).
2. **`([0-9]{3}-|\([0-9]{3}\) )`**: Alternation group matching either prefix:
   - `[0-9]{3}-`: 3 digits followed by a hyphen.
   - `\([0-9]{3}\) `: Parentheses surrounding 3 digits, followed by a **space**.
3. **`[0-9]{3}-[0-9]{4}`**: The required trailing pattern (3 digits, hyphen, 4 digits).

---

# 🧠 Evolution of Solutions: How We Make It Better

```text
┌────────────────────────────────────────────────────────────────────────┐
│  1. Basic GREP with Full Alternation                                    │
│     • grep -E '^(\([0-9]{3}\) [0-9]{3}-[0-9]{4}|[0-9]{3}-[0-9]{3}-[0-9]{4})$'│
│     • Bottleneck: Repetitive suffix pattern, longer regex string       │
└──────────────────────────────────┬─────────────────────────────────────┘
                                   │
                                   ▼ Factor Common Suffix
┌────────────────────────────────────────────────────────────────────────┐
│  2. Factored GREP (Recommended: Optimal One-Liner)                     │
│     • grep -E '^([0-9]{3}-|\([0-9]{3}\) )[0-9]{3}-[0-9]{4}$' file.txt   │
│     • Improvement: Factored prefix, concise, fast POSIX ERE engine     │
└──────────────────────────────────┬─────────────────────────────────────┘
                                   │
                                   ▼ Alternative CLI Tools
┌────────────────────────────────────────────────────────────────────────┐
│  3. AWK Pattern Filter                                                 │
│     • awk '/^([0-9]{3}-|\([0-9]{3}\) )[0-9]{3}-[0-9]{4}$/' file.txt     │
│     • Improvement: Stream-oriented line processing                     │
└──────────────────────────────────┬─────────────────────────────────────┘
                                   │
                                   ▼ In-Memory Programming Language
┌────────────────────────────────────────────────────────────────────────┐
│  4. In-Memory Dart Regex Filter                                        │
│     • lines.where((line) => _phoneRegex.hasMatch(line)).toList()       │
│     • Improvement: Type-safe, testable, cross-platform implementation  │
└────────────────────────────────────────────────────────────────────────┘
```

---

# 💻 Solutions

## 1. Solution 1: `grep -E` Factored (Recommended: Optimal One-Liner)

```bash
# Read from the file file.txt and output all valid phone numbers to stdout.
grep -E '^([0-9]{3}-|\([0-9]{3}\) )[0-9]{3}-[0-9]{4}$' file.txt
```

### 🟢 Why this is Recommended:
- `-E` enables **Extended Regular Expressions (ERE)**, standard across all Unix / Linux / macOS environments.
- Factoring out the prefix makes the regular expression clean and minimizes branching in the regex engine's NFA/DFA state machine.

---

## 2. Solution 2: `grep -P` (Perl-Compatible Regular Expressions)

Using PCRE, `[0-9]` can be abbreviated as `\d`:

```bash
grep -P '^(\d{3}-|\(\d{3}\) )\d{3}-\d{4}$' file.txt
```

### ⚠️ Note on Portability:
While shorter, `-P` relies on libpcre and is not supported by default on standard BSD/macOS `grep`. `grep -E` is more portable.

---

## 3. Solution 3: `awk`

In `awk`, any pattern enclosed in `/.../` prints matching lines by default:

```bash
awk '/^([0-9]{3}-|\([0-9]{3}\) )[0-9]{3}-[0-9]{4}$/' file.txt
```

---

## 4. Solution 4: `sed`

```bash
sed -n -E '/^([0-9]{3}-|\([0-9]{3}\) )[0-9]{3}-[0-9]{4}$/p' file.txt
```

- `-n`: Suppresses automatic printing of every line.
- `p`: Prints only lines matching the regular expression.

---

## 5. Solution 5: In-Memory Dart Implementation

```dart
class Solution {
  static final RegExp _phoneRegex = RegExp(
    r'^([0-9]{3}-|\([0-9]{3}\) )[0-9]{3}-[0-9]{4}$',
  );

  List<String> validPhoneNumbers(List<String> lines) {
    return lines.where((line) => _phoneRegex.hasMatch(line)).toList();
  }
}
```

---

# 📊 Comprehensive Comparison Matrix

| Tool / Approach | Command / Implementation | Regex Engine | Portability | Best Used For |
| :--- | :--- | :--- | :--- | :--- |
| **`grep -E` (Optimal)** | `grep -E '^([0-9]{3}-|\([0-9]{3}\) )[0-9]{3}-[0-9]{4}$'` | POSIX ERE | **Universal** (Linux, BSD, macOS) | **Bash 1-Liners / Interviews** |
| **`grep -P`** | `grep -P '^(\d{3}-|\(\d{3}\) )\d{3}-\d{4}$'` | PCRE | Linux / GNU only | Quick terminal scripting |
| **`awk`** | `awk '/.../' file.txt` | POSIX ERE | Universal | Stream processing pipelines |
| **`sed`** | `sed -n -E '/.../p' file.txt` | POSIX ERE | Universal | Stream editing & filtering |
| **Dart (`RegExp`)** | `lines.where(_phoneRegex.hasMatch)` | ECMA Regex | Cross-Platform | Application software logic |

---

# ⚠️ Key Interview Gotchas & Edge Cases

1. **Anchors `^` and `$` are Mandatory**:
   Without anchors, a line like `123-456-78901` (5 trailing digits) or `x987-123-4567` will erroneously match because it contains a valid 10-digit substring!
2. **Space After Area Code in `(xxx) xxx-xxxx`**:
   Notice the space in `(123) 456-7890`. An invalid line without a space (e.g. `(123)456-7890`) must NOT match.
3. **Escaping Parentheses**:
   In Extended Regular Expressions (`-E`), raw `(` and `)` are grouping operators. Literal parentheses must be escaped: `\(` and `\)`.
