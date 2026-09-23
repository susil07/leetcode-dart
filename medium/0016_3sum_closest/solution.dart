// LeetCode 0016: 3Sum Closest
// Optimal Solution: Sorting + Two Pointers with Greedy Bound Pruning
// Time Complexity: O(N^2) | Space Complexity: O(1) Auxiliary Space

class Solution {
  int threeSumClosest(List<int> nums, int target) {
    // 1. Sort the array to enable two-pointer convergence and bound pruning: O(N log N)
    nums.sort();
    final n = nums.length;
    int closestSum = nums[0] + nums[1] + nums[2];

    for (int i = 0; i < n - 2; i++) {
      // Skip duplicate starting numbers to avoid redundant window checks
      if (i > 0 && nums[i] == nums[i - 1]) continue;

      // Bound Pruning 1: Smallest possible sum using nums[i]
      final minSum = nums[i] + nums[i + 1] + nums[i + 2];
      if (minSum > target) {
        if ((minSum - target).abs() < (closestSum - target).abs()) {
          closestSum = minSum;
        }
        // Since array is sorted, any subsequent triplet starting with i' > i
        // will produce a sum >= minSum > target, moving further away from target.
        break;
      }

      // Bound Pruning 2: Largest possible sum using nums[i]
      final maxSum = nums[i] + nums[n - 2] + nums[n - 1];
      if (maxSum < target) {
        if ((target - maxSum).abs() < (closestSum - target).abs()) {
          closestSum = maxSum;
        }
        // No pair with this nums[i] can reach target; largest sum is still < target.
        continue;
      }

      int left = i + 1;
      int right = n - 1;

      while (left < right) {
        final currentSum = nums[i] + nums[left] + nums[right];

        // An exact match has an absolute difference of 0, which cannot be improved.
        if (currentSum == target) {
          return target;
        }

        if ((currentSum - target).abs() < (closestSum - target).abs()) {
          closestSum = currentSum;
        }

        if (currentSum < target) {
          left++;
          // Skip duplicate values for the left pointer
          while (left < right && nums[left] == nums[left - 1]) {
            left++;
          }
        } else {
          right--;
          // Skip duplicate values for the right pointer
          while (left < right && nums[right] == nums[right + 1]) {
            right--;
          }
        }
      }
    }

    return closestSum;
  }
}
