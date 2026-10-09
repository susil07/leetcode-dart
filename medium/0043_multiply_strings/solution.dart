// LeetCode 0043: Multiply Strings
// Optimal Solution: In-Place Position Accumulation with Code Units
// Time Complexity: O(M * N) where M = num1.length, N = num2.length
// Space Complexity: O(M + N) to store the product digits

class Solution {
  String multiply(String num1, String num2) {
    // Edge case: multiplying any number by zero results in zero
    if (num1 == '0' || num2 == '0') return '0';

    final int m = num1.length;
    final int n = num2.length;
    // An m-digit number times an n-digit number produces at most m + n digits
    final List<int> pos = List<int>.filled(m + n, 0);

    // Compute products right-to-left
    for (int i = m - 1; i >= 0; i--) {
      final int d1 = num1.codeUnitAt(i) - 48; // ASCII '0' is 48

      for (int j = n - 1; j >= 0; j--) {
        final int d2 = num2.codeUnitAt(j) - 48;
        final int mul = d1 * d2;

        // d1 * d2 contributes to indices (i + j) and (i + j + 1)
        final int p1 = i + j;
        final int p2 = i + j + 1;
        final int sum = mul + pos[p2];

        pos[p2] = sum % 10;
        pos[p1] += sum ~/ 10; // Carry over to p1
      }
    }

    // Skip leading zeros
    int start = 0;
    while (start < pos.length && pos[start] == 0) {
      start++;
    }

    if (start == pos.length) return '0';

    // Convert digits back to ASCII character codes in-place
    for (int i = start; i < pos.length; i++) {
      pos[i] += 48;
    }

    return String.fromCharCodes(pos, start, pos.length);
  }
}
