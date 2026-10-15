# 🚀 LeetCode 0048 - Rotate Image

## 📝 Problem Statement

You are given an $n \times n$ 2D `matrix` representing an image. Rotate the image by **90 degrees (clockwise)**.

You have to rotate the image **in-place**, which means you have to modify the input 2D matrix directly. **DO NOT** allocate another 2D matrix and do the rotation.

---

## 🔒 Constraints

- $n == \text{matrix.length} == \text{matrix}[i].length$
- $1 \le n \le 20$
- $-1000 \le \text{matrix}[i][j] \le 1000$

---

## 💡 Examples

### Example 1
```text
Input: matrix = [
  [1, 2, 3],
  [4, 5, 6],
  [7, 8, 9]
]
Output: [
  [7, 4, 1],
  [8, 5, 2],
  [9, 6, 3]
]
```

### Example 2
```text
Input: matrix = [
  [ 5,  1,  9, 11],
  [ 2,  4,  8, 10],
  [13,  3,  6,  7],
  [15, 14, 12, 16]
]
Output: [
  [15, 13,  2,  5],
  [14,  3,  4,  1],
  [12,  6,  8,  9],
  [16,  7, 10, 11]
]
```

---

# 📐 Mathematical Foundation: Coordinate Transformation

In a $90^\circ$ clockwise rotation, a cell at coordinate $(r, c)$ moves to:
$$(r, c) \longrightarrow (c, \; n - 1 - r)$$

```text
Original:                       Rotated 90° Clockwise:
(0, 0) (0, 1) (0, 2)            (2, 0) (1, 0) (0, 0)
(1, 0) (1, 1) (1, 2)    ───►    (2, 1) (1, 1) (0, 1)
(2, 0) (2, 1) (2, 2)            (2, 2) (1, 2) (0, 2)
```

### Decomposing into Elementary Matrix Operations
Directly shifting cells in-place along circular arcs requires tricky 4-corner index bookkeeping. However, linear algebra allows us to factor a $90^\circ$ rotation into two simple geometric reflections:

$$\text{Rotate } 90^\circ \text{ Clockwise} = \text{Horizontal Reflection} \circ \text{Transpose}$$

1. **Transpose (Reflection along main diagonal):**
   $$(r, c) \longrightarrow (c, r)$$
2. **Horizontal Reflection (Reverse each row):**
   $$(c, r) \longrightarrow (c, \; n - 1 - r)$$

```text
Step 1: Transpose along main diagonal (swap [i][j] with [j][i]):
[ 1, 2, 3 ]          [ 1, 4, 7 ]
[ 4, 5, 6 ]   ───►   [ 2, 5, 8 ]
[ 7, 8, 9 ]          [ 3, 6, 9 ]

Step 2: Reverse each row horizontally:
[ 1, 4, 7 ]          [ 7, 4, 1 ]
[ 2, 5, 8 ]   ───►   [ 8, 5, 2 ]
[ 3, 6, 9 ]          [ 9, 6, 3 ]   <-- 90° Clockwise Rotated!
```

---

# 🧭 Matrix Rotation Operations Cheat Sheet

| Transformation | Sequence of Operations |
| :--- | :--- |
| **$90^\circ$ Clockwise** | **Transpose $\to$ Reverse each Row** *(or Reverse Vertically $\to$ Transpose)* |
| **$90^\circ$ Counter-Clockwise** | **Transpose $\to$ Reverse Vertically** *(or Reverse each Row $\to$ Transpose)* |
| **$180^\circ$ Rotation** | **Reverse Vertically $\to$ Reverse each Row** |
| **$270^\circ$ Clockwise** | Equivalent to **$90^\circ$ Counter-Clockwise** |

---

# 🧠 Evolution of Solutions: How We Make It Better

