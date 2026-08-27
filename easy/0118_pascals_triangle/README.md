# 🚀 LeetCode 118 - Pascal's Triangle

## 📝 Problem

Given an integer `numRows`, return the first `numRows` of **Pascal's Triangle**.

Each number is the sum of the two numbers directly above it.

---

## Example

Input

```
numRows = 5
```

Output

```
[
 [1],
 [1,1],
 [1,2,1],
 [1,3,3,1],
 [1,4,6,4,1]
]
```

---

## 💡 Approach

We build the triangle row by row.

### Rules

- Every row starts with **1**
- Every row ends with **1**
- Middle elements are:

```
current[j] = previous[j-1] + previous[j]
```

---

## 🛠️ Algorithm

1. Create an empty answer list.
2. Loop from `0` to `numRows-1`.
3. Create a row filled with `1`s.
4. Compute the middle values using the previous row.
5. Add the row to the answer.
6. Return the triangle.

---

## 🧪 Dry Run

```
numRows = 5
```

Row 0

```
[1]
```

Row 1

```
[1,1]
```

Row 2

```
[1,2,1]
```

because

```
2 = 1 + 1
```

Row 3

```
[1,3,3,1]
```

because

```
3 = 1 + 2

3 = 2 + 1
```

Row 4

```
[1,4,6,4,1]
```

because

```
4 = 1 + 3

6 = 3 + 3

4 = 3 + 1
```

Final answer

```
[
 [1],
 [1,1],
 [1,2,1],
 [1,3,3,1],
 [1,4,6,4,1]
]
```

---

## 📊 Complexity Analysis

| Complexity | Value |
|------------|-------|
| Time | O(numRows²) |
| Space | O(numRows²) |

---

## ⚠️ Edge Cases

### One Row

```
Input

1
```

Output

```
[[1]]
```

---

### Two Rows

```
[
 [1],
 [1,1]
]
```

---

### Large Input

```
30 rows
```

Still works efficiently.

---

## ✅ Why This Approach?

- Every element is computed exactly once.
- No unnecessary calculations.
- Uses previously computed row.
- Clean and interview-friendly.

This is the standard optimal solution.

---

## 🎯 Interview Follow-up

### Can Space be Reduced?

If only the **last row** is needed (LeetCode 119), yes.

For generating the **entire triangle**, every row must be stored.

So

- Time cannot be better than **O(n²)**
- Space cannot be better than **O(n²)**

because the output itself contains **O(n²)** elements.

---

## 📚 Concepts Used

- Arrays
- Dynamic Programming
- Simulation
- Matrix Construction

---

## 🔗 Related Problems

- 119. Pascal's Triangle II
- 120. Triangle