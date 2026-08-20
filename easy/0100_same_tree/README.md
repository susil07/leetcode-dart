# 100. Same Tree

**Difficulty:** Easy  
**LeetCode Link:** https://leetcode.com/problems/same-tree/

---

## Problem Statement

Given the roots of two binary trees `p` and `q`, determine whether they are the same.

Two trees are considered the same if:

- They are structurally identical.
- Corresponding nodes contain the same value.

Return `true` if both trees are identical; otherwise return `false`.

---

## Example

### Example 1

**Input**

```text
p = [1,2,3]
q = [1,2,3]
```

**Output**

```text
true
```

### Example 2

**Input**

```text
p = [1,2]
q = [1,null,2]
```

**Output**

```text
false
```

---

## Approach

Use recursion to compare both trees simultaneously.

For every pair of nodes:

1. If both are `null`, they are equal.
2. If only one is `null`, trees differ.
3. If values differ, return `false`.
4. Recursively compare left subtrees.
5. Recursively compare right subtrees.

---

## Algorithm

1. Check if both nodes are `null`.
2. Check if one node is `null`.
3. Compare node values.
4. Recursively compare left children.
5. Recursively compare right children.
6. Return `true` only if both recursive calls return `true`.

---

## Dry Run

Tree 1

```text
    1
   / \
  2   3
```

Tree 2

```text
    1
   / \
  2   3
```

Comparison

```text
1 == 1 ✔
2 == 2 ✔
3 == 3 ✔
All null children ✔
```

Result

```text
true
```

---

## Complexity Analysis

### Time Complexity

```text
O(n)
```

Every node is visited once.

### Space Complexity

```text
O(h)
```

Where `h` is the height of the tree.

- Worst case: `O(n)`
- Balanced tree: `O(log n)`

---

## Technique Used

- Binary Tree
- DFS
- Recursion

---

## Key Takeaways

- Compare both structure and values.
- Both nodes being `null` means they match.
- A single `null` means the trees differ.
- Simple recursive traversal solves the problem elegantly.

---

## Dart Solution

```dart
class Solution {
  bool isSameTree(TreeNode? p, TreeNode? q) {
    if (p == null && q == null) return true;
    if (p == null || q == null) return false;
    if (p.val != q.val) return false;

    return isSameTree(p.left, q.left) &&
        isSameTree(p.right, q.right);
  }
}
```