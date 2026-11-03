// LeetCode 0056: Merge Intervals
// Optimal Solution: Sort by Start Coordinate + Single Linear Merge Scan
// Time Complexity: O(N log N) where N = intervals.length (dominated by sorting)
// Space Complexity: O(N) for the output list (or O(log N) auxiliary sorting space)

class Solution {
  List<List<int>> merge(List<List<int>> intervals) {
    if (intervals.length <= 1) return intervals;

    // 1. Sort intervals ascending by start time
    intervals.sort((a, b) => a[0].compareTo(b[0]));

    final List<List<int>> merged = [];
    // Initialize merged list with the first interval
    merged.add(intervals[0]);

    // 2. Iterate through remaining intervals and merge overlapping intervals
    for (int i = 1; i < intervals.length; i++) {
      final List<int> current = intervals[i];
      final List<int> last = merged.last;

      // If the current interval's start falls within the previous interval's range,
      // they overlap: extend the previous interval's end if current reaches further.
      if (current[0] <= last[1]) {
        if (current[1] > last[1]) {
          last[1] = current[1];
        }
      } else {
        // Disjoint interval: no overlap, push as a new merged segment
        merged.add(current);
      }
    }

    return merged;
  }
}
