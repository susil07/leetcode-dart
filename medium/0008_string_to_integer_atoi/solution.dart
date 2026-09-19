// LeetCode 0008: String to Integer (atoi)
// Optimal Solution: Single-Pass Linear Scan with 32-Bit Clamping
// Time Complexity: O(N) | Space Complexity: O(1) Auxiliary Space

class Solution {
  int myAtoi(String s) {
    const int intMax = 2147483647;
    const int intMin = -2147483648;
    const int maxThreshold = 214748364; // 2147483647 ~/ 10

    int i = 0;
    final n = s.length;

    // 1. Skip leading whitespaces
    while (i < n && s[i] == ' ') {
      i++;
    }
    if (i == n) return 0;

    // 2. Check for optional '+' or '-' sign
    int sign = 1;
    if (s[i] == '-') {
      sign = -1;
      i++;
    } else if (s[i] == '+') {
      i++;
    }

    // 3. Parse digits and clamp to 32-bit signed range
    int result = 0;
    while (i < n) {
      final code = s.codeUnitAt(i);
      // Stop reading if non-digit is encountered
      if (code < 48 || code > 57) {
        break;
      }
      final digit = code - 48;

      // Check overflow/underflow BEFORE multiplying by 10
      if (sign == 1) {
        if (result > maxThreshold || (result == maxThreshold && digit > 7)) {
          return intMax;
        }
      } else {
        if (result > maxThreshold || (result == maxThreshold && digit > 8)) {
          return intMin;
        }
      }

      result = result * 10 + digit;
      i++;
    }

    return sign * result;
  }
}
