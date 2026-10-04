# 🚀 LeetCode 0034 - Find First and Last Position of Element in Sorted Array

## 📝 Problem Statement

Given an array of integers `nums` sorted in non-decreasing order, find the starting and ending position of a given `target` value.

If `target` is not found in the array, return `[-1, -1]`.

You must write an algorithm with **$O(\log n)$ runtime complexity**.

---

## 🔒 Constraints

- $0 \le \text{nums.length} \le 10^5$
- $-10^9 \le \text{nums}[i] \le 10^9$
- `nums` is a non-decreasing array.
- $-10^9 \le \text{target} \le 10^9$

---

## 💡 Examples

### Example 1
```text
Input: nums = [5, 7, 7, 8, 8, 10], target = 8
Output: [3, 4]
```

### Example 2
```text
Input: nums = [5, 7, 7, 8, 8, 10], target = 6
Output: [-1, -1]
```

### Example 3
```text
Input: nums = [], target = 0
Output: [-1, -1]
```

---

# 🧠 Evolution of Solutions: How We Make It Better

```text
┌────────────────────────────────────────────────────────────────────────┐
│  1. Linear Scan                                                        │
│     • Iterate left-to-right to find first, then right-to-left for last │
│     • Time: O(N) | Space: O(1)                                         │
│     • Bottleneck: Fails the explicit interview requirement for O(log N)│
└──────────────────────────────────┬─────────────────────────────────────┘
                                   │
                                   ▼ Binary Search + Linear Expansion
┌────────────────────────────────────────────────────────────────────────┐
│  2. Binary Search + Linear Bidirectional Expansion                     │
│     • Use standard binary search to find any occurrence at mid         │
│     • Expand outward linearly: while (nums[left] == target) left--     │
│     • Time: O(log N) best / O(N) worst | Space: O(1)                   │
│     • Bottleneck: When all elements equal target [8, 8, 8, ...],       │
│       expansion degenerates to O(N), failing worst-case complexity!    │
└──────────────────────────────────┬─────────────────────────────────────┘
                                   │
                                   ▼ Dual Binary Search for Strict Bounds
┌────────────────────────────────────────────────────────────────────────┐
│  3. Dual Binary Search (Optimal Interview Standard)                    │
│     • Search 1 (Lower Bound): When nums[mid] == target, record mid     │
│       and search LEFT (right = mid - 1) to find the first occurrence   │
│     • Early Exit: If first == -1, target doesn't exist -> return [-1,-1│
│     • Search 2 (Upper Bound): When nums[mid] == target, record mid     │
│       and search RIGHT (left = mid + 1) to find the last occurrence    │
│     • Time: O(log N) guaranteed worst-case | Space: O(1)               │
└────────────────────────────────────────────────────────────────────────┘
```

---

# 💡 Core Concept: Modified Binary Search for Range Boundaries

Standard binary search stops immediately upon finding `nums[mid] == target`.  
To find **boundaries**, we record `bound = mid` and **continue searching**:

```text
Array: [5, 7, 7, 8, 8, 10], target = 8

Finding First Position (Search Left):
  Left = 0, Right = 5, Mid = 2 (val = 7 < 8)   --> Left = 3
  Left = 3, Right = 5, Mid = 4 (val = 8 == 8)  --> bound = 4, Right = 3
  Left = 3, Right = 3, Mid = 3 (val = 8 == 8)  --> bound = 3, Right = 2
  Left = 3 > Right = 2 --> Loop ends. First index = 3 ✅

Finding Last Position (Search Right):
  Left = 0, Right = 5, Mid = 2 (val = 7 < 8)   --> Left = 3
  Left = 3, Right = 5, Mid = 4 (val = 8 == 8)  --> bound = 4, Left = 5
  Left = 5, Right = 5, Mid = 5 (val = 10 > 8)  --> Right = 4
  Left = 5 > Right = 4 --> Loop ends. Last index = 4 ✅

Result: [3, 4] 🎉
```

---

# 💻 Solutions

## 1. Approach 1: Linear Scan ($O(N)$ Time, $O(1)$ Space)

Scan the entire array:

