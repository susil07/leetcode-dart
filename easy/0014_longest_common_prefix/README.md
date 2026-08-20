# 🚀 LeetCode 14 - Longest Common Prefix

## 📝 Problem

Write a function to find the **longest common prefix** string amongst an array of strings.

If there is no common prefix, return an empty string `""`.

---

## Examples

### Example 1

```
Input: ["flower","flow","flight"]

Output: "fl"
```

---

### Example 2

```
Input: ["dog","racecar","car"]

Output: ""
```

Explanation:

There is no common prefix.

---

## 💡 Approach (Horizontal Scanning)

Assume the first string is the common prefix.

Compare this prefix with every other string.

If a string doesn't start with the current prefix:

- Remove the last character from the prefix.
- Continue checking until it matches.

Eventually, the remaining prefix will be the longest common prefix.

---

## 🛠️ Algorithm

1. Take the first string as the prefix.
2. Iterate through the remaining strings.
3. While the current string doesn't start with the prefix:
   - Remove the last character.
4. If the prefix becomes empty:
   - Return `""`.
5. Return the prefix.

---

## 🧪 Dry Run

Input

```
["flower","flow","flight"]
```

Initial

```
prefix = "flower"
```

Compare with

```
flow
```

```
flower ❌

Remove last letter

flowe ❌

flow ✅

prefix = "flow"
```

Compare with

```
flight
```

```
flow ❌

flo ❌

fl ✅
```

Final Answer

```
"fl"
```

---

## 📊 Complexity Analysis

Let

- N = number of strings
- M = length of the shortest string

| Complexity | Value |
|------------|-------|
| Time | O(N × M) |
| Space | O(1) |

---

## ⚠️ Edge Cases

### Only one string

```
["apple"]
```

Output

```
apple
```

---

### No common prefix

```
["dog","cat","fish"]
```

Output

```
""
```

---

### All strings identical

```
["abc","abc","abc"]
```

Output

```
abc
```

---

### Empty strings

```
["","abc"]
```

Output

```
""
```

---

## ✅ Why This Approach?

- Easy to understand.
- Very common interview solution.
- No extra data structures.
- Works efficiently for the given constraints.
- Accepted by LeetCode.

---

## 🎯 Interview Tip

There are several ways to solve this problem:

| Approach | Time | Space |
|----------|------|-------|
| Horizontal Scanning ✅ | O(N × M) | O(1) |
| Vertical Scanning | O(N × M) | O(1) |
| Divide & Conquer | O(N × M) | O(log N) |
| Binary Search | O(N log M) | O(1) |
| Trie | O(total characters) | O(total characters) |

For interviews, **Horizontal Scanning** is the most commonly expected solution because it is simple, readable, and efficient.

---

## 📚 Concepts Used

- String
- Prefix Matching
- Horizontal Scanning
- Greedy

---

## 🔗 Related Problems

- 28. Find the Index of the First Occurrence in a String
- 125. Valid Palindrome
- 58. Length of Last Word