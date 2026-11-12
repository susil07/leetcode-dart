# 🚀 LeetCode 0073 - Set Matrix Zeroes

## 📝 Problem Statement

Given an `m x n` integer matrix `matrix`, if an element is `0`, set its entire row and column to `0`'s.

You must do it **in place**.

---

## 🔒 Constraints

- `m == matrix.length`
- `n == matrix[0].length`
- `1 <= m, n <= 200`
- $-2^{31} \le \text{matrix}[i][j] \le 2^{31} - 1$

### Follow-up Questions:
- A straightforward solution using $\mathcal{O}(m \cdot n)$ space is probably a bad idea.
- A simple improvement uses $\mathcal{O}(m + n)$ space, but still not the best solution.
- Could you devise a constant space solution ($\mathcal{O}(1)$ auxiliary space)?

---

## 💡 Examples

### Example 1
```text
Input: matrix = [
  [1, 1, 1],
  [1, 0, 1],
  [1, 1, 1]
]
Output: [
  [1, 0, 1],
  [0, 0, 0],
  [1, 0, 1]
]
```

```text
 ┌───┬───┬───┐       ┌───┬───┬───┐
 │ 1 │ 1 │ 1 │       │ 1 │ 0 │ 1 │
 ├───┼───┼───┤  ══►  ├───┼───┼───┤
 │ 1 │ 0 │ 1 │       │ 0 │ 0 │ 0 │
 ├───┼───┼───┤       ├───┼───┼───┤
 │ 1 │ 1 │ 1 │       │ 1 │ 0 │ 1 │
 └───┴───┴───┘       └───┴───┴───┘
```

### Example 2
```text
Input: matrix = [
  [0, 1, 2, 0],
  [3, 4, 5, 2],
  [1, 3, 1, 5]
]
Output: [
  [0, 0, 0, 0],
  [0, 4, 5, 0],
  [0, 3, 1, 0]
]
```

---

# 📐 Core Engineering Insight: Overcoming the Zero Cascading Problem

If we iterate through the matrix and immediately zero out row $i$ and column $j$ upon seeing a zero, the newly placed zeros will cascade across subsequent iterations, wiping out the entire matrix into all zeros!

### In-Place Flag Re-use
To achieve **$\mathcal{O}(1)$ auxiliary space**, we re-use the **first row** and **first column** of the matrix itself as our boolean marker arrays:
- `matrix[0][j] == 0`: Column $j$ should be completely zeroed out.
- `matrix[i][0] == 0`: Row $i$ should be completely zeroed out.

### Resolving the $(0, 0)$ Collision
Notice that cell `matrix[0][0]` sits at the intersection of both the first row and the first column. To prevent collision:
- `matrix[0][0]` is dedicated to tracking **Row 0**.
- A single boolean variable `firstColHasZero` tracks **Column 0**.

```text
                  col 1   col 2   col 3
                    │       │       │
matrix[0][0] ─────► [ 0 ]   [ 1 ]   [ 0 ]   <-- First Row acts as Column Markers
(Row 0 Flag)        │
                    │
  row 1 ──────────► [ 1 ]   [ X ]   [ X ]
                    │
  row 2 ──────────► [ 0 ]   [ X ]   [ X ]
                    ▲
                    │
          First Column acts as Row Markers
          (firstColHasZero tracks Col 0)
```

---

# 🧠 Evolution of Solutions: How We Make It Better

```text
┌────────────────────────────────────────────────────────────────────────┐
│  1. Matrix Clone / Copy (Naive)                                        │
│     • Duplicate the entire matrix, read from clone and write to original
│     • Time: O(M * N) | Space: O(M * N) auxiliary memory                │
│     • Fatal Flaw: Allocates an entire redundant matrix on the heap     │
└──────────────────────────────────┬─────────────────────────────────────┘
                                   │
                                   ▼ Compress to 1D Row & Column Markers
┌────────────────────────────────────────────────────────────────────────┐
│  2. Row and Column Marker Arrays                                       │
│     • rowZero[M] and colZero[N] boolean flags                          │
│     • Time: O(M * N) | Space: O(M + N) auxiliary memory                │
│     • Bottleneck: Still requires O(M + N) extra memory allocation      │
└──────────────────────────────────┬─────────────────────────────────────┘
                                   │
                                   ▼ Eliminate Extra Arrays via Grid Encoding
┌────────────────────────────────────────────────────────────────────────┐
│  3. First Row & Column as Marker Flags (Optimal & Gold Standard)       │
│     • Use matrix[i][0] and matrix[0][j] directly                       │
│     • Disambiguate (0, 0) with a single boolean flag firstColHasZero   │
│     • Zero inner subgrid first, then zero first row and first column   │
│     • Time: O(M * N) | Space: O(1) auxiliary space                     │
│     • Value: Zero heap allocations, strictly in-place, production ready│
└────────────────────────────────────────────────────────────────────────┘
```

---

# 💻 Solutions

## 1. Approach 1: Matrix Clone / Copy ($\mathcal{O}(M \cdot N)$ Time, $\mathcal{O}(M \cdot N)$ Space)

```dart
class SolutionClone {
  void setZeroes(List<List<int>> matrix) {
    final int m = matrix.length;
    final int n = matrix[0].length;

    // Create a deep copy of the original matrix
    final List<List<int>> copy = List.generate(
      m,
      (i) => List<int>.from(matrix[i]),
    );

    for (int i = 0; i < m; i++) {
      for (int j = 0; j < n; j++) {
        if (copy[i][j] == 0) {
          // Zero row i in original matrix
          for (int c = 0; c < n; c++) matrix[i][c] = 0;
          // Zero col j in original matrix
          for (int r = 0; r < m; r++) matrix[r][j] = 0;
        }
      }
    }
  }
}
```