```text
┌────────────────────────────────────────────────────────────────────────┐
│  1. Out-of-Place Auxiliary Matrix Allocation                           │
│     • Allocate newMatrix[n][n]; newMatrix[j][n - 1 - i] = matrix[i][j] │
│     • Copy back to input matrix                                        │
│     • Time: O(N^2) | Space: O(N^2) auxiliary memory                    │
│     • Bottleneck: Directly violates the in-place problem constraint    │
└──────────────────────────────────┬─────────────────────────────────────┘
                                   │
                                   ▼ In-Place 4-Way Cyclic Swaps
┌────────────────────────────────────────────────────────────────────────┐
│  2. Concentric Ring 4-Way Rotation                                     │
│     • Iterate layer-by-layer from outside in                           │
│     • For each element, cyclically rotate 4 corners with 1 temp var    │
│     • Time: O(N^2) | Space: O(1) in-place                              │
│     • Bottleneck: Highly error-prone coordinate offsets under pressure │
└──────────────────────────────────┬─────────────────────────────────────┘
                                   │
                                   ▼ Decompose into Transpose + Reverse
┌────────────────────────────────────────────────────────────────────────┐
│  3. Transpose + Horizontal Reflection (Optimal & Gold Standard)        │
│     • Pass 1: Transpose matrix along diagonal (j from i + 1 to n - 1)  │
│     • Pass 2: Reverse each row using 2-pointer swaps                   │
│     • Time: O(N^2) | Space: O(1) strictly in-place                     │
│     • Improvement: Clean, modular, zero index bugs, maximum locality   │
└────────────────────────────────────────────────────────────────────────┘
```

---

# 💻 Solutions

## 1. Approach 1: Auxiliary Buffer Matrix ($O(N^2)$ Time, $O(N^2)$ Space)

Creates a new matrix and populates it according to the rotation formula $(r, c) \to (c, n - 1 - r)$:

```dart
class SolutionOutOfPlace {
  void rotate(List<List<int>> matrix) {
    final int n = matrix.length;
    final List<List<int>> rotated = List.generate(
      n,
      (_) => List<int>.filled(n, 0),
    );

    for (int r = 0; r < n; r++) {
      for (int c = 0; c < n; c++) {
        rotated[c][n - 1 - r] = matrix[r][c];
      }
    }

    // Copy back into original matrix
    for (int r = 0; r < n; r++) {
      for (int c = 0; c < n; c++) {
        matrix[r][c] = rotated[r][c];
      }
    }
  }
}
```

### 🔴 Bottlenecks:
- Allocates $O(N^2)$ auxiliary heap memory.
- Explicitly disqualified by the problem constraint: *"DO NOT allocate another 2D matrix"*.

---

## 2. Approach 2: Concentric Ring 4-Way Cyclic Swaps ($O(N^2)$ Time, $O(1)$ Space)

Rotates groups of 4 cells cyclically in concentric layers from outermost to innermost:

```dart
class SolutionCyclicRotation {
  void rotate(List<List<int>> matrix) {
    final int n = matrix.length;

    for (int i = 0; i < (n ~/ 2); i++) {
      for (int j = i; j < n - 1 - i; j++) {
        final temp = matrix[i][j];

        // Bottom-left -> Top-left
        matrix[i][j] = matrix[n - 1 - j][i];

        // Bottom-right -> Bottom-left
        matrix[n - 1 - j][i] = matrix[n - 1 - i][n - 1 - j];

        // Top-right -> Bottom-right
        matrix[n - 1 - i][n - 1 - j] = matrix[j][n - 1 - i];

        // Top-left (temp) -> Top-right
        matrix[j][n - 1 - i] = temp;
      }
    }
  }
}
```

### 🔴 Bottlenecks:
- Requires memorizing four complex index expressions (`[n - 1 - j][i]`, `[n - 1 - i][n - 1 - j]`, etc.).
- A single off-by-one sign error causes subtle bugs in an interview setting.

---

## 3. Approach 3: Transpose + Horizontal Reflection (Optimal & Gold Standard)

