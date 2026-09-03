# 🚀 LeetCode 144 - Binary Tree Preorder Traversal

## 📝 Problem

Given the root of a binary tree, return the preorder traversal of its nodes' values.

Preorder traversal visits nodes in this order:

```
Root → Left → Right
```

---

## Example 1

Input

```
    1
     \
      2
     /
    3
```

Output

```
[1,2,3]
```

---

## Example 2

Input

```
[]
```

Output

```
[]
```

---

## Example 3

Input

```
1
```

Output

```
[1]
```

---

# 💡 Approach (Depth-First Search)

Preorder traversal always follows:

```
Root
Left
Right
```

Visit the current node first, then recursively traverse the left subtree, followed by the right subtree.

---

## 🛠️ Algorithm

1. If node is null, return.
2. Add current node's value.
3. Traverse left subtree.
4. Traverse right subtree.

---

## 🧪 Dry Run

Tree

```
        1
      /   \
     2     3
    / \   /
   4   5 6
```

Traversal

```
Visit 1
Visit 2
Visit 4
Visit 5
Visit 3
Visit 6
```

Output

```
[1,2,4,5,3,6]
```

---

## 🌳 Traversal Order

### Preorder

```
Root → Left → Right
```

### Inorder

```
Left → Root → Right
```

### Postorder

```
Left → Right → Root
```

---

## 📊 Complexity Analysis

| Complexity | Value |
|------------|-------|
| Time | O(n) |
| Space | O(h) |

Where:

- `n` = number of nodes
- `h` = height of the tree

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
[]
```

---

### Single Node

```
1
```

Output

```
[1]
```

---

### Left Skewed

```
1
|
2
|
3
```

Output

```
[1,2,3]
```

---

### Right Skewed

```
1
 \
  2
   \
    3
```

Output

```
[1,2,3]
```

---

## 🔄 Iterative Solution

Use a stack.

Push:

```
Right child first
Left child second
```

This ensures the left child is processed first.

Time

```
O(n)
```

Space

```
O(h)
```

---

## 📚 Concepts Used

- Binary Tree
- DFS
- Recursion
- Stack
- Tree Traversal

---

## 🔗 Related Problems

- 94. Binary Tree Inorder Traversal
- 145. Binary Tree Postorder Traversal
- 102. Binary Tree Level Order Traversal
- 104. Maximum Depth of Binary Tree