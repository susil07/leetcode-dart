// LeetCode 0033: Search in Rotated Sorted Array
// Optimal Solution: One-Pass Modified Binary Search
// Time Complexity: O(log N) | Space Complexity: O(1) Auxiliary Space

class Solution {
  int search(List<int> nums, int target) {
    int left = 0;
    int right = nums.length - 1;

    while (left <= right) {
      final mid = left + (right - left) ~/ 2;

      // Target found at mid
      if (nums[mid] == target) {
        return mid;
      }

      // Check if the left half [left .. mid] is sorted
      if (nums[left] <= nums[mid]) {
        // Check if target falls within the sorted left half
        if (nums[left] <= target && target < nums[mid]) {
          right = mid - 1;
        } else {
          left = mid + 1;
        }
      }
      // Otherwise, the right half [mid .. right] must be sorted
      else {
        // Check if target falls within the sorted right half
        if (nums[mid] < target && target <= nums[right]) {
          left = mid + 1;
        } else {
          right = mid - 1;
        }
      }
    }

    // Target does not exist in nums
    return -1;
  }
}
