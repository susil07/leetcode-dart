# 🔍 Binary Search in Dart

Binary Search is a divide-and-conquer algorithm that finds a target in a **monotonic (sorted)** search space in **$O(\log N)$** time and **$O(1)$** space.

---

## ⚡ 1. The Standard Template

```dart
int binarySearch(List<int> nums, int target) {
  int low = 0;
  int high = nums.length - 1;

  while (low <= high) {
    // Prevent integer overflow: equivalent to (low + high) ~/ 2
    int mid = low + (high - low) ~/ 2;

    if (nums[mid] == target) {
      return mid; // Target found
    } else if (nums[mid] < target) {
      low = mid + 1; // Discard left half
    } else {
      high = mid - 1; // Discard right half
    }
  }

  return -1; // Not found
}
```

---

## 🧩 2. Core Binary Search Patterns

### Pattern A: Search Insert Position (Lower Bound)

If the target does not exist in the array, where should it be placed to keep the array sorted?

- The standard loop terminates when `low > high`.
- At this exact termination point, **`low` always points to the correct insert index**!

```dart
int searchInsert(List<int> nums, int target) {
  int low = 0;
  int high = nums.length - 1;

  while (low <= high) {
    int mid = low + (high - low) ~/ 2;

    if (nums[mid] == target) return mid;
    else if (nums[mid] < target) low = mid + 1;
    else high = mid - 1;
  }

  return low; // Correct insert position
}
```

**Solved in Repo**:
- [0035. Search Insert Position](../easy/0035_search_insert_position/)

---

### Pattern B: Binary Search on Answer Space

Binary search is not just for searching arrays! You can search over any **numeric range** $[0, x]$ if a monotonic condition exists.

**Example**: Finding $\lfloor \sqrt{x} \rfloor$:
- If $mid \times mid \le x$, then $mid$ could be the answer, but a larger number might also work.
- If $mid \times mid > x$, $mid$ and anything larger is too big.

```dart
int mySqrt(int x) {
  if (x < 2) return x;

  int low = 1;
  int high = x ~/ 2;
  int ans = 0;

  while (low <= high) {
    int mid = low + (high - low) ~/ 2;

    if (mid <= x ~/ mid) { // Avoid overflow: mid * mid <= x
      ans = mid;
      low = mid + 1;
    } else {
      high = mid - 1;
    }
  }

  return ans;
}
```

**Solved in Repo**:
- [0069. Sqrt(x)](../easy/0069_sqrt_x/)

---

## ⚠️ 3. Crucial Tips & Edge Cases

1. **Integer Division in Dart**:
   Always use `~/` for integer division in Dart. Using `/` returns a `double`.
2. **Preventing Overflow**:
   Use `low + (high - low) ~/ 2` instead of `(low + high) ~/ 2`.
3. **Infinite Loops**:
   Ensure `low = mid + 1` and `high = mid - 1` strictly reduce the window size on every step.
