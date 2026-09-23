# 🚀 LeetCode 0016 - 3Sum Closest

## 📝 Problem Statement

You are given an integer array `nums` of length `n` and an integer `target`.

Find three integers at **distinct indices** in `nums` such that their sum is **closest to `target`**.

Return the sum of the three integers.

You may assume that each input would have **exactly one solution**.

---

## 🔒 Constraints

- $3 \le \text{nums.length} \le 500$
- $-1000 \le \text{nums}[i] \le 1000$
- $-10^4 \le \text{target} \le 10^4$

---

## 💡 Examples

### Example 1
```text
Input: nums = [-1, 2, 1, -4], target = 1
Output: 2
Explanation: The sum that is closest to the target is 2: (-1 + 2 + 1 = 2).
```

### Example 2
```text
Input: nums = [0, 0, 0], target = 1
Output: 0
Explanation: The sum that is closest to the target is 0: (0 + 0 + 0 = 0).
```

### Example 3 (Negative Target & Duplicates)
```text
Input: nums = [4, 0, 5, -5, 3, 3, 0, -4, -5], target = -2
Output: -2
Explanation: (-5 + 3 + 0 = -2), which perfectly equals the target.
```

---

# 🧠 Evolution of Solutions: How We Make It Better

```text
┌────────────────────────────────────────────────────────────────────────┐
│  1. Brute Force (Check All Triplets)                                   │
│     • 3 nested loops checking every combination (i, j, k)              │
│     • Compute |sum - target| and retain minimal distance               │
│     • Time: O(N^3) | Space: O(1)                                       │
│     • Bottleneck: ~500^3 / 6 ≈ 2.08 * 10^7 checks without direction    │
└──────────────────────────────────┬─────────────────────────────────────┘
                                   │
                                   ▼ Sort + Binary Search for Complement
┌────────────────────────────────────────────────────────────────────────┐
│  2. Fix Two + Binary Search Third Complement                           │
│     • Sort array in O(N log N)                                         │
│     • Fix nums[i] and nums[j], then binary search for (target - sum)   │
│     • Time: O(N^2 log N) | Space: O(1)                                 │
│     • Bottleneck: Fixed inner index j doesn't exploit two-way movement │
└──────────────────────────────────┬─────────────────────────────────────┘
                                   │
                                   ▼ Sort + Two Pointers + Greedy Bound Pruning
┌────────────────────────────────────────────────────────────────────────┐
│  3. Sort + Two Pointers with Greedy Bound Pruning (Optimal)            │
│     • Sort array once: O(N log N)                                      │
│     • Fix nums[i], collapse [left, right] inward based on sum sign     │
│     • Greedy Pruning 1: if minSum > target, record & break immediately │
│     • Greedy Pruning 2: if maxSum < target, record & continue to next  │
│     • Time: O(N^2) (average << N^2) | Space: O(1) Auxiliary Space      │
│     • Improvement: In-place skip + instant return on distance 0        │
└────────────────────────────────────────────────────────────────────────┘
```

---

# 💡 Core Insights & Optimizations

### 1. Two-Pointer Convergence
Once `nums` is sorted:
- If `nums[i] + nums[left] + nums[right] < target`: To increase the sum and get closer to `target`, we must increment `left++`.
- If `nums[i] + nums[left] + nums[right] > target`: To decrease the sum and get closer to `target`, we must decrement `right--`.
- If `nums[i] + nums[left] + nums[right] == target`: The distance is $0$, which cannot be improved. Return `target` immediately!

### 2. Greedy Min/Max Bound Pruning (Massive Speedup)
For each fixed index `i`:
- **Smallest Possible Sum**: `minSum = nums[i] + nums[i + 1] + nums[i + 2]`
  - Since the array is sorted, any other pair `(left, right)` with `i < left < right` will yield a sum $\ge minSum$.
  - If `minSum > target`, any other combination in this or subsequent outer iterations $i' > i$ will only produce sums $\ge minSum > target$, moving **strictly farther away** from `target`.
  - Thus, update `closestSum` with `minSum` if closer, and `break` the entire outer loop!
- **Largest Possible Sum**: `maxSum = nums[i] + nums[n - 2] + nums[n - 1]`
  - Any pair chosen with `nums[i]` will yield a sum $\le maxSum$.
  - If `maxSum < target`, all pairs with this `nums[i]` are strictly less than `target`. The one closest to `target` is `maxSum`.
  - Thus, update `closestSum` with `maxSum` if closer, and `continue` immediately to the next `i`!

