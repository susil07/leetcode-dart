// LeetCode 0034: Find First and Last Position of Element in Sorted Array
// Optimal Solution: Dual Binary Search for Lower and Upper Bounds
// Time Complexity: O(log N) | Space Complexity: O(1) Auxiliary Space

class Solution {
  List<int> searchRange(List<int> nums, int target) {
    // 1. Find the first occurrence (lower bound)
    final first = _findBound(nums, target, isFirst: true);

    // If target is not present at all, return [-1, -1] immediately
    if (first == -1) {
      return [-1, -1];
    }

    // 2. Find the last occurrence (upper bound)
    final last = _findBound(nums, target, isFirst: false);

    return [first, last];
  }

  int _findBound(List<int> nums, int target, {required bool isFirst}) {
    int left = 0;
    int right = nums.length - 1;
    int bound = -1;

    while (left <= right) {
      final mid = left + (right - left) ~/ 2;

      if (nums[mid] == target) {
        bound = mid;
        if (isFirst) {
          // Narrow search to the left half to find earlier occurrences
          right = mid - 1;
        } else {
          // Narrow search to the right half to find later occurrences
          left = mid + 1;
        }
      } else if (nums[mid] < target) {
        left = mid + 1;
      } else {
        right = mid - 1;
      }
    }

    return bound;
  }
}
