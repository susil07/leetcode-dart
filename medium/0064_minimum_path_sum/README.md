# 🚀 LeetCode 0064 - Minimum Path Sum

## 📝 Problem Statement

Given a `m x n` `grid` filled with non-negative numbers, find a path from top-left to bottom-right, which **minimizes the sum of all numbers along its path**.

**Note**: You can only move either **down** or **right** at any point in time.

---

## 🔒 Constraints

- `m == grid.length`
- `n == grid[i].length`
- `1 <= m, n <= 200`
- `0 <= grid[i][j] <= 200`

---

## 💡 Examples

### Example 1
```text
Input: grid = [
  [1, 3, 1],
  [1, 5, 1],
  [4, 2, 1]
]
Output: 7
Explanation: Because the path 1 -> 3 -> 1 -> 1 -> 1 minimizes the sum:
1 + 3 + 1 + 1 + 1 = 7.
```

```text
 ┌───┬───┬───┐
 │ 1 │ 3 │ 1 │  ==> Move Right to (0, 1), then Right to (0, 2)
 ├───┼───┼───┤
 │ 1 │ 5 │ 1 │  ==> Move Down to (1, 2)
 ├───┼───┼───┤
 │ 4 │ 2 │ 1 │  ==> Move Down to (2, 2) [Finish = 7]
 └───┴───┴───┘
```

### Example 2
```text
Input: grid = [
  [1, 2, 3],
  [4, 5, 6]
]
Output: 12
Explanation: 1 -> 2 -> 3 -> 6 = 12.
```

---

# 🔄 Path Optimization Matrix Comparison

| Problem | LeetCode 62 (Unique Paths I) | LeetCode 63 (Unique Paths II) | LeetCode 64 (Minimum Path Sum) |
| :--- | :--- | :--- | :--- |
| **Objective** | Count total paths | Count valid paths around obstacles | Find single path with **minimum cost** |
| **Transition** | `dp[j] += dp[j - 1]` | `dp[j] = obstacle ? 0 : dp[j] + dp[j - 1]` | `dp[j] = min(top, left) + grid[i][j]` |
| **Algebraic Structure** | Counting (Sum over paths) | Counting with zero-masking | **Tropical Semiring** $(\min, +)$ |
| **Optimal Complexity** | $\mathcal{O}(\min(m, n))$ Time, $\mathcal{O}(1)$ Space | $\mathcal{O}(m \cdot n)$ Time, $\mathcal{O}(n)$ Space | $\mathcal{O}(m \cdot n)$ Time, $\mathcal{O}(n)$ Space |

---

# 📐 Core Dynamic Programming Formulation

Let $\text{dp}[i][j]$ denote the minimum cumulative path sum from $(0, 0)$ to $(i, j)$.

### 1. Optimal Substructure
Any path reaching $(i, j)$ must arrive either from the cell directly above $(i - 1, j)$ or the cell directly to the left $(i, j - 1)$:

$$\text{dp}[i][j] = \min(\text{dp}[i - 1][j], \text{dp}[i][j - 1]) + \text{grid}[i][j]$$

### 2. Base Cases
- **Origin**: $\text{dp}[0][0] = \text{grid}[0][0]$
- **First Row**: Can only be reached from the left:
  $$\text{dp}[0][j] = \text{dp}[0][j - 1] + \text{grid}[0][j]$$
- **First Column**: Can only be reached from above:
  $$\text{dp}[i][0] = \text{dp}[i - 1][0] + \text{grid}[i][0]$$

### 3. State Compression (1D Rolling Buffer)
Observe that computing cell $(i, j)$ depends solely on:
- $\text{dp}[i - 1][j]$: The value directly **above** in the previous row (stored in `dp[j]` before being overwritten).
- $\text{dp}[i][j - 1]$: The value directly to the **left** in the current row (already updated in `dp[j - 1]`).

```text
       Previous Row:    ...  dp[j]  ...   <-- Value from Top (i - 1, j)
                             │
                             ▼
       Current Row:   dp[j-1] ──► dp[j]   <-- New dp[j] = min(dp[j], dp[j-1]) + grid[i][j]
```

---

# 🧠 Evolution of Solutions: How We Make It Better

