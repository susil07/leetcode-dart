# 🚀 LeetCode 169 - Majority Element

## 📝 Problem Statement

Given an array `nums` of size `n`, return the **majority element**.

The **majority element** is the element that appears more than `⌊n / 2⌋` times. You may assume that the majority element always exists in the array.

---

## Example 1

Input:

```text
nums = [3, 2, 3]
```

Output:

```text
3
```

Explanation:
`3` appears 2 times, which is more than `⌊3 / 2⌋ = 1`.

---

## Example 2

Input:

```text
nums = [2, 2, 1, 1, 1, 2, 2]
```

Output:

```text
2
```

Explanation:
`2` appears 4 times, which is more than `⌊7 / 2⌋ = 3`.

---

## 🔒 Constraints

- `n == nums.length`
- `1 <= n <= 5 * 10⁴`
- `-10⁹ <= nums[i] <= 10⁹`

---

## 🎯 Follow-up

Could you solve the problem in linear time **O(n)** and in **O(1)** space?

---

# 💡 Approaches Comparison

| Approach | Technique | Time Complexity | Space Complexity | Notes |
| :--- | :--- | :--- | :--- | :--- |
| **1. Brute Force** | Nested loops count frequencies | $O(n^2)$ | $O(1)$ | Times out for large inputs |
| **2. HashMap** | Count occurrences of each number | $O(n)$ | $O(n)$ | Uses extra memory |
| **3. Sorting** | Sort array and pick index `n ~/ 2` | $O(n \log n)$ | $O(1)$ or $O(n)$ | Modifies input or uses sort memory |
| **4. Boyer-Moore** | Candidate cancellation voting | $O(n)$ | $O(1)$ | **Optimal solution** |

---

# 🧠 Optimal Approach: Boyer-Moore Voting Algorithm

The **Boyer-Moore Voting Algorithm** is an ingenious algorithm that finds the majority element in $O(n)$ time and $O(1)$ extra space.

### Intuition

The majority element is guaranteed to appear strictly more than `⌊n / 2⌋` times.

This means the count of the majority element is greater than the count of all other elements combined:

```text
Count(Majority) > Count(All other elements combined)
```

If we pair off each occurrence of the majority element with a different element and cancel them out, the majority element will always be the one left standing at the end.

---

## 🛠️ Algorithm

1. Initialize two variables:
   - `candidate = 0` (stores the potential majority element)
   - `count = 0` (tracks the net votes for the candidate)
2. Iterate through each number `num` in `nums`:
   - If `count == 0`, assign `candidate = num`.
   - If `num == candidate`, increment `count++`.
   - Otherwise, decrement `count--`.
3. After the loop finishes, return `candidate`.

---

# 🧪 Detailed Dry Run

Consider the input:

```text
nums = [2, 2, 1, 1, 1, 2, 2]
```

### Trace Table

| Step | Current `num` | `count` (before) | `candidate` (before) | Action | `candidate` (after) | `count` (after) |
| :---: | :---: | :---: | :---: | :--- | :---: | :---: |
| **1** | `2` | `0` | `0` | `count == 0` → `candidate = 2`, `count++` | `2` | `1` |
| **2** | `2` | `1` | `2` | `num == candidate` → `count++` | `2` | `2` |
| **3** | `1` | `2` | `2` | `num != candidate` → `count--` | `2` | `1` |
| **4** | `1` | `1` | `2` | `num != candidate` → `count--` | `2` | `0` |
| **5** | `1` | `0` | `2` | `count == 0` → `candidate = 1`, `count++` | `1` | `1` |
| **6** | `2` | `1` | `1` | `num != candidate` → `count--` | `1` | `0` |
| **7** | `2` | `0` | `1` | `count == 0` → `candidate = 2`, `count++` | `2` | `1` |

### Result:

```text
candidate = 2
```

---

# 💻 Solutions

## Dart Solution

```dart
class Solution {
  int majorityElement(List<int> nums) {
    int candidate = 0;
    int count = 0;

    for (int num in nums) {
      if (count == 0) {
        candidate = num;
      }

      if (num == candidate) {
        count++;
      } else {
        count--;
      }
    }

    return candidate;
  }
}
```

---

## C++ Solution

```cpp
class Solution {
public:
    int majorityElement(vector<int>& nums) {
        int candidate = 0;
        int count = 0;

        for (int num : nums) {
            if (count == 0) {
                candidate = num;
            }

            if (num == candidate) {
                count++;
            } else {
                count--;
            }
        }

        return candidate;
    }
};
```

---

# 📊 Complexity Analysis

| Complexity | Value | Explanation |
| :--- | :---: | :--- |
| **Time Complexity** | **$O(n)$** | We traverse the array exactly once in a single loop. |
| **Space Complexity** | **$O(1)$** | Only two integer variables (`candidate` and `count`) are maintained. |

---

# ⚠️ Edge Cases

### 1. Single Element Array

```text
Input: [1]
Output: 1
```

- Loop runs once.
- `count == 0` sets `candidate = 1`, `count = 1`.
- Correctly returns `1`.

---

### 2. All Elements Are Identical

```text
Input: [5, 5, 5, 5]
Output: 5
```

- `candidate` is set to `5`.
- `count` increments on every iteration to `4`.
- Correctly returns `5`.

---

### 3. Minimal Majority

```text
Input: [3, 1, 3]
```

- `3` appears 2 times out of 3 elements (`2 > 3 / 2`).
- The single `1` reduces `count`, but cannot cancel out both `3`s.
- Correctly returns `3`.

---

# 📚 Concepts Used

- **Boyer-Moore Voting Algorithm**
- **Array Traversal**
- **Linear Time and Constant Space Optimization**
- **Candidate Cancellation Pattern**

---

# 🔄 Key Takeaway

When looking for an element that appears **more than half the time** (`> ⌊n / 2⌋`), you do not need a hash map to store frequencies:

1. Think of it as a battle where each non-majority element can cancel out one majority element.
2. Because the majority element has more than $50\%$ representation, it will always survive the cancellation.

---

# 🔗 Related Problems

- **0229. Majority Element II** (Elements appearing $> \lfloor n / 3 \rfloor$ times)
- **1150. Check If a Number Is Majority Element in a Sorted Array**
- **0136. Single Number**
