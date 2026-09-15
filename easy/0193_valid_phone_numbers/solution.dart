// In-Memory Dart Implementation of Regex Filtering
// Simulating LeetCode 193: Valid Phone Numbers

class Solution {
  static final RegExp _phoneRegex = RegExp(
    r'^([0-9]{3}-|\([0-9]{3}\) )[0-9]{3}-[0-9]{4}$',
  );

  List<String> validPhoneNumbers(List<String> lines) {
    return lines.where((line) => _phoneRegex.hasMatch(line)).toList();
  }
}
