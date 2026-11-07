# 🚀 LeetCode 0062 - Unique Paths

## 📝 Problem Statement

There is a robot on an `m x n` grid. The robot is initially located at the **top-left corner** (i.e., `grid[0][0]`). The robot tries to move to the **bottom-right corner** (i.e., `grid[m - 1][n - 1]`). The robot can only move either **down** or **right** at any point in time.

Given the two integers `m` and `n`, return the number of possible unique paths that the robot can take to reach the bottom-right corner.

The test cases are generated so that the answer will be less than or equal to $2 \times 10^9$.

---

## 🔒 Constraints

- $1 \le m, n \le 100$

---

## 💡 Examples

### Example 1
```text
Input: m = 3, n = 7
Output: 28
```

```text
Start ──► [ ] ──► [ ] ──► [ ] ──► [ ] ──► [ ] ──► [ ]
  │
  ▼
 [ ]      [ ]     [ ]     [ ]     [ ]     [ ]     [ ]
  │
  ▼
 [ ]      [ ]     [ ]     [ ]     [ ]     [ ]    Finish (28 Unique Paths)
```

### Example 2
```text
Input: m = 3, n = 2
Output: 3
Explanation: From the top-left corner, there are a total of 3 ways to reach the bottom-right corner:
1. Right -> Down -> Down
2. Down -> Down -> Right
3. Down -> Right -> Down
```

### Example 3
```text
Input: m = 3, n = 3
Output: 6
```

---

# 📐 Core Mathematical & Algorithmic Intuition

### 1. Grid Invariant: Fixed Number of Steps
To travel from $(0, 0)$ to $(m - 1, n - 1)$, the robot **must** make:
- Exactly $(m - 1)$ **Down** ($D$) moves
- Exactly $(n - 1)$ **Right** ($R$) moves

Regardless of the route taken:
$$\text{Total Moves } N = (m - 1) + (n - 1) = m + n - 2$$

Every distinct path corresponds to a unique permutation of $(m - 1)$ $D$'s and $(n - 1)$ $R$'s.

```text
Example: m = 3, n = 3  ==>  2 Down (D), 2 Right (R)
Total 4 moves:
  1. D D R R
  2. D R D R
  3. D R R D
  4. R D D R
  5. R D R D
  6. R R D D
Total = 6 unique paths
```

### 2. The Combinatorial Formula
The total number of unique sequences is the binomial coefficient:

$$\binom{N}{k} = \binom{m + n - 2}{m - 1} = \binom{m + n - 2}{n - 1} = \frac{(m + n - 2)!}{(m - 1)! \cdot (n - 1)!}$$

By choosing $k = \min(m - 1, n - 1)$, we can compute the answer in $\mathcal{O}(\min(m, n))$ operations and $\mathcal{O}(1)$ space!

---

# 🧠 Evolution of Solutions: How We Make It Better

```text
┌────────────────────────────────────────────────────────────────────────┐
│  1. Naive Recursive DFS (Brute Force)                                  │
│     • Explore all branches: f(r, c) = f(r+1, c) + f(r, c+1)             │
│     • Time: O(2^(m+n)) | Space: O(m+n) call stack                      │
│     • Fatal Flaw: Massive overlapping subproblems, Time Limit Exceeded │
└──────────────────────────────────┬─────────────────────────────────────┘
                                   │
                                   ▼ Memoize Subproblems (Tabulation)
┌────────────────────────────────────────────────────────────────────────┐
│  2. 2D Dynamic Programming (Grid Tabulation)                           │
│     • dp[r][c] = dp[r-1][c] + dp[r][c-1]                               │
│     • Time: O(m * n) | Space: O(m * n) auxiliary grid                  │
│     • Bottleneck: Allocates m * n matrix when only prior row is needed │
└──────────────────────────────────┬─────────────────────────────────────┘
                                   │
                                   ▼ Compress State to a Single Row
┌────────────────────────────────────────────────────────────────────────┐
│  3. 1D Dynamic Programming (Rolling Array)                             │
│     • dp[c] = dp[c] + dp[c-1] (in-place accumulation)                  │
│     • Time: O(m * n) | Space: O(min(m, n)) auxiliary array             │
│     • Bottleneck: Still performs m * n nested loop additions           │
└──────────────────────────────────┬─────────────────────────────────────┘
                                   │
                                   ▼ Closed-Form Combinatorics
┌────────────────────────────────────────────────────────────────────────┐
│  4. Combinatorics / Binomial Coefficient (Optimal & Gold Standard)     │
│     • Directly compute C(m + n - 2, min(m - 1, n - 1))                 │
│     • Time: O(min(m, n)) | Space: O(1) auxiliary space                 │
│     • Value: Sub-millisecond arithmetic, zero heap allocations         │
└────────────────────────────────────────────────────────────────────────┘
```

