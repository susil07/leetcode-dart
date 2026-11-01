// LeetCode 0055: Jump Game
// Optimal Solution: Greedy Forward Reachability with Early Exit
// Time Complexity: O(N) single-pass
// Space Complexity: O(1) auxiliary space

class Solution {
  bool canJump(List<int> nums) {
    int maxReach = 0;
    final int n = nums.length;

    for (int i = 0; i < n; i++) {
      // If current index is beyond the farthest reachable index, we cannot proceed
      if (i > maxReach) {
        return false;
      }

      // Greedily update the farthest index we can reach
      final int currentReach = i + nums[i];
      if (currentReach > maxReach) {
        maxReach = currentReach;
      }

      // Early exit: if destination is already reachable, return true immediately
      if (maxReach >= n - 1) {
        return true;
      }
    }

    return true;
  }
}
