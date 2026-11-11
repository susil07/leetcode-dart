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
