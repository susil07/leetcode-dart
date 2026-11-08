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
