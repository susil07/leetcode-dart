# 🚀 LeetCode 0011 - Container With Most Water

## 📝 Problem Statement

You are given an integer array `height` of length `n`. There are `n` vertical lines drawn such that the two endpoints of the $i$-th line are `(i, 0)` and `(i, height[i])`.

Find two lines that together with the x-axis form a container, such that the container contains the **most water**.

Return the **maximum amount of water a container can store**.

**Notice:** You may not slant the container.

---

## 🔒 Constraints

- $n == \text{height.length}$
- $2 \le n \le 10^5$
- $0 \le \text{height}[i] \le 10^4$

---

## Examples

### Example 1:
```text
Input: height = [1, 8, 6, 2, 5, 4, 8, 3, 7]
Output: 49
Explanation: The vertical lines are represented by array [1, 8, 6, 2, 5, 4, 8, 3, 7].
The max area of water is formed between index 1 (height 8) and index 8 (height 7).
Width = 8 - 1 = 7
Height = min(8, 7) = 7
Area = 7 * 7 = 49
```

### Visual Diagram:
```text
8 ┆   █               █
7 ┆   █ ~ ~ ~ ~ ~ ~ ~ █ ~ ~ █   <--- Water level bounded by min(8, 7) = 7
6 ┆   █   █           █     █
5 ┆   █   █       █   █     █
4 ┆   █   █   █   █   █     █
3 ┆   █   █   █   █   █ █   █
2 ┆   █   █ █ █   █   █ █   █
1 ┆ █ █   █ █ █   █   █ █   █
0 └─┴─┴─┴─┴─┴─┴─┴─┴─┴─┴─┴─┴─┴─
    0 1 2 3 4 5 6 7 8
      ▲                     ▲
     left                 right
     Width = 8 - 1 = 7
     Height = min(8, 7) = 7
     Area = 7 * 7 = 49
```

---

### Example 2:
```text
Input: height = [1, 1]
Output: 1
```

---

# 🧠 Evolution of Solutions: How We Make It Better

```text
┌────────────────────────────────────────────────────────────────────────┐
│  1. Brute Force (Check All Pairs)                                      │
│     • Evaluate Area(i, j) for all 0 <= i < j < n                       │
│     • Time: O(N^2) | Space: O(1)                                       │
│     • Bottleneck: 10^10 operations for N = 10^5 -> TLE                 │
└──────────────────────────────────┬─────────────────────────────────────┘
                                   │
                                   ▼ Greedy Two Pointers Elimination
┌────────────────────────────────────────────────────────────────────────┐
│  2. Standard Two Pointers                                              │
│     • Start at widest ends (left = 0, right = n - 1)                   │
│     • Move the pointer with the SHORTER height inward                  │
│     • Time: O(N) | Space: O(1)                                         │
│     • Improvement: Cuts search space from O(N^2) to single pass        │
└──────────────────────────────────┬─────────────────────────────────────┘
                                   │
                                   ▼ Skip Suboptimal Heights
┌────────────────────────────────────────────────────────────────────────┐
│  3. Two Pointers with Greedy Plateau Pruning (Optimal)                 │
│     • Fast-forward past lines shorter than or equal to current minHeight│
│     • Time: O(N) with lower constant factor | Space: O(1)              │
│     • Improvement: Skips unnecessary area calculations completely      │
└────────────────────────────────────────────────────────────────────────┘
```

---

# 💡 Mathematical Proof: Why Move the Shorter Pointer?

The area formula is:
$$\text{Area} = (right - left) \times \min(height[left], height[right])$$

