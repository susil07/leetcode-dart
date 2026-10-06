// LeetCode 0038: Count and Say
// Optimal Solution: Iterative Run-Length Encoding with StringBuffer
// Time Complexity: O(sum(L_i)) where L_i is length at step i | Space Complexity: O(L_n)

class Solution {
  String countAndSay(int n) {
    if (n <= 1) return '1';

    String current = '1';

    for (int step = 2; step <= n; step++) {
      final buffer = StringBuffer();
      final len = current.length;
      int i = 0;

      while (i < len) {
        int count = 1;
        // Count consecutive identical digits
        while (i + 1 < len && current.codeUnitAt(i) == current.codeUnitAt(i + 1)) {
          count++;
          i++;
        }

        // Append count and the digit character
        buffer.write(count);
        buffer.writeCharCode(current.codeUnitAt(i));
        i++;
      }

      current = buffer.toString();
    }

    return current;
  }
}