Decomposes the rotation into two clear, distinct passes:

```dart
// LeetCode 0048: Rotate Image
// Optimal Solution: In-Place Transpose + Horizontal Reflection (Reverse Rows)
// Time Complexity: O(N^2) where N is the dimension of the matrix
// Space Complexity: O(1) auxiliary space (strictly in-place modification)

class Solution {
  void rotate(List<List<int>> matrix) {
    final int n = matrix.length;

    // Step 1: Transpose the matrix along the main diagonal (swap matrix[i][j] with matrix[j][i])
    for (int i = 0; i < n; i++) {
      for (int j = i + 1; j < n; j++) {
        final temp = matrix[i][j];
        matrix[i][j] = matrix[j][i];
        matrix[j][i] = temp;
      }
    }

    // Step 2: Reverse each row horizontally (swap matrix[i][left] with matrix[i][right])
    for (int i = 0; i < n; i++) {
      int left = 0;
      int right = n - 1;
      while (left < right) {
        final temp = matrix[i][left];
        matrix[i][left] = matrix[i][right];
        matrix[i][right] = temp;
        left++;
        right--;
      }
    }
  }
}
```

### 🟢 Why This is Optimal:
- **Zero Bug Risk:** The loops for transpose (`j = i + 1 .. n - 1`) and row reversal (`left < right`) are elementary and intuitive.
- **Strictly In-Place:** Mutates the matrix with a single scalar `temp` variable: $O(1)$ auxiliary space.
- **Cache Locality:** Reversing rows traverses contiguous memory row-by-row, leveraging hardware CPU cache prefetching.
- **Generalizability:** Directly adapts to $90^\circ$ counter-clockwise, $180^\circ$, or custom affine reflections.

---

# 📊 Comprehensive Comparison Matrix

| Metric | 1. Auxiliary Matrix | 2. 4-Way Cyclic Swaps | 3. Transpose + Reverse Rows (Optimal) |
| :--- | :--- | :--- | :--- |
| **Time Complexity** | $O(N^2)$ | $O(N^2)$ | **$O(N^2)$** |
| **Auxiliary Space** | $O(N^2)$ | **$O(1)$** | **$O(1)$** |
| **Total Memory Writes** | $2N^2$ writes | $\approx N^2$ writes | $\approx N^2$ writes |
| **Cache Friendliness** | Moderate | Poor (accesses 4 distant edges) | **Exceptional (Row-wise memory access)** |
| **Code Readability** | Easy | Complex & error-prone | **Crystal Clear & Modular** |
| **Interview Rating** | Rejected (violates constraints) | Good | 🏆 **Gold Standard Expected** |

*Where $N$ is the side length of the matrix ($N \le 20$).*

---

# ⚠️ Key Interview Gotchas & Edge Cases

1. **The Transpose Loop Bound (`j = i + 1`):**
   - **Crucial!** Always start the inner transpose loop at `j = i + 1` (strictly above the diagonal).
   - If you iterate `j` from `0` to `n - 1`, swapping $(i, j)$ and $(j, i)$ will swap every element **twice**, leaving the matrix completely unchanged!
   - Elements on the main diagonal ($i == j$) naturally stay in place during a transpose.
2. **Strict In-Place Constraint:**
   - Always clarify whether allocating helper rows is allowed. In this problem, it is strictly forbidden.
3. **$1 \times 1$ Matrix:**
   - When $n = 1$, the transpose loop `j = i + 1` doesn't execute (`j = 1 < 1` is false), and `left = 0, right = 0` terminates immediately without error.
4. **Generalizing in Follow-Up Questions:**
   - *Interviewer: "How would you rotate 90° counter-clockwise?"*
     - Answer: Transpose the matrix, then **reverse columns vertically** (or reverse each row horizontally first, then transpose).
   - *Interviewer: "How would you rotate 180°?"*
     - Answer: **Reverse vertically** (reverse row order), then **reverse each row horizontally**.
