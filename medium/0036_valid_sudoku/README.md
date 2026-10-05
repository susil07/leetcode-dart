# 🚀 LeetCode 0036 - Valid Sudoku

## 📝 Problem Statement

Determine if a $9 \times 9$ Sudoku board is valid. Only the filled cells need to be validated according to the following rules:

1. Each **row** must contain the digits `1-9` without repetition.
2. Each **column** must contain the digits `1-9` without repetition.
3. Each of the nine **$3 \times 3$ sub-boxes** of the grid must contain the digits `1-9` without repetition.

**Note:**
- A Sudoku board (partially filled) could be valid but is not necessarily solvable.
- Only the filled cells need to be validated according to the mentioned rules.

---

## 🔒 Constraints

- `board.length == 9`
- `board[i].length == 9`
- `board[i][j]` is a digit `'1'-'9'` or `'.'`.

---

## 💡 Examples

### Example 1
```text
Input: board = 
[["5","3",".",".","7",".",".",".","."]
,["6",".",".","1","9","5",".",".","."]
,[".","9","8",".",".",".",".","6","."]
,["8",".",".",".","6",".",".",".","3"]
,["4",".",".","8",".","3",".",".","1"]
,["7",".",".",".","2",".",".",".","6"]
,[".","6",".",".",".",".","2","8","."]
,[".",".",".","4","1","9",".",".","5"]
,[".",".",".",".","8",".",".","7","9"]]
Output: true
```

### Example 2
```text
Input: board = 
[["8","3",".",".","7",".",".",".","."]
,["6",".",".","1","9","5",".",".","."]
,[".","9","8",".",".",".",".","6","."]
,["8",".",".",".","6",".",".",".","3"]
,["4",".",".","8",".","3",".",".","1"]
,["7",".",".",".","2",".",".",".","6"]
,[".","6",".",".",".",".","2","8","."]
,[".",".",".","4","1","9",".",".","5"]
,[".",".",".",".","8",".",".","7","9"]]
Output: false
Explanation: Same as Example 1, except the top-left cell is modified to '8'. 
Since there are two 8's in the top-left 3x3 sub-box, it is invalid.
```

---

# 🧠 Evolution of Solutions: How We Make It Better

```text
┌────────────────────────────────────────────────────────────────────────┐
│  1. Three Passes with 27 HashSets                                      │
│     • Pass 1: 9 HashSets for 9 rows                                    │
│     • Pass 2: 9 HashSets for 9 columns                                 │
│     • Pass 3: 9 HashSets for 9 sub-boxes                               │
│     • Time: O(81 * 3) = O(1) | Space: O(27 * 9) Set entries            │
│     • Bottleneck: Traverses board 3 times; allocates 27 HashSets       │
└──────────────────────────────────┬─────────────────────────────────────┘
                                   │
                                   ▼ Single Pass with Encoded Strings
┌────────────────────────────────────────────────────────────────────────┐
│  2. Single Pass with String Hash Set                                   │
│     • Insert encoded strings: "r:1:v", "c:2:v", "b:0:v"                │
│     • Time: O(81) = O(1) | Space: O(81 * 3) strings in a single Set    │
│     • Bottleneck: Frequent string formatting and hash collision checks │
└──────────────────────────────────┬─────────────────────────────────────┘
                                   │
                                   ▼ 2D Boolean Lookup Matrix
┌────────────────────────────────────────────────────────────────────────┐
│  3. Single Pass with 2D Boolean Arrays                                 │
│     • rows[9][9], cols[9][9], boxes[9][9]                              │
│     • Check if flag is true; if so return false, else set true         │
│     • Time: O(81) = O(1) | Space: O(81 * 3) boolean primitives         │
│     • Bottleneck: 243 boolean values; multiple array pointer hops      │
└──────────────────────────────────┬─────────────────────────────────────┘
                                   │
                                   ▼ Bit Manipulation (Bitmasking)
┌────────────────────────────────────────────────────────────────────────┐
│  4. Single Pass with Integer Bitmasks (Optimal)                        │
│     • Use 3 flat arrays of 9 integers: rows[9], cols[9], boxes[9]      │
│     • Map digit '1'-'9' to bitmask: mask = 1 << (digit - 1)            │
│     • Collision test: (rows[r] & mask) != 0 in a single CPU cycle      │
│     • Update: rows[r] |= mask                                          │
│     • Time: O(1) [exactly 81 steps] | Space: O(1) [27 integers only]   │
│     • Improvement: Zero heap allocations, zero string hashing          │
└────────────────────────────────────────────────────────────────────────┘
```

