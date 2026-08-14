# 67. Add Binary

**Difficulty:** Easy  
**LeetCode Link:** https://leetcode.com/problems/add-binary/

---

## Problem Statement

Given two binary strings `a` and `b`, return their sum as a binary string.

---

## Example

### Example 1

**Input**

```text
a = "11"
b = "1"
```

**Output**

```text
"100"
```

Explanation

```text
3 + 1 = 4
```

Binary

```text
11 + 1 = 100
```

---

### Example 2

**Input**

```text
a = "1010"
b = "1011"
```

**Output**

```text
"10101"
```

---

## Approach

Traverse both strings from right to left.

- Add corresponding bits.
- Include any carry from the previous addition.
- Store the current bit (`sum % 2`).
- Update carry (`sum ~/ 2`).
- Reverse the result at the end.

---

## Algorithm

1. Start from the last character of both strings.
2. Add current bits and carry.
3. Append `sum % 2` to the result.
4. Update carry using `sum ~/ 2`.
5. Continue until both strings and carry are exhausted.
6. Reverse and return the result.

---

## Dry Run

Input

```text
a = "11"
b = "1"
```

| a | b | Carry | Sum | Result |
|---|---|------|-----|--------|
|1|1|0|2|0|
|1|-|1|2|00|
|-|-|1|1|001|

Reverse

```text
100
```

---

## Complexity Analysis

### Time Complexity

```text
O(max(m, n))
```

where `m` and `n` are the lengths of the two strings.

### Space Complexity

```text
O(max(m, n))
```

for the output string.

---

## Technique Used

- String Traversal
- Carry Propagation
- Simulation

---

## Key Takeaways

- Traverse from the least significant bit.
- Carry works exactly like decimal addition.
- `StringBuffer` is efficient for string building in Dart.
- Reverse the result because bits are added from right to left.

---

## Dart Solution

```dart
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
```