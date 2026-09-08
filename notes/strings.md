# 🔤 Strings & Character Manipulation in Dart

In Dart, a `String` is an **immutable** sequence of UTF-16 code units. Because strings are immutable, modifying a string creates a new string in memory.

---

## ⚡ 1. String Efficiency & Gotchas in Dart

| Operation | Complexity | Note |
| :--- | :---: | :--- |
| **Character Access (`s[i]` or `s.codeUnitAt(i)`)** | $O(1)$ | Direct indexed access |
| **Length (`s.length`)** | $O(1)$ | Stored property |
| **Substrings (`s.substring(start, end)`)** | $O(K)$ | Copies $K$ characters |
| **Loop Concatenation (`str += s[i]`)** | $O(N^2)$ | **Avoid!** Creates a new copy on every step |
| **`StringBuffer.write()`** | $O(1)$ amortized | **Recommended**: $O(N)$ total to build strings |
| **ASCII Code Unit** | $O(1)$ | `s.codeUnitAt(i)` (e.g. `'A'` = 65, `'0'` = 48) |

---

## 🧩 2. Core String Patterns

### Pattern A: Two Pointers Inward (Palindrome Checking)

Use two pointers (`left` starting at 0, `right` starting at `s.length - 1`) advancing towards the middle.

```dart
int left = 0;
int right = s.length - 1;

while (left < right) {
  while (left < right && !isAlphaNumeric(s[left])) left++;
  while (left < right && !isAlphaNumeric(s[right])) right--;

  if (s[left].toLowerCase() != s[right].toLowerCase()) {
    return false;
  }
  left++;
  right--;
}
return true;
```

**Solved in Repo**:
- [0125. Valid Palindrome](../easy/0125_valid_palindrome/)

---

### Pattern B: Sliding Window with Hash Set / Map

To find the longest or shortest substring meeting a constraint without duplicate characters:
- Expand `right` pointer to include characters.
- Shrink `left` pointer when a duplicate is encountered.

```dart
// Template: Longest Substring Without Repeating Characters
int left = 0;
int maxLen = 0;
Set<String> seen = {};

for (int right = 0; right < s.length; right++) {
  while (seen.contains(s[right])) {
    seen.remove(s[left]);
    left++;
  }
  seen.add(s[right]);
  maxLen = math.max(maxLen, right - left + 1);
}
return maxLen;
```

**Solved in Repo**:
- [0003. Longest Substring Without Repeating Characters](../medium/0003_longest_substring_without_repeating_characters/)

---

### Pattern C: Character Arithmetic & Base Conversion

Characters map directly to ASCII/Unicode integers:
- Digit to Integer: `c.codeUnitAt(0) - 48` (since `'0'` = 48)
- Letter to Alphabet Rank (1 to 26): `c.codeUnitAt(0) - 65 + 1` (since `'A'` = 65)

```dart
// Base-26 to Integer (Horner's rule)
int result = 0;
for (int i = 0; i < columnTitle.length; i++) {
  int val = columnTitle.codeUnitAt(i) - 65 + 1;
  result = result * 26 + val;
}
return result;
```

**Solved in Repo**:
- [0168. Excel Sheet Column Title](../easy/0168_excel_sheet_column_title/)
- [0171. Excel Sheet Column Number](../easy/0171_excel_sheet_column_number/)
- [0067. Add Binary](../easy/0067_add_binary/)

---

### Pattern D: Prefix & Substring Scanning

Comparing prefixes horizontally or vertically across a list of strings:

**Solved in Repo**:
- [0014. Longest Common Prefix](../easy/0014_longest_common_prefix/)
- [0028. Find the Index of the First Occurrence in a String](../easy/0028_find_the_index_of_the_first_occurrence_in_a_string/)
- [0058. Length of Last Word](../easy/0058_length_of_last_word/)

---

### Pattern E: Fixed 26-Bucket Frequency Array (Anagrams)

When comparing two strings to see if they are anagrams or permutations of each other, **do not sort them ($O(N \log N)$)** and **do not use a `Map<String, int>` (high allocation overhead)**:

```dart
// Template: Valid Anagram check in O(N) time and O(1) space
bool isAnagram(String s, String t) {
  if (s.length != t.length) return false;

  List<int> counts = List.filled(26, 0);

  for (int i = 0; i < s.length; i++) {
    counts[s.codeUnitAt(i) - 97]++; // 'a' is 97
    counts[t.codeUnitAt(i) - 97]--;
  }

  for (int count in counts) {
    if (count != 0) return false;
  }

  return true;
}
```

---

## 💡 3. Dart String Interview Secrets & Tips

### 1. Avoid `RegExp` in Hot Loops
Many developers use `RegExp(r'[a-zA-Z0-9]').hasMatch(char)` inside a loop. **Interviewers consider this suboptimal** because regex compilation and matching has significant overhead.

**Optimal approach**: Check ASCII code units directly:
```dart
bool isAlphaNumeric(int code) {
  return (code >= 48 && code <= 57) ||  // '0' - '9'
         (code >= 65 && code <= 90) ||  // 'A' - 'Z'
         (code >= 97 && code <= 122);   // 'a' - 'z'
}
```
*This executes in 1–2 CPU clock cycles!*

---

### 2. How to Reverse a String in Dart
Dart's `String` does **not** have a `.reverse()` method.

**Option A (Idiomatic Dart)**:
```dart
String reversed = s.split('').reversed.join(); // O(N) time & O(N) space
```

**Option B (Optimal StringBuffer)**:
```dart
StringBuffer sb = StringBuffer();
for (int i = s.length - 1; i >= 0; i--) {
  sb.write(s[i]);
}
String reversed = sb.toString();
```

---

### 3. Case Normalization Without Extra String Allocations
Calling `s[i].toLowerCase()` inside a loop creates thousands of tiny 1-character string objects in memory.

**Bitwise / ASCII Trick**:
- `'A'` is `65` (`01000001` in binary)
- `'a'` is `97` (`01100001` in binary)
- The difference is exactly **32** (`1 << 5`).
- Setting the 5th bit turns uppercase into lowercase:
  ```dart
  int lowerCode = code | 32; // Converts 'A'-'Z' to 'a'-'z'
  ```

---

### 4. String Equality: Dart vs Java
In Java, `s1 == s2` compares memory addresses (requiring `.equals()`).
In **Dart**, `==` automatically checks **structural value equality**:
```dart
"hello" == "hello" // true in Dart!
```
To check alphabetical (lexicographical) order, use:
```dart
s1.compareTo(s2); // returns < 0, 0, or > 0
```

---

### 5. `codeUnitAt(i)` vs `runes` (Surrogate Pairs)
- In Dart, `s.length` counts **UTF-16 code units** (16 bits each).
- Standard English letters, numbers, and punctuation are 1 code unit.
- Emojis (e.g. 🚀, 😊) take **2 code units** (surrogate pairs).
- For LeetCode, inputs are almost always standard ASCII/English, so `s.codeUnitAt(i)` is the fastest and safest approach.

