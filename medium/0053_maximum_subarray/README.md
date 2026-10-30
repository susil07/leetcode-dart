# 🚀 LeetCode 0053 - Maximum Subarray

## 📝 Problem Statement

Given an integer array `nums`, find the **subarray** with the largest sum, and return *its sum*.

A **subarray** is a contiguous non-empty sequence of elements within an array.

---

## 🔒 Constraints

- $1 \le \text{nums.length} \le 10^5$
- $-10^4 \le \text{nums}[i] \le 10^4$

---

## 💡 Examples

### Example 1
```text
Input: nums = [-2,1,-3,4,-1,2,1,-5,4]
Output: 6
Explanation: The subarray [4,-1,2,1] has the largest sum 6.
```

### Example 2
```text
Input: nums = [1]
Output: 1
Explanation: The subarray [1] has the largest sum 1.
```

### Example 3
```text
Input: nums = [5,4,-1,7,8]
Output: 23
Explanation: The subarray [5,4,-1,7,8] has the largest sum 23.
```

---

# 📐 Core Mathematical Intuition

### 1. Dynamic Programming Recurrence
Let $dp[i]$ be the maximum subarray sum that **ends at index $i$**.
At index $i$, we face two choices:
1. **Extend** the optimal subarray ending at $i - 1$: $dp[i - 1] + \text{nums}[i]$
2. **Start fresh** at index $i$: $\text{nums}[i]$

$$\mathbf{dp[i] = \max(\text{nums}[i], \; dp[i - 1] + \text{nums}[i]) = \text{nums}[i] + \max(0, \; dp[i - 1])}$$

The overall maximum subarray in the array is:
$$\mathbf{\text{maxSum} = \max_{0 \le i < n} dp[i]}$$

### 2. The Reset Condition (Why Negative Sums are Abandoned)
If $dp[i - 1] < 0$, adding it to $\text{nums}[i]$ will only decrease the sum. Therefore, whenever the running subarray sum drops below zero, it can never contribute positively to any future subarray, and we reset the running sum to start anew at $\text{nums}[i]$.

```text
Index:        0     1     2     3     4     5     6     7     8
Nums:       [-2,    1,   -3,    4,   -1,    2,    1,   -5,    4]
            -----------------------------------------------------
currentSum:  -2     1    -2     4     3     5     6     1     5
maxSum:      -2     1     1     4     4     5     6     6     6
                                ^^^^^^^^^^^^^^^^^
                              Subarray: [4, -1, 2, 1] -> Sum = 6
```

---

# 🧠 Evolution of Solutions: How We Make It Better

```text
┌────────────────────────────────────────────────────────────────────────┐
│  1. Cubic Brute Force                                                  │
│     • Check every pair (i, j); compute sum with a third loop           │
│     • Time: O(N^3) | Space: O(1)                                       │
│     • Bottleneck: Recomputes overlapping sums from scratch (TLE)       │
└──────────────────────────────────┬─────────────────────────────────────┘
                                   │
                                   ▼ Eliminate Inner Loop
┌────────────────────────────────────────────────────────────────────────┐
│  2. Quadratic Brute Force (Cumulative Sum)                             │
│     • Fix starting index i; accumulate running sum as j advances       │
│     • Time: O(N^2) | Space: O(1)                                       │
│     • Bottleneck: For N = 10^5, N^2 = 10^10 operations (Still TLE)     │
└──────────────────────────────────┬─────────────────────────────────────┘
                                   │
                                   ▼ Divide & Conquer / Segment Tree
┌────────────────────────────────────────────────────────────────────────┐
│  3. Divide and Conquer                                                 │
│     • Split array in half: max(leftSub, rightSub, crossSub)            │
│     • Time: O(N log N) | Space: O(log N) stack frames                  │
│     • Value: Crucial for dynamic segment tree range maximum queries    │
└──────────────────────────────────┬─────────────────────────────────────┘
                                   │
                                   ▼ Dynamic Programming Memoization
┌────────────────────────────────────────────────────────────────────────┐
│  4. 1D Dynamic Programming Tabulation                                  │
│     • Store dp[i] = max(nums[i], dp[i-1] + nums[i])                    │
│     • Time: O(N) | Space: O(N) array                                   │
│     • Bottleneck: Array allocation is unnecessary (only dp[i-1] needed)│
└──────────────────────────────────┬─────────────────────────────────────┘
                                   │
                                   ▼ Space Optimization (Kadane's Algorithm)
┌────────────────────────────────────────────────────────────────────────┐
│  5. Kadane's Algorithm (Optimal & Gold Standard)                       │
│     • Maintain two scalar variables: currentSum and maxSum             │
│     • currentSum = max(nums[i], currentSum + nums[i])                  │
│     • Time: O(N) single pass | Space: O(1) strictly scalar             │
│     • Improvement: Maximum cache locality, zero heap allocations       │
└────────────────────────────────────────────────────────────────────────┘
```

