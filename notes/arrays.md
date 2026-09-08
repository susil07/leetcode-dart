# 📊 Arrays & Dynamic Lists in Dart

An array (represented as `List<T>` in Dart) is a contiguous block of memory storing elements sequentially. It provides $O(1)$ random access by index.

---

## ⚡ 1. Operation Complexities in Dart

| Operation | Complexity | Explanation |
| :--- | :---: | :--- |
| **Access by index (`nums[i]`)** | $O(1)$ | Direct memory address offset calculation |
| **Update (`nums[i] = x`)** | $O(1)$ | Overwrites value at memory offset |
| **Append at end (`nums.add(x)`)** | $O(1)$ amortized | Appends into allocated buffer; resizes occasionally |
| **Insert at start (`nums.insert(0, x)`)** | $O(N)$ | Shifts every subsequent element to the right |
| **Remove from end (`nums.removeLast()`)** | $O(1)$ | Decrements length |
| **Remove from middle/start** | $O(N)$ | Shifts subsequent elements left |
| **Search (Unsorted)** | $O(N)$ | Linear scan |
| **Search (Sorted)** | $O(\log N)$ | Binary Search |

> [!WARNING]
> Avoid `nums.insert(0, val)` or `nums.removeAt(0)` inside a loop! Doing this $N$ times turns an $O(N)$ algorithm into an accidental $O(N^2)$ algorithm.

---

## 🧩 2. Core Array Patterns & Templates

### Pattern A: Two Pointers (Slow & Fast for In-Place Modification)

When asked to modify an array **in-place** with $O(1)$ extra memory:
- **Fast pointer (`j` or loop index)**: scans through every element.
- **Slow pointer (`i`)**: writes valid/accepted elements to the front.

```dart
// Template: Remove matching elements in-place
int slow = 0;
for (int fast = 0; fast < nums.length; fast++) {
  if (condition(nums[fast])) {
    nums[slow] = nums[fast];
    slow++;
  }
}
return slow; // New effective length
```

**Solved in Repo**:
- [0026. Remove Duplicates from Sorted Array](../easy/0026_remove_duplicates_from_sorted_array/)
- [0027. Remove Element](../easy/0027_remove_element/)

---

### Pattern B: Right-to-Left (Reverse) Traversal

When merging two sorted arrays or expanding an array where placing elements from the start would overwrite unprocessed items, **fill from the back**.

```dart
// Template: Merge sorted arrays into nums1 (size m + n)
int p1 = m - 1;
int p2 = n - 1;
int p = m + n - 1;

while (p2 >= 0) {
  if (p1 >= 0 && nums1[p1] > nums2[p2]) {
    nums1[p] = nums1[p1--];
  } else {
    nums1[p] = nums2[p2--];
  }
  p--;
}
```

**Solved in Repo**:
- [0088. Merge Sorted Array](../easy/0088_merge_sorted_array/)

---

### Pattern C: Greedy Min-Tracking / One-Pass Traversal

Track running extremes (minimum seen so far, maximum seen so far) in a single pass to find optimal differences or subarray metrics.

```dart
int minPrice = nums[0];
int maxProfit = 0;

for (int price in nums) {
  if (price < minPrice) {
    minPrice = price;
  } else {
    maxProfit = math.max(maxProfit, price - minPrice);
  }
}
```

**Solved in Repo**:
- [0121. Best Time to Buy and Sell Stock](../easy/0121_best_time_to_buy_and_sell_stock/)

---

### Pattern D: Boyer-Moore Majority Voting

Find an element with $> \lfloor N / 2 \rfloor$ frequency in $O(N)$ time and $O(1)$ space through candidate cancellation.

```dart
int candidate = 0;
int count = 0;

for (int num in nums) {
  if (count == 0) {
    candidate = num;
  }
  count += (num == candidate) ? 1 : -1;
}
return candidate;
```

**Solved in Repo**:
- [0169. Majority Element](../easy/0169_majority_element/)

---

### Pattern E: Prefix Construction & Dynamic Lists

Building rows where each element depends on previous rows/values.

**Solved in Repo**:
- [0118. Pascal's Triangle](../easy/0118_pascals_triangle/)
- [0119. Pascal's Triangle II](../easy/0119_pascals_triangle_ii/)

---

## 🎯 3. Interview Traps to Avoid

1. **Off-by-One Errors**: Be meticulous with loop conditions (`<` vs `<=`, `length - 1`).
2. **Modifying an Array While Iterating**:
   ```dart
   // BAD: Causes skipped indices or runtime error
   for (int i = 0; i < nums.length; i++) {
     if (nums[i] == target) nums.removeAt(i);
   }
   ```
3. **Deep vs. Shallow Copying**:
   ```dart
   List<int> copy = List.from(original); // Shallow copy
   ```
