class Solution {
  String addBinary(String a, String b) {
    int i = a.length - 1;
    int j = b.length - 1;
    int carry = 0;

    StringBuffer result = StringBuffer();

    while (i >= 0 || j >= 0 || carry > 0) {
      int sum = carry;

      if (i >= 0) {
        sum += a[i] == '1' ? 1 : 0;
        i--;
      }

      if (j >= 0) {
        sum += b[j] == '1' ? 1 : 0;
        j--;
      }

      result.write(sum % 2);
      carry = sum ~/ 2;
    }

    return result.toString().split('').reversed.join();
  }
}