---

# 💡 Core Concept: Sub-Box Mapping & Bitmasking

### 1. The $3 \times 3$ Sub-Box Formula
The board is divided into nine $3 \times 3$ sub-boxes indexed from $0$ to $8$:
```text
Box Index Grid:
   Cols:  0 1 2   3 4 5   6 7 8
Rows 0-2: [ 0 ]   [ 1 ]   [ 2 ]
Rows 3-5: [ 3 ]   [ 4 ]   [ 5 ]
Rows 6-8: [ 6 ]   [ 7 ]   [ 8 ]
```

Formula for any cell at `(row, col)`:
$$\text{boxIndex} = \left(\lfloor \text{row} / 3 \rfloor \times 3\right) + \lfloor \text{col} / 3 \rfloor$$

In Dart integer arithmetic:
```dart
final boxIdx = (r ~/ 3) * 3 + (c ~/ 3);
```

### 2. Bitmask Representation
Since there are only 9 possible digits (`1` through `9`), we can represent the seen digits as bits in a single 32-bit integer:
- Digit `1` $\to$ Bit $0$ (`1 << 0 = 1`)
- Digit `2` $\to$ Bit $1$ (`1 << 1 = 2`)
- ...
- Digit `9` $\to$ Bit $8$ (`1 << 8 = 256`)

Checking if digit was previously seen:
```dart
if ((rows[r] & mask) != 0) return false; // Duplicate found!
rows[r] |= mask;                          // Mark as seen
```

---

# 💻 Solutions

## 1. Approach 1: Three Passes with HashSets ($O(1)$ Time, $O(1)$ Space)

Check rows, then columns, then boxes with 27 `Set<String>`:

```dart
class SolutionThreePass {
  bool isValidSudoku(List<List<String>> board) {
    // 1. Check Rows
    for (int r = 0; r < 9; r++) {
      final Set<String> seen = {};
      for (int c = 0; c < 9; c++) {
        if (board[r][c] != '.' && !seen.add(board[r][c])) return false;
      }
    }

    // 2. Check Columns
    for (int c = 0; c < 9; c++) {
      final Set<String> seen = {};
      for (int r = 0; r < 9; r++) {
        if (board[r][c] != '.' && !seen.add(board[r][c])) return false;
      }
    }

    // 3. Check 3x3 Sub-boxes
    for (int b = 0; b < 9; b++) {
      final Set<String> seen = {};
      final rOffset = (b ~/ 3) * 3;
      final cOffset = (b % 3) * 3;
      for (int r = 0; r < 3; r++) {
        for (int c = 0; c < 3; c++) {
          final cell = board[rOffset + r][cOffset + c];
          if (cell != '.' && !seen.add(cell)) return false;
        }
      }
    }

    return true;
  }
}
```

### 🔴 Bottlenecks:
- Scans all 81 cells three distinct times ($81 \times 3 = 243$ iterations).
- Allocates 27 temporary `Set` objects on the heap.

---

## 2. Approach 2: Single Pass with String Hash Set ($O(1)$ Time, $O(1)$ Space)

Encode each seen digit into a unique string identifier:

