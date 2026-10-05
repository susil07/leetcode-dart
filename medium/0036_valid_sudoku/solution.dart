// LeetCode 0036: Valid Sudoku
// Optimal Solution: Single Pass with Bitmask Arrays
// Time Complexity: O(1) (fixed 81 cells) | Space Complexity: O(1) (3 arrays of size 9)

class Solution {
  bool isValidSudoku(List<List<String>> board) {
    // Bitmasks for each of the 9 rows, 9 columns, and 9 sub-boxes.
    // The d-th bit represents whether digit (d + 1) has been encountered.
    final List<int> rows = List<int>.filled(9, 0);
    final List<int> cols = List<int>.filled(9, 0);
    final List<int> boxes = List<int>.filled(9, 0);

    for (int r = 0; r < 9; r++) {
      for (int c = 0; c < 9; c++) {
        final cell = board[r][c];
        if (cell == '.') continue;

        // Convert char '1'-'9' to a bitmask (1 << 0 to 1 << 8)
        final mask = 1 << (cell.codeUnitAt(0) - 49);
        final boxIdx = (r ~/ 3) * 3 + (c ~/ 3);

        // If the bit is already set in the row, column, or 3x3 sub-box, it's invalid
        if ((rows[r] & mask) != 0 ||
            (cols[c] & mask) != 0 ||
            (boxes[boxIdx] & mask) != 0) {
          return false;
        }

        // Mark the bit in the corresponding row, column, and sub-box
        rows[r] |= mask;
        cols[c] |= mask;
        boxes[boxIdx] |= mask;
      }
    }

    return true;
  }
}