---

# 💻 Solutions

## 1. Approach 1: Naive Recursive DFS (Brute Force)

Explores all paths recursively by taking either a Down step or a Right step:

```dart
class SolutionDFS {
  int uniquePaths(int m, int n) {
    return _dfs(0, 0, m, n);
  }

  int _dfs(int r, int c, int m, int n) {
    // Reached destination
    if (r == m - 1 && c == n - 1) return 1;
    // Out of bounds
    if (r >= m || c >= n) return 0;

    return _dfs(r + 1, c, m, n) + _dfs(r, c + 1, m, n);
  }
}
```

### 🔴 Bottlenecks:
- **Exponential Complexity $\mathcal{O}(2^{m+n})$**: For $m=23, n=12$, this evaluates over $3.8 \times 10^{10}$ recursive calls, timing out instantly.
- **Redundant Work**: Computes identical subgrids $(r, c)$ millions of times without caching.

---

## 2. Approach 2: 2D Dynamic Programming (Tabulation) ($\mathcal{O}(m \cdot n)$ Time, $\mathcal{O}(m \cdot n)$ Space)

Constructs an $m \times n$ table where `dp[i][j]` stores the number of paths from $(0, 0)$ to $(i, j)$:

```dart
class SolutionDP2D {
  int uniquePaths(int m, int n) {
    final List<List<int>> dp = List.generate(
      m,
      (_) => List<int>.filled(n, 1),
    );

    // Each cell is reached either from above (i - 1, j) or from left (i, j - 1)
    for (int i = 1; i < m; i++) {
      for (int j = 1; j < n; j++) {
        dp[i][j] = dp[i - 1][j] + dp[i][j - 1];
      }
    }

    return dp[m - 1][n - 1];
  }
}
```

### 🔴 Bottlenecks:
- Allocates an entire $\mathcal{O}(m \cdot n)$ 2D matrix on the heap.
- High memory footprint when $m, n$ are large, even though computing row $i$ only requires values from row $i - 1$.

---

## 3. Approach 3: 1D Dynamic Programming (Rolling Array) ($\mathcal{O}(m \cdot n)$ Time, $\mathcal{O}(\min(m, n))$ Space)

Flattens the 2D grid into a single row vector. Iteratively updates `dp[j] = dp[j] + dp[j - 1]`:

```dart
class SolutionDP1D {
  int uniquePaths(int m, int n) {
    // Optimize space by setting n to the smaller dimension
    if (m < n) {
      final temp = m;
      m = n;
      n = temp;
    }

    final List<int> dp = List<int>.filled(n, 1);

    for (int i = 1; i < m; i++) {
      for (int j = 1; j < n; j++) {
        dp[j] += dp[j - 1];
      }
    }

    return dp[n - 1];
  }
}
```

### 🟢 Improvements Over 2D DP:
- Reduces memory from $\mathcal{O}(m \cdot n)$ to $\mathcal{O}(\min(m, n))$.
- Improves CPU cache locality by reusing a single contiguous array buffer.

---

## 4. Approach 4: Combinatorics / Binomial Coefficient (Optimal & Gold Standard)

Computes $\binom{N}{k} = \binom{m + n - 2}{\min(m - 1, n - 1)}$ using iterative multiplication and division:

$$\binom{N}{k} = \prod_{i=1}^{k} \frac{N - k + i}{i}$$

