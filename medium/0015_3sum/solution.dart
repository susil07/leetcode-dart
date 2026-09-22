// LeetCode 0015: 3Sum
// Optimal Solution: Sorting + Two Pointers with In-Place Deduplication
// Time Complexity: O(N^2) | Space Complexity: O(1) Auxiliary Space (ignoring output)

class Solution {
  List<List<int>> threeSum(List<int> nums) {
    // 1. Sort array to enable two-pointer traversal & duplicate skipping: O(N log N)
    nums.sort();
    final List<List<int>> result = [];
    final n = nums.length;

    for (int i = 0; i < n - 2; i++) {
      // Early pruning: Since the array is sorted in ascending order,
      // if nums[i] > 0, all following elements are also > 0, making sum 0 impossible.
      if (nums[i] > 0) break;

      // Skip duplicate values for the first element
      if (i > 0 && nums[i] == nums[i - 1]) continue;

      int left = i + 1;
      int right = n - 1;

      while (left < right) {
        final sum = nums[i] + nums[left] + nums[right];

        if (sum == 0) {
          result.add([nums[i], nums[left], nums[right]]);

          // Skip duplicate values for the second element
          while (left < right && nums[left] == nums[left + 1]) {
            left++;
          }
          // Skip duplicate values for the third element
          while (left < right && nums[right] == nums[right - 1]) {
            right--;
          }

          left++;
          right--;
        } else if (sum < 0) {
          left++; // Sum too small, move left pointer to increase sum
        } else {
          right--; // Sum too large, move right pointer to decrease sum
        }
      }
    }

    return result;
  }
}
