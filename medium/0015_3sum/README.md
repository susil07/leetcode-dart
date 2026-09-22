# 🚀 LeetCode 0015 - 3Sum

## 📝 Problem Statement

Given an integer array `nums`, return all the triplets `[nums[i], nums[j], nums[k]]` such that:
- `i != j`, `i != k`, and `j != k`
- `nums[i] + nums[j] + nums[k] == 0`

**Notice:** The solution set must **not** contain duplicate triplets.

---

## 🔒 Constraints

- $3 \le \text{nums.length} \le 3000$
- $-10^5 \le \text{nums}[i] \le 10^5$

---

## Examples

### Example 1:
```text
Input: nums = [-1, 0, 1, 2, -1, -4]
Output: [[-1, -1, 2], [-1, 0, 1]]
Explanation: 
nums[0] + nums[1] + nums[2] = (-1) + 0 + 1 = 0.
nums[1] + nums[2] + nums[4] = 0 + 1 + (-1) = 0.
nums[0] + nums[3] + nums[4] = (-1) + 2 + (-1) = 0.
The distinct triplets are [-1, 0, 1] and [-1, -1, 2].
Notice that the order of the output and the order of the triplets does not matter.
```

### Example 2:
```text
Input: nums = [0, 1, 1]
Output: []
Explanation: The only possible triplet does not sum up to 0.
```

### Example 3:
```text
Input: nums = [0, 0, 0]
Output: [[0, 0, 0]]
Explanation: The only possible triplet sums up to 0.
```

---

# 🧠 Evolution of Solutions: How We Make It Better

```text
┌────────────────────────────────────────────────────────────────────────┐
│  1. Brute Force with Set Deduplication                                 │
│     • 3 nested loops checking every triplet (i, j, k)                  │
│     • Store sorted triplets in a Set to filter duplicates              │
│     • Time: O(N^3) | Space: O(N)                                       │
│     • Bottleneck: 3000^3 ≈ 2.7 * 10^10 operations -> Severe TLE       │
└──────────────────────────────────┬─────────────────────────────────────┘
                                   │
                                   ▼ Use Two Sum Hash Set
┌────────────────────────────────────────────────────────────────────────┐
│  2. Fix One + Two Sum Hash Set                                         │
│     • Fix nums[i], search for -(nums[i] + nums[j]) using a HashSet     │
│     • Time: O(N^2) | Space: O(N)                                       │
│     • Bottleneck: Still needs an extra Set for duplicate triplets      │
└──────────────────────────────────┬─────────────────────────────────────┘
                                   │
                                   ▼ Sort + Two Pointers (In-Place Deduplication)
┌────────────────────────────────────────────────────────────────────────┐
│  3. Sort + Two Pointers (Optimal Interview Solution)                   │
│     • Sort array once: O(N log N)                                      │
│     • Fix nums[i], use two pointers (left, right)                      │
│     • In-place skipping: if nums[i] == nums[i-1], skip!                │
│     • Time: O(N^2) | Space: O(1) Auxiliary Space                       │
│     • Improvement: Zero HashSets, early pruning if nums[i] > 0         │
└────────────────────────────────────────────────────────────────────────┘
```

---

# 💡 Core Concept: In-Place Deduplication via Sorting

Once `nums` is sorted (e.g. `[-4, -1, -1, 0, 1, 2]`):
1. **Identical numbers are adjacent**. We can avoid duplicate triplets simply by checking if `nums[i] == nums[i - 1]`!
2. **Two Pointers**: If the current sum `nums[i] + nums[left] + nums[right] < 0`, we must increment `left` to increase the sum. If the sum is `> 0`, we decrement `right`.
3. **Early Pruning**: If `nums[i] > 0`, since the array is sorted in ascending order, all subsequent numbers are also positive. The sum of three positive numbers can **never** be zero $\rightarrow$ `break` immediately!

---

# 💻 Solutions

## 1. Approach 1: Brute Force ($O(N^3)$ Time, $O(N)$ Space)

Check every possible triplet and use a `Set<String>` to eliminate duplicates:

