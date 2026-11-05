# 🚀 LeetCode 0059 - Spiral Matrix II

## 📝 Problem Statement

Given a positive integer `n`, generate an $n \times n$ `matrix` filled with elements from $1$ to $n^2$ in **spiral order**.

---

## 🔒 Constraints

- $1 \le n \le 20$

---

## 💡 Examples

### Example 1
```text
Input: n = 3
Output: [
  [1, 2, 3],
  [8, 9, 4],
  [7, 6, 5]
]
```

### Example 2
```text
Input: n = 1
Output: [[1]]
```

### Example 3
```text
Input: n = 4
Output: [
  [ 1,  2,  3,  4],
  [12, 13, 14,  5],
  [11, 16, 15,  6],
  [10,  9,  8,  7]
]
```

---

# 🔄 Contrast: Spiral Matrix I vs Spiral Matrix II

| Feature | LeetCode 54 (Spiral Matrix I) | LeetCode 59 (Spiral Matrix II) |
| :--- | :--- | :--- |
| **Operation** | **Read** an existing matrix | **Generate & populate** a new matrix |
| **Dimensions** | Arbitrary rectangular $M \times N$ | Strictly square $N \times N$ |
| **Total Elements** | $M \times N$ elements | Exactly $N^2$ elements (values $1 \dots N^2$) |
| **Center Behavior** | Can collapse to a horizontal or vertical line | Even $N \to 2 \times 2$ inner ring; Odd $N \to$ single center cell |

---

# 📐 Core Geometric Intuition: Concentric Ring Filling

Since the matrix is square ($n \times n$), it consists of exactly $\lceil n / 2 \rceil$ concentric square shells:

```text
       left                               right
        │                                   │
top ────┼──►  [ 1 ] ──► [ 2 ] ──► [ 3 ] ──► [ 4 ]
        │                                   │
        │                                   ▼
        │     [12 ] ──► [13 ] ──► [14 ]   [ 5 ]
        │       ▲                   │       │
        │       │                   ▼       ▼
        │     [11 ] ◄── [16 ] ◄── [15 ]   [ 6 ]
        │       ▲                           │
        │       │                           ▼
bottom ─┼──►  [10 ] ◄── [ 9 ] ◄── [ 8 ] ◄─ [ 7 ]
        │
```

Four boundary pointers (`top`, `bottom`, `left`, `right`) contract inward after writing each perimeter segment:
1. **Right**: Populate row `top` from `left` to `right`, then `top++`.
2. **Down**: Populate column `right` from `top` to `bottom`, then `right--`.
3. **Left**: Populate row `bottom` from `right` to `left`, then `bottom--`.
4. **Up**: Populate column `left` from `bottom` to `top`, then `left++`.

The loop terminates precisely when all $n^2$ numbers are placed (`val > n * n`).

---

# 🧠 Evolution of Solutions: How We Make It Better

```text
┌────────────────────────────────────────────────────────────────────────┐
│  1. Direction Vector Simulation                                        │
│     • Move along (dr, dc) = [(0, 1), (1, 0), (0, -1), (-1, 0)]         │
│     • Check if next position is out of bounds or matrix[r][c] != 0     │
│     • Change direction: dir = (dir + 1) % 4                            │
│     • Time: O(N^2) | Space: O(1) auxiliary                             │
│     • Bottleneck: Boundary checks & branch mispredictions on every step│
└──────────────────────────────────┬─────────────────────────────────────┘
                                   │
                                   ▼ Four-Boundary Layer Shrinking
┌────────────────────────────────────────────────────────────────────────┐
│  2. Four-Boundary Layer Shrinking (Optimal & Gold Standard)            │
│     • Explicit bounds: top, bottom, left, right                        │
│     • Run straight sequential loops for each side of the ring          │
│     • Time: O(N^2) strictly N^2 writes | Space: O(1) auxiliary         │
│     • Improvement: Direct sequential indexing, zero conditional turns  │
└──────────────────────────────────┬─────────────────────────────────────┘
                                   │
                                   ▼ Closed-Form Ring Indexing
┌────────────────────────────────────────────────────────────────────────┐
│  3. Closed-Form Mathematical Mapping                                   │
│     • Directly compute the value for each coordinate (r, c)            │
│     • Based on ring depth k = min(r, c, n - 1 - r, n - 1 - c)          │
│     • Time: O(N^2) | Space: O(1) auxiliary                             │
│     • Value: Excellent for querying individual cells in O(1) time      │
└────────────────────────────────────────────────────────────────────────┘
```

---

# 💻 Solutions

## 1. Approach 1: Direction Vector Simulation ($O(N^2)$ Time, $O(1)$ Space)

Simulates walking through the matrix, turning clockwise whenever encountering a border or an already-filled cell:

```dart
class SolutionDirectionSimulation {
  List<List<int>> generateMatrix(int n) {
    final List<List<int>> matrix = List.generate(
      n,
      (_) => List<int>.filled(n, 0),
    );

    final dr = [0, 1, 0, -1];
    final dc = [1, 0, -1, 0];
    int r = 0, c = 0, dir = 0;

    for (int val = 1; val <= n * n; val++) {
      matrix[r][c] = val;

      int nextR = r + dr[dir];
      int nextC = c + dc[dir];

      // Turn right if next cell is out of bounds or already populated
      if (nextR < 0 || nextR >= n || nextC < 0 || nextC >= n || matrix[nextR][nextC] != 0) {
        dir = (dir + 1) % 4;
        nextR = r + dr[dir];
        nextC = c + dc[dir];
      }

      r = nextR;
      c = nextC;
    }

    return matrix;
  }
}
```

