// LeetCode 0029: Divide Two Integers
// Optimal Solution: Binary Long Division via Bit Shifts
// Time Complexity: O(1) (at most 32 bit iterations) | Space Complexity: O(1)

class Solution {
  int divide(int dividend, int divisor) {
    const int intMax = 2147483647;  //  2^31 - 1
    const int intMin = -2147483648; // -2^31

    // Overflow edge case: -2^31 / -1 = 2^31, which exceeds the 32-bit signed int max
    if (dividend == intMin && divisor == -1) {
      return intMax;
    }

    // Determine the sign of the quotient using XOR
    final bool isNegative = (dividend < 0) ^ (divisor < 0);

    // Convert to positive 64-bit values to perform safe binary long division
    int dvd = dividend.abs();
    final int dvs = divisor.abs();
    int quotient = 0;

    // Binary Long Division: Check powers of 2 from 31 down to 0
    for (int i = 31; i >= 0; i--) {
      // (dvd >> i) >= dvs is mathematically equivalent to dvd >= (dvs << i),
      // but shifting dvd right avoids potential overflow when dvs is shifted left.
      if ((dvd >> i) >= dvs) {
        quotient += 1 << i;
        dvd -= dvs << i;
      }
    }

    return isNegative ? -quotient : quotient;
  }
}
