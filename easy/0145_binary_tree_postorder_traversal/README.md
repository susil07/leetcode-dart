# 🚀 LeetCode 145 - Binary Tree Postorder Traversal

## 📝 Problem

Given the root of a binary tree, return the postorder traversal of its nodes' values.

Postorder traversal visits nodes in the following order:

```
Left → Right → Root
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
[3,2,1]
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

Postorder traversal processes nodes in the order:

```
Left
Right
Root
```

Recursively traverse the left subtree, then the right subtree, and finally visit the current node.

---

## 🛠️ Algorithm

1. If the node is null, return.
2. Traverse the left subtree.
3. Traverse the right subtree.
4. Add the current node's value.

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
Visit 4
Visit 5
Visit 2
Visit 6
Visit 3
Visit 1
```

Output

```
[4,5,2,6,3,1]
```

---

## 🌳 Traversal Comparison

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

- `n` = Number of nodes
- `h` = Height of tree

Worst Case

```
O(n)
```

Balanced Tree

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

### Left Skewed Tree

```
    1
   /
  2
 /
3
```

Output

```
[3,2,1]
```

---

### Right Skewed Tree

```
1
 \
  2
   \
    3
```

Output

```
[3,2,1]
```

---

## 🔄 Iterative Solution

A stack can also be used.

Steps:

- Visit nodes in:

```
Root → Right → Left
```

- Reverse the result to obtain:

```
Left → Right → Root
```

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
- Depth First Search (DFS)
- Recursion
- Stack
- Tree Traversal

---

## 🔗 Related Problems

- 94. Binary Tree Inorder Traversal
- 144. Binary Tree Preorder Traversal
- 102. Binary Tree Level Order Traversal
- 104. Maximum Depth of Binary Tree