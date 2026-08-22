# 🚀 LeetCode 104 - Maximum Depth of Binary Tree

## 📝 Problem

Given the `root` of a binary tree, return its **maximum depth**.

The maximum depth is the number of nodes along the longest path from the root down to the farthest leaf node.

---

## Examples

### Example 1

```
        3
       / \
      9  20
        /  \
       15   7
```

Output

```
3
```

---

### Example 2

```
1
 \
  2
```

Output

```
2
```

---

## 💡 Approach (Recursive DFS)

Every node contributes **1** to the depth.

For each node:

- Find the depth of the left subtree.
- Find the depth of the right subtree.
- Return

```
1 + max(leftDepth, rightDepth)
```

The recursion naturally reaches the leaf nodes first and calculates the answer while returning back.

---

## 🛠️ Algorithm

1. If node is `null`, return `0`.
2. Recursively calculate left depth.
3. Recursively calculate right depth.
4. Return

```
1 + max(leftDepth, rightDepth)
```

---

## 🧪 Dry Run

Input

```
        3
       / \
      9  20
        /  \
       15   7
```

Calculations

```
Depth(9) = 1
Depth(15) = 1
Depth(7) = 1

Depth(20)
= 1 + max(1,1)
= 2

Depth(3)
= 1 + max(1,2)
= 3
```

Output

```
3
```

---

## 📊 Complexity Analysis

| Complexity | Value |
|------------|-------|
| Time | O(n) |
| Space | O(h) |

Where

- **n** = number of nodes
- **h** = height of tree

Worst case (skewed tree)

```
Space = O(n)
```

Balanced tree

```
Space = O(log n)
```

---

## ⚠️ Edge Cases

### Empty Tree

```
[]
```

Output

```
0
```

---

### Single Node

```
1
```

Output

```
1
```

---

### Left Skewed Tree

```
1
|
2
|
3
|
4
```

Output

```
4
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
3
```

---

## ✅ Why This Approach?

- Visits every node exactly once.
- Simple recursive DFS.
- Most common interview solution.
- Easy to understand and implement.

---

## 🎯 Interview Follow-up

### Can it be solved iteratively?

Yes.

Using:

- Queue (Level Order Traversal / BFS)
- Stack (Iterative DFS)

All approaches have

```
Time: O(n)
```

Recursive DFS is usually preferred because it is concise and readable.

---

## 📚 Concepts Used

- Binary Tree
- Depth First Search (DFS)
- Recursion
- Tree Height

---

## 🔗 Related Problems

- 100. Same Tree
- 101. Symmetric Tree
- 111. Minimum Depth of Binary Tree
- 543. Diameter of Binary Tree