# 🚀 LeetCode 0005 - Longest Palindromic Substring

## 📝 Problem Statement

Given a string `s`, return the **longest palindromic substring** in `s`.

A **palindrome** is a string that reads the same backward as forward.

---

## 🔒 Constraints

- `1 <= s.length <= 1000`
- `s` consists of only digits and English letters.

---

## Examples

### Example 1:
**Input:**
```text
s = "babad"
```
**Output:**
```text
"bab"
```
*Explanation:* `"aba"` is also a valid answer.

---

### Example 2:
**Input:**
```text
s = "cbbd"
```
**Output:**
```text
"bb"
```

---

# 🧠 Evolution of Solutions: How We Make It Better

```text
┌────────────────────────────────────────────────────────────────────────┐
│  1. Brute Force                                                        │
│     • Generate all O(N^2) substrings and check each in O(N)            │
│     • Total: O(N^3) Time | O(1) Space                                  │
│     • Bottleneck: Repeatedly re-verifying overlapping substrings       │
└──────────────────────────────────┬─────────────────────────────────────┘
                                   │
                                   ▼ Memoize Palindromic Subproblems
┌────────────────────────────────────────────────────────────────────────┐
│  2. 2D Dynamic Programming                                             │
│     • dp[i][j] = (s[i] == s[j]) && dp[i+1][j-1]                        │
│     • Total: O(N^2) Time | O(N^2) Space                                │
│     • Bottleneck: Allocating a 1000x1000 2D matrix (Memory heavy)      │
└──────────────────────────────────┬─────────────────────────────────────┘
                                   │
                                   ▼ Eliminate 2D Matrix (Expand Outward)
┌────────────────────────────────────────────────────────────────────────┐
│  3. Expand Around Center (Recommended Interview Optimal)               │
│     • Treat each of the 2N - 1 centers (odd & even) and expand outward │
│     • Total: O(N^2) Time | O(1) Auxiliary Space                        │
│     • Improvement: Zero matrix allocations, fast cache locality        │
└──────────────────────────────────┬─────────────────────────────────────┘
                                   │
                                   ▼ Linear Time Optimization
┌────────────────────────────────────────────────────────────────────────┐
│  4. Manacher's Algorithm (Advanced Linear Time)                        │
│     • Exploit palindrome symmetry to skip redundant expansions         │
│     • Total: O(N) Time | O(N) Space                                    │
│     • Improvement: Strictly linear time (optimal for massive strings)  │
└────────────────────────────────────────────────────────────────────────┘
```

---

# 💻 Solutions

## 1. Approach 1: Brute Force ($O(N^3)$)

Check all $\frac{N(N+1)}{2}$ substrings, and verify whether each is a palindrome.

```dart
class SolutionBruteForce {
  String longestPalindrome(String s) {
    if (s.length <= 1) return s;

    String longest = s[0];

    for (int i = 0; i < s.length; i++) {
      for (int j = i + 1; j <= s.length; j++) {
        final sub = s.substring(i, j);
        if (sub.length > longest.length && _isPalindrome(sub)) {
          longest = sub;
        }
      }
    }

    return longest;
  }

  bool _isPalindrome(String s) {
    int left = 0, right = s.length - 1;
    while (left < right) {
      if (s[left] != s[right]) return false;
      left++;
      right--;
    }
    return true;
  }
}
```

### 🔴 Bottlenecks:
- Time: $O(N^3)$ — For $N = 1000$, $N^3 = 10^9$ operations $\rightarrow$ **Time Limit Exceeded (TLE)**.

---

## 2. Approach 2: 2D Dynamic Programming ($O(N^2)$ Time, $O(N^2)$ Space)

### 💡 How We Make It Better:
Notice that `s[i..j]` is a palindrome if and only if:
1. `s[i] == s[j]`, AND
2. The inner substring `s[i+1..j-1]` is also a palindrome!

We can store previously computed subproblem answers in a boolean table `dp[i][j]`.

```dart
class SolutionDP {
  String longestPalindrome(String s) {
    final n = s.length;
    if (n <= 1) return s;

    // dp[i][j] indicates whether s[i..j] is a palindrome
    final dp = List.generate(n, (_) => List<bool>.filled(n, false));

    int start = 0;
    int maxLen = 1;

    // All substrings of length 1 are palindromes
    for (int i = 0; i < n; i++) {
      dp[i][i] = true;
    }

    // Check substrings of length >= 2
    for (int len = 2; len <= n; len++) {
      for (int i = 0; i <= n - len; i++) {
        final j = i + len - 1;

        if (s[i] == s[j]) {
          if (len == 2 || dp[i + 1][j - 1]) {
            dp[i][j] = true;
            if (len > maxLen) {
              start = i;
              maxLen = len;
            }
          }
        }
      }
    }

    return s.substring(start, start + maxLen);
  }
}
```

### 🟢 Improvements Over Approach 1:
- Reduces time from $O(N^3)$ to $O(N^2)$.

### 🔴 Remaining Bottlenecks:
- Allocates an $N \times N$ matrix ($O(N^2)$ space), which consumes substantial memory for large strings and hurts cache locality.

---

## 3. Approach 3: Expand Around Center (Optimal Interview Solution)

