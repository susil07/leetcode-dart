# 🗺️ HashMap & Hashing in Dart: Complete Master Guide

A `Map<K, V>` (Hash Map) and `Set<E>` (Hash Set) provide **$O(1)$ average time complexity** for insertions, lookups, and deletions through hash functions.

---

## 📖 1. What is Hash, Hashing, and HashMap? (Are They the Same?)

They are **not the same thing**, but they are all parts of the **same system**:

```text
    Key        Hash Function       Hash Code (Slot)    Value Stored
  "Alice"   ───► [ Hashing ]  ───►      Slot 3     ───►     25
```

| Term | What is it? | Real-World Analogy |
| :--- | :--- | :--- |
| **Hashing** *(The Action)* | The mathematical process of converting any input data (string, object, number) into a fixed integer. | The attendant taking your coat at a cloakroom and generating a claim ticket. |
| **Hash / Hash Code** *(The Result)* | The actual number or digital fingerprint produced by the hash function. | The **ticket number** (`#42`) handed to you. |
| **HashMap** *(The Data Structure)* | The storage container that uses those numbers as array slots to store and retrieve Key-Value pairs in **$O(1)$ instant time**. | The **numbered rack of hooks** where coats are hung so the attendant finds yours instantly without checking every coat. |

### 🚗 Valet Parking Analogy
- **Key**: Your claim ticket (`#88`).
- **Value**: Your car (White Honda Civic).
- **HashMap**: The valet parking lot has marked bays: `Slot 1, Slot 2, ... Slot 88 ... Slot 500`.
- Instead of walking across 500 cars to find your car ($O(N)$), the valet looks at ticket `#88`, walks **directly** to bay `#88`, and grabs your car in **1 second flat ($O(1)$)**.

---

## 🔍 2. `Map` vs `HashMap` vs `SplayTreeMap`

### The Difference: Interface vs Implementation

> **`Map` is the Interface (the blueprint / contract).**  
> **`HashMap` is the Concrete Implementation (the actual engine).**

* **`Map` is like the word "Vehicle"**: A general concept. Anything with wheels that drives you from A to B is a vehicle.
* **`HashMap` is like a "Tesla"**: A specific vehicle built with an electric battery engine (hash table).

### Dart Map Implementations Compared