```dart
class SolutionLinear {
  List<int> searchRange(List<int> nums, int target) {
    int first = -1;
    int last = -1;

    for (int i = 0; i < nums.length; i++) {
      if (nums[i] == target) {
        if (first == -1) first = i;
        last = i;
      }
    }

    return [first, last];
  }
}
```

### 🔴 Bottlenecks:
- $O(N)$ time: Evaluates all $10^5$ elements, failing the problem's $O(\log n)$ requirement.

---

## 2. Approach 2: Binary Search + Linear Expansion ($O(N)$ Worst-Case, $O(1)$ Space)

Find one occurrence with binary search, then expand left and right:

```dart
class SolutionExpand {
  List<int> searchRange(List<int> nums, int target) {
    int left = 0;
    int right = nums.length - 1;
    int mid = -1;

    while (left <= right) {
      final m = left + (right - left) ~/ 2;
      if (nums[m] == target) {
        mid = m;
        break;
      } else if (nums[m] < target) {
        left = m + 1;
      } else {
        right = m - 1;
      }
    }

    if (mid == -1) return [-1, -1];

    int first = mid;
    while (first > 0 && nums[first - 1] == target) first--;

    int last = mid;
    while (last < nums.length - 1 && nums[last + 1] == target) last++;

    return [first, last];
  }
}
```

### 🔴 Bottlenecks:
- If `nums` contains $10^5$ copies of `target` (`[8, 8, 8, ..., 8]`), the while loops expand linearly through the entire array, collapsing complexity to **$O(N)$**.

---

## 3. Approach 3: Dual Binary Search for Exact Boundaries (Optimal)

Use binary search for both the starting and ending indices:

```dart
class Solution {
  List<int> searchRange(List<int> nums, int target) {
    // 1. Find the first occurrence (lower bound)
    final first = _findBound(nums, target, isFirst: true);

    // If target is not present at all, return [-1, -1] immediately
    if (first == -1) {
      return [-1, -1];
    }

    // 2. Find the last occurrence (upper bound)
    final last = _findBound(nums, target, isFirst: false);

    return [first, last];
  }

  int _findBound(List<int> nums, int target, {required bool isFirst}) {
    int left = 0;
    int right = nums.length - 1;
    int bound = -1;

    while (left <= right) {
      final mid = left + (right - left) ~/ 2;

      if (nums[mid] == target) {
        bound = mid;
        if (isFirst) {
          // Narrow search to the left half to find earlier occurrences
          right = mid - 1;
        } else {
          // Narrow search to the right half to find later occurrences
          left = mid + 1;
        }
      } else if (nums[mid] < target) {
        left = mid + 1;
      } else {
        right = mid - 1;
      }
    }

    return bound;
  }
}
```

---

# 📊 Comprehensive Comparison Matrix

| Metric | 1. Linear Scan | 2. Binary Search + Linear Expansion | 3. Dual Binary Search (Optimal) |
| :--- | :--- | :--- | :--- |
| **Time Complexity** | $O(N)$ | $O(\log N)$ best / $O(N)$ worst | **$O(\log N)$ guaranteed** |
| **Auxiliary Space** | $O(1)$ | $O(1)$ | **$O(1)$** |
| **Worst-Case on `[8, 8, 8, 8]`** | $10^5$ operations | $10^5$ operations (Degrades) | **$\approx 34$ operations ($2 \times \log_2 10^5$)** |
| **Early Termination** | ❌ None | ⚠️ Partial | ✅ **Exits after 1st search if target absent** |
| **Interview Rating** | ❌ Unacceptable | ⚠️ Common Trapped Mistake | 🏆 **Gold Standard Expected** |

---

# ⚠️ Key Interview Gotchas & Edge Cases

1. **The Linear Expansion Trap**:
   - Many candidates find `target` with binary search and then use a `while` loop to scan left and right.
   - Interviewers intentionally test inputs like $10^5$ identical elements to fail these solutions with TLE.
2. **Early Return Optimization**:
   - If the first binary search returns `-1`, we know with 100% certainty that the element is not in the array. Skipping the second search saves half the execution time for missing targets.
3. **Empty Array (`nums = []`)**:
   - Handled cleanly without extra checks because `left = 0` and `right = -1`, which terminates the `while (left <= right)` loop immediately and returns `[-1, -1]`.
