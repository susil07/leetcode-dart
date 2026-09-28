# 🚀 LeetCode 0018 - 4Sum

## 📝 Problem Statement

Given an array `nums` of `n` integers, return an array of all the **unique quadruplets** `[nums[a], nums[b], nums[c], nums[d]]` such that:
- $0 \le a, b, c, d < n$
- $a$, $b$, $c$, and $d$ are **distinct**.
- $nums[a] + nums[b] + nums[c] + nums[d] == target$

You may return the answer in **any order**.

---

## 🔒 Constraints

- $1 \le nums.length \le 200$
- $-10^9 \le nums[i] \le 10^9$
- $-10^9 \le target \le 10^9$

---

## 💡 Examples

### Example 1
```text
Input: nums = [1, 0, -1, 0, -2, 2], target = 0
Output: [[-2, -1, 1, 2], [-2, 0, 0, 2], [-1, 0, 0, 1]]
```

### Example 2
```text
Input: nums = [2, 2, 2, 2, 2], target = 8
Output: [[2, 2, 2, 2]]
```

### Example 3 (Integer Overflow Case)
```text
Input: nums = [1000000000, 1000000000, 1000000000, 1000000000], target = -294967296
Output: []
Explanation: Sum is 4,000,000,000 which does not equal -294,967,296.
```

---

# 🧠 Evolution of Solutions: How We Make It Better

```text
┌────────────────────────────────────────────────────────────────────────┐
│  1. Brute Force with Set Deduplication                                 │
│     • 4 nested loops checking all combinations (a, b, c, d)            │
│     • Store sorted quadruplets in a Set to filter duplicates           │
│     • Time: O(N^4) | Space: O(N)                                       │
│     • Bottleneck: 200^4 ≈ 1.6 * 10^9 operations -> Severe TLE          │
└──────────────────────────────────┬─────────────────────────────────────┘
                                   │
                                   ▼ Pair Sum Hash Map
┌────────────────────────────────────────────────────────────────────────┐
│  2. Pair Sum Hash Map                                                  │
│     • Store pair sums in Map<int, List<Pair>>                          │
│     • Look up complement = target - (nums[i] + nums[j])                │
│     • Time: O(N^2) avg / O(N^3) worst | Space: O(N^2)                  │
│     • Bottleneck: Heavy index overlap checks and secondary set needed  │
└──────────────────────────────────┬─────────────────────────────────────┘
                                   │
                                   ▼ Sort + Two Pointers + Bound Pruning
┌────────────────────────────────────────────────────────────────────────┐
│  3. Sort + Two Pointers with Greedy Bound Pruning (Optimal)            │
│     • Sort array once: O(N log N)                                      │
│     • Fix i and j, use two pointers for left and right                 │
│     • Dual-level min/max bound pruning skips entire subtrees           │
│     • In-place duplicate skipping (zero Set allocations)               │
│     • Time: O(N^3) (average << N^3) | Space: O(1) Auxiliary Space      │
└──────────────────────────────────┬─────────────────────────────────────┘
                                   │
                                   ▼ Generalization
┌────────────────────────────────────────────────────────────────────────┐
│  4. Generalized k-Sum Recursive Reduction                              │
│     • For k > 2, loop and recursively solve (k - 1)-Sum                │
│     • Base case k == 2 solved via Two Pointers                         │
│     • Scales cleanly to 3Sum, 4Sum, ..., k-Sum                         │
│     • Time: O(N^(k - 1)) | Space: O(k) Call Stack                      │
└────────────────────────────────────────────────────────────────────────┘
```

---

# 💡 Core Insights & Optimizations

