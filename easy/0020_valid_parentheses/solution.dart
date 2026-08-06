class Solution {
  bool isValid(String s) {
    List<String> stack = [];

    Map<String, String> pairs = {
      ')': '(',
      '}': '{',
      ']': '[',
    };

    for (String ch in s.split('')) {
      if (ch == '(' || ch == '{' || ch == '[') {
        stack.add(ch);
      } else {
        if (stack.isEmpty || stack.removeLast() != pairs[ch]) {
          return false;
        }
      }
    }

    return stack.isEmpty;
  }
}