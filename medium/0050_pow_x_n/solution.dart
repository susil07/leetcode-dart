// LeetCode 0050: Pow(x, n)
// Optimal Solution: Iterative Binary Exponentiation (Exponentiation by Squaring)
// Time Complexity: O(log |n|) - at most 32 loop iterations
// Space Complexity: O(1) auxiliary space (no recursion stack)

class Solution {
  double myPow(double x, int n) {
    // Base cases & fast paths
    if (n == 0) return 1.0;
    if (x == 1.0) return 1.0;
    if (x == -1.0) return (n % 2 == 0) ? 1.0 : -1.0;

    int power = n < 0 ? -n : n;
    double currentBase = x;
    double result = 1.0;

    // Binary exponentiation: process bits of the exponent from LSB to MSB
    while (power > 0) {
      // If the current bit is 1, multiply currentBase into the result
      if ((power & 1) == 1) {
        result *= currentBase;
      }

      // Square the base for the next bit position
      currentBase *= currentBase;

      // Shift to the next bit
      power >>= 1;
    }

    // Invert the result at the end for negative exponents:
    // Performing a single division at the end avoids compounding reciprocal floating-point
    // rounding errors across intermediate squaring multiplications.
    return n < 0 ? 1.0 / result : result;
  }
}
