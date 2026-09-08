# ⏱️ Time & Space Complexity Master Handbook

A comprehensive guide to understanding, calculating, and optimizing Time and Space Complexity for technical interviews and competitive programming.

---

## 📌 1. What is Algorithmic Complexity?

Complexity is **not** measured in seconds, milliseconds, or megabytes. 

Measuring raw execution time on a machine fails because:
- A newer M-series Mac or powerful server executes code faster than an older laptop.
- Other background processes (browser, OS tasks) fluctuate execution speed.
- The size of the input data dramatically alters performance.

> **Definition**: Complexity measures the **growth rate** of the number of basic operations (Time) and memory allocations (Space) as the input size $N$ tends towards infinity ($N \to \infty$).

---

## 🏷️ 2. Asymptotic Notations

| Notation | Meaning | When to Use in Interviews |
| :--- | :--- | :--- |
| **Big-O ($O$)** | **Upper Bound** (Worst-case scenario) | **Always focus here**. It guarantees the algorithm will never perform worse than this bound. |
| **Big-Theta ($\Theta$)** | **Tight Bound** (Average-case behavior) | Used when best and worst cases scale at the exact same rate. |
| **Big-Omega ($\Omega$)** | **Lower Bound** (Best-case scenario) | e.g., finding the target on the very first element in an array ($O(1)$). |

---

## 🧮 3. How to Calculate Time Complexity

To find the Big-O time complexity, count the number of fundamental operations executed as a function of the input size $N$, then:
1. **Drop non-dominant terms** (e.g., $O(N^2 + 5N + 100) \to O(N^2)$).
2. **Drop constant coefficients** (e.g., $O(3N) \to O(N)$).

### A. Sequential Statements: Additive Rule $O(A + B)$

When operations occur one after the other, add their complexities:

```dart
// Part 1: O(N)
for (int i = 0; i < n; i++) { ... }

// Part 2: O(M)
for (int j = 0; j < m; j++) { ... }

// Total: O(N + M) (or O(N) if N == M)
```

---

### B. Single Loops: $O(N)$

A loop running through elements from $0$ to $N-1$ does constant work $c$ on each step:

```dart
for (int num in nums) {
  sum += num; // Constant time O(1)
}
// Total: N * O(1) = O(N)
```

---

### C. Nested Loops: Multiplicative Rule $O(N \cdot M)$ or $O(N^2)$

When loops are nested, multiply their iteration counts:

```dart
// Outer loop runs N times
for (int i = 0; i < n; i++) {
  // Inner loop runs N times
  for (int j = 0; j < n; j++) {
    // Total comparisons: N * N = O(N²)
  }
}
```

#### Dependent Loops (e.g., $j = i + 1$):
```dart
for (int i = 0; i < n; i++) {
  for (int j = i + 1; j < n; j++) {
    // Operations: (N-1) + (N-2) + ... + 1 = N(N-1)/2 = O(N²)
  }
}
```

---

### D. Halving Loops (Divide & Conquer): $O(\log N)$

Whenever the remaining input is halved on each iteration (e.g., Binary Search):

```dart
while (low <= high) {
  int mid = low + (high - low) ~/ 2;
  if (target == nums[mid]) return mid;
  if (target < nums[mid]) high = mid - 1;
  else low = mid + 1;
}
// Number of steps: log₂(N) -> O(log N)
```

*Example*: If $N = 1,000,000$, $\log_2(10^6) \approx 20$ iterations!

---

### E. Recursive Functions & Trees: $O(\text{Branches}^{\text{Depth}})$

For recursion, visualize the execution tree:

$$\text{Total Calls} \approx \text{Branches}^{\text{Max Depth}}$$

- **Single Branch Recursion** (e.g., binary search or linked list traversal):
  - 1 branch of size $N/2$ $\to O(\log N)$.
- **Double Branch Recursion** (e.g., unmemoized Fibonacci `fib(n-1) + fib(n-2)`):
  - 2 branches down to depth $N \to O(2^N)$ (Exponential).
- **Balanced Binary Tree Traversal** (e.g., Inorder/Preorder):
  - Visits every node once $\to O(N)$.

---

## 💾 4. How to Calculate Space Complexity

Space complexity measures **Auxiliary Space**—the *extra* memory allocated by your algorithm beyond the input itself.

### What Counts:
1. **Explicit Data Structures**:
   - Lists, Maps, Sets, Queues, Stacks created during execution:
     ```dart
     Map<int, int> map = {}; // Stores up to N elements -> O(N)
     ```
2. **Implicit Call Stack Space (Recursion)**:
   - Every function call places a stack frame in memory until it returns.
   - For a tree of height $H$:
     - Balanced Tree: $H = \log N \to O(\log N)$ stack space.
     - Skewed Tree (Linked list shape): $H = N \to O(N)$ stack space.

