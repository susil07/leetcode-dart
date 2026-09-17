// LeetCode 0006: Zigzag Conversion
// Optimal Solution: Direct Mathematical Index Jumps - O(N) Time, O(1) Auxiliary Space

class Solution {
  String convert(String s, int numRows) {
    // Edge case: when numRows is 1 or exceeds string length,
    // the zigzag pattern is identical to the original string.
    if (numRows == 1 || numRows >= s.length) {
      return s;
    }

    final buffer = StringBuffer();
    // Cycle length: moving down (numRows - 1) and diagonally up (numRows - 1)
    final cycleLen = 2 * numRows - 2;

    for (int r = 0; r < numRows; r++) {
      for (int j = r; j < s.length; j += cycleLen) {
        // 1. Primary vertical downward character
        buffer.write(s[j]);

        // 2. Intermediate diagonal upward character (only for interior rows)
        final diagIndex = j + cycleLen - 2 * r;
        if (r > 0 && r < numRows - 1 && diagIndex < s.length) {
          buffer.write(s[diagIndex]);
        }
      }
    }

    return buffer.toString();
  }
}
