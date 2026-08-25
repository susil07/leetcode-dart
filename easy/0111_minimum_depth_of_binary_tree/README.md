# 🚀 LeetCode 111 - Minimum Depth of Binary Tree

## 📝 Problem

Given the `root` of a binary tree, return its **minimum depth**.

The minimum depth is the number of nodes along the shortest path from the root node down to the nearest **leaf node**.

> **Leaf Node:** A node with no left and no right child.

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
2
```

Shortest path

```
3 → 9
```

---

### Example 2

```
1
 \
  2
   \
    3
     \
      4
```

Output

```
4
```

---

## 💡 Approach (Recursive DFS)

This problem looks similar to **Maximum Depth**, but there's one important difference.

If a node has only **one child**, we **cannot** take the minimum of `0` and the other subtree.

Example

```
1
 \
  2
```

Wrong

```
1 + min(0,1) = 1 ❌
```

Correct

```
2
```

So,

- If left child doesn't exist, go right.
- If right child doesn't exist, go left.
- Otherwise return

```
1 + min(leftDepth, rightDepth)
```

---

## 🛠️ Algorithm

1. If node is `null`, return `0`.
2. If left child is `null`, return

```
1 + minDepth(right)
```

3. If right child is `null`, return

```
1 + minDepth(left)
```

4. Compute left and right depths.
5. Return

```
1 + min(leftDepth, rightDepth)
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

Depths

```
9  -> 1
15 -> 1
7  -> 1

20
= 1 + min(1,1)
= 2

3
= 1 + min(1,2)
= 2
```

Output

```
2
```

---

### Another Example

```
1
 \
 2
  \
   3
```

```
Node 3 = 1

Node 2
= 1 + 1
= 2

Node 1
= 1 + 2
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
- **h** = height of the tree

Worst case

```
O(n)
```

Balanced tree

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
```

Output

```
3
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

Many candidates incorrectly write

```dart
1 + min(minDepth(left), minDepth(right))
```

This **fails** when one subtree is empty.

Handling single-child nodes separately guarantees the correct minimum depth.

---

## 🎯 Interview Follow-up

### Can it be solved using BFS?

Yes.

Level-order traversal (BFS) is another optimal solution.

The **first leaf node** encountered gives the minimum depth immediately.

Both approaches have

```
Time: O(n)
```

BFS may terminate earlier than DFS if a shallow leaf exists.

---

## 📚 Concepts Used

- Binary Tree
- Depth First Search (DFS)
- Recursion
- Tree Traversal

---

## 🔗 Related Problems

- 104. Maximum Depth of Binary Tree
- 110. Balanced Binary Tree
- 101. Symmetric Tree
- 100. Same Tree
- 543. Diameter of Binary Tree