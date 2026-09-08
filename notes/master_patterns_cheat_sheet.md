# 🗺️ The Master Pattern Decision Tree & 18 Core Patterns

There are over 3,300+ LeetCode problems, but **more than 90% of them are built from only ~18 core algorithmic patterns**. 

You do not need to memorize thousands of questions; you only need to master the **Decision Flowchart** that maps problem signals to the correct pattern.

---

## 🧭 The Pattern Decision Flowchart ("Where to Use What?")

Ask yourself these questions in sequence when you read a problem:

```text
                                 [ What is the Input? ]
                                            │
        ┌───────────────────────────────────┼──────────────────────────────────┐
        ▼                                   ▼                                  ▼
   [ Array / String ]                [ Linked List ]                     [ Tree / Graph ]
        │                                   │                                  │
        ├─ Is it sorted?                    ├─ Cycle detection?                ├─ Level by level / Shortest path?
        │   ├─ YES ──► Binary Search /      │   └──► Fast & Slow Pointers      │   └──► BFS (Queue)
        │   │          Two Pointers         │                                  │
        │   └─ NO  ──► Can we sort it?      ├─ Merge / Reverse?                ├─ Subtree / Path sum / Deep search?
        │               (Two Pointers)      │   └──► Dummy Head & Pointers     │   └──► DFS (Recursion)
        │                                   │                                  │
        ├─ Contiguous Subarray/Substring?   └─ Intersection?                   └─ BST (Binary Search Tree)?
        │   ├── Fixed/variable length?          └──► Length Alignment Trick        └──► Inorder Traversal (Sorted!)
        │   │   └──► Sliding Window
        │   └── Cumulative sum?
        │       └──► Prefix Sum
        │
        ├─ Finding pairs / Lookups?
        │   └──► HashMap / Complement ($O(1)$)
        │
        ├─ Next Greater / Previous Smaller?
        │   └──► Monotonic Stack
        │
        └─ Optimization / Choices:
            ├── All possibilities/permutations? ──► Backtracking
            ├── Max/Min with overlapping steps? ──► Dynamic Programming
            ├── Top K / Extreme elements?       ──► Heap / Priority Queue
            └── Local best choice always works?  ──► Greedy
```

---

## 📚 The 18 Core DSA Patterns Catalog

| # | Pattern Name | When to Use It (The Signal) | Primary Complexity | Canonical Examples |
| :-: | :--- | :--- | :---: | :--- |
| **1** | **Two Pointers (Inward)** | Sorted array; pair sum; palindrome verification | $O(N)$ time, $O(1)$ space | LeetCode #125, #167, #15 |
| **2** | **Fast & Slow Pointers** | Cycle detection; finding middle node in linked list | $O(N)$ time, $O(1)$ space | LeetCode #141, #876, #202 |
| **3** | **Sliding Window (Dynamic)** | Longest/shortest substring or subarray meeting constraint | $O(N)$ time, $O(K)$ space | LeetCode #3, #76, #209 |
| **4** | **Sliding Window (Fixed)** | Contiguous block of fixed size $K$ (e.g., max sum of $K$ items) | $O(N)$ time, $O(1)$ space | LeetCode #643, #438 |
| **5** | **Prefix Sum** | Subarray sum equals $K$; multiple range sum queries $[i, j]$ | $O(N)$ precompute, $O(1)$ query | LeetCode #303, #560, #118 |
| **6** | **Binary Search (Index)** | Sorted array; finding exact value or insertion index | $O(\log N)$ time, $O(1)$ space | LeetCode #35, #704, #33 |
| **7** | **Binary Search (Answer)** | Search range $[1, \text{Max}]$ where a predicate is monotonic | $O(\log(\text{Range}))$ | LeetCode #69, #875, #1011 |
| **8** | **HashMap Lookup** | Instant $O(1)$ lookback; complement pairs; frequency counting | $O(N)$ time, $O(N)$ space | LeetCode #1, #49, #242 |
| **9** | **Monotonic Stack** | "Next greater element", "previous smaller element", histogram | $O(N)$ time, $O(N)$ space | LeetCode #739, #496, #84 |
| **10**| **Tree DFS (Recursion)** | Height, symmetry, path sum, validate balance | $O(N)$ time, $O(H)$ space | LeetCode #104, #100, #110, #112 |
| **11**| **Tree / Graph BFS** | Level-order traversal; shortest path in unweighted graph | $O(V + E)$ time, $O(V)$ space | LeetCode #102, #107, #199 |
| **12**| **Top K / Heap** | Kth largest element; merge $K$ sorted streams; live medians | $O(N \log K)$ time, $O(K)$ space | LeetCode #215, #347, #23 |
| **13**| **Backtracking (Subsets)** | Generate all combinations, subsets, permutations, sudoku | $O(2^N)$ or $O(N!)$ | LeetCode #78, #46, #39 |
| **14**| **1D Dynamic Programming** | Decision depends on previous 1 or 2 steps (rob / don't rob) | $O(N)$ time, $O(1)$ or $O(N)$ | LeetCode #70, #198, #322 |
| **15**| **2D Dynamic Programming** | Grid paths; comparing two strings (subsequences, edit distance) | $O(M \times N)$ time & space | LeetCode #62, #1143, #72 |
| **16**| **Greedy** | Making the best immediate local choice without reconsideration | $O(N)$ or $O(N \log N)$ | LeetCode #121, #55, #45 |
| **17**| **Graph Flood Fill / DFS** | Connected components, counting islands, matrix traversals | $O(R \times C)$ time & space | LeetCode #200, #695, #733 |
| **18**| **Bit Manipulation** | Unique element cancellation; power of two; bitmasks | $O(N)$ or $O(1)$ | LeetCode #136, #191, #231 |

---

## ⚡ How to Train Your Brain to Recognize Patterns

1. **Do Not Code for the First 3 Minutes**:
   Read the problem and identify:
   - *What is the input structure?*
   - *What is the return type?*
   - *What does the decision tree recommend?*
2. **Tag Problems by Pattern**:
   When you solve a problem, don't just remember the code—remember the **pattern tag** (e.g., *"This is a Dynamic Sliding Window problem"*).
3. **Solve Problems in Pattern Clusters**:
   Instead of jumping randomly across LeetCode, solve 5 Two-Pointer problems in a row, then 5 Binary Search problems. This builds permanent mental muscle memory.
