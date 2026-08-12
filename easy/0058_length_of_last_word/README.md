# 58. Length of Last Word

**Difficulty:** Easy  
**LeetCode Link:** https://leetcode.com/problems/length-of-last-word/

---

## Problem Statement

Given a string `s` consisting of words and spaces, return the **length of the last word** in the string.

A word is defined as a sequence of non-space characters.

---

## Example

### Example 1

**Input**

```text
s = "Hello World"
```

**Output**

```text
5
```

Explanation:

The last word is `"World"`.

---

### Example 2

**Input**

```text
s = "   fly me   to   the moon  "
```

**Output**

```text
4
```

Explanation:

The last word is `"moon"`.

---

### Example 3

**Input**

```text
s = "luffy is still joyboy"
```

**Output**

```text
6
```

Explanation:

The last word is `"joyboy"`.

---

## Approach

Traverse the string from the end.

- Ignore any trailing spaces.
- Count characters until another space or the beginning of the string is reached.
- Return the count.

This avoids splitting the string and uses constant extra space.

---

## Algorithm

1. Start from the last character.
2. Skip trailing spaces.
3. Count characters until a space is found.
4. Return the count.

---

## Dry Run

Input

```text
s = "Hello World"
```

Traversal

```text
Hello World
          ↑
```

Skip spaces → None

Count

```text
d → l → r → o → W
```

Length

```text
5
```

---

Input

```text
s = "   fly me   to   the moon  "
```

Skip trailing spaces

```text
moon__
    ↑↑
```

Count

```text
m → o → o → n
```

Length

```text
4
```

---

## Complexity Analysis

### Time Complexity

```text
O(n)
```

The string is traversed at most once.

### Space Complexity

```text
O(1)
```

No extra memory is required.

---

## Technique Used

- Reverse Traversal
- String Traversal

---

## Key Takeaways

- Traversing from the end avoids unnecessary processing.
- No need to split the string into words.
- Efficient solution using constant extra space.
- Handles trailing spaces correctly.

---

## Dart Solution

```dart
class Solution {
  int lengthOfLastWord(String s) {
    int length = 0;
    int i = s.length - 1;

    while (i >= 0 && s[i] == ' ') {
      i--;
    }

    while (i >= 0 && s[i] != ' ') {
      length++;
      i--;
    }

    return length;
  }
}
```