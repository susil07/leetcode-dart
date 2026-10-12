// LeetCode 0046: Permutations
// Optimal Solution: In-Place Swap Backtracking
// Time Complexity: O(N * N!) where N = nums.length
// Space Complexity: O(N) auxiliary space for recursion stack (excluding output)

class Solution {
  List<List<int>> permute(List<int> nums) {
    final List<List<int>> results = [];
    final int n = nums.length;

    // Recursively fix elements from index `first` to `n - 1`
    void backtrack(int first) {
      // Base case: all positions fixed, record a snapshot copy
      if (first == n) {
        results.add(List<int>.from(nums));
        return;
      }

      for (int i = first; i < n; i++) {
        // Place nums[i] at position `first`
        final temp = nums[first];
        nums[first] = nums[i];
        nums[i] = temp;

        // Recurse to place remaining candidates at position `first + 1`
        backtrack(first + 1);

        // Backtrack: restore original array state for subsequent iterations
        nums[i] = nums[first];
        nums[first] = temp;
      }
    }

    backtrack(0);
    return results;
  }
}