```dart
class SolutionBruteForce {
  List<List<int>> threeSum(List<int> nums) {
    nums.sort();
    final Set<String> seen = {};
    final List<List<int>> result = [];
    final n = nums.length;

    for (int i = 0; i < n; i++) {
      for (int j = i + 1; j < n; j++) {
        for (int k = j + 1; k < n; k++) {
          if (nums[i] + nums[j] + nums[k] == 0) {
            final key = "${nums[i]},${nums[j]},${nums[k]}";
            if (!seen.contains(key)) {
              seen.add(key);
              result.add([nums[i], nums[j], nums[k]]);
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
- $O(N^3)$ time complexity: For $N = 3000$, $(3000)^3 \approx 2.7 \times 10^{10}$ operations $\rightarrow$ **Time Limit Exceeded (TLE)**.

---

## 2. Approach 2: Hash Set for Complement Lookup ($O(N^2)$ Time, $O(N)$ Space)

Fix `nums[i]`, then use a Hash Set to find the two-sum complement:

```dart
class SolutionHashSet {
  List<List<int>> threeSum(List<int> nums) {
    nums.sort();
    final Set<String> seenTriplets = {};
    final List<List<int>> result = [];
    final n = nums.length;

    for (int i = 0; i < n - 2; i++) {
      if (nums[i] > 0) break;
      if (i > 0 && nums[i] == nums[i - 1]) continue;

      final Set<int> seenNumbers = {};
      for (int j = i + 1; j < n; j++) {
        final complement = -(nums[i] + nums[j]);
        if (seenNumbers.contains(complement)) {
          final key = "${nums[i]},$complement,${nums[j]}";
          if (!seenTriplets.contains(key)) {
            seenTriplets.add(key);
            result.add([nums[i], complement, nums[j]]);
          }
        }
        seenNumbers.add(nums[j]);
      }
    }

    return result;
  }
}
```

### 🔴 Bottlenecks:
- Allocates a new `Set` on every outer loop iteration.
- Requires string formatting and a secondary `Set` to deduplicate identical triplets.

---

## 3. Approach 3: Sort + Two Pointers (Optimal Interview Solution)

### 💡 How We Make It Better:
By sorting the array, we can use two pointers (`left` and `right`) and skip duplicates **in-place** with zero extra memory!

```dart
class Solution {
  List<List<int>> threeSum(List<int> nums) {
    // 1. Sort array to enable two-pointer traversal & duplicate skipping: O(N log N)
    nums.sort();
    final List<List<int>> result = [];
    final n = nums.length;

    for (int i = 0; i < n - 2; i++) {
      // Early pruning: Since the array is sorted in ascending order,
      // if nums[i] > 0, all following elements are also > 0, making sum 0 impossible.
      if (nums[i] > 0) break;

      // Skip duplicate values for the first element
      if (i > 0 && nums[i] == nums[i - 1]) continue;

      int left = i + 1;
      int right = n - 1;

      while (left < right) {
        final sum = nums[i] + nums[left] + nums[right];

        if (sum == 0) {
          result.add([nums[i], nums[left], nums[right]]);

          // Skip duplicate values for the second element
          while (left < right && nums[left] == nums[left + 1]) {
            left++;
          }
          // Skip duplicate values for the third element
          while (left < right && nums[right] == nums[right - 1]) {
            right--;
          }

          left++;
          right--;
        } else if (sum < 0) {
          left++; // Sum too small, move left pointer to increase sum
        } else {
          right--; // Sum too large, move right pointer to decrease sum
        }
      }
    }

    return result;
  }
}
```

---

# 🧪 Step-by-Step Dry Run

Input: `nums = [-1, 0, 1, 2, -1, -4]`  
Sorted: `[-4, -1, -1, 0, 1, 2]`

| `i` | `nums[i]` | `left` (`nums[left]`) | `right` (`nums[right]`) | `sum` | Action / Result |
| :---: | :---: | :---: | :---: | :---: | :--- |
| `0` | `-4` | `1` (`-1`) | `5` (`2`) | $-3 < 0$ | `left++` |
| `0` | `-4` | `4` (`1`) | `5` (`2`) | $-1 < 0$ | `left++` $\rightarrow$ `left == right` |
| `1` | `-1` | `2` (`-1`) | `5` (`2`) | **$0$** ✅ | **Found `[-1, -1, 2]`**; `left++`, `right--` |
| `1` | `-1` | `3` (`0`) | `4` (`1`) | **$0$** ✅ | **Found `[-1, 0, 1]`**; `left++`, `right--` |
| `2` | `-1` | — | — | — | **Duplicate (`nums[2] == nums[1]`) $\rightarrow$ `continue`** |
| `3` | `0` | `4` (`1`) | `5` (`2`) | $3 > 0$ | `right--` $\rightarrow$ `left == right` |
| `4` | `1` | — | — | — | `nums[4] > 0` $\rightarrow$ **Early `break`!** |

**Final Output:** `[[-1, -1, 2], [-1, 0, 1]]` 🎉

---

# 📊 Comprehensive Comparison Matrix

| Metric | 1. Brute Force | 2. Hash Set | 3. Sort + Two Pointers (Optimal) |
| :--- | :--- | :--- | :--- |
| **Time Complexity** | $O(N^3)$ | $O(N^2)$ | **$O(N^2)$** |
| **Auxiliary Space** | $O(N)$ (Set of triplets) | $O(N)$ (Lookup + Triplet Sets) | **$O(1)$** (Zero extra data structures) |
| **Deduplication Method** | String hash set | String hash set | **In-place index skipping (`while ==`)** |
| **Early Pruning?** | ❌ No | ⚠️ Partial | ✅ **Immediate `break` when `nums[i] > 0`** |
| **Interview Rating** | ❌ TLE / Unacceptable | 👍 Passable | 🏆 **Gold Standard Expected** |

---

# ⚠️ Key Interview Gotchas & Edge Cases

1. **Why `i > 0 && nums[i] == nums[i - 1]` and NOT `nums[i] == nums[i + 1]`?**
   - If you check forward (`nums[i] == nums[i + 1]`), you will skip the first `nums[i]`, which **breaks valid pairs of identical numbers** like `[-1, -1, 2]`!
   - Checking backward (`nums[i] == nums[i - 1]`) ensures you process the first instance and only skip duplicate repetitions.
2. **Advancing BOTH Pointers After Match**:
   When `sum == 0`, after skipping duplicates, you must advance **both** `left++` and `right--`. Advancing only one would make reaching `0` again impossible without a duplicate number.
3. **Empty Output**:
   If $N < 3$ or all elements are positive (e.g. `[1, 2, 3]`), returns `[]` safely.
