# 🚀 LeetCode 0001 - Two Sum

## 📝 Problem Statement

Given an array of integers `nums` and an integer `target`, return **indices of the two numbers** such that they add up to `target`.

You may assume that each input would have **exactly one solution**, and you may not use the same element twice.

You can return the answer in any order.

---

## 🔒 Constraints

- $2 \le \text{nums.length} \le 10^4$
- $-10^9 \le \text{nums}[i] \le 10^9$
- $-10^9 \le \text{target} \le 10^9$
- **Only one valid answer exists.**

---

## Examples

### Example 1:
**Input:** `nums = [2, 7, 11, 15], target = 9`  
**Output:** `[0, 1]`  
*Explanation:* Because `nums[0] + nums[1] == 9`, we return `[0, 1]`.

---

### Example 2:
**Input:** `nums = [3, 2, 4], target = 6`  
**Output:** `[1, 2]`  
*Explanation:* Because `nums[1] + nums[2] == 6`, we return `[1, 2]`.

---

### Example 3:
**Input:** `nums = [3, 3], target = 6`  
**Output:** `[0, 1]`  

---

# 🧠 Evolution of Solutions: How We Make It Better

```text
┌────────────────────────────────────────────────────────────────────────┐
│  1. Brute Force (Nested Loops)                                         │
│     • Check every possible pair (i, j) with i < j                      │
│     • Time: O(N^2) | Space: O(1)                                       │
│     • Bottleneck: For every element x, scans remaining array in O(N)   │
└──────────────────────────────────┬─────────────────────────────────────┘
                                   │
                                   ▼ Trade Space for Time (O(1) Lookup)
┌────────────────────────────────────────────────────────────────────────┐
│  2. Two-Pass Hash Map                                                  │
│     • Pass 1: Put all (num -> index) into a Map                        │
│     • Pass 2: Check if (target - num) exists in Map and index != i     │
│     • Time: O(N) | Space: O(N)                                         │
│     • Bottleneck: 2 passes + duplicate elements can overwrite map keys │
└──────────────────────────────────┬─────────────────────────────────────┘
                                   │
                                   ▼ Combine Insertion & Search in 1 Pass
┌────────────────────────────────────────────────────────────────────────┐
│  3. One-Pass Hash Map (Optimal Solution)                               │
│     • Check if complement exists in Map BEFORE inserting current num   │
│     • Time: O(N) | Space: O(N)                                         │
│     • Improvement: 1 single pass, zero duplicate overwrite issues      │
└────────────────────────────────────────────────────────────────────────┘
```

---

# 💻 Solutions

## 1. Approach 1: Brute Force ($O(N^2)$ Time, $O(1)$ Space)

Check every possible pair of numbers using two nested loops:

```dart
class SolutionBruteForce {
  List<int> twoSum(List<int> nums, int target) {
    for (int i = 0; i < nums.length; i++) {
      for (int j = i + 1; j < nums.length; j++) {
        if (nums[i] + nums[j] == target) {
          return [i, j];
        }
      }
    }
    return [];
  }
}
```

### 🔴 Bottlenecks:
- **Time Complexity:** $O(N^2)$ — Total comparisons: $\frac{N(N-1)}{2}$. For $N = 10^4$, this requires $\approx 5 \times 10^7$ iterations.
- For each number `x`, we linearly scan the rest of the array just to ask: *"Does `target - x` exist?"*

---

## 2. Approach 2: Two-Pass Hash Map ($O(N)$ Time, $O(N)$ Space)

### 💡 How We Make It Better:
A **Hash Map** provides average **$O(1)$ lookup time**.
Instead of scanning the array linearly to find the complement, we can store values in a Map:

1. **Pass 1**: Store every element and its index in a `Map<int, int>`.
2. **Pass 2**: Iterate through `nums` and check if `complement = target - nums[i]` exists in the Map **and** is not the same index (`map[complement] != i`).

```dart
class SolutionTwoPassMap {
  List<int> twoSum(List<int> nums, int target) {
    final Map<int, int> map = {};

    // Pass 1: Populate map
    for (int i = 0; i < nums.length; i++) {
      map[nums[i]] = i;
    }

    // Pass 2: Check for complement
    for (int i = 0; i < nums.length; i++) {
      final complement = target - nums[i];
      if (map.containsKey(complement) && map[complement] != i) {
        return [i, map[complement]!];
      }
    }

    return [];
  }
}
```

### 🟢 Improvements Over Approach 1:
- Time drops from **$O(N^2)$ to $O(N)$**.

### 🔴 Remaining Issues:
- Requires **two full traversals** of the array.
- Duplicate keys (e.g. `[3, 3]` with target `6`) overwrite the earlier index in Pass 1, which requires extra care.

---

