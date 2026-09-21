// LeetCode 0012: Integer to Roman
// Optimal Solution: Greedy Value-Symbol Decomposition
// Time Complexity: O(1) [at most 15 operations since num <= 3999]
// Space Complexity: O(1) Auxiliary Space

class Solution {
  String intToRoman(int num) {
    // 13 unique Roman numeral values including subtractive forms
    const values = [
      1000, 900, 500, 400,
      100,  90,  50,  40,
      10,   9,   5,   4,
      1,
    ];

    const symbols = [
      'M',  'CM', 'D',  'CD',
      'C',  'XC', 'L',  'XL',
      'X',  'IX', 'V',  'IV',
      'I',
    ];

    final buffer = StringBuffer();

    // Greedily match and subtract the largest possible Roman value
    for (int i = 0; i < values.length && num > 0; i++) {
      while (num >= values[i]) {
        buffer.write(symbols[i]);
        num -= values[i];
      }
    }

    return buffer.toString();
  }
}