---

# 💻 Solutions

## 1. Approach 1: Quadratic Brute Force ($O(N^2)$ Time, $O(1)$ Space)

Considers every possible starting point $i$ and expands to endpoint $j$:

```dart
class SolutionQuadratic {
  int maxSubArray(List<int> nums) {
    int maxSum = nums[0];

    for (int i = 0; i < nums.length; i++) {
      int currentSum = 0;
      for (int j = i; j < nums.length; j++) {
        currentSum += nums[j];
        if (currentSum > maxSum) {
          maxSum = currentSum;
        }
      }
    }

    return maxSum;
  }
}
```

### 🔴 Bottlenecks:
- $O(N^2)$ running time. For $N = 10^5$, this requires $5 \times 10^9$ operations, timing out on LeetCode.

---

## 2. Approach 2: Divide and Conquer ($O(N \log N)$ Time, $O(\log N)$ Space)

Divides the array into two halves at `mid`. The maximum subarray must either:
1. Lie entirely in the left half `[left, mid]`.
2. Lie entirely in the right half `[mid + 1, right]`.
3. Cross through the middle, spanning `mid` and `mid + 1`.

```dart
class SolutionDivideAndConquer {
  int maxSubArray(List<int> nums) {
    return _dnc(nums, 0, nums.length - 1);
  }

  int _dnc(List<int> nums, int left, int right) {
    if (left == right) return nums[left];

    final int mid = left + ((right - left) >> 1);
    final int leftMax = _dnc(nums, left, mid);
    final int rightMax = _dnc(nums, mid + 1, right);
    final int crossMax = _maxCrossing(nums, left, mid, right);

    int max = leftMax > rightMax ? leftMax : rightMax;
    return max > crossMax ? max : crossMax;
  }

  int _maxCrossing(List<int> nums, int left, int mid, int right) {
    int leftSum = -1000000000;
    int sum = 0;
    for (int i = mid; i >= left; i--) {
      sum += nums[i];
      if (sum > leftSum) leftSum = sum;
    }

    int rightSum = -1000000000;
    sum = 0;
    for (int i = mid + 1; i <= right; i++) {
      sum += nums[i];
      if (sum > rightSum) rightSum = sum;
    }

    return leftSum + rightSum;
  }
}
```

### 🟢 Value:
- Demonstrates mastery of divide-and-conquer recurrences: $T(N) = 2T(N/2) + O(N) \implies O(N \log N)$.
- Forms the architectural basis for **Segment Trees** to answer dynamic range maximum subarray sum queries in $O(\log N)$ with updates.

---

## 3. Approach 3: 1D Dynamic Programming Tabulation ($O(N)$ Time, $O(N)$ Space)

Stores the recurrence results in an explicit table `dp`:

```dart
class SolutionDPTabulation {
  int maxSubArray(List<int> nums) {
    final int n = nums.length;
    final List<int> dp = List<int>.filled(n, 0);
    dp[0] = nums[0];
    int maxSum = dp[0];

    for (int i = 1; i < n; i++) {
      dp[i] = (dp[i - 1] > 0 ? dp[i - 1] : 0) + nums[i];
      if (dp[i] > maxSum) {
        maxSum = dp[i];
      }
    }

    return maxSum;
  }
}
```

### 🔴 Bottlenecks:
- Allocates an array of size $10^5$ ($400\text{ KB}$), though only the immediately preceding state `dp[i - 1]` is ever consulted.

---

## 4. Approach 4: Kadane's Algorithm (Optimal & Gold Standard)

Collapses the DP array into a single running accumulator `currentSum`, operating in strictly $O(N)$ time and $O(1)$ auxiliary space:

