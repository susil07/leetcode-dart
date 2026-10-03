// LeetCode 0031: Next Permutation
// Optimal Solution: Narayana Pandita's In-Place Single-Pass Algorithm
// Time Complexity: O(N) | Space Complexity: O(1) Auxiliary Space

class Solution {
  void nextPermutation(List<int> nums) {
    final int n = nums.length;
    if (n <= 1) return;

    // Step 1: Find the first decreasing element from the right (the pivot)
    int i = n - 2;
    while (i >= 0 && nums[i] >= nums[i + 1]) {
      i--;
    }

    // Step 2: If a valid pivot was found, find the smallest element > nums[i] from the right
    if (i >= 0) {
      int j = n - 1;
      // Suffix nums[i + 1 .. n - 1] is non-increasing, so first element > nums[i] from right is successor
      while (nums[j] <= nums[i]) {
        j--;
      }
      _swap(nums, i, j);
    }

    // Step 3: Reverse the non-increasing suffix [i + 1 .. n - 1] to make it ascending (minimal)
    _reverse(nums, i + 1, n - 1);
  }

  void _swap(List<int> nums, int a, int b) {
    final temp = nums[a];
    nums[a] = nums[b];
    nums[b] = temp;
  }

  void _reverse(List<int> nums, int start, int end) {
    int left = start;
    int right = end;
    while (left < right) {
      _swap(nums, left, right);
      left++;
      right--;
    }
  }
}
