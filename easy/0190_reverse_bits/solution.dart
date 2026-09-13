// LeetCode 190: Reverse Bits
// Most Optimal Solution: Divide & Conquer (Bit Masking in 5 Operations)

class Solution {
  int reverseBits(int n) {
    // Ensure 32-bit representation
    n = n & 0xFFFFFFFF;

    // Step 1: Swap 16-bit halves
    n = ((n >> 16) & 0x0000FFFF) | ((n & 0x0000FFFF) << 16);

    // Step 2: Swap 8-bit bytes
    n = ((n >> 8) & 0x00FF00FF) | ((n & 0x00FF00FF) << 8);

    // Step 3: Swap 4-bit nibbles
    n = ((n >> 4) & 0x0F0F0F0F) | ((n & 0x0F0F0F0F) << 4);

    // Step 4: Swap 2-bit pairs
    n = ((n >> 2) & 0x33333333) | ((n & 0x33333333) << 2);

    // Step 5: Swap adjacent 1-bit pairs
    n = ((n >> 1) & 0x55555555) | ((n & 0x55555555) << 1);

    return n & 0xFFFFFFFF;
  }
}
