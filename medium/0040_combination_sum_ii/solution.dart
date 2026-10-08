// LeetCode 0040: Combination Sum II
// Optimal Solution: Backtracking with Sorting, Early Pruning, and Sibling Deduplication
// Time Complexity: O(2^N) in the worst case (tightly bounded by pruning)
// Space Complexity: O(N) auxiliary space for recursion call stack and current path

class Solution {
  List<List<int>> combinationSum2(List<int> candidates, int target) {
    // 1. Sorting clusters identical elements together and enables early pruning
    candidates.sort();

    final List<List<int>> results = [];
    final List<int> currentCombination = [];

    void backtrack(int remainingTarget, int startIndex) {
      // Base Case: Target sum matched
      if (remainingTarget == 0) {
        results.add(List<int>.from(currentCombination));
        return;
      }

      for (int i = startIndex; i < candidates.length; i++) {
        final candidate = candidates[i];

        // Pruning: Since the list is sorted in ascending order, if the current
        // candidate exceeds remainingTarget, all subsequent candidates will too.
        if (candidate > remainingTarget) {
          break;
        }

        // Deduplication: Skip duplicate candidates at the SAME recursion level/depth.
        // Elements are only skipped if i > startIndex (i.e. not the first candidate explored
        // in this loop), ensuring identical values can still be picked across DIFFERENT levels.
        if (i > startIndex && candidate == candidates[i - 1]) {
          continue;
        }

        currentCombination.add(candidate);
        // Each number may only be used ONCE, so advance to i + 1
        backtrack(remainingTarget - candidate, i + 1);
        currentCombination.removeLast(); // Backtrack
      }
    }

    backtrack(target, 0);
    return results;
  }
}
