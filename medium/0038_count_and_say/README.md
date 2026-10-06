# 🚀 LeetCode 0038 - Count and Say

## 📝 Problem Statement

The **count-and-say** sequence is a sequence of digit strings defined by the recursive formula:

- $\text{countAndSay}(1) = \text{"1"}$
- $\text{countAndSay}(n)$ is the **run-length encoding** (RLE) of $\text{countAndSay}(n - 1)$.

### Run-Length Encoding (RLE)
Run-length encoding is a string compression method that replaces each maximal group of consecutive identical characters with the concatenation of the count of the group followed by the character itself.

For example, to compress `"3322251"`:
- `"33"` becomes `"23"` (two `'3'`s)
- `"222"` becomes `"32"` (three `'2'`s)
- `"5"` becomes `"15"` (one `'5'`)
- `"1"` becomes `"11"` (one `'1'`)
- Result: `"23321511"`

Given a positive integer $n$, return the $n^{\text{th}}$ element of the **count-and-say** sequence.

---

## 🔒 Constraints

- $1 \le n \le 30$

---

## 💡 Examples

### Example 1
```text
Input: n = 4
Output: "1211"
Explanation:
countAndSay(1) = "1"
countAndSay(2) = RLE of "1"      = "11"
countAndSay(3) = RLE of "11"     = "21"
countAndSay(4) = RLE of "21"     = "1211"
```

### Example 2
```text
Input: n = 1
Output: "1"
Explanation: Base case.
```

### Example 3
```text
Input: n = 5
Output: "111221"
Explanation:
countAndSay(4) = "1211"
One '1', one '2', two '1's -> "111221"
```

---

## 🔬 Mathematical Curiosity: Conway's Constant & "Audioactive Decay"

The Count and Say sequence was extensively analyzed by the mathematician **John Conway**:
1. **Conway's Constant ($\lambda$):** As $n \to \infty$, the ratio of the length of the $n^{\text{th}}$ term to the $(n-1)^{\text{th}}$ term converges to an algebraic constant of degree 71:
   $$\lambda \approx 1.303577269\dots$$
   Each term grows approximately $30.36\%$ longer than the preceding term.
2. **The "No 4" Rule:** Starting from `"1"`, the digit `4` (or greater) **never appears** in the sequence. The only digits that will ever exist are `1`, `2`, and `3`. No run of identical characters ever exceeds length 3.

---

# 🧠 Evolution of Solutions: How We Make It Better

```text
┌────────────────────────────────────────────────────────────────────────┐
│  1. Naive Recursive with String Concatenation (+)                      │
│     • Recurse to n - 1, then build RLE via string concatenation (+)    │
│     • Time: O(sum(L_i^2)) | Space: O(sum(L_i)) + Call Stack O(n)       │
│     • Bottleneck: Immutability of strings copies bytes on every +      │
└──────────────────────────────────┬─────────────────────────────────────┘
                                   │
                                   ▼ Eliminate Recursion Overhead
┌────────────────────────────────────────────────────────────────────────┐
│  2. Iterative with Two Pointers & String Concat                        │
│     • Loop from 2 to n sequentially                                    │
│     • Time: O(sum(L_i^2)) | Space: O(L_n)                              │
│     • Bottleneck: Still creates excessive intermediate string objects  │
└──────────────────────────────────┬─────────────────────────────────────┘
                                   │
                                   ▼ Eliminate String Copying Allocations
┌────────────────────────────────────────────────────────────────────────┐
│  3. Iterative with StringBuffer & codeUnitAt (Optimal)                 │
│     • Scan character code units directly with codeUnitAt(i)            │
│     • Build next string using StringBuffer.write / writeCharCode       │
│     • Time: O(sum(L_i)) | Space: O(L_n)                                │
│     • Improvement: O(1) amortized appends, zero intermediate strings   │
└──────────────────────────────────┬─────────────────────────────────────┘
                                   │
                                   ▼ Production / High-Throughput Lookup
┌────────────────────────────────────────────────────────────────────────┐
│  4. Precomputed Static Cache (Lookup Table)                            │
│     • Since 1 <= n <= 30, precompute all 30 sequence terms once        │
│     • Time: O(1) query time | Space: O(1) heap per call                │
│     • Improvement: Instantaneous O(1) returns for repeated queries     │
└────────────────────────────────────────────────────────────────────────┘
```

---

# 💻 Solutions

## 1. Approach 1: Naive Recursive with String Concatenation ($O(\sum L_i^2)$ Time, $O(\sum L_i)$ Space)

A straightforward implementation mirroring the problem's mathematical definition recursively.

```dart
class SolutionNaiveRecursive {
  String countAndSay(int n) {
    if (n == 1) return '1';

    final prev = countAndSay(n - 1);
    String result = '';
    int i = 0;

    while (i < prev.length) {
      int count = 1;
      while (i + 1 < prev.length && prev[i] == prev[i + 1]) {
        count++;
        i++;
      }
      // String concatenation creates a brand-new string on every append
      result = result + '$count${prev[i]}';
      i++;
    }

    return result;
  }
}
```

### 🔴 Bottlenecks:
- **String Immutability:** In Dart, strings are immutable. Doing `result = result + ...` copies all accumulated characters into a newly allocated string on every run of digits.
- **Call Stack:** Incurs $O(n)$ recursion call stack frames.

---

## 2. Approach 2: Iterative with Two Pointers & String Slicing ($O(\sum L_i^2)$ Time, $O(L_n)$ Space)

Eliminates the recursive call stack by iterating from $2$ to $n$:

