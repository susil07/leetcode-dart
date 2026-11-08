# 🚀 LeetCode 0063 - Unique Paths II

## 📝 Problem Statement

You are given an `m x n` integer array `obstacleGrid`. There is a robot initially located at the **top-left corner** (i.e., `obstacleGrid[0][0]`). The robot tries to move to the **bottom-right corner** (i.e., `obstacleGrid[m - 1][n - 1]`). The robot can only move either **down** or **right** at any point in time.

An obstacle and space are marked as `1` or `0` respectively in `obstacleGrid`. A path that the robot takes cannot include **any** square that is an obstacle.

Return the number of possible unique paths that the robot can take to reach the bottom-right corner.

The testcases are generated so that the answer will be less than or equal to $2 \times 10^9$.

---

## 🔒 Constraints

- `m == obstacleGrid.length`
- `n == obstacleGrid[i].length`
- `1 <= m, n <= 100`
- `obstacleGrid[i][j]` is `0` or `1`.

---

## 💡 Examples

### Example 1
```text
Input: obstacleGrid = [
  [0, 0, 0],
  [0, 1, 0],
  [0, 0, 0]
]
Output: 2
Explanation: There is one obstacle in the middle of the 3x3 grid above.
There are two ways to reach the bottom-right corner:
1. Right -> Right -> Down -> Down
2. Down -> Down -> Right -> Right
```

```text
Start ──► [ ] ──► [ ]
  │                 │
  ▼                 ▼
 [ ]     [ X ]     [ ]
  │                 │
  ▼                 ▼
 [ ] ──► [ ] ──► Finish (2 Unique Paths)
```

### Example 2
```text
Input: obstacleGrid = [
  [0, 1],
  [0, 0]
]
Output: 1
```

```text
Start ──► [ X ]
  │
  ▼
 [ ] ──► Finish (1 Unique Path)
```

---

# 🔄 Contrast: Unique Paths I vs Unique Paths II

| Feature | LeetCode 62 (Unique Paths I) | LeetCode 63 (Unique Paths II) |
| :--- | :--- | :--- |
| **Grid Surface** | Completely open / unblocked | Contains arbitrary obstacle cells (`1`) |
| **Optimal Approach** | Combinatorics $\binom{m + n - 2}{\min(m - 1, n - 1)}$ | Dynamic Programming (Rolling Array) |
| **Time Complexity** | $\mathcal{O}(\min(m, n))$ | $\mathcal{O}(m \cdot n)$ |
| **Why DP is Necessary** | Step combinations are uniform everywhere | Obstacles break uniform global symmetry; path count depends on local connectivity |

---

# 📐 Core Dynamic Programming Formulation

Let $\text{dp}[i][j]$ denote the number of unique valid paths from $(0, 0)$ to $(i, j)$.

### 1. Recurrence Relation
$$\text{dp}[i][j] = \begin{cases} 0 & \text{if } \text{obstacleGrid}[i][j] == 1 \\ \text{dp}[i - 1][j] + \text{dp}[i][j - 1] & \text{if } \text{obstacleGrid}[i][j] == 0 \end{cases}$$

### 2. State Compression (1D Rolling Buffer)
Observe that computing cell $(i, j)$ depends solely on:
- $\text{dp}[i - 1][j]$: The value directly **above** in the previous row.
- $\text{dp}[i][j - 1]$: The value directly to the **left** in the current row.

```text
       Previous Row:    ...  dp[j]  ...   <-- Value from Top (i - 1, j)
                             │
                             ▼
       Current Row:   dp[j-1] ──► dp[j]   <-- New dp[j] = dp[j] (top) + dp[j-1] (left)
```

By traversing row-by-row and updating an array `dp` of size $n$ from left to right:
1. When `obstacleGrid[i][j] == 1`: set `dp[j] = 0` (zero paths through obstacles).
2. When `obstacleGrid[i][j] == 0` and `j > 0`: `dp[j] += dp[j - 1]`.
3. When `j == 0`: `dp[0]` retains its previous value unless blocked (`obstacleGrid[i][0] == 1`).

---

# 🧠 Evolution of Solutions: How We Make It Better

