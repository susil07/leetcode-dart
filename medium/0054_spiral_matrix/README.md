# 🚀 LeetCode 0054 - Spiral Matrix

## 📝 Problem Statement

Given an $m \times n$ `matrix`, return *all elements of the `matrix` in **spiral order***.

---

## 🔒 Constraints

- $m == \text{matrix.length}$
- $n == \text{matrix}[i].\text{length}$
- $1 \le m, n \le 10$
- $-100 \le \text{matrix}[i][j] \le 100$

---

## 💡 Examples

### Example 1
```text
Input: matrix = [
  [1, 2, 3],
  [4, 5, 6],
  [7, 8, 9]
]
Output: [1, 2, 3, 6, 9, 8, 7, 4, 5]
```

### Example 2
```text
Input: matrix = [
  [ 1,  2,  3,  4],
  [ 5,  6,  7,  8],
  [ 9, 10, 11, 12]
]
Output: [1, 2, 3, 4, 8, 12, 11, 10, 9, 5, 6, 7]
```

---

# 📐 Core Geometric Intuition: Concentric Boundary Shrinking

A matrix spiral traversal can be visualized as walking along the perimeter of concentric rectangular rings from the outermost shell inward.

```text
       left                               right
        │                                   │
top ────┼──►  [ 1 ] ──► [ 2 ] ──► [ 3 ] ──► [ 4 ]
        │                                   │
        │                                   ▼
        │     [ 5 ] ──► [ 6 ] ──► [ 7 ]   [ 8 ]
        │       ▲                   │       │
        │       │                   ▼       ▼
bottom ─┼──►  [ 9 ] ◄── [ 10] ◄── [ 11] ◄─ [ 12]
        │
```

Four boundary pointers define the active unexplored rectangle:
- `top`: index of the topmost unvisited row (starts at `0`).
- `bottom`: index of the bottommost unvisited row (starts at `m - 1`).
- `left`: index of the leftmost unvisited column (starts at `0`).
- `right`: index of the rightmost unvisited column (starts at `n - 1`).

Each complete ring consists of 4 directional steps:
1. **Right**: Traverse from `left` to `right` along row `top`, then increment `top++`.
2. **Down**: Traverse from `top` to `bottom` along column `right`, then decrement `right--`.
3. **Left**: Traverse from `right` to `left` along row `bottom`, then decrement `bottom--`.
4. **Up**: Traverse from `bottom` to `top` along column `left`, then increment `left++`.

---

# 🧠 Evolution of Solutions: How We Make It Better

```text
┌────────────────────────────────────────────────────────────────────────┐
│  1. Direction Vector Simulation with Visited Matrix                    │
│     • Move along (dr, dc) = [(0, 1), (1, 0), (0, -1), (-1, 0)]         │
│     • Maintain a 2D boolean array visited[m][n]                        │
│     • Turn right (dir = (dir + 1) % 4) on wall or visited cell         │
│     • Time: O(M * N) | Space: O(M * N) auxiliary memory                │
│     • Bottleneck: Extra 2D array allocation on the heap                │
└──────────────────────────────────┬─────────────────────────────────────┘
                                   │
                                   ▼ In-Place Sentinel Mutation
┌────────────────────────────────────────────────────────────────────────┐
│  2. Direction Simulation with Sentinel Value Mutation                  │
│     • Mark visited cells directly in matrix with 101                   │
│     • Time: O(M * N) | Space: O(1) auxiliary                           │
│     • Bottleneck: Destructive mutation of caller's input array         │
└──────────────────────────────────┬─────────────────────────────────────┘
                                   │
                                   ▼ Four-Boundary Layer Shrinking
┌────────────────────────────────────────────────────────────────────────┐
│  3. Four-Boundary Pointer Shrinking (Optimal & Gold Standard)          │
│     • Maintain top, bottom, left, right pointers                       │
│     • Loop while top <= bottom && left <= right                        │
│     • Guard checks for Left and Up traversals to avoid duplicates      │
│     • Time: O(M * N) | Space: O(1) auxiliary (Non-destructive)         │
│     • Improvement: Zero heap allocations, pure scalar register math    │
└──────────────────────────────────┬─────────────────────────────────────┘
                                   │
                                   ▼ Recursive Ring Decomposition
┌────────────────────────────────────────────────────────────────────────┐
│  4. Recursive Perimeter Peeling                                        │
│     • Peel perimeter of submatrix (top, bottom, left, right)           │
│     • Recurse on (top + 1, bottom - 1, left + 1, right - 1)            │
│     • Time: O(M * N) | Space: O(min(M, N)) call stack                  │
│     • Trade-off: Elegant structure, but incurs function call overhead  │
└────────────────────────────────────────────────────────────────────────┘
```