---

# 💻 Solutions

## 1. Approach 1: Brute Force ($O(N^3)$ Time, $O(1)$ Space)

Check every possible combination of 3 distinct indices:

```dart
class SolutionBruteForce {
  int threeSumClosest(List<int> nums, int target) {
    int closestSum = nums[0] + nums[1] + nums[2];
    final n = nums.length;

    for (int i = 0; i < n; i++) {
      for (int j = i + 1; j < n; j++) {
        for (int k = j + 1; k < n; k++) {
          final currentSum = nums[i] + nums[j] + nums[k];
          if ((currentSum - target).abs() < (closestSum - target).abs()) {
            closestSum = currentSum;
          }
        }
      }
    }

    return closestSum;
  }
}
```

### 🔴 Bottlenecks:
- $O(N^3)$ time complexity: For $N = 500$, evaluates $\binom{500}{3} \approx 20,708,500$ triplets.
- Does not take advantage of sorting or directionality.

---

## 2. Approach 2: Sort + Binary Search for Complement ($O(N^2 \log N)$ Time, $O(1)$ Space)

Fix two elements `nums[i]` and `nums[j]`, then binary search for the complement `target - (nums[i] + nums[j])` in the remaining suffix `nums[j + 1 .. n - 1]`:

```dart
class SolutionBinarySearch {
  int threeSumClosest(List<int> nums, int target) {
    nums.sort();
    final n = nums.length;
    int closestSum = nums[0] + nums[1] + nums[2];

    for (int i = 0; i < n - 2; i++) {
      for (int j = i + 1; j < n - 1; j++) {
        final desired = target - (nums[i] + nums[j]);
        int low = j + 1;
        int high = n - 1;

        while (low <= high) {
          final mid = low + (high - low) ~/ 2;
          final currentSum = nums[i] + nums[j] + nums[mid];

          if (currentSum == target) return target;

          if ((currentSum - target).abs() < (closestSum - target).abs()) {
            closestSum = currentSum;
          }

          if (nums[mid] < desired) {
            low = mid + 1;
          } else {
            high = mid - 1;
          }
        }
      }
    }

    return closestSum;
  }
}
```

### 🔴 Bottlenecks:
- $O(N^2 \log N)$ time: Each pair `(i, j)` still executes an $O(\log N)$ binary search.
- We can do better: fixing only `nums[i]` allows two pointers `left` and `right` to search the remaining array in $O(N)$ total steps instead of $O(N \log N)$.

---

## 3. Approach 3: Sort + Two Pointers with Greedy Bound Pruning (Optimal)

### 💡 How We Make It Better:
1. Fix only `nums[i]`, and search the remaining range with two pointers in $O(N)$ time per iteration $\rightarrow O(N^2)$ total.
2. Add greedy boundary pruning (`minSum` and `maxSum`) to discard entire subproblems instantly.
3. Skip duplicate numbers to avoid evaluating identical window sums.

```dart
class Solution {
  int threeSumClosest(List<int> nums, int target) {
    // 1. Sort the array to enable two-pointer convergence and bound pruning: O(N log N)
    nums.sort();
    final n = nums.length;
    int closestSum = nums[0] + nums[1] + nums[2];

    for (int i = 0; i < n - 2; i++) {
      // Skip duplicate starting numbers to avoid redundant window checks
      if (i > 0 && nums[i] == nums[i - 1]) continue;

      // Bound Pruning 1: Smallest possible sum using nums[i]
      final minSum = nums[i] + nums[i + 1] + nums[i + 2];
      if (minSum > target) {
        if ((minSum - target).abs() < (closestSum - target).abs()) {
          closestSum = minSum;
        }
        // Since array is sorted, any subsequent triplet starting with i' > i
        // will produce a sum >= minSum > target, moving further away from target.
        break;
      }

      // Bound Pruning 2: Largest possible sum using nums[i]
      final maxSum = nums[i] + nums[n - 2] + nums[n - 1];
      if (maxSum < target) {
        if ((target - maxSum).abs() < (closestSum - target).abs()) {
          closestSum = maxSum;
        }
        // No pair with this nums[i] can reach target; largest sum is still < target.
        continue;
      }

      int left = i + 1;
      int right = n - 1;

      while (left < right) {
        final currentSum = nums[i] + nums[left] + nums[right];

        // An exact match has an absolute difference of 0, which cannot be improved.
        if (currentSum == target) {
          return target;
        }

        if ((currentSum - target).abs() < (closestSum - target).abs()) {
          closestSum = currentSum;
        }

        if (currentSum < target) {
          left++;
          // Skip duplicate values for the left pointer
          while (left < right && nums[left] == nums[left - 1]) {
            left++;
          }
        } else {
          right--;
          // Skip duplicate values for the right pointer
          while (left < right && nums[right] == nums[right + 1]) {
            right--;
          }
        }
      }
    }

    return closestSum;
  }
}
```