```text
┌────────────────────────────────────────────────────────────────────────┐
│  1. Naive Recursive DFS with Backtracking                              │
│     • Branch down and right, returning 0 on obstacles                  │
│     • Time: O(2^(m+n)) | Space: O(m+n) call stack                      │
│     • Fatal Flaw: Exponential time complexity, Time Limit Exceeded     │
└──────────────────────────────────┬─────────────────────────────────────┘
                                   │
                                   ▼ Memoization / Grid Tabulation
┌────────────────────────────────────────────────────────────────────────┐
│  2. 2D Dynamic Programming (Grid Tabulation)                           │
│     • dp[i][j] = dp[i-1][j] + dp[i][j-1], zeroing obstacle cells       │
│     • Time: O(m * n) | Space: O(m * n) auxiliary table                 │
│     • Bottleneck: High heap footprint allocating m arrays of length n  │
└──────────────────────────────────┬─────────────────────────────────────┘
                                   │
                                   ▼ Mutating Input Grid (Destructive)
┌────────────────────────────────────────────────────────────────────────┐
│  3. In-Place Dynamic Programming                                       │
│     • Overwrite obstacleGrid cells directly in-place                   │
│     • Time: O(m * n) | Space: O(1) auxiliary space                     │
│     • Drawback: Mutates input data, side effects violate clean design  │
└──────────────────────────────────┬─────────────────────────────────────┘
                                   │
                                   ▼ State Compression (1D Rolling Array)
┌────────────────────────────────────────────────────────────────────────┐
│  4. 1D Dynamic Programming (Optimal & Interview-Ready)                 │
│     • dp[j] = dp[j] + dp[j-1] using a single array of size n           │
│     • Time: O(m * n) | Space: O(n) auxiliary space                     │
│     • Value: Non-destructive, cache-friendly, ultra-compact memory     │
└────────────────────────────────────────────────────────────────────────┘
```

---

# 💻 Solutions

## 1. Approach 1: Naive Recursive DFS (Brute Force)

```dart
class SolutionDFS {
  int uniquePathsWithObstacles(List<List<int>> obstacleGrid) {
    return _dfs(0, 0, obstacleGrid);
  }

  int _dfs(int r, int c, List<List<int>> grid) {
    final int m = grid.length;
    final int n = grid[0].length;

    // Out of bounds or hit an obstacle
    if (r >= m || c >= n || grid[r][c] == 1) return 0;
    // Reached destination
    if (r == m - 1 && c == n - 1) return 1;

    return _dfs(r + 1, c, grid) + _dfs(r, c + 1, grid);
  }
}
```

### 🔴 Bottlenecks:
- **Exponential Complexity $\mathcal{O}(2^{m+n})$**: For large open sub-areas without obstacles, recurses through the same subproblems repeatedly $\implies$ TLE.

---

## 2. Approach 2: 2D Dynamic Programming ($\mathcal{O}(m \cdot n)$ Time, $\mathcal{O}(m \cdot n)$ Space)

```dart
class SolutionDP2D {
  int uniquePathsWithObstacles(List<List<int>> obstacleGrid) {
    final int m = obstacleGrid.length;
    final int n = obstacleGrid[0].length;

    if (obstacleGrid[0][0] == 1 || obstacleGrid[m - 1][n - 1] == 1) {
      return 0;
    }

    final List<List<int>> dp = List.generate(
      m,
      (_) => List<int>.filled(n, 0),
    );

    dp[0][0] = 1;

    for (int i = 0; i < m; i++) {
      for (int j = 0; j < n; j++) {
        if (obstacleGrid[i][j] == 1) {
          dp[i][j] = 0;
        } else {
          if (i > 0) dp[i][j] += dp[i - 1][j];
          if (j > 0) dp[i][j] += dp[i][j - 1];
        }
      }
    }

    return dp[m - 1][n - 1];
  }
}
```

### 🔴 Bottlenecks:
- Allocates an $m \times n$ matrix on the heap, when only the previous row is needed.

---

## 3. Approach 3: In-Place DP ($\mathcal{O}(m \cdot n)$ Time, $\mathcal{O}(1)$ Space)

Uses `obstacleGrid` itself to store intermediate path counts:

```dart
class SolutionInPlace {
  int uniquePathsWithObstacles(List<List<int>> obstacleGrid) {
    final int m = obstacleGrid.length;
    final int n = obstacleGrid[0].length;

    if (obstacleGrid[0][0] == 1 || obstacleGrid[m - 1][n - 1] == 1) {
      return 0;
    }

    obstacleGrid[0][0] = 1;

    // Fill first column
    for (int i = 1; i < m; i++) {
      obstacleGrid[i][0] = (obstacleGrid[i][0] == 0 && obstacleGrid[i - 1][0] == 1) ? 1 : 0;
    }

    // Fill first row
    for (int j = 1; j < n; j++) {
      obstacleGrid[0][j] = (obstacleGrid[0][j] == 0 && obstacleGrid[0][j - 1] == 1) ? 1 : 0;
    }

    // Fill the rest
    for (int i = 1; i < m; i++) {
      for (int j = 1; j < n; j++) {
        if (obstacleGrid[i][j] == 0) {
          obstacleGrid[i][j] = obstacleGrid[i - 1][j] + obstacleGrid[i][j - 1];
        } else {
          obstacleGrid[i][j] = 0;
        }
      }
    }

    return obstacleGrid[m - 1][n - 1];
  }
}
```