---

# 💻 Solutions

## 1. Approach 1: Direction Vector with Visited Matrix ($O(M \cdot N)$ Time, $O(M \cdot N)$ Space)

Simulates the movement of an agent walking inside a maze, turning $90^\circ$ clockwise whenever hitting a boundary or an already-visited cell:

```dart
class SolutionVisitedSimulation {
  List<int> spiralOrder(List<List<int>> matrix) {
    if (matrix.isEmpty || matrix[0].isEmpty) return [];

    final int m = matrix.length;
    final int n = matrix[0].length;
    final List<int> result = [];
    final List<List<bool>> visited = List.generate(
      m,
      (_) => List<bool>.filled(n, false),
    );

    // Direction vectors: Right, Down, Left, Up
    final dr = [0, 1, 0, -1];
    final dc = [1, 0, -1, 0];
    int r = 0, c = 0, dir = 0;

    for (int i = 0; i < m * n; i++) {
      result.add(matrix[r][c]);
      visited[r][c] = true;

      int nextR = r + dr[dir];
      int nextC = c + dc[dir];

      // Turn right if next cell is out of bounds or already visited
      if (nextR < 0 || nextR >= m || nextC < 0 || nextC >= n || visited[nextR][nextC]) {
        dir = (dir + 1) % 4;
        nextR = r + dr[dir];
        nextC = c + dc[dir];
      }

      r = nextR;
      c = nextC;
    }

    return result;
  }
}
```

### 🔴 Bottlenecks:
- Allocates an $m \times n$ boolean matrix on the heap.
- Constant branch mispredictions checking edge collisions at every step.

---

## 2. Approach 2: Four-Boundary Pointer Shrinking (Optimal & Gold Standard)

Traverses concentric rectangles by maintaining 4 scalar bounds (`top`, `bottom`, `left`, `right`). Because bounds contract symmetrically, no visited matrix is needed:

```dart
// LeetCode 0054: Spiral Matrix
// Optimal Solution: Four-Boundary Layer Shrinking (top, bottom, left, right)
// Time Complexity: O(M * N) where M = matrix.length, N = matrix[0].length
// Space Complexity: O(1) auxiliary space (excluding the output list)

class Solution {
  List<int> spiralOrder(List<List<int>> matrix) {
    if (matrix.isEmpty || matrix[0].isEmpty) return [];

    final List<int> result = [];
    int top = 0;
    int bottom = matrix.length - 1;
    int left = 0;
    int right = matrix[0].length - 1;

    // Continue traversing in concentric rectangular rings until boundaries cross
    while (top <= bottom && left <= right) {
      // 1. Traverse Right along the top row
      for (int c = left; c <= right; c++) {
        result.add(matrix[top][c]);
      }
      top++; // Shrink top boundary downwards

      // 2. Traverse Down along the right column
      for (int r = top; r <= bottom; r++) {
        result.add(matrix[r][right]);
      }
      right--; // Shrink right boundary leftwards

      // 3. Traverse Left along the bottom row
      // Guard condition: ensure there is still a remaining row to traverse
      if (top <= bottom) {
        for (int c = right; c >= left; c--) {
          result.add(matrix[bottom][c]);
        }
        bottom--; // Shrink bottom boundary upwards
      }

      // 4. Traverse Up along the left column
      // Guard condition: ensure there is still a remaining column to traverse
      if (left <= right) {
        for (int r = bottom; r >= top; r--) {
          result.add(matrix[r][left]);
        }
        left++; // Shrink left boundary rightwards
      }
    }

    return result;
  }
}
```