```dart
// LeetCode 0062: Unique Paths
// Optimal Solution: Combinatorics / Closed-Form Binomial Coefficient C(m + n - 2, min(m - 1, n - 1))
// Time Complexity: O(min(m, n))
// Space Complexity: O(1) auxiliary space

class Solution {
  int uniquePaths(int m, int n) {
    // Fast path: A 1xN or Mx1 grid has only a single straight-line path
    if (m == 1 || n == 1) return 1;

    // Total steps = (m - 1) Down moves + (n - 1) Right moves = m + n - 2
    // We choose min(m - 1, n - 1) directions out of the total steps:
    // C(N, k) = N! / (k! * (N - k)!)
    final int totalMoves = m + n - 2;
    final int k = (m - 1 < n - 1) ? m - 1 : n - 1;

    // Compute C(totalMoves, k) iteratively to prevent integer overflow:
    // C(N, k) = Product_{i=1..k} (N - k + i) / i
    int paths = 1;
    for (int i = 1; i <= k; i++) {
      paths = (paths * (totalMoves - k + i)) ~/ i;
    }

    return paths;
  }
}
```

### 🟢 Why This is Optimal:
- **Sub-linear Time $\mathcal{O}(\min(m, n))$**: Requires at most $k \le 99$ simple arithmetic operations, running in a fraction of a microsecond.
- **Strictly $\mathcal{O}(1)$ Auxiliary Space**: Zero array allocations or dynamic structures.
- **Overflow-Free Arithmetic**: Because the product of any $i$ consecutive integers is always divisible by $i!$, `(paths * (totalMoves - k + i)) ~/ i` divides cleanly with no remainder and never overflows 64-bit integers.

---

# 📊 Comprehensive Comparison Matrix

| Metric | Approach 1: Naive DFS | Approach 2: 2D DP Tabulation | Approach 3: 1D DP Rolling Array | Approach 4: Combinatorics (Optimal) |
| :--- | :--- | :--- | :--- | :--- |
| **Time Complexity** | $\mathcal{O}(2^{m + n})$ | $\mathcal{O}(m \cdot n)$ | $\mathcal{O}(m \cdot n)$ | $\mathcal{O}(\min(m, n))$ |
| **Auxiliary Space** | $\mathcal{O}(m + n)$ (call stack) | $\mathcal{O}(m \cdot n)$ | $\mathcal{O}(\min(m, n))$ | **$\mathcal{O}(1)$** |
| **Operations ($100 \times 100$)** | $\approx 10^{59}$ (TLE) | $10,000$ additions | $10,000$ additions | **$\le 99$ multiplications** |
| **Heap Allocations** | $0$ (high stack frame) | $m$ arrays of length $n$ | $1$ array of length $\min(m, n)$ | **$0$ allocations** |
| **Cache Locality** | Poor | Moderate | High | **Optimal (CPU registers)** |
| **Handles Obstacles?** | Easily extensible | Standard (LC 63) | Standard (LC 63) | ❌ Only uniform grids |

---

# ⚠️ Key Interview Gotchas & Edge Cases

1. **Boundary Cases ($m = 1$ or $n = 1$)**:
   - If the grid is a single row ($1 \times n$) or single column ($m \times 1$), the robot can only move in one direction. There is only **$1$** unique path.
   - Handled instantly by `if (m == 1 || n == 1) return 1;`.

2. **Minimizing the Loop Count ($k = \min(m - 1, n - 1)$)**:
   - Since $\binom{N}{k} = \binom{N}{N - k}$, choosing $k = \min(m - 1, n - 1)$ ensures the loop runs at most $\min(m - 1, n - 1)$ times instead of $\max$.
   - Example: For $m = 100, n = 2$, $k = 1$. The loop runs **1 time** instead of 99 times.

3. **Multiplication Before Integer Division**:
   - Must write `paths = (paths * (totalMoves - k + i)) ~/ i;`
   - Doing division first (`(totalMoves - k + i) ~/ i`) truncates prematurely, producing incorrect fractional results.
   - The product `paths * (totalMoves - k + i)` is mathematically guaranteed to be a multiple of `i` because it represents $\binom{N - k + i}{i}$.

4. **Follow-Up: Grid with Obstacles (LeetCode 63)**:
   - When cells can be blocked, closed-form combinatorics cannot be applied directly.
   - Dynamic Programming (Approach 3) becomes the required optimal approach: `dp[j] = obstacleGrid[i][j] == 1 ? 0 : dp[j] + dp[j - 1]`.
