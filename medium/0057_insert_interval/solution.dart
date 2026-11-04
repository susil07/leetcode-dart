// LeetCode 0057: Insert Interval
// Optimal Solution: Three-Phase Linear Scan
// Time Complexity: O(N) single-pass
// Space Complexity: O(N) auxiliary space to construct the result list

class Solution {
  List<List<int>> insert(List<List<int>> intervals, List<int> newInterval) {
    final List<List<int>> result = [];
    final int n = intervals.length;
    int i = 0;

    // Phase 1: Add all intervals that come strictly before newInterval (no overlap)
    // Condition: interval's end is strictly less than newInterval's start
    while (i < n && intervals[i][1] < newInterval[0]) {
      result.add(intervals[i]);
      i++;
    }

    // Phase 2: Merge all overlapping intervals into newInterval
    // Condition: interval's start is less than or equal to newInterval's end
    while (i < n && intervals[i][0] <= newInterval[1]) {
      if (intervals[i][0] < newInterval[0]) {
        newInterval[0] = intervals[i][0];
      }
      if (intervals[i][1] > newInterval[1]) {
        newInterval[1] = intervals[i][1];
      }
      i++;
    }
    // Add the merged newInterval
    result.add(newInterval);

    // Phase 3: Add all remaining intervals that come strictly after newInterval
    while (i < n) {
      result.add(intervals[i]);
      i++;
    }

    return result;
  }
}
