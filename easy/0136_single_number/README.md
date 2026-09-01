# 🚀 LeetCode 136 - Single Number

## 📝 Problem

Given a non-empty array of integers where every element appears exactly twice except for one element, find that single element.

You must solve it in:

- **O(n)** time
- **O(1)** extra space

---

## Example 1

Input

```
[2,2,1]
```

Output

```
1
```

---

## Example 2

Input

```
[4,1,2,1,2]
```

Output

```
4
```

---

## Example 3

Input

```
[1]
```

Output

```
1
```

---

# 💡 Approach (Bit Manipulation - XOR)

The XOR operator (`^`) has two important properties:

```
a ^ a = 0
```

```
a ^ 0 = a
```

Since every duplicate appears exactly twice,

they cancel each other out.

Only the unique number remains.

---

## 🛠️ Algorithm

1. Initialize

```
result = 0
```

2. Traverse every number.

3. XOR the current number with `result`.

```
result ^= num
```

4. Return `result`.

---

## 🧪 Dry Run

Input

```
[4,1,2,1,2]
```

Start

```
result = 0
```

After XOR with 4

```
0 ^ 4 = 4
```

After XOR with 1

```
4 ^ 1 = 5
```

After XOR with 2

```
5 ^ 2 = 7
```

After XOR with 1

```
7 ^ 1 = 6
```

After XOR with 2

```
6 ^ 2 = 4
```

Answer

```
4
```

---

## Why Does It Work?

Imagine

```
4 ^ 1 ^ 2 ^ 1 ^ 2
```

Rearrange

```
4 ^ (1 ^ 1) ^ (2 ^ 2)
```

Duplicates become

```
4 ^ 0 ^ 0
```

Result

```
4
```

---

## 📊 Complexity Analysis

| Complexity | Value |
|------------|-------|
| Time | **O(n)** |
| Space | **O(1)** |

---

## ⚠️ Edge Cases

### Single Element

```
[7]
```

Output

```
7
```

---

### Negative Numbers

```
[-1,-1,-5]
```

Output

```
-5
```

---

### Zero

```
[0,1,1]
```

Output

```
0
```

---

## ❌ Brute Force

Use a HashMap.

Time

```
O(n)
```

Space

```
O(n)
```

Not acceptable because the problem requires constant extra space.

---

## ✅ Why XOR?

- Linear scan
- Constant memory
- No sorting
- No HashMap
- Interview favorite
- Most optimal solution

---

## 📚 Concepts Used

- Bit Manipulation
- XOR Operator
- Arrays

---

## 🔗 Related Problems

- 137. Single Number II
- 260. Single Number III
- 268. Missing Number