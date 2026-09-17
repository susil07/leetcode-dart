# 🚀 LeetCode 0006 - Zigzag Conversion

## 📝 Problem Statement

The string `"PAYPALISHIRING"` is written in a zigzag pattern on a given number of rows like this:

```text
P   A   H   N
A P L S I I G
Y   I   R
```

And then read line by line: `"PAHNAPLSIIGYIR"`

Write the code that will take a string and make this conversion given a number of rows:

```dart
String convert(String s, int numRows);
```

---

## 🔒 Constraints

- `1 <= s.length <= 1000`
- `s` consists of English letters (lower-case and upper-case), `','` and `'.'`.
- `1 <= numRows <= 1000`

---

## Examples

### Example 1:
**Input:**
```text
s = "PAYPALISHIRING", numRows = 3
```
**Output:**
```text
"PAHNAPLSIIGYIR"
```
**Visual Pattern:**
```text
Row 0:  P (0)        A (4)        H (8)         N (12)
Row 1:  A (1)  P (3) L (5)  S (7) I (9)  I (11) G (13)
Row 2:  Y (2)        I (6)        R (10)
```

---

### Example 2:
**Input:**
```text
s = "PAYPALISHIRING", numRows = 4
```
**Output:**
```text
"PINALSIGYAHRPI"
```
**Visual Pattern:**
```text
Row 0:  P (0)              I (6)              N (12)
Row 1:  A (1)        L (5) S (7)        I (11) G (13)
Row 2:  Y (2)  A (4)       H (8)  R (10)
Row 3:  P (3)              I (9)
```

---

### Example 3:
**Input:**
```text
s = "A", numRows = 1
```
**Output:**
```text
"A"
```

---

# 🧠 Evolution of Solutions: How We Make It Better

```text
┌────────────────────────────────────────────────────────────────────────┐
│  1. 2D Matrix Simulation (Brute Force)                                  │
│     • Allocate matrix of size numRows x N, trace zigzag positions      │
│     • Bottleneck: Massive O(numRows * N) space with mostly empty cells │
└──────────────────────────────────┬─────────────────────────────────────┘
                                   │
                                   ▼ Eliminate Empty Matrix Cells
┌────────────────────────────────────────────────────────────────────────┐
│  2. Row-by-Row Simulation (Direction Flag)                             │
│     • Maintain numRows StringBuffers, bounce direction up/down         │
│     • Improvement: O(N) Space, only stores actual characters           │
│     • Bottleneck: Multiple buffer allocations and state-machine branches│
└──────────────────────────────────┬─────────────────────────────────────┘
                                   │
                                   ▼ Eliminate Row Buffers via Math
┌────────────────────────────────────────────────────────────────────────┐
│  3. Direct Mathematical Index Jumps (Optimal Solution)                 │
│     • Calculate exact indices using cycle formula: 2 * numRows - 2     │
│     • Directly append characters to a single output buffer             │
│     • Improvement: O(N) Time, O(1) Auxiliary Space, zero row overhead  │
└────────────────────────────────────────────────────────────────────────┘
```

---

# 💡 Mathematical Cycle Derivation

Looking at the pattern indices, each full "V-shaped" zigzag cycle consists of:
- Moving down: `numRows - 1` steps
- Moving diagonally up: `numRows - 1` steps

$$\text{cycleLen} = 2 \times \text{numRows} - 2$$

For each row `r` ($0 \le r < \text{numRows}$):
1. **Top Row (`r = 0`)**: Contains characters at indices $j = k \times \text{cycleLen}$.
2. **Bottom Row (`r = numRows - 1`)**: Contains characters at indices $j = r + k \times \text{cycleLen}$.
3. **Interior Rows ($0 < r < \text{numRows} - 1$)**: Every cycle produces **two** characters:
   - The downward character: $j$
   - The diagonal upward character: $j + \text{cycleLen} - 2r$

---

# 💻 Solutions

## 1. Approach 1: 2D Matrix Simulation (Brute Force)

Create a 2D grid `matrix[numRows][s.length]`, plot characters by moving down and diagonally up, then read row-by-row.

```dart
class SolutionMatrix {
  String convert(String s, int numRows) {
    if (numRows == 1 || numRows >= s.length) return s;

    final matrix = List.generate(
      numRows,
      (_) => List<String?>.filled(s.length, null),
    );

    int row = 0, col = 0;
    bool goingDown = false;

    for (int i = 0; i < s.length; i++) {
      matrix[row][col] = s[i];

      if (row == 0 || row == numRows - 1) {
        goingDown = !goingDown;
      }

      if (goingDown) {
        row++;
      } else {
        row--;
        col++;
      }
    }

    final buffer = StringBuffer();
    for (int r = 0; r < numRows; r++) {
      for (int c = 0; c < s.length; c++) {
        if (matrix[r][c] != null) {
          buffer.write(matrix[r][c]);
        }
      }
    }

    return buffer.toString();
  }
}
```