```text
┌────────────────────────────────────────────────────────────────────────┐
│  1. Naive Recursive DFS (Brute Force)                                  │
│     • Explore both branches: cost(r, c) = min(cost(r+1, c), cost(r, c+1))
│     • Time: O(2^(m+n)) | Space: O(m+n) call stack                      │
│     • Fatal Flaw: Exponential combinatorial explosion, TLE             │
└──────────────────────────────────┬─────────────────────────────────────┘
                                   │
                                   ▼ Memoize Subproblems (Tabulation)
┌────────────────────────────────────────────────────────────────────────┐
│  2. 2D Dynamic Programming (Grid Tabulation)                           │
│     • dp[i][j] = min(dp[i-1][j], dp[i][j-1]) + grid[i][j]              │
│     • Time: O(m * n) | Space: O(m * n) auxiliary matrix                │
│     • Bottleneck: Allocates m * n matrix when only prior row is needed │
└──────────────────────────────────┬─────────────────────────────────────┘
                                   │
                                   ▼ Mutate Input Grid (In-Place)
┌────────────────────────────────────────────────────────────────────────┐
│  3. In-Place Dynamic Programming                                       │
│     • Overwrite grid[i][j] directly with min path sums                 │
│     • Time: O(m * n) | Space: O(1) auxiliary space                     │
│     • Drawback: Mutates caller's input array (unsafe side effect)      │
└──────────────────────────────────┬─────────────────────────────────────┘
                                   │
                                   ▼ State Compression (1D Rolling Array)
┌────────────────────────────────────────────────────────────────────────┐
│  4. 1D Dynamic Programming (Optimal & Gold Standard)                 │
│     • dp[j] = min(dp[j], dp[j-1]) + grid[i][j] using size n array      │
│     • Time: O(m * n) | Space: O(n) auxiliary space                     │
│     • Value: Non-destructive, cache-friendly, ultra-low memory (<2 KB) │
└────────────────────────────────────────────────────────────────────────┘
```

---

# 💻 Solutions

## 1. Approach 1: Naive Recursive DFS (Brute Force)

```dart
class SolutionDFS {
  int minPathSum(List<List<int>> grid) {
    return _dfs(0, 0, grid);
  }

  int _dfs(int r, int c, List<List<int>> grid) {
    final int m = grid.length;
    final int n = grid[0].length;

    // Out of bounds: return very large number
    if (r >= m || c >= n) return 1 << 60;
    // Reached destination
    if (r == m - 1 && c == n - 1) return grid[r][c];

    final int down = _dfs(r + 1, c, grid);
    final int right = _dfs(r, c + 1, grid);

    return (down < right ? down : right) + grid[r][c];
  }
}
```

### 🔴 Bottlenecks:
- **Exponential Time $\mathcal{O}(2^{m+n})$**: For a $200 \times 200$ grid, the number of distinct paths is $\binom{398}{199} \approx 10^{118}$, causing immediate Time Limit Exceeded.

---

## 2. Approach 2: 2D Dynamic Programming ($\mathcal{O}(m \cdot n)$ Time, $\mathcal{O}(m \cdot n)$ Space)

```dart
class SolutionDP2D {
  int minPathSum(List<List<int>> grid) {
    final int m = grid.length;
    final int n = grid[0].length;

    final List<List<int>> dp = List.generate(
      m,
      (_) => List<int>.filled(n, 0),
    );

    dp[0][0] = grid[0][0];

    // Initialize first row
    for (int j = 1; j < n; j++) {
      dp[0][j] = dp[0][j - 1] + grid[0][j];
    }

    // Initialize first column
    for (int i = 1; i < m; i++) {
      dp[i][0] = dp[i - 1][0] + grid[i][0];
    }

    // Fill table
    for (int i = 1; i < m; i++) {
      for (int j = 1; j < n; j++) {
        final int top = dp[i - 1][j];
        final int left = dp[i][j - 1];
        dp[i][j] = (top < left ? top : left) + grid[i][j];
      }
    }

    return dp[m - 1][n - 1];
  }
}
```

### 🔴 Bottlenecks:
- Allocates an entire $m \times n$ table ($40,000$ integers), wasting memory when only values from the row directly above are actively referenced.

---

## 3. Approach 3: In-Place DP ($\mathcal{O}(m \cdot n)$ Time, $\mathcal{O}(1)$ Space)

```dart
class SolutionInPlace {
  int minPathSum(List<List<int>> grid) {
    final int m = grid.length;
    final int n = grid[0].length;

    // First row prefix sum
    for (int j = 1; j < n; j++) {
      grid[0][j] += grid[0][j - 1];
    }

    // First column prefix sum
    for (int i = 1; i < m; i++) {
      grid[i][0] += grid[i - 1][0];
    }

    // Overwrite inner cells
    for (int i = 1; i < m; i++) {
      for (int j = 1; j < n; j++) {
        final int top = grid[i - 1][j];
        final int left = grid[i][j - 1];
        grid[i][j] += (top < left ? top : left);
      }
    }

    return grid[m - 1][n - 1];
  }
}
```

