# 🚀 LeetCode 119 - Pascal's Triangle II

## 📝 Problem

Given an integer `rowIndex`, return the **rowIndexᵗʰ (0-indexed)** row of Pascal's Triangle.

Each number is the sum of the two numbers directly above it.

---

## Example 1

Input

```
rowIndex = 3
```

Output

```
[1,3,3,1]
```

---

## Example 2

Input

```
rowIndex = 0
```

Output

```
[1]
```

---

## Example 3

Input

```
rowIndex = 1
```

Output

```
[1,1]
```

---

# 💡 Approach

Instead of generating the **entire Pascal Triangle**, we only generate the required row.

We use **one array** and update it **from right to left**.

Why right to left?

Because every element depends on the previous row.

Updating from left to right would overwrite values that are still needed.

---

## 🛠️ Algorithm

1. Create an array of size `rowIndex + 1` initialized with `0`.
2. Set the first element to `1`.
3. For every row:
   - Traverse from right to left.
   - Update

```
row[j] = row[j] + row[j - 1]
```

4. Return the array.

---

## 🧪 Dry Run

Input

```
rowIndex = 4
```

Initially

```
[1,0,0,0,0]
```

Row 1

```
[1,1,0,0,0]
```

Row 2

```
[1,2,1,0,0]
```

Row 3

```
[1,3,3,1,0]
```

Row 4

```
[1,4,6,4,1]
```

Answer

```
[1,4,6,4,1]
```

---

## Why Update Right → Left?

Suppose

```
Current

[1,3,3,1]
```

If we update left to right,

```
row[1]

becomes

4
```

Then

```
row[2]

uses the updated value

4

instead of

3
```

Result becomes incorrect.

Updating from **right to left** preserves the previous row values.

---

## 📊 Complexity Analysis

| Complexity | Value |
|------------|-------|
| Time | O(rowIndex²) |
| Space | O(rowIndex) |

---

## ⚠️ Edge Cases

### First Row

```
0
```

Output

```
[1]
```

---

### Second Row

```
1
```

Output

```
[1,1]
```

---

### Large Row

```
33
```

Still works efficiently using only one array.

---

## ✅ Why This Approach?

This is the solution expected in the follow-up.

Advantages

- Generates only one row.
- Uses one array.
- No recursion.
- No extra triangle.

This is the standard optimal interview solution.

---

## 🎯 Follow-up

LeetCode asks

> Can you optimize the space complexity to O(rowIndex)?

Answer

✅ Yes.

This solution uses exactly

```
O(rowIndex)
```

extra space.

---

## 📚 Concepts Used

- Arrays
- Dynamic Programming
- In-place Update

---

## 🔗 Related Problems

- 118. Pascal's Triangle
- 120. Triangle