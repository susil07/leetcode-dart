// LeetCode 0011: Container With Most Water
// Optimal Solution: Two Pointers with Greedy Pruning - O(N) Time, O(1) Space

class Solution {
  int maxArea(List<int> height) {
    int left = 0;
    int right = height.length - 1;
    int maxWater = 0;

    while (left < right) {
      final width = right - left;
      final minHeight = height[left] < height[right] ? height[left] : height[right];
      final currentArea = width * minHeight;

      if (currentArea > maxWater) {
        maxWater = currentArea;
      }

      // Mathematical Pruning:
      // The area is bottlenecked by the shorter boundary (minHeight).
      // Moving the taller pointer will only decrease width without any chance
      // of increasing height beyond minHeight. Therefore, we advance the shorter
      // pointer inward, skipping any lines that are <= minHeight.
      if (height[left] < height[right]) {
        while (left < right && height[left] <= minHeight) {
          left++;
        }
      } else {
        while (left < right && height[right] <= minHeight) {
          right--;
        }
      }
    }

    return maxWater;
  }
}
