class Solution {
  int romanToInt(String s) {
    final Map<String, int> roman = {
      'I': 1,
      'V': 5,
      'X': 10,
      'L': 50,
      'C': 100,
      'D': 500,
      'M': 1000,
    };

    int result = 0;

    for (int i = 0; i < s.length; i++) {
      int current = roman[s[i]]!;

      if (i < s.length - 1 && current < roman[s[i + 1]]!) {
        result -= current;
      } else {
        result += current;
      }
    }

    return result;
  }
}