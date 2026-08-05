# 0003. Longest Substring Without Repeating Characters

- **Difficulty:** Medium
- **Category:** String, Sliding Window, HashSet, Two Pointers
- **Language:** Dart

---

# Problem Statement

Given a string `s`, find the length of the **longest substring** without repeating characters.

A **substring** is a contiguous sequence of characters within a string.

Return the length of the longest substring containing only unique characters.

---

# Example

### Example 1

```text
Input:

s = "abcabcbb"

Output:

3
```

Explanation

```text
The longest substring is "abc"
```

Length

```text
3
```

---

### Example 2

```text
Input:

s = "bbbbb"

Output:

1
```

Explanation

```text
The longest substring is "b"
```

---

### Example 3

```text
Input:

s = "pwwkew"

Output:

3
```

Explanation

```text
The longest substring is "wke"
```

Note:

```text
"pwke"
```

is **not** a substring because the characters are not contiguous.

---

# Solution

```dart
class Solution {
  int lengthOfLongestSubstring(String s) {
    Set<String> window = {};

    int left = 0;
    int maxLength = 0;

    for (int right = 0; right < s.length; right++) {
      while (window.contains(s[right])) {
        window.remove(s[left]);
        left++;
      }

      window.add(s[right]);

      maxLength = maxLength > (right - left + 1)
          ? maxLength
          : (right - left + 1);
    }

    return maxLength;
  }
}
```

---

# Technique Used

- Sliding Window
- Two Pointers
- HashSet

---

# Understanding the Problem

The goal is to find the **longest continuous substring** without repeating characters.

Instead of checking every possible substring, we maintain a **window** of unique characters.

If a duplicate character is found, we shrink the window from the left until the duplicate is removed.

This allows us to solve the problem in a single traversal.

---

# Algorithm

1. Create an empty HashSet.
2. Initialize two pointers:
   - `left`
   - `right`
3. Move the `right` pointer through the string.
4. If the current character already exists in the HashSet:
   - Remove characters from the left.
   - Move the `left` pointer forward.
5. Add the current character to the HashSet.
6. Update the maximum window size.
7. Continue until the end of the string.

---

# Dry Run

Input

```text
abcabcbb
```

Initially

```text
left = 0

window = {}

maxLength = 0
```

---

### Step 1

```text
right = 0

Character = a
```

Window

```text
[a]
```

Length

```text
1
```

Maximum

```text
1
```

---

### Step 2

```text
right = 1

Character = b
```

Window

```text
[a b]
```

Length

```text
2
```

Maximum

```text
2
```

---

### Step 3

```text
right = 2

Character = c
```

Window

```text
[a b c]
```

Length

```text
3
```

Maximum

```text
3
```

---

### Step 4

```text
right = 3

Character = a
```

Duplicate found.

Remove

```text
a
```

Move left.

Window

```text
[b c]
```

Now add

```text
a
```

Window

```text
[b c a]
```

Length

```text
3
```

Continue the same process until the string ends.

Final Answer

```text
3
```

---

# Visualization

```text
String

a b c a b c b b
^
L
R

Window

[a]

-------------------

[a b]

-------------------

[a b c]

-------------------

Duplicate 'a'

Remove 'a'

Window

[b c]

Add 'a'

Window

[b c a]
```

The window always contains unique characters.

---

# Why do we use a HashSet?

A HashSet allows us to check whether a character already exists in **O(1)** time.

Without a HashSet, checking duplicates would take **O(n)** time.

---

# Why do we use Two Pointers?

- **Right Pointer**
  - Expands the window.

- **Left Pointer**
  - Shrinks the window whenever a duplicate appears.

Together, they ensure each character is processed efficiently.

---

# Why is it called Sliding Window?

The window expands when characters are unique.

```text
[a]

[a b]

[a b c]
```

When a duplicate appears,

the left side moves forward.

```text
[a b c a]

↓

[b c a]
```

The window keeps sliding through the string.

---

# Time Complexity

Each character is

- Added once.
- Removed once.

Therefore,

```text
Time Complexity = O(n)
```

---

# Space Complexity

The HashSet stores only the current window.

Worst case,

```text
abcdefg...
```

All characters are unique.

Therefore,

```text
Space Complexity = O(min(n, charset))
```

For interview purposes, it is commonly written as

```text
O(n)
```

---

# Advantages

- Efficient
- Single traversal
- Uses constant-time lookup
- Easy to understand

---

# Disadvantages

- Requires extra memory for the HashSet.

---

# Key Concepts Learned

- Sliding Window
- Two Pointers
- HashSet
- String Traversal
- Window Expansion
- Window Shrinking

---

# Interview Questions

### What is a substring?

A contiguous sequence of characters.

Example

```text
abc
```

is a substring of

```text
abcde
```

---

### What is a subsequence?

Characters that appear in order but are **not necessarily contiguous**.

Example

```text
ace
```

is a subsequence of

```text
abcde
```

---

### Why use a HashSet?

To detect duplicates in constant time.

---

### Why is Time Complexity O(n)?

Each character is visited at most twice.

- Once when added.
- Once when removed.

---

### Why not use nested loops?

Nested loops would check every substring.

Time Complexity becomes

```text
O(n²)
```

---

### Can we optimize further?

Yes.

Instead of removing one character at a time,

we can store the last index of each character using a **HashMap**.

This also runs in **O(n)** but may reduce unnecessary removals.

---

# Final Complexity

| Property | Value |
|----------|-------|
| Technique | Sliding Window |
| Data Structure | HashSet |
| Time Complexity | O(n) |
| Space Complexity | O(n) |
| Difficulty | Medium |

---

# Takeaway

This problem introduces one of the most frequently asked interview techniques:

- Sliding Window
- Two Pointers
- HashSet for constant-time lookup

Mastering this pattern helps solve many other interview problems such as:

- Minimum Window Substring
- Longest Repeating Character Replacement
- Permutation in String
- Find All Anagrams in a String
- Maximum Consecutive Ones