### 🔴 Bottlenecks:
- Violates the in-place spirit of the problem by creating an exact duplicate of the matrix on the heap.

---

## 2. Approach 2: Row & Column Marker Arrays ($\mathcal{O}(M \cdot N)$ Time, $\mathcal{O}(M + N)$ Space)

```dart
class SolutionMarkerArrays {
  void setZeroes(List<List<int>> matrix) {
    final int m = matrix.length;
    final int n = matrix[0].length;

    final List<bool> rowZero = List<bool>.filled(m, false);
    final List<bool> colZero = List<bool>.filled(n, false);

    // Pass 1: Identify which rows and columns must be zeroed
    for (int i = 0; i < m; i++) {
      for (int j = 0; j < n; j++) {
        if (matrix[i][j] == 0) {
          rowZero[i] = true;
          colZero[j] = true;
        }
      }
    }

    // Pass 2: Update the matrix in-place
    for (int i = 0; i < m; i++) {
      for (int j = 0; j < n; j++) {
        if (rowZero[i] || colZero[j]) {
          matrix[i][j] = 0;
        }
      }
    }
  }
}
```

### 🟢 Improvements & 🔴 Bottlenecks:
- Improves space from $\mathcal{O}(M \cdot N)$ to $\mathcal{O}(M + N)$.
- Still allocates two auxiliary arrays on the heap ($M + N$ booleans).

---

## 3. Approach 3: In-Place State Encoding (Optimal & Gold Standard)

Re-uses the first row and column to store marker flags, using a single boolean variable `firstColHasZero` to resolve the $(0, 0)$ corner ambiguity:

```dart
// LeetCode 0073: Set Matrix Zeroes
// Optimal Solution: In-Place State Encoding using First Row & First Column as Flags
// Time Complexity: O(M * N) where M is rows and N is columns
// Space Complexity: O(1) auxiliary space (modifies matrix strictly in-place)

class Solution {
  void setZeroes(List<List<int>> matrix) {
    final int m = matrix.length;
    final int n = matrix[0].length;

    // Track whether the first column initially contains any zero
    // matrix[0][0] will serve as the flag for the first row
    bool firstColHasZero = false;

    // Pass 1: Scan the matrix and use the first row and first column as marker flags
    for (int i = 0; i < m; i++) {
      if (matrix[i][0] == 0) {
        firstColHasZero = true;
      }
      for (int j = 1; j < n; j++) {
        if (matrix[i][j] == 0) {
          matrix[i][0] = 0; // Mark row i
          matrix[0][j] = 0; // Mark column j
        }
      }
    }

    // Pass 2: Iterate through inner subgrid [1..m-1][1..n-1] and set zeroes
    for (int i = 1; i < m; i++) {
      for (int j = 1; j < n; j++) {
        if (matrix[i][0] == 0 || matrix[0][j] == 0) {
          matrix[i][j] = 0;
        }
      }
    }

    // Pass 3: Zero out the first row if flagged by matrix[0][0]
    if (matrix[0][0] == 0) {
      for (int j = 0; j < n; j++) {
        matrix[0][j] = 0;
      }
    }

    // Pass 4: Zero out the first column if flagged by firstColHasZero
    if (firstColHasZero) {
      for (int i = 0; i < m; i++) {
        matrix[i][0] = 0;
      }
    }
  }
}
```

### 🟢 Why This is Optimal:
- **Optimal Time $\mathcal{O}(M \cdot N)$**: Exactly two passes over the elements.
- **Strictly $\mathcal{O}(1)$ Space**: Only one single primitive boolean variable allocated. Zero heap memory used.
- **Robust Against Full Integer Range**: Unlike sentinel value approaches (e.g. marking with `MOD` or `INF`), this works across the full range $-2^{31} \le \text{matrix}[i][j] \le 2^{31} - 1$.

---

# 📊 Comprehensive Comparison Matrix

| Metric | Approach 1: Matrix Clone | Approach 2: Marker Arrays | Approach 3: In-Place Encoding (Optimal) |
| :--- | :--- | :--- | :--- |
| **Time Complexity** | $\mathcal{O}(M \cdot N)$ | $\mathcal{O}(M \cdot N)$ | $\mathcal{O}(M \cdot N)$ |
| **Auxiliary Space** | $\mathcal{O}(M \cdot N)$ | $\mathcal{O}(M + N)$ | **$\mathcal{O}(1)$** |
| **Heap Allocations**| $M \times N$ matrix | $M + N$ booleans | **$0$ allocations** |
| **Passes Over Grid**| 2 passes | 2 passes | **2 passes** |
| **Cache Locality** | Poor | Moderate | **Optimal (Sequential in-place)** |
| **Handles Full Int Range**| ✅ | ✅ | **✅** |
| **Interview Rating**| Poor | Acceptable Baseline | **Gold Standard** |

---

# ⚠️ Key Interview Gotchas & Edge Cases

1. **Order of Updating Matters (Inner Subgrid First)**:
   - Must zero the inner subgrid `[1..m-1][1..n-1]` **before** modifying the first row and first column!
   - If row 0 or column 0 is zeroed first, their marker information is destroyed, causing incorrect zeroing across other cells.

2. **The $(0, 0)$ Disambiguation**:
   - `matrix[0][0]` represents **Row 0**.
   - `firstColHasZero` represents **Column 0**.
   - Conflating both flags into `matrix[0][0]` will mistakenly zero out column 0 whenever row 0 has a zero (or vice versa).

3. **Single Row ($1 \times N$) or Single Column ($M \times 1$) Matrices**:
   - For $1 \times N$, if any cell is $0$, `firstColHasZero` or `matrix[0][0]` properly triggers the entire row to be zeroed.
   - For $M \times 1$, `firstColHasZero` marks the column to zero out every element.
