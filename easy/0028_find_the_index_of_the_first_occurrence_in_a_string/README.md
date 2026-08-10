# 28. Find the Index of the First Occurrence in a String

**Difficulty:** Easy  
**LeetCode Link:** https://leetcode.com/problems/find-the-index-of-the-first-occurrence-in-a-string/

---

## Problem Statement

Given two strings `haystack` and `needle`, return the index of the **first occurrence** of `needle` in `haystack`.

Return `-1` if `needle` is not part of `haystack`.

---

## Example

### Example 1

**Input**

```text
haystack = "sadbutsad"
needle = "sad"
```

**Output**

```text
0
```

Explanation:

- "sad" appears at indices **0** and **6**
- Return the first occurrence → **0**

---

### Example 2

**Input**

```text
haystack = "leetcode"
needle = "leeto"
```

**Output**

```text
-1
```

Explanation:

- "leeto" is not present in "leetcode"

---

## Approach

Use a **Brute Force String Matching** approach.

- Traverse every possible starting position in `haystack`.
- Compare characters one by one with `needle`.
- If every character matches, return the starting index.
- If no match is found, return `-1`.

---

## Algorithm

1. Iterate from index `0` to `haystack.length - needle.length`.
2. Compare each character of `needle`.
3. If all characters match, return the current index.
4. If no match exists, return `-1`.

---

## Dry Run

Input

```text
haystack = "sadbutsad"
needle = "sad"
```

| Start Index | Comparison | Result |
|-------------|------------|--------|
|0|"sad" == "sad"|Match ✅|

Return

```text
0
```

---

Input

```text
haystack = "leetcode"
needle = "leeto"
```

Comparisons

```text
leetc ❌
eetco ❌
etcod ❌
tcode ❌
```

No match found.

Return

```text
-1
```

---

## Complexity Analysis

### Time Complexity

```text
O((n - m + 1) × m)
```

Worst case:

```text
O(n × m)
```

where

- `n` = length of `haystack`
- `m` = length of `needle`

---

### Space Complexity

```text
O(1)
```

No extra memory is used.

---

## Technique Used

- Brute Force
- String Traversal
- Fixed Size Sliding Window

---

## Key Takeaways

- Compare every possible substring of length `needle.length`.
- Return immediately when a complete match is found.
- No extra data structures are required.
- This is the simplest and most common interview solution.

---

## Dart Solution

```dart
class Solution {
  int strStr(String haystack, String needle) {
    if (needle.isEmpty) return 0;

    for (int i = 0; i <= haystack.length - needle.length; i++) {
      int j = 0;

      while (j < needle.length && haystack[i + j] == needle[j]) {
        j++;
      }

      if (j == needle.length) {
        return i;
      }
    }

    return -1;
  }
}
```