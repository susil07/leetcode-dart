// LeetCode 0017: Letter Combinations of a Phone Number
// Optimal Solution: DFS Backtracking with Pre-Allocated Code-Unit Buffer
// Time Complexity: O(4^N * N) | Space Complexity: O(N) Auxiliary Space (ignoring output)

class Solution {
  // Mapping of digits '0'-'9' to their telephone keypad letters.
  // Using a flat array gives O(1) direct access with zero hash collision overhead.
  static const List<String> _phoneMap = [
    '',     // 0
    '',     // 1
    'abc',  // 2
    'def',  // 3
    'ghi',  // 4
    'jkl',  // 5
    'mno',  // 6
    'pqrs', // 7
    'tuv',  // 8
    'wxyz', // 9
  ];

  List<String> letterCombinations(String digits) {
    // Edge case: Empty input string must return an empty list []
    if (digits.isEmpty) return [];

    final int n = digits.length;
    final List<String> result = [];

    // Pre-allocated contiguous code-unit buffer of length N.
    // Eliminates intermediate string concatenations during recursive traversal.
    final List<int> buffer = List<int>.filled(n, 0);

    void backtrack(int index) {
      // Base case: All digits have been mapped to letters
      if (index == n) {
        result.add(String.fromCharCodes(buffer));
        return;
      }

      // Convert digit character to integer index (ASCII '0' is 48)
      final letters = _phoneMap[digits.codeUnitAt(index) - 48];

      // Explore all letter choices for the current digit
      for (int i = 0; i < letters.length; i++) {
        buffer[index] = letters.codeUnitAt(i);
        backtrack(index + 1);
      }
    }

    backtrack(0);
    return result;
  }
}