### 1. Dual-Level Greedy Bound Pruning
For a sorted array of length $n$:
- **At outer loop `i`:**
  - $\text{minSum}_i = nums[i] + nums[i + 1] + nums[i + 2] + nums[i + 3]$
    - If $\text{minSum}_i > target$: Any subsequent triplet with $i' > i$ will only produce even larger sums $\rightarrow$ `break` immediately!
  - $\text{maxSum}_i = nums[i] + nums[n - 3] + nums[n - 2] + nums[n - 1]$
    - If $\text{maxSum}_i < target$: Even paired with the 3 largest numbers in the array, the sum cannot reach $target \rightarrow$ `continue` to $i + 1$.
- **At inner loop `j`:**
  - $\text{minSum}_j = nums[i] + nums[j] + nums[j + 1] + nums[j + 2]$
    - If $\text{minSum}_j > target \rightarrow$ `break` to next $i$.
  - $\text{maxSum}_j = nums[i] + nums[j] + nums[n - 2] + nums[n - 1]$
    - If $\text{maxSum}_j < target \rightarrow$ `continue` to next $j$.

### 2. 64-Bit Integer Arithmetic
In 32-bit languages (Java/C++), four values of $10^9$ sum to $4 \times 10^9$, which overflows a signed 32-bit int ($2^{31} - 1 \approx 2.14 \times 10^9$) into negative values (e.g. $-294967296$).
In Dart, integer types are 64-bit signed integers (up to $\approx 9 \times 10^{18}$), preventing 32-bit overflow naturally.

---

# 💻 Solutions

## 1. Approach 1: Brute Force ($O(N^4)$ Time, $O(N)$ Space)

Check every possible quadruplet using 4 nested loops:

```dart
class SolutionBruteForce {
  List<List<int>> fourSum(List<int> nums, int target) {
    nums.sort();
    final Set<String> seen = {};
    final List<List<int>> result = [];
    final n = nums.length;

    for (int a = 0; a < n; a++) {
      for (int b = a + 1; b < n; b++) {
        for (int c = b + 1; c < n; c++) {
          for (int d = c + 1; d < n; d++) {
            if (nums[a] + nums[b] + nums[c] + nums[d] == target) {
              final key = "${nums[a]},${nums[b]},${nums[c]},${nums[d]}";
              if (!seen.contains(key)) {
                seen.add(key);
                result.add([nums[a], nums[b], nums[c], nums[d]]);
              }
            }
          }
        }
      }
    }

    return result;
  }
}
```

### 🔴 Bottlenecks:
- $O(N^4)$ time: For $N = 200$, evaluates up to $\binom{200}{4} \approx 64,684,950$ combinations $\rightarrow$ **Time Limit Exceeded (TLE)**.

---

## 2. Approach 2: Pair Sum Hash Map ($O(N^2)$ Avg / $O(N^3)$ Worst, $O(N^2)$ Space)

Store all pairs `(nums[a] + nums[b])` into a hash map, then look up `target - (nums[c] + nums[d])`:

```dart
class SolutionHashMap {
  List<List<int>> fourSum(List<int> nums, int target) {
    nums.sort();
    final n = nums.length;
    final Map<int, List<List<int>>> pairMap = {};
    final Set<String> seen = {};
    final List<List<int>> result = [];

    for (int i = 0; i < n; i++) {
      for (int j = i + 1; j < n; j++) {
        final sum = nums[i] + nums[j];
        final complement = target - sum;

        if (pairMap.containsKey(complement)) {
          for (final pair in pairMap[complement]!) {
            // Ensure distinct indices (since sorted: pair[1] < i)
            if (pair[1] < i) {
              final quad = [nums[pair[0]], nums[pair[1]], nums[i], nums[j]];
              final key = quad.join(',');
              if (!seen.contains(key)) {
                seen.add(key);
                result.add(quad);
              }
            }
          }
        }
      }
      for (int j = 0; j < i; j++) {
        final sum = nums[j] + nums[i];
        pairMap.putIfAbsent(sum, () => []).add([j, i]);
      }
    }

    return result;
  }
}
```

### 🔴 Bottlenecks:
- Requires $O(N^2)$ memory to store pair lists.
- Many duplicate pairs create large collision chains, degrading to $O(N^3)$ with heavy string-based deduplication.

