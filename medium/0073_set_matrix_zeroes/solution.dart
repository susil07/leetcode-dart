// LeetCode 0073: Set Matrix Zeroes
// Optimal Solution: In-Place State Encoding using First Row & First Column as Flags
// Time Complexity: O(M * N) where M is rows and N is columns
// Space Complexity: O(1) auxiliary space (modifies matrix strictly in-place)

class Solution {
  void setZeroes(List<List<int>> matrix) {
    final int m = matrix.length;
    final int n = matrix[0].length;

    // Track whether the first column initially contains any zero
    // matrix[0][0] will serve as the flag for the first row
    bool firstColHasZero = false;

    // Pass 1: Scan the matrix and use the first row and first column as marker flags
    for (int i = 0; i < m; i++) {
      if (matrix[i][0] == 0) {
        firstColHasZero = true;
      }
      for (int j = 1; j < n; j++) {
        if (matrix[i][j] == 0) {
          matrix[i][0] = 0; // Mark row i
          matrix[0][j] = 0; // Mark column j
        }
      }
    }

    // Pass 2: Iterate through inner subgrid [1..m-1][1..n-1] and set zeroes
    for (int i = 1; i < m; i++) {
      for (int j = 1; j < n; j++) {
        if (matrix[i][0] == 0 || matrix[0][j] == 0) {
          matrix[i][j] = 0;
        }
      }
    }

    // Pass 3: Zero out the first row if flagged by matrix[0][0]
    if (matrix[0][0] == 0) {
      for (int j = 0; j < n; j++) {
        matrix[0][j] = 0;
      }
    }

    // Pass 4: Zero out the first column if flagged by firstColHasZero
    if (firstColHasZero) {
      for (int i = 0; i < m; i++) {
        matrix[i][0] = 0;
      }
    }
  }
}