```dart
class SolutionStringSet {
  bool isValidSudoku(List<List<String>> board) {
    final Set<String> seen = {};

    for (int r = 0; r < 9; r++) {
      for (int c = 0; c < 9; c++) {
        final val = board[r][c];
        if (val == '.') continue;

        final b = (r ~/ 3) * 3 + (c ~/ 3);
        if (!seen.add('r:$r:$val') ||
            !seen.add('c:$c:$val') ||
            !seen.add('b:$b:$val')) {
          return false;
        }
      }
    }

    return true;
  }
}
```

### 🔴 Bottlenecks:
- Creates hundreds of string objects and runs hash calculations for each string key.

---

## 3. Approach 3: Single Pass with Bitmasking (Optimal)

Use 3 arrays of 9 integers, testing and setting bits in $O(1)$ single-cycle bitwise operations:

```dart
class Solution {
  bool isValidSudoku(List<List<String>> board) {
    // Bitmasks for each of the 9 rows, 9 columns, and 9 sub-boxes.
    // The d-th bit represents whether digit (d + 1) has been encountered.
    final List<int> rows = List<int>.filled(9, 0);
    final List<int> cols = List<int>.filled(9, 0);
    final List<int> boxes = List<int>.filled(9, 0);

    for (int r = 0; r < 9; r++) {
      for (int c = 0; c < 9; c++) {
        final cell = board[r][c];
        if (cell == '.') continue;

        // Convert char '1'-'9' to a bitmask (1 << 0 to 1 << 8)
        final mask = 1 << (cell.codeUnitAt(0) - 49);
        final boxIdx = (r ~/ 3) * 3 + (c ~/ 3);

        // If the bit is already set in the row, column, or 3x3 sub-box, it's invalid
        if ((rows[r] & mask) != 0 ||
            (cols[c] & mask) != 0 ||
            (boxes[boxIdx] & mask) != 0) {
          return false;
        }

        // Mark the bit in the corresponding row, column, and sub-box
        rows[r] |= mask;
        cols[c] |= mask;
        boxes[boxIdx] |= mask;
      }
    }

    return true;
  }
}
```

---

# 📊 Comprehensive Comparison Matrix

| Metric | 1. 27 HashSets | 2. String Encoded Set | 3. Bitmask Arrays (Optimal) |
| :--- | :--- | :--- | :--- |
| **Time Complexity** | $O(1)$ ($243$ iterations) | $O(1)$ ($81$ iterations) | **$O(1)$ (Strictly 81 iterations)** |
| **Auxiliary Space** | $27$ HashSet objects | $1$ Set with $\le 243$ strings | **$3$ flat arrays of size 9 ($27$ ints)** |
| **Heap Allocations** | Heavy | Heavy (Hundreds of strings) | **Zero (Flat primitive arrays)** |
| **Collision Check** | `set.contains()` | `set.add()` | **`&` (Single CPU cycle)** |
| **Cache Locality** | Poor | Poor | **Exceptional** |
| **Interview Rating** | Acceptable | Clever but slow | 🏆 **Gold Standard Expected** |

---

# ⚠️ Key Interview Gotchas & Edge Cases

1. **"Valid" vs "Solvable":**
   - A board can be valid according to the rules (no duplicates in rows, columns, or sub-boxes) even if it cannot actually be completed into a full Sudoku solution.
   - Do not attempt a recursive Sudoku solver (LeetCode 37) here; this problem strictly validates current placements.
2. **ASCII to Mask Shift:**
   - Digit `'1'` has ASCII 49.
   - Doing `cell.codeUnitAt(0) - 49` maps `'1' \to 0, '2' \to 1, \dots, '9' \to 8`.
   - `1 << (cell.codeUnitAt(0) - 49)` shifts into bits $0$ to $8$ (fits comfortably within standard integers).
3. **Empty Cells (`'.'`)**:
   - Make sure to skip `.` immediately with `if (cell == '.') continue;` before calculating masks.