### 🟢 Why This is Optimal:
- **Strictly Single Pass ($O(M \cdot N)$):** Every cell in the grid is visited exactly once.
- **$O(1)$ Auxiliary Space:** Requires zero extra memory beyond the returned result list.
- **Non-Destructive:** Does not modify the input matrix elements.
- **Cache Friendly:** Reads horizontal segments sequentially in memory order.

---

## 3. Approach 3: Recursive Ring Peeling ($O(M \cdot N)$ Time, $O(\min(M, N))$ Space)

Recursively processes the perimeter of each submatrix:

```dart
class SolutionRecursive {
  List<int> spiralOrder(List<List<int>> matrix) {
    if (matrix.isEmpty || matrix[0].isEmpty) return [];
    final List<int> result = [];

    void peelRing(int top, int bottom, int left, int right) {
      if (top > bottom || left > right) return;

      // Top row
      for (int c = left; c <= right; c++) result.add(matrix[top][c]);

      // Right col
      for (int r = top + 1; r <= bottom; r++) result.add(matrix[r][right]);

      // Bottom row (if distinct from top)
      if (top < bottom) {
        for (int c = right - 1; c >= left; c--) result.add(matrix[bottom][c]);
      }

      // Left col (if distinct from right)
      if (left < right) {
        for (int r = bottom - 1; r > top; r--) result.add(matrix[r][left]);
      }

      peelRing(top + 1, bottom - 1, left + 1, right - 1);
    }

    peelRing(0, matrix.length - 1, 0, matrix[0].length - 1);
    return result;
  }
}
```

### 🔴 Bottlenecks:
- Incurs $O(\min(M, N))$ stack frames for recursion depth.

---

# 📊 Comprehensive Comparison Matrix

| Metric | 1. Visited Simulation | 2. Sentinel In-Place | 3. Four-Boundary Shrinking (Optimal) | 4. Recursive Peeling |
| :--- | :--- | :--- | :--- | :--- |
| **Time Complexity** | $O(M \cdot N)$ | $O(M \cdot N)$ | **$O(M \cdot N)$** | $O(M \cdot N)$ |
| **Auxiliary Space** | $O(M \cdot N)$ | **$O(1)$** | **$O(1)$** | $O(\min(M, N))$ stack |
| **Input Mutated?** | No | **Yes (Destructive)** | **No (Safe)** | No |
| **Boundary Guard Needed** | No (visited check) | No (visited check) | **Yes (`top <= bottom`, `left <= right`)** | Yes (`top < bottom`, `left < right`) |
| **Branch Mispredictions** | High | High | **Extremely Low (Direct loops)** | Low |
| **Interview Rating** | Acceptable | Pragmatic | 🏆 **Gold Standard Expected** | Good |

*Where $M$ is the number of rows and $N$ is the number of columns ($1 \le M, N \le 10$).*

---

# ⚠️ Key Interview Gotchas & Edge Cases

1. **The Single Row / Single Column Duplicate Trap (The #1 Bug!):**
   - Consider a $1 \times 3$ matrix: `[[1, 2, 3]]`.
   - Step 1 traverses Right: `[1, 2, 3]` and does `top++` (`top = 1, bottom = 0`).
   - Step 2 traverses Down: `r` from 1 to 0 (does not execute).
   - If Step 3 did **NOT** check `if (top <= bottom)`, it would traverse Left along row 0: `[3, 2, 1]`, **duplicating every element in reverse!**
   - **Rule:** Always guard Step 3 with `if (top <= bottom)` and Step 4 with `if (left <= right)`.
2. **Single Element Matrix (`[[1]]`):**
   - `top = 0, bottom = 0, left = 0, right = 0`.
   - Traverses Right (`[1]`), `top++` becomes 1.
   - Guards prevent steps 2, 3, 4 from executing. Output: `[1]`.
3. **Non-Square Matrices ($M \ne N$):**
   - $3 \times 4$ or $4 \times 3$ matrices collapse into a horizontal line or vertical line at the innermost level. The boundary checks handle non-square dimensions smoothly.
