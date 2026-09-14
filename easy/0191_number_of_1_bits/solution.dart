// LeetCode 191: Number of 1 Bits (Hamming Weight)
// Most Optimal Solution: Brian Kernighan's Algorithm - O(k) where k = number of set bits

class Solution {
  int hammingWeight(int n) {
    int count = 0;

    // Clears the lowest set bit in each iteration
    while (n != 0) {
      n &= (n - 1);
      count++;
    }

    return count;
  }
}
