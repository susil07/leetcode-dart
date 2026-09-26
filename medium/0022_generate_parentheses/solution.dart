// LeetCode 0022: Generate Parentheses
// Optimal Solution: Backtracking with Invariant Constraints & Pre-Allocated Character Buffer
// Time Complexity: O(4^n / sqrt(n)) ~ O(C_n) | Space Complexity: O(n) Auxiliary Space

class Solution {
  List<String> generateParenthesis(int n) {
    final List<String> result = [];
    // Pre-allocated contiguous code-unit buffer of fixed length 2 * n.
    // Eliminates intermediate string concatenations during recursion
    // and works out of the box on LeetCode without external imports.
    final List<int> buffer = List<int>.filled(2 * n, 0);
    const int openParen = 40;  // ASCII code for '('
    const int closeParen = 41; // ASCII code for ')'

    void backtrack(int index, int openCount, int closeCount) {
      // Base case: Exactly n pairs (2n characters) have been placed
      if (index == 2 * n) {
        result.add(String.fromCharCodes(buffer));
        return;
      }

      // Invariant 1: Can place '(' if we haven't used all n opening brackets
      if (openCount < n) {
        buffer[index] = openParen;
        backtrack(index + 1, openCount + 1, closeCount);
      }

      // Invariant 2: Can place ')' only if count of ')' is strictly less than '('
      if (closeCount < openCount) {
        buffer[index] = closeParen;
        backtrack(index + 1, openCount, closeCount + 1);
      }
    }

    backtrack(0, 0, 0);
    return result;
  }
}
