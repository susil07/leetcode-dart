# 🚀 LeetCode 171 - Excel Sheet Column Number

## 📝 Problem

Given a string `columnTitle` that represents the column title as appears in an Excel sheet, return its corresponding column number.

For example:

```text
A  → 1
B  → 2
C  → 3
...
Z  → 26
AA → 27
AB → 28
...
ZY → 701
```

---

## Example 1

Input:

```text
columnTitle = "A"
```

Output:

```text
1
```

---

## Example 2

Input:

```text
columnTitle = "AB"
```

Output:

```text
28
```

---

## Example 3

Input:

```text
columnTitle = "ZY"
```

Output:

```text
701
```

---

## 🔒 Constraints

- `1 <= columnTitle.length <= 7`
- `columnTitle` consists only of uppercase English letters.
- `columnTitle` is in the range `["A", "FXSHRXW"]`.

---

# 💡 Approach

This problem is the **exact inverse of [LeetCode 168 (Excel Sheet Column Title)](../0168_excel_sheet_column_title/)**.

Instead of converting from a number to base 26, we convert a **base-26 positional string** into an integer.

### Analogy: Decimal (Base-10) vs Excel (Base-26)

In standard decimal (base-10):

```text
"352" = 3 * 10² + 5 * 10¹ + 2 * 10⁰
      = ((0 * 10 + 3) * 10 + 5) * 10 + 2
      = 352
```

In Excel column titles (base-26 with digits `1` to `26`):

```text
"AB" = ('A' * 26¹) + ('B' * 26⁰)
     = (1 * 26) + 2
     = 28
```

```text
"ZY" = ('Z' * 26¹) + ('Y' * 26⁰)
     = (26 * 26) + 25
     = 676 + 25
     = 701
```

For every character from left to right, we multiply the existing accumulated total by `26` and add the value of the current character.

---

# 🔢 Character Conversion

Each character maps to a value from `1` to `26`:

```text
'A' → 1
'B' → 2
'C' → 3
...
'Z' → 26
```

In Dart, ASCII code of `'A'` is `65`. We can get the numeric value of a character using:

```dart
int value = columnTitle.codeUnitAt(i) - 65 + 1;
```

---

## 🛠️ Algorithm

1. Initialize `result = 0`.
2. Traverse through `columnTitle` from left to right:
   - Compute character value: `value = columnTitle.codeUnitAt(i) - 65 + 1`.
   - Accumulate into result:
     ```dart
     result = result * 26 + value;
     ```
3. Return `result`.

---

# 🧪 Detailed Dry Run

### Example: `columnTitle = "AB"`

Start with `result = 0`.

#### Iteration 1 (`i = 0`, char = `'A'`):
```text
value = 'A' - 65 + 1 = 1
result = (0 * 26) + 1 = 1
```

#### Iteration 2 (`i = 1`, char = `'B'`):
```text
value = 'B' - 65 + 1 = 2
result = (1 * 26) + 2 = 28
```

**Final Return**: `28` ✅

---

### Example: `columnTitle = "ZY"`

Start with `result = 0`.

#### Iteration 1 (`i = 0`, char = `'Z'`):
```text
value = 'Z' - 65 + 1 = 26
result = (0 * 26) + 26 = 26
```

#### Iteration 2 (`i = 1`, char = `'Y'`):
```text
value = 'Y' - 65 + 1 = 25
result = (26 * 26) + 25 = 676 + 25 = 701
```

**Final Return**: `701` ✅

---

# 💻 Solutions

## Dart Solution

```dart
class Solution {
  int titleToNumber(String columnTitle) {
    int result = 0;

    for (int i = 0; i < columnTitle.length; i++) {
      int value = columnTitle.codeUnitAt(i) - 65 + 1;
      result = result * 26 + value;
    }

    return result;
  }
}
```

---

## C++ Solution

```cpp
#include <string>

using namespace std;

class Solution {
public:
    int titleToNumber(string columnTitle) {
        long long result = 0;

        for (char c : columnTitle) {
            int value = c - 'A' + 1;
            result = result * 26 + value;
        }

        return result;
    }
};
```

---

# 📊 Complexity Analysis

| Complexity | Value | Explanation |
| :--- | :---: | :--- |
| **Time Complexity** | **$O(n)$** | Where $n$ is the length of `columnTitle`. Since $n \le 7$, this runs in effectively **$O(1)$** constant time. |
| **Space Complexity** | **$O(1)$** | Only constant extra variables (`result`, `value`) are used. |

---

# ⚠️ Edge Cases

### 1. Single Character

```text
Input: "A"  → Output: 1
Input: "Z"  → Output: 26
```

---

### 2. Transition Points

```text
Input: "Z"  → Output: 26
Input: "AA" → Output: 27
Input: "AZ" → Output: 52
Input: "BA" → Output: 53
```

---

### 3. Maximum Possible Value

```text
Input: "FXSHRXW" → Output: 2147483647 (2³¹ - 1)
```

Dart's standard `int` handles 64-bit integers on 64-bit platforms, safely preventing overflow.

---

# 📚 Concepts Used

- **Math & Base Conversion**
- **Positional Number Systems (Horner's Method)**
- **ASCII Character Arithmetic**
- **String Traversal**

---

# 🔗 Related Problems

- **0168. Excel Sheet Column Title** (Inverse Problem)
- **0013. Roman to Integer**
- **0012. Integer to Roman**
