// LeetCode 0059: Spiral Matrix II
// Optimal Solution: Four-Boundary Layer Shrinking (top, bottom, left, right)
// Time Complexity: O(N^2) where N is the dimension of the matrix
// Space Complexity: O(1) auxiliary space (excluding the output matrix)

class Solution {
  List<List<int>> generateMatrix(int n) {
    // Allocate the N x N grid initialized with 0
    final List<List<int>> matrix = List.generate(
      n,
      (_) => List<int>.filled(n, 0),
    );

    int top = 0;
    int bottom = n - 1;
    int left = 0;
    int right = n - 1;
    int val = 1;
    final int target = n * n;

    // Fill the matrix in concentric square rings until all n^2 values are placed
    while (val <= target) {
      // 1. Fill Right across the top row
      for (int c = left; c <= right; c++) {
        matrix[top][c] = val++;
      }
      top++; // Contract top boundary downwards

      // 2. Fill Down along the right column
      for (int r = top; r <= bottom; r++) {
        matrix[r][right] = val++;
      }
      right--; // Contract right boundary leftwards

      // 3. Fill Left across the bottom row
      if (top <= bottom) {
        for (int c = right; c >= left; c--) {
          matrix[bottom][c] = val++;
        }
        bottom--; // Contract bottom boundary upwards
      }

      // 4. Fill Up along the left column
      if (left <= right) {
        for (int r = bottom; r >= top; r--) {
          matrix[r][left] = val++;
        }
        left++; // Contract left boundary rightwards
      }
    }

    return matrix;
  }
}
