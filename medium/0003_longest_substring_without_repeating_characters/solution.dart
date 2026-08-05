class Solution {
  int lengthOfLongestSubstring(String s) {
    Set<String> window = {};

    int left = 0;
    int maxLength = 0;

    for (int right = 0; right < s.length; right++) {
      while (window.contains(s[right])) {
        window.remove(s[left]);
        left++;
      }

      window.add(s[right]);

      maxLength = maxLength > (right - left + 1)
          ? maxLength
          : (right - left + 1);
    }

    return maxLength;
  }
}