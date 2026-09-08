# 🗺️ HashMap & HashSet in Dart

A `Map<K, V>` (Hash Map) and `Set<E>` (Hash Set) provide **$O(1)$ average time complexity** for insertions, lookups, and deletions through hash functions.

---

## ⚡ 1. Complexity & Internal Mechanics

| Operation | Average Case | Worst Case (Hash Collisions) |
| :--- | :---: | :---: |
| **Lookup (`map[key]` / `set.contains(x)`)** | $O(1)$ | $O(N)$ |
| **Insert (`map[key] = val` / `set.add(x)`)** | $O(1)$ | $O(N)$ |
| **Delete (`map.remove(key)`)** | $O(1)$ | $O(N)$ |
| **Space Overhead** | $O(N)$ | $O(N)$ |

---

## 🧩 2. Core HashMap Patterns

### Pattern A: The Complement Lookup ($O(N^2) \to O(N)$)

Whenever an algorithm asks to find two elements that satisfy a relationship (such as $a + b = \text{target}$):
- Rearrange to isolate the missing variable: $\text{complement} = \text{target} - a$.
- As you iterate through the list, check if the complement has already been seen in the map.
- If not, save the current element and its index.

```dart
// Two Sum Template
Map<int, int> seen = {};

for (int i = 0; i < nums.length; i++) {
  int complement = target - nums[i];
  if (seen.containsKey(complement)) {
    return [seen[complement]!, i];
  }
  seen[nums[i]] = i;
}
return [];
```

**Solved in Repo**:
- [0001. Two Sum](../easy/0001_two_sum/)

---

### Pattern B: Frequency Counting

Count the occurrences of elements to find duplicates, unique elements, or anagram frequencies.

```dart
Map<int, int> freq = {};
for (int num in nums) {
  freq[num] = (freq[num] ?? 0) + 1;
}
```

---

### Pattern C: HashSet for Instant Deduplication & Visited States

Use a `Set` when you only care about **existence**, not associations or indices.

```dart
Set<int> visited = {};
for (int num in nums) {
  if (visited.contains(num)) {
    return num; // Found duplicate
  }
  visited.add(num);
}
```

---

## ⚖️ 3. When NOT to Use a HashMap (Optimization Trade-Offs)

1. **Fixed Character Sets (e.g., 'a'-'z')**:
   - Instead of `Map<String, int>` (high object allocation overhead), use a fixed array:
     ```dart
     List<int> count = List.filled(26, 0);
     count[char.codeUnitAt(0) - 97]++;
     ```
   - This achieves true $O(1)$ space and avoids hashing costs.
2. **Sorted Arrays**:
   - If the input is sorted, **Two Pointers** can often solve the problem in $O(1)$ space, whereas a HashMap costs $O(N)$ space.
3. **Cancellation Problems**:
   - If duplicates appear in pairs, **Bitwise XOR** solves it in $O(1)$ space ([#136 Single Number](../easy/0136_single_number/)).
   - If a majority element exists ($> N/2$), **Boyer-Moore Voting** solves it in $O(1)$ space ([#169 Majority Element](../easy/0169_majority_element/)).
