# 🚀 LeetCode 13 - Roman to Integer

## 📝 Problem

Roman numerals are represented by seven symbols:

| Symbol | Value |
|--------|------:|
| I | 1 |
| V | 5 |
| X | 10 |
| L | 50 |
| C | 100 |
| D | 500 |
| M | 1000 |

Normally, Roman numerals are written from largest to smallest.

However, there are six subtraction cases:

- IV = 4
- IX = 9
- XL = 40
- XC = 90
- CD = 400
- CM = 900

Given a Roman numeral, convert it to an integer.

---

## 💡 Approach

Use a HashMap to store the value of every Roman character.

Traverse the string from left to right.

- If the current value is **smaller** than the next value, subtract it.
- Otherwise, add it.

This naturally handles all subtraction cases.

---

## 🛠️ Algorithm

1. Create a map of Roman symbols to integer values.
2. Initialize `result = 0`.
3. Traverse the string.
4. Compare current symbol with the next symbol.
5. If current < next:
   - subtract current
6. Else:
   - add current
7. Return the result.

---

## 🧪 Dry Run

Input

```
s = "MCMXCIV"
```

| Character | Action | Result |
|-----------|--------|-------:|
| M | +1000 | 1000 |
| C | -100 | 900 |
| M | +1000 | 1900 |
| X | -10 | 1890 |
| C | +100 | 1990 |
| I | -1 | 1989 |
| V | +5 | 1994 |

Output

```
1994
```

---

## 📊 Complexity Analysis

| Complexity | Value |
|------------|-------|
| Time | O(n) |
| Space | O(1) |

> The map contains only 7 Roman symbols, so its size is constant.

---

## ⚠️ Edge Cases

### Smallest Value

```
I
```

Output

```
1
```

---

### Largest Valid Roman Numeral

```
MMMCMXCIX
```

Output

```
3999
```

---

### Subtraction Cases

```
IV
IX
XL
XC
CD
CM
```

Handled automatically by the comparison logic.

---

## ✅ Why This Approach?

- Simple to understand.
- No need to hardcode subtraction pairs.
- Single traversal.
- Interview-friendly.
- Optimal solution accepted by LeetCode.

---

## 🎯 Interview Tip

Instead of checking:

```
IV
IX
XL
XC
CD
CM
```

one by one, simply compare the current value with the next value.

If

```
current < next
```

subtract it.

Otherwise,

```
add it.
```

This makes the code cleaner and scalable.

---

## 📚 Concepts Used

- HashMap
- String Traversal
- Greedy
- Simulation

---

## 🔗 Related Problems

- 9. Palindrome Number
- 67. Add Binary
- 171. Excel Sheet Column Number