---

## 3. Approach 3: Sort + Two Pointers with Greedy Bound Pruning (Optimal)

### 💡 How We Make It Better:
1. Sort the array in $O(N \log N)$ to enable two-pointer convergence and in-place duplicate skipping.
2. Fix indices `i` and `j`, then use two pointers `left = j + 1` and `right = n - 1` to find pairs in $O(N)$.
3. Apply greedy `minSum` and `maxSum` pruning at both levels to bypass millions of unnecessary operations.

```dart
class Solution {
  List<List<int>> fourSum(List<int> nums, int target) {
    final List<List<int>> result = [];
    final int n = nums.length;
    if (n < 4) return result;

    // 1. Sort the array to enable two-pointer convergence and duplicate skipping: O(N log N)
    nums.sort();

    for (int i = 0; i < n - 3; i++) {
      // Skip duplicate values for the first element
      if (i > 0 && nums[i] == nums[i - 1]) continue;

      // Bound Pruning 1: Smallest possible sum with nums[i]
      final minSumI = nums[i] + nums[i + 1] + nums[i + 2] + nums[i + 3];
      if (minSumI > target) break; // All subsequent combinations with i' > i will be even larger

      // Bound Pruning 2: Largest possible sum with nums[i]
      final maxSumI = nums[i] + nums[n - 3] + nums[n - 2] + nums[n - 1];
      if (maxSumI < target) continue; // No combination starting with nums[i] can reach target

      for (int j = i + 1; j < n - 2; j++) {
        // Skip duplicate values for the second element
        if (j > i + 1 && nums[j] == nums[j - 1]) continue;

        // Bound Pruning 1: Smallest possible sum with nums[i] and nums[j]
        final minSumJ = nums[i] + nums[j] + nums[j + 1] + nums[j + 2];
        if (minSumJ > target) break; // All subsequent combinations with j' > j will be even larger

        // Bound Pruning 2: Largest possible sum with nums[i] and nums[j]
        final maxSumJ = nums[i] + nums[j] + nums[n - 2] + nums[n - 1];
        if (maxSumJ < target) continue; // No combination with this (i, j) pair can reach target

        int left = j + 1;
        int right = n - 1;

        while (left < right) {
          final sum = nums[i] + nums[j] + nums[left] + nums[right];

          if (sum == target) {
            result.add([nums[i], nums[j], nums[left], nums[right]]);

            // Skip duplicate values for the third element
            while (left < right && nums[left] == nums[left + 1]) {
              left++;
            }
            // Skip duplicate values for the fourth element
            while (left < right && nums[right] == nums[right - 1]) {
              right--;
            }

            left++;
            right--;
          } else if (sum < target) {
            left++; // Sum too small, move left pointer to increase sum
          } else {
            right--; // Sum too large, move right pointer to decrease sum
          }
        }
      }
    }

    return result;
  }
}
```

---

## 4. Approach 4: Generalized $k$-Sum Template

Any $k$-Sum problem can be solved generically using recursion down to $k = 2$:

```dart
class SolutionKSum {
  List<List<int>> fourSum(List<int> nums, int target) {
    nums.sort();
    return kSum(nums, target, 0, 4);
  }

  List<List<int>> kSum(List<int> nums, int target, int start, int k) {
    final List<List<int>> res = [];
    final int n = nums.length;
    if (start >= n) return res;

    // Pruning: average value must be within [nums[start], nums[n - 1]]
    final int average = target ~/ k;
    if (nums[start] > average || average > nums[n - 1]) return res;

    // Base Case: 2Sum using Two Pointers
    if (k == 2) {
      int left = start;
      int right = n - 1;
      while (left < right) {
        final sum = nums[left] + nums[right];
        if (sum == target) {
          res.add([nums[left], nums[right]]);
          while (left < right && nums[left] == nums[left + 1]) left++;
          while (left < right && nums[right] == nums[right - 1]) right--;
          left++;
          right--;
        } else if (sum < target) {
          left++;
        } else {
          right--;
        }
      }
      return res;
    }

    // Recursive Step for k > 2
    for (int i = start; i < n - k + 1; i++) {
      if (i > start && nums[i] == nums[i - 1]) continue;
      for (final sub in kSum(nums, target - nums[i], i + 1, k - 1)) {
        res.add([nums[i], ...sub]);
      }
    }

    return res;
  }
}
```

