# 🚀 LeetCode 101 - Symmetric Tree

## 📝 Problem

Given the `root` of a binary tree, determine whether it is **symmetric around its center**.

A tree is symmetric if the left subtree is the mirror image of the right subtree.

---

## Examples

### Example 1

```
Input:

        1
      /   \
     2     2
    / \   / \
   3   4 4   3

Output:
true
```

---

### Example 2

```
Input:

        1
      /   \
     2     2
      \     \
       3     3

Output:
false
```

---

## 💡 Approach (Recursive Mirror Check)

Two trees are mirrors if:

- Their root values are equal.
- Left child of the first equals right child of the second.
- Right child of the first equals left child of the second.

Recursively compare both sides.

---

## 🛠️ Algorithm

1. Compare left and right subtree.
2. If both are null → true.
3. If only one is null → false.
4. If values differ → false.
5. Recursively compare:
   - left.left with right.right
   - left.right with right.left
6. Return the result.

---

## 🧪 Dry Run

Input

```
        1
      /   \
     2     2
    / \   / \
   3   4 4   3
```

Compare

```
2 == 2 ✅
```

Compare

```
3 == 3 ✅
```

Compare

```
4 == 4 ✅
```

All comparisons succeed.

Output

```
true
```

---

## 📊 Complexity Analysis

| Complexity | Value |
|------------|-------|
| Time | O(n) |
| Space | O(h) |

Where:

- **n** = number of nodes
- **h** = tree height (recursion stack)

Worst case:

```
O(n)
```

Balanced tree:

```
O(log n)
```

---

## ⚠️ Edge Cases

### Empty Tree

```
[]
```

Output

```
true
```

---

### Single Node

```
1
```

Output

```
true
```

---

### Different Structure

```
    1
   / \
  2   2
   \   \
   3    3
```

Output

```
false
```

---

### Different Values

```
    1
   / \
  2   3
```

Output

```
false
```

---

## ✅ Why This Approach?

- Most common interview solution.
- Elegant recursive implementation.
- Visits every node only once.
- No extra data structures required.

---

## 🎯 Interview Follow-up

LeetCode asks:

> Can you solve it iteratively?

Yes.

Another approach uses a **Queue**.

Push pairs of mirror nodes into the queue and compare them level by level.

Both recursive and iterative approaches have:

- Time: **O(n)**
- Space: **O(n)** (queue) or **O(h)** (recursion)

---

## 📚 Concepts Used

- Binary Tree
- DFS
- Recursion
- Mirror Tree
- Tree Traversal

---

## 🔗 Related Problems

- 100. Same Tree
- 104. Maximum Depth of Binary Tree
- 226. Invert Binary Tree