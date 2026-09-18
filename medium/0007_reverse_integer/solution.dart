// LeetCode 0007: Reverse Integer
// Optimal Solution: Mathematical Digit Extraction with 32-Bit Overflow Guard
// Time Complexity: O(log10 |x|) [at most 10 iterations]
// Space Complexity: O(1) Auxiliary Space

class Solution {
  int reverse(int x) {
    // 32-bit signed integer limits:
    // INT_MAX =  2147483647 (ends in 7)
    // INT_MIN = -2147483648 (ends in 8)
    const int maxThreshold = 214748364;  //  2147483647 ~/ 10
    const int minThreshold = -214748364; // -2147483648 ~/ 10

    int result = 0;

    while (x != 0) {
      // In Dart, remainder(10) preserves the negative sign, unlike %
      final digit = x.remainder(10);
      x ~/= 10;

      // 1. Check positive 32-bit overflow before multiplying by 10
      if (result > maxThreshold || (result == maxThreshold && digit > 7)) {
        return 0;
      }

      // 2. Check negative 32-bit underflow before multiplying by 10
      if (result < minThreshold || (result == minThreshold && digit < -8)) {
        return 0;
      }

      result = result * 10 + digit;
    }

    return result;
  }
}