### What Does NOT Count:
- The input arguments (e.g., `List<int> nums` passed into the function).
- A few primitive variables (`int i`, `count`, `candidate`) $\to O(1)$ Constant Space.

---

## ⚡ 5. The Optimization Playbook

When an interviewer asks: *"Can you optimize this?"*, apply these standard patterns:

### Pattern 1: Trade Space for Time ($O(N^2) \to O(N)$)
- **Problem**: Repeatedly searching for a pair or complement inside a nested loop.
- **Fix**: Use a **HashMap** or **HashSet** to achieve instant $O(1)$ lookups.
- **Example in Repo**: [LeetCode #1 Two Sum](../easy/0001_two_sum/) (from $O(N^2)$ brute force to $O(N)$ with Map).

### Pattern 2: Two Pointers or Sorting ($O(N^2) \to O(N \log N)$ or $O(N)$)
- **Problem**: Checking pairs or ranges in an array/string.
- **Fix**: Sort the array (if allowed, $O(N \log N)$) or use Two Pointers moving inward/outward ($O(N)$).
- **Example in Repo**: [LeetCode #125 Valid Palindrome](../easy/0125_valid_palindrome/), [LeetCode #26 Remove Duplicates](../easy/0026_remove_duplicates_from_sorted_array/).

### Pattern 3: Monotonicity & Binary Search ($O(N) \to O(\log N)$)
- **Problem**: Searching for an element, index, or minimum/maximum condition in a sorted or monotonic space.
- **Fix**: Use **Binary Search** to eliminate half the candidate answers per step.
- **Example in Repo**: [LeetCode #35 Search Insert Position](../easy/0035_search_insert_position/), [LeetCode #69 Sqrt(x)](../easy/0069_sqrt_x/).

### Pattern 4: State Invariants & Cancellation ($O(N)$ Space $\to O(1)$ Space)
- **Problem**: Counting frequencies or finding unique items using a HashMap.
- **Fix**:
  - If pairs cancel: Use **Bitwise XOR (`^`)** $\to$ [LeetCode #136 Single Number](../easy/0136_single_number/).
  - If strictly majority ($> N/2$): Use **Boyer-Moore Voting** $\to$ [LeetCode #169 Majority Element](../easy/0169_majority_element/).

### Pattern 5: Fast & Slow Pointers ($O(N)$ Space $\to O(1)$ Space)
- **Problem**: Detecting cycles or finding midpoints in linked lists without a visited `HashSet`.
- **Fix**: **Floyd’s Tortoise and Hare** algorithm.
- **Example in Repo**: [LeetCode #141 Linked List Cycle](../easy/0141_linked_list_cycle/).

---

## 🎯 6. Input Size ($N$) vs. Acceptable Complexity Cheat Sheet

In competitive programming and online platforms (LeetCode, Codeforces), execution time limit is typically **1.0 - 2.0 seconds** ($\approx 10^8$ basic operations):

| Constraint on $N$ | Maximum Allowed Time Complexity | Expected Algorithm Type |
| :--- | :--- | :--- |
| $N \le 10$ | $O(N!)$ or $O(N^6)$ | Permutations, brute force backtracking |
| $N \le 20$ | $O(2^N)$ | Subsets, bitmask DP |
| $N \le 500$ | $O(N^3)$ | All-pairs shortest paths (Floyd-Warshall), 3D DP |
| $N \le 5,000$ | $O(N^2)$ | Nested loops, 2D DP, Insertion/Selection sort |
| $N \le 10^5$ | $O(N \log N)$ or $O(N)$ | Sorting, Heap, Two Pointers, Sliding Window, Tree traversals |
| $N \le 10^7$ | $O(N)$ | Single pass, linear scan, Boyer-Moore |
| $N \ge 10^9$ | $O(\log N)$ or $O(1)$ | Binary Search, Math formulas, Bit manipulation |

---

## 💡 Summary Checklist for Problem Solving

1. **Clarify Constraints First**: Always check the value range of $N$ before coding. This tells you which complexity is acceptable.
2. **Start with Brute Force**: State the naive solution and its Big-O. This demonstrates your baseline problem-solving process.
3. **Identify Bottlenecks**: Is an inner loop doing repetitive searching? Are you recalculating subproblems?
4. **Select the Right Structure**:
   - Need $O(1)$ lookup? $\to$ **HashMap / HashSet**
   - Need FIFO? $\to$ **Queue**
   - Need LIFO or matching? $\to$ **Stack**
   - Need sorted/extreme elements? $\to$ **Heap / Priority Queue**
   - Need fast range queries? $\to$ **Prefix Sums / Binary Indexed Tree**