---

# 🧪 Step-by-Step Dry Run

Input: `nums = [1, 0, -1, 0, -2, 2], target = 0`  
Sorted: `[-2, -1, 0, 0, 1, 2]`

| `i` (`nums[i]`) | `j` (`nums[j]`) | `left` (`nums[l]`) | `right` (`nums[r]`) | `sum` | Action / Result |
| :---: | :---: | :---: | :---: | :---: | :--- |
| `0` (`-2`) | `1` (`-1`) | `2` (`0`) | `5` (`2`) | $-1 < 0$ | `left++` |
| `0` (`-2`) | `1` (`-1`) | `3` (`0`) | `5` (`2`) | $-1 < 0$ | `left++` |
| `0` (`-2`) | `1` (`-1`) | `4` (`1`) | `5` (`2`) | **$0$** ✅ | **Found `[-2, -1, 1, 2]`**; `left++`, `right--` |
| `0` (`-2`) | `2` (`0`) | `3` (`0`) | `5` (`2`) | **$0$** ✅ | **Found `[-2, 0, 0, 2]`**; `left++`, `right--` |
| `0` (`-2`) | `3` (`0`) | — | — | — | Skip duplicate `nums[3] == nums[2]` |
| `1` (`-1`) | `2` (`0`) | `3` (`0`) | `4` (`1`) | **$0$** ✅ | **Found `[-1, 0, 0, 1]`**; `left++`, `right--` |

**Final Result**: `[[-2, -1, 1, 2], [-2, 0, 0, 2], [-1, 0, 0, 1]]` 🎉

---

# 📊 Comprehensive Comparison Matrix

| Metric | 1. Brute Force | 2. Pair Hash Map | 3. Two Pointers + Bound Pruning (Optimal) | 4. Generalized $k$-Sum |
| :--- | :--- | :--- | :--- | :--- |
| **Time Complexity** | $O(N^4)$ | $O(N^2)$ avg / $O(N^3)$ worst | **$O(N^3)$** | **$O(N^{k-1})$** |
| **Auxiliary Space** | $O(N)$ | $O(N^2)$ | **$O(1)$** | **$O(k)$** |
| **Bound Pruning** | ❌ None | ❌ None | ✅ **Dual-level min/max pruning** | ✅ Average bound check |
| **Deduplication** | String Set | String Set | **In-place index skipping** | **In-place index skipping** |
| **32-Bit Overflow** | Prone | Prone | **Safe (64-bit Dart int)** | **Safe (64-bit Dart int)** |
| **Interview Rating** | ❌ Fail / TLE | ⚠️ Space-heavy | 🏆 **Gold Standard Expected** | 🌟 **Top-Tier / Follow-Up Master** |

---

# ⚠️ Key Interview Gotchas & Edge Cases

1. **Duplicate Skipping Boundary Check (`j > i + 1` vs `j > 0`)**:
   - For the inner loop, check `j > i + 1 && nums[j] == nums[j - 1]`.
   - Checking `j > 0` would mistakenly skip valid duplicate elements between `i` and `j` (e.g. `nums = [2, 2, 2, 2]` where $i=0, j=1$).
2. **Double Pointer Duplicate Skip**:
   - When `sum == target`, skip duplicates on **both** pointers before advancing (`left++` and `right--`).
3. **Empty Input**:
   - If $n < 4$, return `[]` immediately.