### 🔴 Bottlenecks:
- Checks 5 separate conditions (`nextR < 0 || nextR >= n || ...`) at every single cell.

---

## 2. Approach 2: Four-Boundary Layer Shrinking (Optimal & Gold Standard)

Uses 4 contracting boundary pointers, writing contiguous segments directly:

```dart
// LeetCode 0059: Spiral Matrix II
// Optimal Solution: Four-Boundary Layer Shrinking (top, bottom, left, right)
// Time Complexity: O(N^2) where N is the dimension of the matrix
// Space Complexity: O(1) auxiliary space (excluding the output matrix)

class Solution {
  List<List<int>> generateMatrix(int n) {
    // Allocate the N x N grid initialized with 0
    final List<List<int>> matrix = List.generate(
      n,
      (_) => List<int>.filled(n, 0),
    );

    int top = 0;
    int bottom = n - 1;
    int left = 0;
    int right = n - 1;
    int val = 1;
    final int target = n * n;

    // Fill the matrix in concentric square rings until all n^2 values are placed
    while (val <= target) {
      // 1. Fill Right across the top row
      for (int c = left; c <= right; c++) {
        matrix[top][c] = val++;
      }
      top++; // Contract top boundary downwards

      // 2. Fill Down along the right column
      for (int r = top; r <= bottom; r++) {
        matrix[r][right] = val++;
      }
      right--; // Contract right boundary leftwards

      // 3. Fill Left across the bottom row
      if (top <= bottom) {
        for (int c = right; c >= left; c--) {
          matrix[bottom][c] = val++;
        }
        bottom--; // Contract bottom boundary upwards
      }

      // 4. Fill Up along the left column
      if (left <= right) {
        for (int r = bottom; r >= top; r--) {
          matrix[r][left] = val++;
        }
        left++; // Contract left boundary rightwards
      }
    }

    return matrix;
  }
}
```

### 🟢 Why This is Optimal:
- **Exactly $N^2$ Writes:** Each cell is assigned a value exactly once.
- **$O(1)$ Auxiliary Memory:** Operates directly within the allocated return matrix.
- **Fast Sequential Loops:** Eliminates direction array indexing and conditional wall checks on every cell.

---

## 3. Approach 3: Closed-Form Mathematical Mapping ($O(N^2)$ Time, $O(1)$ Space)

In system design or distributed databases, if you need the value at coordinate $(r, c)$ without generating the entire matrix, you can compute it in $O(1)$ time:
- Ring index: $k = \min(r, c, n - 1 - r, n - 1 - c)$.
- Base offset before ring $k$: $4k(n - k)$.
- Offset within ring $k$ depends on which of the 4 edges $(r, c)$ lies on.

```dart
class SolutionMathematical {
  int getVal(int r, int c, int n) {
    int k = r;
    if (c < k) k = c;
    if (n - 1 - r < k) k = n - 1 - r;
    if (n - 1 - c < k) k = n - 1 - c;

    int base = 4 * k * (n - k);
    int side = n - 2 * k;

    if (r == k) return base + (c - k + 1); // Top edge
    if (c == n - 1 - k) return base + side + (r - k); // Right edge
    if (r == n - 1 - k) return base + 2 * side - 1 + (n - 1 - k - c); // Bottom edge
    return base + 3 * side - 2 + (n - 1 - k - r); // Left edge
  }

  List<List<int>> generateMatrix(int n) {
    return List.generate(
      n,
      (r) => List.generate(n, (c) => getVal(r, c, n)),
    );
  }
}
```

### 🟢 Value:
- Allows random-access queries to any coordinate $(r, c)$ in $O(1)$ time without populating preceding cells!

---

# 📊 Comprehensive Comparison Matrix

| Metric | 1. Direction Simulation | 2. Four-Boundary Shrinking (Optimal) | 3. Mathematical Mapping |
| :--- | :--- | :--- | :--- |
| **Time Complexity** | $O(N^2)$ | **$O(N^2)$** | $O(N^2)$ |
| **Auxiliary Space** | $O(1)$ | **$O(1)$** | **$O(1)$** |
| **Condition Checks** | Checked at **every** cell | Checked **once per perimeter** | Math formula per cell |
| **Random Coordinate Access**| No ($O(N^2)$ simulation) | No ($O(N^2)$ generation) | **Yes ($O(1)$ closed form)** |
| **Code Simplicity** | Moderate | **High & Clean** | Mathematical |
| **Interview Rating** | Acceptable | 🏆 **Gold Standard Expected** | 💡 **Top-Tier Follow-Up** |

*Where $N$ is the side length of the matrix ($1 \le N \le 20$).*

---

# ⚠️ Key Interview Gotchas & Edge Cases

1. **$N = 1$ Base Case:**
   - For $n = 1$, `top = 0, bottom = 0, left = 0, right = 0`.
   - Step 1 writes `matrix[0][0] = 1`, increments `val` to 2 and `top` to 1.
   - Loop terminates immediately (`val > 1`). Returns `[[1]]`.
2. **Odd $N$ Center Element:**
   - When $n = 3$, the innermost ring is just the center cell $(1, 1)$.
   - Step 1 fills $(1, 1)$ with `9` and sets `top = 2`.
   - The guards `if (top <= bottom)` and `if (left <= right)` prevent steps 3 and 4 from re-writing the center cell!
3. **1-Indexed Values:**
   - Values must run from $1$ to $n^2$ (not $0$ to $n^2 - 1$).
