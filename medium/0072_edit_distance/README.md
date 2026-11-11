# 🚀 LeetCode 0072 - Edit Distance

## 📝 Problem Statement

Given two strings `word1` and `word2`, return the **minimum number of operations** required to convert `word1` to `word2`.

You have the following three operations permitted on a word:
- **Insert** a character
- **Delete** a character
- **Replace** a character

---

## 🔒 Constraints

- `0 <= word1.length, word2.length <= 500`
- `word1` and `word2` consist of lowercase English letters.

---

## 💡 Examples

### Example 1
```text
Input: word1 = "horse", word2 = "ros"
Output: 3
Explanation: 
horse -> rorse (replace 'h' with 'r')
rorse -> rose (remove 'r')
rose -> ros (remove 'e')
```

### Example 2
```text
Input: word1 = "intention", word2 = "execution"
Output: 5
Explanation: 
intention -> inention (remove 't')
inention -> enention (replace 'i' with 'e')
enention -> exention (replace 'n' with 'x')
exention -> exection (replace 'n' with 'c')
exection -> execution (insert 'u')
```

---

# 📐 Core Dynamic Programming Formulation (Levenshtein Distance)

Let $\text{dp}[i][j]$ denote the minimum number of operations required to convert the prefix $\text{word1}[0 \dots i-1]$ to the prefix $\text{word2}[0 \dots j-1]$.

### 1. Base Cases
- Converting an empty string to a prefix of length $j$ requires **$j$ insertions**:
  $$\text{dp}[0][j] = j$$
- Converting a prefix of length $i$ to an empty string requires **$i$ deletions**:
  $$\text{dp}[i][0] = i$$

### 2. Recurrence Relation
For any characters at indices $i-1$ and $j-1$:

```text
                     ┌─ dp[i - 1][j - 1]                            (if word1[i - 1] == word2[j - 1])
                     │
dp[i][j] = ──────────┼─ 1 + min(
                     │       dp[i - 1][j - 1],   // Replace
                     │       dp[i - 1][j],       // Delete
                     │       dp[i][j - 1]        // Insert
                     └─     )                    (if word1[i - 1] != word2[j - 1])
```

### 3. State Compression (1D Rolling Array + Diagonal Scalar)
Notice that computing cell $\text{dp}[i][j]$ depends strictly on three adjacent states:
- $\text{dp}[i - 1][j]$: The value directly **above** (current `dp[j]` before being overwritten).
- $\text{dp}[i][j - 1]$: The value directly to the **left** (already updated `dp[j - 1]`).
- $\text{dp}[i - 1][j - 1]$: The **diagonal top-left** value (stored in a scalar variable `prevDiagonal`).

```text
       Previous Row:    ...  prevDiagonal  ──►  dp[j] (above / Delete)  ...
                                    \             │
                                     \            ▼
       Current Row:     ...    dp[j-1] (left) ──► dp[j] (Target)
```

By keeping a single variable `prevDiagonal` to remember $\text{dp}[i - 1][j - 1]$ before updating `dp[j]`, the entire 2D matrix collapses into a **single 1D array of size $\min(M, N) + 1$**!

---

# 🧠 Evolution of Solutions: How We Make It Better

```text
┌────────────────────────────────────────────────────────────────────────┐
│  1. Naive Recursive DFS (Brute Force)                                  │
│     • Branch into 3 recursive calls for insert, delete, replace        │
│     • Time: O(3^(M + N)) | Space: O(M + N) call stack                  │
│     • Fatal Flaw: Exponential explosion with massive overlap, TLE      │
└──────────────────────────────────┬─────────────────────────────────────┘
                                   │
                                   ▼ Tabulate Overlapping Subproblems
┌────────────────────────────────────────────────────────────────────────┐
│  2. 2D Dynamic Programming (Matrix Tabulation)                         │
│     • Full (M + 1) x (N + 1) matrix tracking Levenshtein subproblems   │
│     • Time: O(M * N) | Space: O(M * N) auxiliary memory                │
│     • Bottleneck: Allocates up to 250,000 integers on the heap         │
└──────────────────────────────────┬─────────────────────────────────────┘
                                   │
                                   ▼ Compress State to Single Row
┌────────────────────────────────────────────────────────────────────────┐
│  3. 1D Dynamic Programming with Diagonal Scalar (Optimal & Gold)       │
│     • Single 1D array of size min(M, N) + 1                            │
│     • Swap inputs so N <= M to guarantee minimal buffer                │
│     • Use prevDiagonal scalar to capture diagonal state in-place       │
│     • Time: O(M * N) | Space: O(min(M, N)) auxiliary memory            │
│     • Value: Ultra-low memory (< 4 KB), optimal CPU L1 cache locality  │
└────────────────────────────────────────────────────────────────────────┘
```