### ⚠️ Drawbacks in Production & Interviews:
- **Destructive Mutation**: Overwrites the caller's input data structure, which can cause unexpected bugs in multi-threaded or pipeline systems.
- In Dart, modifying input lists passed by reference is often considered an anti-pattern.

---

## 4. Approach 4: 1D Dynamic Programming (Optimal & Gold Standard)

Compresses the 2D DP table into a single 1D rolling array of size $n$, maintaining high readability, pure functional safety, and minimal memory:

```dart
// LeetCode 0063: Unique Paths II
// Optimal Solution: 1D Dynamic Programming (Rolling Array / State Compression)
// Time Complexity: O(M * N) where M is rows and N is columns
// Space Complexity: O(N) auxiliary space

class Solution {
  int uniquePathsWithObstacles(List<List<int>> obstacleGrid) {
    final int m = obstacleGrid.length;
    final int n = obstacleGrid[0].length;

    // Fast path: If start or destination cell has an obstacle, no path exists
    if (obstacleGrid[0][0] == 1 || obstacleGrid[m - 1][n - 1] == 1) {
      return 0;
    }

    // dp[j] represents the number of unique paths to the current column j
    final List<int> dp = List<int>.filled(n, 0);
    dp[0] = 1; // 1 way to be at the starting cell

    for (int i = 0; i < m; i++) {
      for (int j = 0; j < n; j++) {
        if (obstacleGrid[i][j] == 1) {
          // Obstacle cell cannot be reached or traversed
          dp[j] = 0;
        } else if (j > 0) {
          // dp[j] holds paths from top cell (i - 1, j)
          // dp[j - 1] holds paths from left cell (i, j - 1)
          dp[j] += dp[j - 1];
        }
      }
    }

    return dp[n - 1];
  }
}
```

### 🟢 Why This is Optimal:
- **Optimal Time $\mathcal{O}(M \times N)$**: Visits each grid cell exactly once.
- **Minimal Space $\mathcal{O}(N)$**: Consumes only a single flat array of size $\le 100$ ($< 1$ KB).
- **Non-Destructive**: Leaves `obstacleGrid` completely untouched.
- **Cache-Friendly**: Sequential memory access pattern with zero cache thrashing.

---

# 📊 Comprehensive Comparison Matrix

| Metric | Approach 1: Naive DFS | Approach 2: 2D DP Tabulation | Approach 3: In-Place DP | Approach 4: 1D DP Rolling Array (Optimal) |
| :--- | :--- | :--- | :--- | :--- |
| **Time Complexity** | $\mathcal{O}(2^{m + n})$ | $\mathcal{O}(m \cdot n)$ | $\mathcal{O}(m \cdot n)$ | $\mathcal{O}(m \cdot n)$ |
| **Auxiliary Space** | $\mathcal{O}(m + n)$ (stack) | $\mathcal{O}(m \cdot n)$ | $\mathcal{O}(1)$ | **$\mathcal{O}(n)$** |
| **Allocated Memory**| Call frames | $m \times n$ integers | $0$ | **$n$ integers ($\le 800$ B)** |
| **Input Mutability**| Non-destructive | Non-destructive | ❌ Overwrites input | **Non-destructive** |
| **Branching / Logic**| Complex base cases | 4 boundary branches | High complexity | **Simple & Unified** |
| **Interview Suitability**| Low (Brute Force) | Medium | Caution (side effects) | **Gold Standard** |

---

# ⚠️ Key Interview Gotchas & Edge Cases

1. **Blocked Origin or Destination (`grid[0][0] == 1` or `grid[m - 1][n - 1] == 1`)**:
   - If the starting square has an obstacle, the robot cannot even begin moving $\implies 0$.
   - If the target square has an obstacle, the robot cannot step into it $\implies 0$.
   - Checking this upfront (`if (obstacleGrid[0][0] == 1 || ...) return 0;`) avoids wasted computation.

2. **$1 \times 1$ Grid**:
   - `obstacleGrid = [[0]]` $\implies$ returns `1` (robot is already at destination).
   - `obstacleGrid = [[1]]` $\implies$ returns `0`.

3. **Obstacles in the First Row or Column**:
   - If an obstacle appears at $(0, 2)$, all cells to the right in row $0$ ($(0, 3), (0, 4), \dots$) have $0$ paths from row $0$.
   - The 1D DP logic cleanly propagates this: once blocked, `dp[j] = 0`, and subsequent cells will not receive any contribution from the left.

4. **Zero Paths Available (Full Wall Blockade)**:
   - If an entire row or diagonal is filled with obstacles, paths cannot pass through. `dp[n - 1]` correctly evaluates to `0`.