### 🔴 Bottlenecks:
- **Memory Inefficiency**: Allocates $O(\text{numRows} \times N)$ space, where > 90% of cells are `null`.
- **Extra Traversal**: Must iterate through all empty matrix cells to collect characters.

---

## 2. Approach 2: Row-by-Row Simulation with Direction Flag (Intuitive)

### 💡 How We Make It Better:
Instead of allocating a full matrix with empty spaces, allocate only `numRows` list/buffer buckets. Iterate through `s` once, append to the active row, and toggle direction when hitting the top or bottom row.

```dart
class SolutionRowSimulation {
  String convert(String s, int numRows) {
    if (numRows == 1 || numRows >= s.length) return s;

    final rows = List.generate(numRows, (_) => StringBuffer());
    int currentRow = 0;
    bool goingDown = false;

    for (int i = 0; i < s.length; i++) {
      rows[currentRow].write(s[i]);

      // Reverse direction upon reaching the top or bottom row
      if (currentRow == 0 || currentRow == numRows - 1) {
        goingDown = !goingDown;
      }

      currentRow += goingDown ? 1 : -1;
    }

    final result = StringBuffer();
    for (final row in rows) {
      result.write(row.toString());
    }

    return result.toString();
  }
}
```

### 🟢 Improvements Over Approach 1:
- Eliminates empty cells; memory drops from $O(\text{numRows} \times N)$ to $O(N)$.
- Single pass through the string.

### 🔴 Remaining Bottleneck:
- Allocates `numRows` separate `StringBuffer` objects on the heap.
- Frequent conditional direction checks in every loop step.

---

## 3. Approach 3: Direct Mathematical Index Jumps (Optimal Solution)

### 💡 How We Make It Better:
We can jump directly from one character in row `r` to the next character in row `r` without maintaining any row lists or simulating movements!

```dart
class Solution {
  String convert(String s, int numRows) {
    // Edge case: when numRows is 1 or exceeds string length,
    // the zigzag pattern is identical to the original string.
    if (numRows == 1 || numRows >= s.length) {
      return s;
    }

    final buffer = StringBuffer();
    final cycleLen = 2 * numRows - 2;

    for (int r = 0; r < numRows; r++) {
      for (int j = r; j < s.length; j += cycleLen) {
        // 1. Downward character
        buffer.write(s[j]);

        // 2. Intermediate diagonal character (only for interior rows)
        final diagIndex = j + cycleLen - 2 * r;
        if (r > 0 && r < numRows - 1 && diagIndex < s.length) {
          buffer.write(s[diagIndex]);
        }
      }
    }

    return buffer.toString();
  }
}
```

### 🟢 Improvements Over Approach 2:
- **$O(1)$ Auxiliary Space**: Exactly 1 `StringBuffer` used for the output; zero intermediate row lists.
- **Zero Simulation Overhead**: Indices are calculated via direct arithmetic jumps.
- **Cache-Friendly**: Fast sequential streaming into the output buffer.

---

# 📊 Comprehensive Comparison Matrix

| Metric | 1. 2D Matrix Simulation | 2. Row-by-Row Simulation | 3. Direct Mathematical Jumps (Optimal) |
| :--- | :--- | :--- | :--- |
| **Time Complexity** | $O(\text{numRows} \times N)$ | $O(N)$ | **$O(N)$** |
| **Auxiliary Space** | $O(\text{numRows} \times N)$ (Sparse Grid) | $O(N)$ (`numRows` buffers) | **$O(1)$** (Zero extra buffers) |
| **Heap Allocations** | Large 2D List | `numRows` `StringBuffer` objects | **Only 1 final `StringBuffer`** |
| **Loop Overhead** | Matrix navigation & bounds checking | Condition checks at every step | **Direct stride jumps (`j += cycleLen`)** |
| **Interview Rating** | ⚠️ Naive / Wasteful | 👍 Good intuitive solution | 🏆 **Optimal Production Standard** |

---

# ⚠️ Key Interview Gotchas & Edge Cases

1. **`numRows == 1`**:
   If `numRows = 1`, `cycleLen = 2 * (1) - 2 = 0`. Without an early return, `j += cycleLen` leads to an **infinite loop** or **division by zero**! Always handle `numRows == 1` at the start:
   ```dart
   if (numRows == 1 || numRows >= s.length) return s;
   ```
2. **`numRows >= s.length`**:
   If `numRows` is greater than or equal to `s.length`, the pattern is a single vertical column, matching the original string unchanged.
3. **Boundary Check for Diagonal Character**:
   The diagonal character index `diagIndex = j + cycleLen - 2 * r` on the last cycle can exceed `s.length`. Always guard with `diagIndex < s.length`.