---

# 💻 Solutions

## 1. Approach 1: Naive Recursive DFS (Brute Force)

```dart
class SolutionDFS {
  int minDistance(String word1, String word2) {
    return _dfs(word1.length, word2.length, word1, word2);
  }

  int _dfs(int i, int j, String w1, String w2) {
    // Base cases: one string is exhausted
    if (i == 0) return j;
    if (j == 0) return i;

    // Characters match: advance both
    if (w1[i - 1] == w2[j - 1]) {
      return _dfs(i - 1, j - 1, w1, w2);
    }

    // Try all three operations
    final int replaceOp = _dfs(i - 1, j - 1, w1, w2);
    final int deleteOp  = _dfs(i - 1, j, w1, w2);
    final int insertOp  = _dfs(i, j - 1, w1, w2);

    int minOp = replaceOp;
    if (deleteOp < minOp) minOp = deleteOp;
    if (insertOp < minOp) minOp = insertOp;

    return 1 + minOp;
  }
}
```

### 🔴 Bottlenecks:
- **Exponential Time $\mathcal{O}(3^{M+N})$**: For strings of length $20$, evaluates $> 10^{19}$ recursive branches $\implies$ instant Time Limit Exceeded.

---

## 2. Approach 2: 2D Dynamic Programming ($\mathcal{O}(M \cdot N)$ Time, $\mathcal{O}(M \cdot N)$ Space)

```dart
class SolutionDP2D {
  int minDistance(String word1, String word2) {
    final int m = word1.length;
    final int n = word2.length;

    final List<List<int>> dp = List.generate(
      m + 1,
      (_) => List<int>.filled(n + 1, 0),
    );

    for (int i = 0; i <= m; i++) dp[i][0] = i;
    for (int j = 0; j <= n; j++) dp[0][j] = j;

    for (int i = 1; i <= m; i++) {
      for (int j = 1; j <= n; j++) {
        if (word1.codeUnitAt(i - 1) == word2.codeUnitAt(j - 1)) {
          dp[i][j] = dp[i - 1][j - 1];
        } else {
          int minOps = dp[i - 1][j - 1]; // Replace
          if (dp[i - 1][j] < minOps) minOps = dp[i - 1][j]; // Delete
          if (dp[i][j - 1] < minOps) minOps = dp[i][j - 1]; // Insert
          dp[i][j] = 1 + minOps;
        }
      }
    }

    return dp[m][n];
  }
}
```

### 🔴 Bottlenecks:
- Allocates a large 2D matrix on the heap ($501 \times 501 = 251,001$ integers $\approx 2\,\text{MB}$).
- Poor cache locality due to pointer chasing across nested `List` instances.

---

## 3. Approach 3: 1D Dynamic Programming (Optimal & Gold Standard)

Compresses the 2D grid into a single flat array of size $\min(M, N) + 1$, updating in-place using a single scalar `prevDiagonal`:

```dart
// LeetCode 0072: Edit Distance
// Optimal Solution: 1D Dynamic Programming (Rolling Array with Diagonal Scalar)
// Time Complexity: O(M * N) where M = word1.length and N = word2.length
// Space Complexity: O(min(M, N)) auxiliary space

class Solution {
  int minDistance(String word1, String word2) {
    int m = word1.length;
    int n = word2.length;

    // Fast path: If either string is empty, the only operations are insertions/deletions
    if (m == 0) return n;
    if (n == 0) return m;

    // Ensure word2 is the shorter string to minimize auxiliary space to O(min(M, N))
    if (m < n) {
      final String tempStr = word1;
      word1 = word2;
      word2 = tempStr;
      final int tempLen = m;
      m = n;
      n = tempLen;
    }

    // dp[j] stores the minimum edit distance to form word2[0..j-1]
    // Base case: Converting an empty prefix of word1 to word2[0..j-1] requires j insertions
    final List<int> dp = List<int>.generate(n + 1, (j) => j);

    for (int i = 1; i <= m; i++) {
      int prevDiagonal = dp[0]; // Holds dp[i - 1][j - 1] (state before current row update)
      dp[0] = i;                // Converting word1[0..i-1] to empty string requires i deletions

      final int char1 = word1.codeUnitAt(i - 1);

      for (int j = 1; j <= n; j++) {
        final int temp = dp[j]; // Will become prevDiagonal for column j + 1
        final int char2 = word2.codeUnitAt(j - 1);

        if (char1 == char2) {
          // Matching characters: No edit operation required
          dp[j] = prevDiagonal;
        } else {
          // Characters differ: Choose minimum among replace, delete, and insert
          // 1. Replace: prevDiagonal (dp[i - 1][j - 1])
          // 2. Delete:  dp[j]         (dp[i - 1][j])
          // 3. Insert:  dp[j - 1]     (dp[i][j - 1])
          int minOps = prevDiagonal;
          if (dp[j] < minOps) minOps = dp[j];
          if (dp[j - 1] < minOps) minOps = dp[j - 1];

          dp[j] = 1 + minOps;
        }

        prevDiagonal = temp;
      }
    }

    return dp[n];
  }
}
```

### 🟢 Why This is Optimal:
- **Optimal Time $\mathcal{O}(M \times N)$**: Exactly $M \times N$ inner loop transitions.
- **Minimal Auxiliary Space $\mathcal{O}(\min(M, N))$**: Swapping guarantees the array size never exceeds $\min(M, N) + 1 \le 501$ integers ($< 4\,\text{KB}$).
- **L1 CPU Cache Resident**: A 500-element array stays entirely inside the CPU L1 cache throughout execution.
- **Fast Character Comparisons**: Uses `codeUnitAt()` for direct integer comparison without allocating character substring objects.

---

# 📊 Comprehensive Comparison Matrix

| Metric | Approach 1: Naive DFS | Approach 2: 2D DP Tabulation | Approach 3: 1D Rolling DP (Optimal) |
| :--- | :--- | :--- | :--- |
| **Time Complexity** | $\mathcal{O}(3^{M + N})$ | $\mathcal{O}(M \cdot N)$ | $\mathcal{O}(M \cdot N)$ |
| **Auxiliary Space** | $\mathcal{O}(M + N)$ (call stack) | $\mathcal{O}(M \cdot N)$ | **$\mathcal{O}(\min(M, N))$** |
| **Memory ($500 \times 500$)**| Call stack overflow | $\approx 251,000$ ints ($\approx 2\,\text{MB}$) | **$\le 501$ ints ($< 4\,\text{KB}$)** |
| **Cache Efficiency**| Negligible | Moderate (fragmented lists) | **Optimal (L1 Cache)** |
| **Input Invariance**| Symmetry not used | Requires $M \times N$ table | **Auto-swaps for min space** |
| **Production Ready**| ❌ TLE | ✅ | **Gold Standard** |

---

# ⚠️ Key Interview Gotchas & Edge Cases

1. **Empty Strings**:
   - `word1 = ""`, `word2 = ""` $\implies 0$.
   - `word1 = ""`, `word2 = "abc"` $\implies 3$ insertions.
   - `word1 = "abc"`, `word2 = ""` $\implies 3$ deletions.
   - Guarded immediately by:
     ```dart
     if (m == 0) return n;
     if (n == 0) return m;
     ```

2. **Identical Strings**:
   - When all characters match, the diagonal path is traversed with zero additions, yielding `0`.

3. **String Swapping for $\mathcal{O}(\min(M, N))$ Space**:
   - Levenshtein distance is completely symmetric: $\text{dist}(A, B) = \text{dist}(B, A)$.
   - If $M < N$, swapping $A$ and $B$ makes the DP vector size $M + 1$ instead of $N + 1$.

4. **Correct Diagonal Scalar Ordering**:
   - Must save `temp = dp[j]` **before** updating `dp[j]`.
   - Update `prevDiagonal = temp` **after** computing `dp[j]`.
   - Failing to store `prevDiagonal` properly causes `dp[j - 1]` or the new `dp[j]` to pollute the diagonal value for the next cell.