## 3. Approach 3: One-Pass Hash Map (Most Optimal: $O(N)$ Time, $O(N)$ Space)

### 💡 How We Make It Better:
Can we find the pair in **just one single pass**?

Yes! As we iterate through the array:
1. Calculate `complement = target - nums[i]`.
2. Check if `complement` is **already in our map** (i.e. seen in an earlier index).
3. If it exists $\rightarrow$ **return `[map[complement]!, i]` immediately!**
4. If not $\rightarrow$ insert `map[nums[i]] = i` and continue.

```dart
class Solution {
  List<int> twoSum(List<int> nums, int target) {
    // Map to store: number -> its index
    final Map<int, int> numToIndex = {};

    for (int i = 0; i < nums.length; i++) {
      final complement = target - nums[i];

      // If the complement has already been seen, we found our pair!
      if (numToIndex.containsKey(complement)) {
        return [numToIndex[complement]!, i];
      }

      // Record current number for future lookups
      numToIndex[nums[i]] = i;
    }

    return [];
  }
}
```

### 🧪 Step-by-Step Dry Run (`nums = [2, 7, 11, 15], target = 9`):

| Step | `i` | `nums[i]` | `complement` (`9 - nums[i]`) | Map Contents (`numToIndex`) | Complement in Map? | Action |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **1** | `0` | `2` | `7` | `{}` | ❌ No | Add `2 -> 0` to map |
| **2** | `1` | `7` | `2` | `{2: 0}` | ✅ **Yes!** (at index `0`) | **Return `[0, 1]`** 🎉 |

### 🟢 Why One-Pass is Superior:
1. **Single Pass**: Solves the problem in a single traversal, often finishing well before reaching the end of the array.
2. **Naturally Handles Duplicates**: For `nums = [3, 3], target = 6`:
   - At `i = 0`: `nums[0] = 3`, complement `3` is not yet in map $\rightarrow$ insert `{3: 0}`.
   - At `i = 1`: `nums[1] = 3`, complement `3` **is** in map at index `0` $\rightarrow$ returns `[0, 1]` immediately before any key collision occurs!

---

## 4. Approach 4: Sorting + Two Pointers ($O(N \log N)$ Time, $O(N)$ Space)

If the array were already sorted (as in **LeetCode 167: Two Sum II**), we could use **Two Pointers** in $O(1)$ space.
However, because here we must return the **original indices**, sorting requires tracking original indices with extra pairs:

```dart
class SolutionTwoPointers {
  List<int> twoSum(List<int> nums, int target) {
    // Pair each number with its original index
    final indexedNums = List.generate(nums.length, (i) => [nums[i], i]);

    // Sort by value: O(N log N)
    indexedNums.sort((a, b) => a[0].compareTo(b[0]));

    int left = 0;
    int right = nums.length - 1;

    while (left < right) {
      final currentSum = indexedNums[left][0] + indexedNums[right][0];

      if (currentSum == target) {
        return [indexedNums[left][1], indexedNums[right][1]];
      } else if (currentSum < target) {
        left++;
      } else {
        right--;
      }
    }

    return [];
  }
}
```

---

# 📊 Comprehensive Comparison Matrix

| Metric | 1. Brute Force | 2. Two-Pass Hash Map | 3. One-Pass Hash Map (Optimal) | 4. Sorting + Two Pointers |
| :--- | :--- | :--- | :--- | :--- |
| **Time Complexity** | $O(N^2)$ | $O(N)$ | **$O(N)$** | $O(N \log N)$ |
| **Space Complexity** | **$O(1)$** | $O(N)$ | **$O(N)$** | $O(N)$ (index tracking) |
| **Number of Passes** | $\frac{N(N-1)}{2}$ comparisons | 2 passes | **1 single pass** | 1 sort + 1 scan |
| **Handles Duplicates** | Trivial | Needs `index != i` check | **Seamless (auto-resolved)** | Handled |
| **Interview Rating** | ⚠️ Naive Baseline | 👍 Good intermediate | 🏆 **Gold Standard** | 💡 Great follow-up discussion |

---

# ⚠️ Key Interview Gotchas & Edge Cases

1. **Cannot Use Same Element Twice**:
   If `nums = [3, 2, 4]` and `target = 6`, returning `[0, 0]` because `3 + 3 = 6` is **wrong**. In the one-pass approach, we check the map *before* adding the current element, completely preventing self-pairing.
2. **Duplicate Values**:
   `nums = [3, 3], target = 6` $\rightarrow$ both numbers have the same value. The one-pass hash map finds the first `3` at index `0` when processing the second `3` at index `1`.
3. **Negative Numbers & Zero**:
   `nums = [-3, 4, 3, 90], target = 0` $\rightarrow$ `complement = 0 - (-3) = 3`. Subtraction handles signs naturally without any special casing.