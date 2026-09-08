class Solution {
  int titleToNumber(String columnTitle) {
    int result = 0;

    for (int i = 0; i < columnTitle.length; i++) {
      int value = columnTitle.codeUnitAt(i) - 65 + 1;
      result = result * 26 + value;
    }

    return result;
  }
}
