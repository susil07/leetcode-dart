// LeetCode 0018: 4Sum
// Optimal Solution: Sorting + Two Pointers with Greedy Bound Pruning
// Time Complexity: O(N^3) | Space Complexity: O(1) Auxiliary Space (ignoring output)

class Solution {
  List<List<int>> fourSum(List<int> nums, int target) {
    final List<List<int>> result = [];
    final int n = nums.length;
    if (n < 4) return result;

    // 1. Sort the array to enable two-pointer convergence and duplicate skipping: O(N log N)
    nums.sort();

    for (int i = 0; i < n - 3; i++) {
      // Skip duplicate values for the first element
      if (i > 0 && nums[i] == nums[i - 1]) continue;

      // Bound Pruning 1: Smallest possible sum with nums[i]
      final minSumI = nums[i] + nums[i + 1] + nums[i + 2] + nums[i + 3];
      if (minSumI > target) break; // All subsequent combinations with i' > i will be even larger

      // Bound Pruning 2: Largest possible sum with nums[i]
      final maxSumI = nums[i] + nums[n - 3] + nums[n - 2] + nums[n - 1];
      if (maxSumI < target) continue; // No combination starting with nums[i] can reach target

      for (int j = i + 1; j < n - 2; j++) {
        // Skip duplicate values for the second element
        if (j > i + 1 && nums[j] == nums[j - 1]) continue;

        // Bound Pruning 1: Smallest possible sum with nums[i] and nums[j]
        final minSumJ = nums[i] + nums[j] + nums[j + 1] + nums[j + 2];
        if (minSumJ > target) break; // All subsequent combinations with j' > j will be even larger

        // Bound Pruning 2: Largest possible sum with nums[i] and nums[j]
        final maxSumJ = nums[i] + nums[j] + nums[n - 2] + nums[n - 1];
        if (maxSumJ < target) continue; // No combination with this (i, j) pair can reach target

        int left = j + 1;
        int right = n - 1;

        while (left < right) {
          final sum = nums[i] + nums[j] + nums[left] + nums[right];

          if (sum == target) {
            result.add([nums[i], nums[j], nums[left], nums[right]]);

            // Skip duplicate values for the third element
            while (left < right && nums[left] == nums[left + 1]) {
              left++;
            }
            // Skip duplicate values for the fourth element
            while (left < right && nums[right] == nums[right - 1]) {
              right--;
            }

            left++;
            right--;
          } else if (sum < target) {
            left++; // Sum too small, move left pointer to increase sum
          } else {
            right--; // Sum too large, move right pointer to decrease sum
          }
        }
      }
    }

    return result;
  }
}
