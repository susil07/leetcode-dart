// LeetCode 0053: Maximum Subarray
// Optimal Solution: Kadane's Algorithm (Dynamic Programming with O(1) Space)
// Time Complexity: O(N) single-pass
// Space Complexity: O(1) auxiliary space

class Solution {
  int maxSubArray(List<int> nums) {
    // currentSum tracks the maximum subarray sum ending at the current position.
    // maxSum tracks the overall global maximum subarray sum encountered so far.
    int currentSum = nums[0];
    int maxSum = nums[0];

    for (int i = 1; i < nums.length; i++) {
      final int x = nums[i];

      // Kadane's recurrence:
      // Either extend the previous subarray (currentSum + x)
      // or start a fresh subarray at the current element (x).
      currentSum = (currentSum + x > x) ? currentSum + x : x;

      // Update global maximum if current subarray sum exceeds it
      if (currentSum > maxSum) {
        maxSum = currentSum;
      }
    }

    return maxSum;
  }
}