Suppose $height[left] < height[right]$.
- The current height is strictly limited by $height[left]$.
- If we keep $left$ fixed and move $right$ inward:
  - The **width** $(right - left)$ strictly **decreases**.
  - The **effective height** can never exceed $height[left]$ (it's at best $height[left]$ or even smaller).
  - Therefore, $\text{Area} = \text{smaller width} \times (\le height[left]) < \text{current Area}$.
- **Conclusion**: Moving the taller pointer inward can **NEVER** produce a larger area! All pairs involving this shorter boundary are mathematically dominated.
- Hence, the **only possibility** of finding a larger area is to discard the shorter line and move $left$ inward.

---

# 💻 Solutions

## 1. Approach 1: Brute Force ($O(N^2)$ Time, $O(1)$ Space)

Examine every possible pair of lines and track the maximum area.

```dart
class SolutionBruteForce {
  int maxArea(List<int> height) {
    int maxWater = 0;

    for (int i = 0; i < height.length; i++) {
      for (int j = i + 1; j < height.length; j++) {
        final width = j - i;
        final h = height[i] < height[j] ? height[i] : height[j];
        final area = width * h;
        if (area > maxWater) {
          maxWater = area;
        }
      }
    }

    return maxWater;
  }
}
```

### 🔴 Bottleneck:
- For $N = 10^5$, $\frac{N(N-1)}{2} \approx 5 \times 10^9$ operations $\rightarrow$ **Time Limit Exceeded (TLE)**.

---

## 2. Approach 2: Standard Two Pointers ($O(N)$ Time, $O(1)$ Space)

Start with maximum width (`left = 0, right = n - 1`) and greedily advance the shorter line inward.

```dart
class SolutionTwoPointers {
  int maxArea(List<int> height) {
    int left = 0;
    int right = height.length - 1;
    int maxWater = 0;

    while (left < right) {
      final width = right - left;
      final minHeight = height[left] < height[right] ? height[left] : height[right];
      final currentArea = width * minHeight;

      if (currentArea > maxWater) {
        maxWater = currentArea;
      }

      if (height[left] < height[right]) {
        left++;
      } else {
        right--;
      }
    }

    return maxWater;
  }
}
```

---

## 3. Approach 3: Two Pointers with Greedy Plateau Pruning (Most Optimal)

### 💡 How We Make It Better:
When we advance a pointer, if the next line is **shorter than or equal to** the line we just had, its area can never exceed the previous area (since both width and height decreased or stayed the same).
We can skip those lines in a tight inner loop:

```dart
class Solution {
  int maxArea(List<int> height) {
    int left = 0;
    int right = height.length - 1;
    int maxWater = 0;

    while (left < right) {
      final width = right - left;
      final minHeight = height[left] < height[right] ? height[left] : height[right];
      final currentArea = width * minHeight;

      if (currentArea > maxWater) {
        maxWater = currentArea;
      }

      // Skip lines that cannot possibly beat currentArea
      if (height[left] < height[right]) {
        while (left < right && height[left] <= minHeight) {
          left++;
        }
      } else {
        while (left < right && height[right] <= minHeight) {
          right--;
        }
      }
    }

    return maxWater;
  }
}
```

### 🟢 Improvements Over Approach 2:
- Same $O(N)$ asymptotic complexity, but skips redundant multiplications and comparisons on plateaus.
- Zero extra memory allocations ($O(1)$ auxiliary space).

---

# 📊 Comprehensive Comparison Matrix

| Metric | 1. Brute Force | 2. Standard Two Pointers | 3. Two Pointers + Pruning (Optimal) |
| :--- | :--- | :--- | :--- |
| **Time Complexity** | $O(N^2)$ | $O(N)$ | **$O(N)$** *(Lowest constant factor)* |
| **Space Complexity** | **$O(1)$** | **$O(1)$** | **$O(1)$** |
| **Comparisons for $N=10^5$** | $\approx 5 \times 10^9$ (TLE) | At most $10^5$ | **$\le 10^5$ (Skips flat regions)** |
| **Extra Allocations** | 0 bytes | 0 bytes | **0 bytes** |
| **Interview Rating** | ⚠️ Naive Baseline | 👍 Accepted | 🏆 **Optimal Production Standard** |

---

# ⚠️ Key Interview Gotchas & Edge Cases

1. **Equal Heights (`height[left] == height[right]`)**:
   Moving either pointer (or moving both) is valid because neither line can produce a larger area with any inner line bounded by the other.
2. **Zero Heights (`height[i] == 0`)**:
   Area is simply 0; algorithm naturally skips 0-height boundaries.
3. **Minimum Length $N = 2$**:
   Loop executes exactly once, computing the only possible container area.