---

# 🧪 Step-by-Step Dry Run

Input: `nums = [-1, 2, 1, -4], target = 1`  
Sorted: `nums = [-4, -1, 1, 2]`, `closestSum = -4 + (-1) + 1 = -4`

| `i` | `nums[i]` | `left` (`nums[left]`) | `right` (`nums[right]`) | `currentSum` | `|sum - target|` | Action / `closestSum` |
| :---: | :---: | :---: | :---: | :---: | :---: | :--- |
| `0` | `-4` | `1` (`-1`) | `3` (`2`) | $-3$ | $|-3 - 1| = 4$ | Closer than $-4$ (diff 5) $\rightarrow$ `closestSum = -3`. $sum < 1 \rightarrow$ `left++` |
| `0` | `-4` | `2` (`1`) | `3` (`2`) | $-1$ | $|-1 - 1| = 2$ | Closer $\rightarrow$ `closestSum = -1`. $sum < 1 \rightarrow$ `left++` (`left == right`) |
| `1` | `-1` | `2` (`1`) | `3` (`2`) | $2$ | $|2 - 1| = 1$ | Closer $\rightarrow$ `closestSum = 2`. $sum > 1 \rightarrow$ `right--` (`left == right`) |

**Loop finishes $\rightarrow$ Return `closestSum = 2`** 🎉

---

# 📊 Comprehensive Comparison Matrix

| Metric | 1. Brute Force | 2. Binary Search | 3. Two Pointers + Bound Pruning (Optimal) |
| :--- | :--- | :--- | :--- |
| **Time Complexity** | $O(N^3)$ | $O(N^2 \log N)$ | **$O(N^2)$ worst-case, $O(N)$ best-case** |
| **Space Complexity** | $O(1)$ | $O(1)$ | **$O(1)$ auxiliary space** |
| **Early Termination** | ❌ None | ⚠️ Only if exact match found | ✅ **Instant `return` on diff 0 + Min/Max Pruning** |
| **Duplicate Skipping** | ❌ No | ⚠️ Partial | ✅ **In-place skipping across all 3 pointers** |
| **Operations for $N=500$** | $\approx 2 \times 10^7$ | $\approx 1.1 \times 10^6$ | **$\approx 1.2 \times 10^5$ or far fewer with pruning** |
| **Interview Suitability** | ❌ Reject (Naive) | ⚠️ Suboptimal | 🏆 **Gold Standard Expected** |

---

# ⚠️ Key Interview Gotchas & Edge Cases

1. **Exact Match Short-Circuit (`currentSum == target`)**:
   - Because the problem asks for the *closest* sum, an absolute difference of $0$ is globally minimal.
   - Returning `target` immediately avoids scanning the rest of the array.

2. **Negative Target & Negative Differences**:
   - When updating `closestSum`, always use `(currentSum - target).abs() < (closestSum - target).abs()`.
   - Never use signed differences, as $-2$ is closer to $1$ (diff 3) than $-5$ (diff 6).

3. **Safe Initialization of `closestSum`**:
   - Initializing `closestSum = nums[0] + nums[1] + nums[2]` is always safe because $n \ge 3$.
   - Avoid initializing `closestSum = 0` or `closestSum = double.infinity.toInt()`, which can overflow when subtracting negative targets.

4. **Correct Backward Duplicate Check (`nums[i] == nums[i - 1]`)**:
   - Compare with the *previous* element (`i - 1`), not the *next* (`i + 1`), so that the first occurrence is properly evaluated.