### 💡 How We Make It Better:
A palindrome mirrors around its center. Instead of storing a huge $O(N^2)$ matrix, we can **expand outward from every possible center in $O(1)$ space**!

There are $2N - 1$ centers in a string of length $N$:
- **$N$ odd-length centers**: centered on a single character (`i`, `i`)
- **$N - 1$ even-length centers**: centered between two characters (`i`, `i + 1`)

```text
Odd Center (length 3):        Even Center (length 4):
       left   right                  left   right
         ▼     ▼                       ▼     ▼
     [ b  a  b ]                 [ c  b  b  d ]
          ▲                             ▲ ▲
        center                        center
```

```dart
class Solution {
  String longestPalindrome(String s) {
    if (s.length <= 1) return s;

    int start = 0;
    int maxLength = 1;

    for (int i = 0; i < s.length; i++) {
      // 1. Odd-length palindromes (center at i)
      final len1 = _expandAroundCenter(s, i, i);

      // 2. Even-length palindromes (center between i and i + 1)
      final len2 = _expandAroundCenter(s, i, i + 1);

      final currentMax = len1 > len2 ? len1 : len2;

      if (currentMax > maxLength) {
        maxLength = currentMax;
        // Formula valid for both odd and even lengths:
        start = i - (currentMax - 1) ~/ 2;
      }
    }

    return s.substring(start, start + maxLength);
  }

  int _expandAroundCenter(String s, int left, int right) {
    while (left >= 0 && right < s.length && s[left] == s[right]) {
      left--;
      right++;
    }
    // Palindrome boundaries are [left + 1, right - 1]
    return right - left - 1;
  }
}
```

### 🟢 Improvements Over Approach 2:
- Space reduced from **$O(N^2)$ to $O(1)$**.
- Runs in a fraction of the time because character mismatches abort expansions early.

---

## 4. Approach 4: Manacher's Algorithm ($O(N)$ Linear Time)

### 💡 How We Make It Better (Theoretical Peak):
Manacher's algorithm avoids re-checking characters by leveraging **symmetry** within an already discovered palindrome window:
1. Pre-process the string with delimiters (e.g. `^#a#b#a#$`) so that all palindromes have an odd length.
2. Maintain the current center `C` and the rightmost boundary `R` reached so far.
3. For index `i`, its mirror is `i' = 2*C - i`. If `i < R`, we can initialize `P[i] = min(R - i, P[i'])` without expanding from scratch!

```dart
class SolutionManacher {
  String longestPalindrome(String s) {
    if (s.length <= 1) return s;

    // Transform s: "aba" -> "^#a#b#a#$"
    final sb = StringBuffer('^');
    for (int i = 0; i < s.length; i++) {
      sb.write('#${s[i]}');
    }
    sb.write('#\$');
    final t = sb.toString();

    final p = List<int>.filled(t.length, 0);
    int center = 0, right = 0;
    int maxLen = 0, centerIndex = 0;

    for (int i = 1; i < t.length - 1; i++) {
      final iMirror = 2 * center - i;

      if (right > i) {
        p[i] = (right - i < p[iMirror]) ? right - i : p[iMirror];
      }

      while (t[i + 1 + p[i]] == t[i - 1 - p[i]]) {
        p[i]++;
      }

      if (i + p[i] > right) {
        center = i;
        right = i + p[i];
      }

      if (p[i] > maxLen) {
        maxLen = p[i];
        centerIndex = i;
      }
    }

    final start = (centerIndex - 1 - maxLen) ~/ 2;
    return s.substring(start, start + maxLen);
  }
}
```

---

# 📊 Comprehensive Comparison Matrix

| Approach | Time Complexity | Space Complexity | Extra Allocations | Interview Preference |
| :--- | :--- | :--- | :--- | :--- |
| **1. Brute Force** | $O(N^3)$ | $O(1)$ | High (substrings) | ⚠️ Baseline only (TLE on LeetCode) |
| **2. Dynamic Programming** | $O(N^2)$ | $O(N^2)$ | $N \times N$ matrix | Good theoretical DP exercise |
| **3. Expand Around Center** | **$O(N^2)$** *(Fast in practice)* | **$O(1)$** | **None (0 bytes)** | 🏆 **Gold Standard for Interviews** |
| **4. Manacher's Algorithm** | **$O(N)$** | $O(N)$ | $2N + 3$ array | 🌟 Elite / Advanced competitive programming |

---

# ⚠️ Key Interview Gotchas & Edge Cases

1. **Even vs. Odd Palindrome Lengths**:
   Always check both `(i, i)` (odd length like `"aba"`) and `(i, i + 1)` (even length like `"abba"`).
2. **The Start Index Formula**:
   ```dart
   start = i - (currentMax - 1) ~/ 2;
   ```
   * Why this works for both:
     - Odd: length 3, center at `i = 1`: `start = 1 - (3 - 1) ~/ 2 = 0` ✅
     - Even: length 4, center at `i = 1, 2`: `start = 1 - (4 - 1) ~/ 2 = 0` ✅
3. **Strings with Length 1**:
   Strings of length $\le 1$ are always palindromes; handle this base case upfront in $O(1)$.
