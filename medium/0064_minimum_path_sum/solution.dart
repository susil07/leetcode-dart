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