```dart
// LeetCode 0053: Maximum Subarray
// Optimal Solution: Kadane's Algorithm (Dynamic Programming with O(1) Space)
// Time Complexity: O(N) single-pass
// Space Complexity: O(1) auxiliary space

class Solution {
  int maxSubArray(List<int> nums) {
    // currentSum tracks the maximum subarray sum ending at the current position.
    // maxSum tracks the overall global maximum subarray sum encountered so far.
    int currentSum = nums[0];
    int maxSum = nums[0];

    for (int i = 1; i < nums.length; i++) {
      final int x = nums[i];

      // Kadane's recurrence:
      // Either extend the previous subarray (currentSum + x)
      // or start a fresh subarray at the current element (x).
      currentSum = (currentSum + x > x) ? currentSum + x : x;

      // Update global maximum if current subarray sum exceeds it
      if (currentSum > maxSum) {
        maxSum = currentSum;
      }
    }

    return maxSum;
  }
}
```

### 🟢 Why This is Optimal:
- **Strictly Single-Pass ($O(N)$):** Each element is examined exactly once.
- **Constant Memory ($O(1)$):** Only two scalar registers (`currentSum` and `maxSum`).
- **Optimal Hardware Cache Locality:** Scans sequential memory in order without pointer chasing.

---

## 5. Interview Follow-Up: Reconstructing the Subarray Indices

Often, interviewers follow up with: *"How would you return the actual subarray itself (or its start and end indices)?"*

We track a temporary starting index `tempStart`, and whenever `currentSum` resets to `nums[i]`, we move `tempStart` to `i`. Whenever `maxSum` is updated, we record `[start = tempStart, end = i]`:

```dart
class SolutionWithIndices {
  List<int> maxSubArrayWithIndices(List<int> nums) {
    int currentSum = nums[0];
    int maxSum = nums[0];
    int start = 0, end = 0, tempStart = 0;

    for (int i = 1; i < nums.length; i++) {
      final x = nums[i];
      if (x > currentSum + x) {
        currentSum = x;
        tempStart = i; // Reset start of new candidate subarray
      } else {
        currentSum += x;
      }

      if (currentSum > maxSum) {
        maxSum = currentSum;
        start = tempStart;
        end = i;
      }
    }

    // Return the actual subarray
    return nums.sublist(start, end + 1);
  }
}
```

---

# 📊 Comprehensive Comparison Matrix

| Metric | 1. Quadratic Brute Force | 2. Divide & Conquer | 3. 1D DP Tabulation | 4. Kadane's Algorithm (Optimal) |
| :--- | :--- | :--- | :--- | :--- |
| **Time Complexity** | $O(N^2)$ | $O(N \log N)$ | $O(N)$ | **$O(N)$ Strictly Linear** |
| **Auxiliary Space** | $O(1)$ | $O(\log N)$ stack | $O(N)$ array | **$O(1)$ Pure Registers** |
| **Passes Over Input** | $N$ nested scans | Recursive splitting | 1 pass | **1 unified single pass** |
| **Dynamic Updates** | Infeasible | **Adaptable to Segment Tree** | Recalculate | Recalculate |
| **All Negative Numbers**| Handled | Handled | Handled | **Handled correctly (`nums[0]`)** |
| **Interview Rating** | Rejected (TLE) | Impressive Follow-up | Good | 🏆 **Gold Standard Expected** |

*Where $N = \text{nums.length} \le 10^5$.*

---

# ⚠️ Key Interview Gotchas & Edge Cases

1. **All Negative Numbers Trap:**
   - **Critical bug:** Initializing `maxSum = 0` or `currentSum = 0`.
   - If `nums = [-5, -2, -8, -1, -4]`, the correct maximum subarray sum is `-1` (the single element `[-1]`).
   - If initialized to `0`, the algorithm would incorrectly return `0`.
   - **Correct initialization:** Always initialize `currentSum = nums[0]` and `maxSum = nums[0]`, then start the loop at index `1`.
2. **Single Element Array (`nums = [1]` or `nums = [-10]`):**
   - The loop `for (int i = 1; i < nums.length; i++)` does not execute; immediately returns `nums[0]`.
3. **Subarray vs Subsequence:**
   - A **subarray** must be *contiguous*. If the problem asked for the maximum sum of a non-empty *subsequence*, the answer would simply be the sum of all positive numbers (or the single largest negative number if all are negative).
4. **Integer Overflow Considerations:**
   - Constraints: $N \le 10^5$, $\text{nums}[i] \le 10^4$.
   - Max possible sum: $10^5 \times 10^4 = 10^9$, which fits safely within 32-bit signed integers ($2.14 \times 10^9$) and Dart's 64-bit `int`.
