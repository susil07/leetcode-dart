// LeetCode 0039: Combination Sum
// Optimal Solution: Backtracking with Sorting and Branch Pruning
// Time Complexity: O(N^(T/M)) where N = candidates.length, T = target, M = min(candidates)
// Space Complexity: O(T/M) for recursion call stack and current combination path

class Solution {
  List<List<int>> combinationSum(List<int> candidates, int target) {
    // Sorting allows early pruning: once candidates[i] > remainingTarget,
    // all subsequent candidates will also exceed remainingTarget.
    candidates.sort();

    final List<List<int>> results = [];
    final List<int> currentCombination = [];

    void backtrack(int remainingTarget, int startIndex) {
      // Base Case: Target sum achieved
      if (remainingTarget == 0) {
        results.add(List<int>.from(currentCombination));
        return;
      }

      for (int i = startIndex; i < candidates.length; i++) {
        final candidate = candidates[i];

        // Pruning: Since the array is sorted ascending, if the current candidate
        // exceeds remainingTarget, all subsequent candidates will also exceed it.
        if (candidate > remainingTarget) {
          break;
        }

        currentCombination.add(candidate);
        // We pass `i` (not `i + 1`) to allow the same element to be chosen
        // an unlimited number of times.
        backtrack(remainingTarget - candidate, i);
        currentCombination.removeLast(); // Backtrack
      }
    }

    backtrack(target, 0);
    return results;
  }
}
