// LeetCode 0054: Spiral Matrix
// Optimal Solution: Four-Boundary Layer Shrinking (top, bottom, left, right)
// Time Complexity: O(M * N) where M = matrix.length, N = matrix[0].length
// Space Complexity: O(1) auxiliary space (excluding the output list)

class Solution {
  List<int> spiralOrder(List<List<int>> matrix) {
    if (matrix.isEmpty || matrix[0].isEmpty) return [];

    final List<int> result = [];
    int top = 0;
    int bottom = matrix.length - 1;
    int left = 0;
    int right = matrix[0].length - 1;

    // Continue traversing in concentric rectangular rings until boundaries cross
    while (top <= bottom && left <= right) {
      // 1. Traverse Right along the top row
      for (int c = left; c <= right; c++) {
        result.add(matrix[top][c]);
      }
      top++; // Shrink top boundary downwards

      // 2. Traverse Down along the right column
      for (int r = top; r <= bottom; r++) {
        result.add(matrix[r][right]);
      }
      right--; // Shrink right boundary leftwards

      // 3. Traverse Left along the bottom row
      // Guard condition: ensure there is still a remaining row to traverse
      if (top <= bottom) {
        for (int c = right; c >= left; c--) {
          result.add(matrix[bottom][c]);
        }
        bottom--; // Shrink bottom boundary upwards
      }

      // 4. Traverse Up along the left column
      // Guard condition: ensure there is still a remaining column to traverse
      if (left <= right) {
        for (int r = bottom; r >= top; r--) {
          result.add(matrix[r][left]);
        }
        left++; // Shrink left boundary rightwards
      }
    }

    return result;
  }
}
