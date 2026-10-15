// LeetCode 0048: Rotate Image
// Optimal Solution: In-Place Transpose + Horizontal Reflection (Reverse Rows)
// Time Complexity: O(N^2) where N is the dimension of the matrix
// Space Complexity: O(1) auxiliary space (strictly in-place modification)

class Solution {
  void rotate(List<List<int>> matrix) {
    final int n = matrix.length;

    // Step 1: Transpose the matrix along the main diagonal (swap matrix[i][j] with matrix[j][i])
    for (int i = 0; i < n; i++) {
      for (int j = i + 1; j < n; j++) {
        final temp = matrix[i][j];
        matrix[i][j] = matrix[j][i];
        matrix[j][i] = temp;
      }
    }

    // Step 2: Reverse each row horizontally (swap matrix[i][left] with matrix[i][right])
    for (int i = 0; i < n; i++) {
      int left = 0;
      int right = n - 1;
      while (left < right) {
        final temp = matrix[i][left];
        matrix[i][left] = matrix[i][right];
        matrix[i][right] = temp;
        left++;
        right--;
      }
    }
  }
}
