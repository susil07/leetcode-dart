// LeetCode 0005: Longest Palindromic Substring
// Optimal Interview Solution: Expand Around Center - O(N^2) Time, O(1) Space

class Solution {
  String longestPalindrome(String s) {
    if (s.length <= 1) return s;

    int start = 0;
    int maxLength = 1;

    for (int i = 0; i < s.length; i++) {
      // 1. Odd-length palindromes (single character center at i)
      final len1 = _expandAroundCenter(s, i, i);

      // 2. Even-length palindromes (two character center at i, i + 1)
      final len2 = _expandAroundCenter(s, i, i + 1);

      final currentMax = len1 > len2 ? len1 : len2;

      if (currentMax > maxLength) {
        maxLength = currentMax;
        // Derivation: For both odd and even length, start is:
        // i - (currentMax - 1) ~/ 2
        start = i - (currentMax - 1) ~/ 2;
      }
    }

    return s.substring(start, start + maxLength);
  }

  /// Expands outward from [left] and [right] while characters match.
  /// Returns the length of the palindrome found.
  int _expandAroundCenter(String s, int left, int right) {
    while (left >= 0 && right < s.length && s[left] == s[right]) {
      left--;
      right++;
    }
    // Palindrome boundaries are [left + 1, right - 1]
    // Length = (right - 1) - (left + 1) + 1 = right - left - 1
    return right - left - 1;
  }
}
