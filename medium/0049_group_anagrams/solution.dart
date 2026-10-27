// LeetCode 0049: Group Anagrams
// Optimal Solution: Linear-Time Character Frequency Hashing with Reusable Buffer
// Time Complexity: O(N * K) where N = strs.length, K = max(strs[i].length)
// Space Complexity: O(N * K) auxiliary space for hash map and output groups

class Solution {
  List<List<String>> groupAnagrams(List<String> strs) {
    final Map<String, List<String>> groups = {};
    // Reusable frequency buffer of size 26 for lowercase English letters ('a' - 'z')
    final List<int> counts = List<int>.filled(26, 0);

    for (final s in strs) {
      counts.fillRange(0, 26, 0);
      final int len = s.length;

      // Count character occurrences in O(K) time
      for (int i = 0; i < len; i++) {
        counts[s.codeUnitAt(i) - 97]++; // 97 is ASCII code for 'a'
      }

      // Generate a canonical 26-character signature key from frequency code units
      final String key = String.fromCharCodes(counts);
      groups.putIfAbsent(key, () => []).add(s);
    }

    return groups.values.toList();
  }
}
