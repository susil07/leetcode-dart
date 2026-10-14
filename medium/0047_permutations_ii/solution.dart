// LeetCode 0047: Permutations II
// Optimal Solution: Backtracking with Sorting and Predecessor-Used Deduplication
// Time Complexity: O(N * (N! / (n1! * n2! * ... * nk!))) where N = nums.length
// Space Complexity: O(N) auxiliary space for recursion stack and used array

class Solution {
  List<List<int>> permuteUnique(List<int> nums) {
    // Sorting clusters identical elements together so duplicates are adjacent
    nums.sort();

    final List<List<int>> results = [];
    final List<int> current = [];
    final List<bool> used = List<bool>.filled(nums.length, false);

    void backtrack() {
      // Base case: a complete unique permutation of length N has been formed
      if (current.length == nums.length) {
        results.add(List<int>.from(current));
        return;
      }

      for (int i = 0; i < nums.length; i++) {
        // Skip already selected elements in the current permutation path
        if (used[i]) continue;

        // Deduplication rule:
        // If the current element equals the previous element, we only permit
        // picking it if the previous identical element is ALREADY USED in the current branch.
        // If !used[i - 1], it means nums[i - 1] was previously picked and backtracked out,
        // so picking nums[i] here would begin an identical duplicate subtree at this level.
        if (i > 0 && nums[i] == nums[i - 1] && !used[i - 1]) {
          continue;
        }

        used[i] = true;
        current.add(nums[i]);

        backtrack();

        current.removeLast(); // Backtrack
        used[i] = false;
      }
    }

    backtrack();
    return results;
  }
}
