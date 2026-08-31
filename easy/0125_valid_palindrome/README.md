# 🚀 LeetCode 125 - Valid Palindrome

## 📝 Problem

A phrase is a palindrome if, after:

- Converting all uppercase letters into lowercase.
- Removing all non-alphanumeric characters.

it reads the same forward and backward.

Return `true` if the string is a palindrome, otherwise return `false`.

---

## Example 1

Input

```
"A man, a plan, a canal: Panama"
```

Output

```
true
```

Explanation

After removing special characters and converting to lowercase:

```
amanaplanacanalpanama
```

It reads the same from both directions.

---

## Example 2

Input

```
"race a car"
```

Output

```
false
```

---

## Example 3

Input

```
" "
```

Output

```
true
```

Explanation

After removing non-alphanumeric characters, the string becomes empty, which is considered a palindrome.

---

# 💡 Approach (Two Pointers)

Use two pointers:

- `left` starts from the beginning.
- `right` starts from the end.

Skip every character that is **not a letter or digit**.

Compare the valid characters ignoring case.

If any pair differs, return `false`.

Otherwise continue until the pointers meet.

---

## 🛠️ Algorithm

1. Initialize

```
left = 0
right = s.length - 1
```

2. Skip non-alphanumeric characters.

3. Compare lowercase versions of both characters.

4. If different

```
return false
```

5. Move both pointers.

6. If loop finishes

```
return true
```

---

## 🧪 Dry Run

Input

```
"A man, a plan, a canal: Panama"
```

Pointers

```
A----------------------a
```

Compare

```
A == a
```

Move inward.

Skip

```
space
comma
colon
```

Continue

```
m == m
a == a
n == n
...
```

No mismatch found.

Answer

```
true
```

---

## Another Dry Run

Input

```
"race a car"
```

Compare

```
r == r
```

Move inward

```
a == a
```

Move inward

```
c != e
```

Mismatch found.

Answer

```
false
```

---

## 📊 Complexity Analysis

| Complexity | Value |
|------------|-------|
| Time | O(n) |
| Space | O(1) |

---

## ⚠️ Edge Cases

### Empty String

```
""
```

Output

```
true
```

---

### Only Symbols

```
".,,!!"
```

Output

```
true
```

---

### Single Character

```
"a"
```

Output

```
true
```

---

### Mixed Case

```
"RaceCar"
```

Output

```
true
```

---

### Numbers

```
"12321"
```

Output

```
true
```

---

## ✅ Why This Approach?

Brute force would:

- Build a cleaned string.
- Reverse it.
- Compare.

This requires extra memory.

Instead, the two-pointer technique:

- Skips unwanted characters in-place.
- Uses constant extra space.
- Scans the string only once.

---

## 🎯 Interview Follow-up

### Why not create a new cleaned string?

You can, but it requires **O(n)** extra space.

Using two pointers processes the original string directly, making it more memory efficient.

---

## 📚 Concepts Used

- Two Pointers
- String Traversal
- Character Validation

---

## 🔗 Related Problems

- 9. Palindrome Number
- 680. Valid Palindrome II
- 2108. Find First Palindromic String in the Array