| Type of Map | Underlying Engine | Lookup Speed | Key Ordering | Best Used For |
| :--- | :--- | :---: | :--- | :--- |
| **`HashMap`** | Raw Hash Table | **$O(1)$** | Unordered / Random | Maximum raw performance |
| **`LinkedHashMap`** *(Dart's default `{}`)* | Hash Table + Linked List | **$O(1)$** | **Insertion Order** | Default choice for 95% of LeetCode |
| **`SplayTreeMap`** | Self-Balancing Binary Search Tree | **$O(\log N)$** | **Always Sorted (A-Z / 1-9)** | Range queries, Min/Max keys, Sorted views |

### 🌲 Deep Dive: What is a `SplayTreeMap`?
A `SplayTreeMap` does **not** use hashing. It uses a **Splay Tree** (Binary Search Tree) with two superpowers:

1. **Always Sorted**: Keys are kept in ascending order automatically, no matter what order you insert them.
   ```dart
   import 'dart:collection';

   final map = SplayTreeMap<int, String>();
   map[50] = "Bob";
   map[10] = "Alice";
   map[30] = "Charlie";

   print(map.keys); // Output: (10, 30, 50) -> ALWAYS SORTED!
   ```
2. **The Splaying Trick (Temporal Locality)**:
   - Whenever you access or insert a key, the tree rotates that node to the **very top (root)** of the tree.
   - **Desk Analogy**: Like putting the folder you just used on the **top of the pile** on your desk. If you need that same folder again in 2 minutes, it's right on top with zero digging!

---

## ⚡ 3. Complexity & Internal Mechanics

| Operation | Average Case | Worst Case (Hash Collisions) |
| :--- | :---: | :---: |
| **Lookup (`map[key]` / `set.contains(x)`)** | $O(1)$ | $O(N)$ |
| **Insert (`map[key] = val` / `set.add(x)`)** | $O(1)$ | $O(N)$ |
| **Delete (`map.remove(key)`)** | $O(1)$ | $O(N)$ |
| **Space Overhead** | $O(N)$ | $O(N)$ |

---

## ⚠️ 4. The 3 Classic Interview Traps (Illustrated via Two Sum)

In problems like **LeetCode 0001: Two Sum**, interviewers watch out for 3 specific edge cases:

### Trap 1: "Cannot Use Same Element Twice" (The Self-Pairing Bug)
- **The Scenario**: `nums = [3, 2, 4]`, `target = 6`.
- **The Trap**: `nums[0] = 3`. Since $3 + 3 = 6$, an algorithm might mistakenly pair index `0` with itself and return `[0, 0]`.
- **The Fix in One-Pass HashMap**:
  ```dart
  // STEP 1: Check map FIRST (map is empty, so 3 cannot find itself!)
  if (map.containsKey(complement)) return [map[complement]!, i];

  // STEP 2: Store in map SECOND
  map[nums[i]] = i;
  ```
  Because we check the map **before** adding the current number, the number can never match with itself!

### Trap 2: "Duplicate Values" (The Map Overwrite Bug)
- **The Scenario**: `nums = [3, 3]`, `target = 6`.
- **The Trap**: Both elements have value `3`. If you populate the map beforehand (Two-Pass), the second `3` at index `1` **overwrites** index `0` in the map (`map[3] = 1`), losing index `0` forever!
- **How One-Pass Solves It**:
  1. At `i = 0`: map is empty `{}`. Saves `{3: 0}`.
  2. At `i = 1`: searches for `target - 3 = 3`. Finds `3` at index `0` in the map!
  3. Returns `[0, 1]` **immediately**, before any key collision can occur.

### Trap 3: "Negative Numbers and Zero"
- **The Question**: Does `complement = target - nums[i]` work with negative numbers? Do we need special `if` checks?
- **The Answer**: **No special casing needed!** Basic algebra handles signs naturally:
  - `nums = [-3, 4, 3, 90]`, `target = 0`.
  - At `nums[0] = -3`: stores `{-3: 0}`.
  - At `nums[2] = 3`: `complement = 0 - 3 = -3`. Finds `-3` at index `0` $\rightarrow$ returns `[0, 2]`.

---

## 🧩 5. Core HashMap Patterns

### Pattern A: The Complement Lookup ($O(N^2) \to O(N)$)
Whenever an algorithm asks to find two elements that satisfy a relationship ($a + b = \text{target}$):
- Rearrange to isolate the missing variable: $\text{complement} = \text{target} - a$.
- As you iterate through the list, check if the complement has already been seen in the map.
- If not, save the current element and its index.

```dart
// Two Sum Template (One-Pass)
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
Count the occurrences of elements to find duplicates, unique elements, or anagram frequencies:

```dart
Map<int, int> freq = {};
for (int num in nums) {
  freq[num] = (freq[num] ?? 0) + 1;
}
```

---

### Pattern C: HashSet for Instant Deduplication & Visited States
Use a `Set` when you only care about **existence**, not associations or indices:

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

## ⚖️ 6. When NOT to Use a HashMap (Optimization Trade-Offs)

1. **Fixed Character Sets (e.g., 'a'-'z')**:
   - Instead of `Map<String, int>` (which allocates heap nodes and runs hash functions), use a fixed 26-element array:
     ```dart
     List<int> count = List.filled(26, 0);
     count[char.codeUnitAt(0) - 97]++;
     ```
   - True $O(1)$ space, direct CPU array indexing, zero hashing overhead.
2. **Sorted Arrays**:
   - If the input is sorted, **Two Pointers** solves Two Sum in $O(1)$ extra space, whereas a HashMap costs $O(N)$ extra space.
3. **Cancellation Problems**:
   - If duplicates appear in pairs, **Bitwise XOR** solves it in $O(1)$ space ([#136 Single Number](../easy/0136_single_number/)).
   - If a majority element exists ($> N/2$), **Boyer-Moore Voting** solves it in $O(1)$ space ([#169 Majority Element](../easy/0169_majority_element/)).
