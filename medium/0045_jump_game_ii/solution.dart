// LeetCode 0045: Jump Game II
// Optimal Solution: Greedy BFS Window Interval
// Time Complexity: O(N) single-pass traversal
// Space Complexity: O(1) auxiliary space

class Solution {
  int jump(List<int> nums) {
    // If the array has 0 or 1 elements, we are already at the destination
    if (nums.length <= 1) return 0;

    int jumps = 0;
    int currentEnd = 0;
    int farthest = 0;

    // We only iterate up to nums.length - 2 because once we reach or pass
    // the last index, we do not need to make another jump.
    for (int i = 0; i < nums.length - 1; i++) {
      // Greedily update the farthest reach achievable from any index visited so far
      if (i + nums[i] > farthest) {
        farthest = i + nums[i];
      }

      // When we hit the boundary of the current jump, we MUST commit to a jump
      if (i == currentEnd) {
        jumps++;
        currentEnd = farthest;

        // Early exit: destination is already reachable
        if (currentEnd >= nums.length - 1) {
          break;
        }
      }
    }

    return jumps;
  }
}
