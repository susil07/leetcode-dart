# 🚀 LeetCode 168 - Excel Sheet Column Title

## 📝 Problem

Given an integer `columnNumber`, return its corresponding column title as it appears in an Excel sheet.

Excel uses the following column numbering:

```text
A  → 1
B  → 2
C  → 3
...
Z  → 26
AA → 27
AB → 28
...
```

---

## Example 1

Input

```text
columnNumber = 1
```

Output

```text
"A"
```

---

## Example 2

Input

```text
columnNumber = 28
```

Output

```text
"AB"
```

---

## Example 3

Input

```text
columnNumber = 701
```

Output

```text
"ZY"
```

---

# 💡 Approach

This problem looks similar to converting a number to base 26.

However, Excel columns are **1-indexed**:

```text
1 → A
2 → B
...
26 → Z
```

There is no column `0`.

Therefore, before calculating the remainder, we decrement the number:

```dart
columnNumber--;
```

This converts the numbering into a zero-based system:

```text
A → 0
B → 1
...
Z → 25
```

---

## 🛠️ Algorithm

1. Create an empty `result` string.
2. While `columnNumber > 0`:
   - Decrement `columnNumber`.
   - Calculate:
     ```text
     remainder = columnNumber % 26
     ```
   - Convert the remainder into a letter from `A` to `Z`.
   - Add the letter to the beginning of `result`.
   - Divide `columnNumber` by `26`.
3. Return `result`.

---

# 🧪 Dry Run

Consider:

```text
columnNumber = 28
```

### Step 1

```text
28 - 1 = 27
27 % 26 = 1
```

`1` represents:

```text
B
```

Then:

```text
27 ~/ 26 = 1
```

---

### Step 2

```text
1 - 1 = 0
0 % 26 = 0
```

`0` represents:

```text
A
```

Then:

```text
0 ~/ 26 = 0
```

We processed:

```text
B
A
```

Since characters are calculated from right to left, the answer is:

```text
AB
```

Therefore:

```text
28 → "AB"
```

---

# 🔢 Character Conversion

Dart's `String.fromCharCode()` can convert ASCII values into characters.

```dart
String.fromCharCode(65)
```

produces:

```text
A
```

The alphabet is:

```text
A → 65
B → 66
C → 67
...
Z → 90
```

Therefore:

```dart
String.fromCharCode(65 + remainder)
```

converts:

```text
0  → A
1  → B
2  → C
...
25 → Z
```

---

# 💻 Dart Solution

```dart
class Solution {
  String convertToTitle(int columnNumber) {
    String result = '';

    while (columnNumber > 0) {
      columnNumber--;

      int remainder = columnNumber % 26;

      result = String.fromCharCode(65 + remainder) + result;

      columnNumber ~/= 26;
    }

    return result;
  }
}
```

---

# 📊 Complexity Analysis

| Complexity | Value |
|------------|-------|
| Time | O(log₍26₎ n) |
| Space | O(log₍26₎ n) |

Where:

- `n` = `columnNumber`
- The number of iterations is the number of characters in the Excel column title.

---

# ⚠️ Edge Cases

## Column 1

```text
Input:
1
```

Output:

```text
A
```

---

## Column 26

```text
Input:
26
```

Output:

```text
Z
```

---

## Column 27

```text
Input:
27
```

Output:

```text
AA
```

---

## Column 52

```text
Input:
52
```

Output:

```text
AZ
```

---

## Column 53

```text
Input:
53
```

Output:

```text
BA
```

---

## Column 701

```text
Input:
701
```

Output:

```text
ZY
```

---

# 🔄 Important Pattern

The main pattern to remember is:

```text
while (number > 0) {
    number--;

    remainder = number % 26;

    convert remainder to A-Z;

    number ~/= 26;
}
```

The `number--` is essential because Excel uses **1-based numbering**.

---

# 📚 Concepts Used

- Math
- Modular Arithmetic
- Number System Conversion
- ASCII Character Conversion
- Iteration

---

# 🔗 Related Problems

- 171. Excel Sheet Column Number
- 168. Excel Sheet Column Title
- 13. Roman to Integer
- 12. Integer to Roman