### ⚠️ Drawbacks:
- Modifies the caller's input matrix in-place. In production applications, mutating shared input buffers can lead to catastrophic bugs in concurrent or retry-driven workflows.

---

## 4. Approach 4: 1D Dynamic Programming (Optimal & Gold Standard)

Compresses the 2D table into a single rolling row vector of size $n$, offering non-destructive safety, optimal memory, and maximum performance:

```dart
// LeetCode 0064: Minimum Path Sum
// Optimal Solution: 1D Dynamic Programming (Rolling Array / State Compression)
// Time Complexity: O(M * N) where M is rows and N is columns
// Space Complexity: O(N) auxiliary space (non-destructive)

class Solution {
  int minPathSum(List<List<int>> grid) {
    final int m = grid.length;
    final int n = grid[0].length;

    // dp[j] stores the minimum path sum to reach column j in the current row
    final List<int> dp = List<int>.filled(n, 0);

    // Initialize base case: First cell and prefix sums across the first row
    dp[0] = grid[0][0];
    for (int j = 1; j < n; j++) {
      dp[j] = dp[j - 1] + grid[0][j];
    }

    // Process subsequent rows sequentially
    for (int i = 1; i < m; i++) {
      // First column can only be reached from the cell directly above
      dp[0] += grid[i][0];

      // Remaining columns can be reached from either top (dp[j]) or left (dp[j - 1])
      for (int j = 1; j < n; j++) {
        final int fromTop = dp[j];
        final int fromLeft = dp[j - 1];
        dp[j] = (fromTop < fromLeft ? fromTop : fromLeft) + grid[i][j];
      }
    }

    return dp[n - 1];
  }
}
```

### 🟢 Why This is Optimal:
- **Optimal Time $\mathcal{O}(M \times N)$**: Exactly $M \times N$ cell updates.
- **Minimal Auxiliary Space $\mathcal{O}(N)$**: Allocates only a single array of size $N \le 200$ ($\le 1.6\,\text{KB}$).
- **Non-Destructive**: Leaves the original `grid` completely unmodified.
- **High CPU Cache Locality**: Sequential contiguous array access pattern fits entirely inside L1 cache.

---

# 📊 Comprehensive Comparison Matrix

| Metric | Approach 1: Naive DFS | Approach 2: 2D DP Tabulation | Approach 3: In-Place DP | Approach 4: 1D DP Rolling Array (Optimal) |
| :--- | :--- | :--- | :--- | :--- |
| **Time Complexity** | $\mathcal{O}(2^{m + n})$ | $\mathcal{O}(m \cdot n)$ | $\mathcal{O}(m \cdot n)$ | $\mathcal{O}(m \cdot n)$ |
| **Auxiliary Space** | $\mathcal{O}(m + n)$ (stack) | $\mathcal{O}(m \cdot n)$ | $\mathcal{O}(1)$ | **$\mathcal{O}(n)$** |
| **Allocated Memory**| Call frames | $m \times n$ integers | $0$ | **$n$ integers ($\le 1.6\,\text{KB}$)** |
| **Input Mutability**| Non-destructive | Non-destructive | ❌ Overwrites input | **Non-destructive** |
| **Cache Locality** | Poor | Moderate | High | **Optimal (L1 Cache)** |
| **Production Ready**| ❌ TLE | ✅ | ⚠️ Side effects | **Gold Standard** |

---

# ⚠️ Key Interview Gotchas & Edge Cases

1. **Single Cell Grid ($1 \times 1$)**:
   - `grid = [[5]]` $\implies$ returns `5`.
   - The loop `for (int j = 1; j < n; j++)` does not execute; `for (int i = 1; i < m; i++)` does not execute; returns `dp[0]` directly.

2. **Single Row Grid ($1 \times n$)**:
   - Robot can only move right. Returns the sum of all elements in the first row.

3. **Single Column Grid ($m \times 1$)**:
   - Robot can only move down. Returns the sum of all elements in the first column.

4. **Zero-Weighted Cells (`grid[i][j] == 0`)**:
   - Valid under constraints ($0 \le \text{grid}[i][j] \le 200$). Does not require special handling because non-negative weights ensure path costs monotonically non-decrease.

5. **Why Dijkstra's Algorithm is Unnecessary**:
   - Since the grid movements are strictly **Down** and **Right**, the underlying state graph is a **Directed Acyclic Graph (DAG)**.
   - Finding the shortest path in a DAG can be solved in $\mathcal{O}(V + E) = \mathcal{O}(m \cdot n)$ via topological order (row-by-row traversal), avoiding Dijkstra's $\mathcal{O}(V \log V)$ priority queue overhead.
