# 94. Binary Tree Inorder Traversal

**Difficulty:** Easy  
**LeetCode Link:** https://leetcode.com/problems/binary-tree-inorder-traversal/

---

## Problem Statement

Given the root of a binary tree, return the inorder traversal of its nodes' values.

Inorder traversal visits nodes in the following order:

```text
Left → Root → Right
```

---

## Example

### Example 1

**Input**

```text
root = [1,null,2,3]
```

**Output**

```text
[1,3,2]
```

---

## Approach

Use Depth First Search (DFS).

For every node:

1. Traverse left subtree.
2. Visit current node.
3. Traverse right subtree.

Store each visited value in a list.

---

## Algorithm

1. Create an empty result list.
2. Recursively visit the left child.
3. Add current node value.
4. Recursively visit the right child.
5. Return the result list.

---

## Dry Run

Tree

```text
      1
       \
        2
       /
      3
```

Traversal

```text
Left of 1
↓

Visit 1

↓

Left of 2
↓

Visit 3

↓

Visit 2
```

Result

```text
[1,3,2]
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

`h` is the height of the tree.

Worst case:

```text
O(n)
```

Balanced tree:

```text
O(log n)
```

---

## Technique Used

- Binary Tree
- DFS
- Recursion
- Inorder Traversal

---

## Key Takeaways

- Inorder traversal always follows **Left → Root → Right**.
- DFS recursion naturally fits tree traversal problems.
- Very common interview question for binary trees.

---

## Dart Solution

```dart
class Solution {
  List<int> inorderTraversal(TreeNode? root) {
    List<int> result = [];

    void dfs(TreeNode? node) {
      if (node == null) return;

      dfs(node.left);
      result.add(node.val);
      dfs(node.right);
    }

    dfs(root);
    return result;
  }
}
```