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