```dart
class SolutionIterativeNaive {
  String countAndSay(int n) {
    String current = '1';

    for (int step = 2; step <= n; step++) {
      String next = '';
      int i = 0;

      while (i < current.length) {
        int count = 1;
        while (i + 1 < current.length && current[i] == current[i + 1]) {
          count++;
          i++;
        }
        next += '$count${current[i]}';
        i++;
      }

      current = next;
    }

    return current;
  }
}
```

### 🔴 Bottlenecks:
- Iterative loop removes recursion depth overhead, but repeated string concatenations still result in quadratic copying cost per term.

---

## 3. Approach 3: Iterative with `StringBuffer` and `codeUnitAt` (Optimal)

To achieve maximum performance:
1. **`StringBuffer`**: Pre-allocates expandable memory and appends in amortized $O(1)$ without allocating temporary strings.
2. **`codeUnitAt(i)`**: Reads 16-bit integer UTF-16 code units directly from memory instead of allocating 1-character substring objects with `[]`.
3. **`writeCharCode`**: Appends the digit code unit directly to the buffer.

```dart
// LeetCode 0038: Count and Say
// Optimal Solution: Iterative Run-Length Encoding with StringBuffer
// Time Complexity: O(sum(L_i)) where L_i is length at step i | Space Complexity: O(L_n)

class Solution {
  String countAndSay(int n) {
    if (n <= 1) return '1';

    String current = '1';

    for (int step = 2; step <= n; step++) {
      final buffer = StringBuffer();
      final len = current.length;
      int i = 0;

      while (i < len) {
        int count = 1;
        // Count consecutive identical digits
        while (i + 1 < len && current.codeUnitAt(i) == current.codeUnitAt(i + 1)) {
          count++;
          i++;
        }

        // Append count and the digit character
        buffer.write(count);
        buffer.writeCharCode(current.codeUnitAt(i));
        i++;
      }

      current = buffer.toString();
    }

    return current;
  }
}
```

### 🟢 Why This is Optimal:
- **Zero intermediate string allocations:** Only one `StringBuffer` is allocated per iteration step.
- **Linear processing time per step:** Each character is examined at most twice (by the lookahead pointer and then by incrementing `i`). Total time is strictly bounded by $\sum_{k=1}^n L_k$.
- **Zero external imports:** Uses core Dart language primitives.

---

## 4. Approach 4: Precomputed Static Table (High-Throughput / System Design Follow-Up)

Because $1 \le n \le 30$ and the sequence is completely deterministic and immutable, a static list can be initialized once at startup:

```dart
class SolutionPrecomputed {
  static final List<String> _cache = _precompute();

  static List<String> _precompute() {
    final list = List<String>.filled(31, '');
    list[1] = '1';

    for (int step = 2; step <= 30; step++) {
      final prev = list[step - 1];
      final buffer = StringBuffer();
      final len = prev.length;
      int i = 0;

      while (i < len) {
        int count = 1;
        while (i + 1 < len && prev.codeUnitAt(i) == prev.codeUnitAt(i + 1)) {
          count++;
          i++;
        }
        buffer.write(count);
        buffer.writeCharCode(prev.codeUnitAt(i));
        i++;
      }

      list[step] = buffer.toString();
    }

    return list;
  }

  String countAndSay(int n) => _cache[n];
}
```

### 🟢 Advantages:
- Any subsequent query executes in **$O(1)$ time**.
- Ideal when `countAndSay` is queried frequently across multiple requests.

---

# 📊 Comprehensive Comparison Matrix

| Metric | 1. Naive Recursive | 2. Iterative Naive | 3. StringBuffer + codeUnitAt (Optimal) | 4. Static Precomputation |
| :--- | :--- | :--- | :--- | :--- |
| **Time Complexity** | $O\left(\sum L_i^2\right)$ | $O\left(\sum L_i^2\right)$ | **$O\left(\sum L_i\right)$** | **$O(1)$ per query** ($O\left(\sum_{1}^{30} L_i\right)$ once) |
| **Auxiliary Space** | $O\left(\sum L_i\right) + O(n)$ call stack | $O(L_n)$ | **$O(L_n)$** | **$O(1)$ per query** ($O(\text{total cache})$ once) |
| **String Allocations** | Heavy (thousands of small strings) | Heavy | **Minimal (1 buffer per step)** | **Zero per query** |
| **Traversal Method** | String indexing `prev[i]` | String indexing `current[i]` | **`codeUnitAt(i)` & `writeCharCode`** | Table lookup |
| **Max String Length ($n=30$)** | 4,462 chars | 4,462 chars | 4,462 chars | 4,462 chars |
| **Interview Rating** | Acceptable for basic recursion | Suboptimal | 🏆 **Gold Standard Expected** | 🚀 **Outstanding Follow-Up** |

---

# ⚠️ Key Interview Gotchas & Edge Cases

1. **1-Indexed Input:**
   - The sequence starts at $n = 1$ with `"1"`. $n = 0$ is not in the constraints ($1 \le n \le 30$).
2. **Order of Output ("Count" then "Say"):**
   - A common slip-up is appending the character before the count (e.g., `"11"` instead of `"21"` for two `'1'`s). The rule is strictly: `count` followed by `digit`.
3. **Handling the Last Run:**
   - Notice how `i` is incremented in `while (i + 1 < len && ...)`: after the inner loop finishes, `i` sits on the *last* duplicate character. Appending `count` and `current[i]` and then doing `i++` guarantees the final group is properly written without an extra post-loop condition.
4. **Strings vs Integer Overflows:**
   - Even though $n$ is up to 30, the string length reaches 4,462 characters, far exceeding 64-bit integer limits if stored numerically. It must be processed strictly as digit strings.
