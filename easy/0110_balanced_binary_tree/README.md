# 🚀 LeetCode 110 - Balanced Binary Tree

## 📝 Problem

Given the `root` of a binary tree, determine whether it is **height-balanced**.

A binary tree is height-balanced if the depths of the left and right subtrees of **every node** differ by no more than **1**.

---

## Examples

### Example 1

```
        3
       / \
      9  20
         / \
        15  7
```

Output

```
true
```

---

### Example 2

```
         1
        / \
       2   2
      / \
     3   3
    / \
   4   4
```

Output

```
false
```

---

### Example 3

Input

```
[]
```

Output

```
true
```

---

## 💡 Approach (Postorder DFS)

Instead of checking the height of every subtree separately (which is inefficient), compute the height while checking balance.

For every node:

- Calculate the height of the left subtree.
- Calculate the height of the right subtree.
- If either subtree is already unbalanced, immediately return `-1`.
- If the height difference is greater than `1`, return `-1`.
- Otherwise return the current height.

Using `-1` as a sentinel value avoids unnecessary calculations.

---

## 🛠️ Algorithm

1. If node is `null`, return height `0`.
2. Recursively compute left height.
3. If left height is `-1`, return `-1`.
4. Recursively compute right height.
5. If right height is `-1`, return `-1`.
6. If

```
abs(left - right) > 1
```

return `-1`.

7. Otherwise return

```
1 + max(left, right)
```

8. Tree is balanced if the final result is **not** `-1`.

---

## 🧪 Dry Run

Input

```
        3
       / \
      9  20
         / \
        15  7
```

Heights

```
9  -> 1
15 -> 1
7  -> 1

20
= 1 + max(1,1)
= 2

3
= 1 + max(1,2)
= 3
```

Difference at every node

```
≤ 1
```

Output

```
true
```

---

### Unbalanced Example

```
      1
     /
    2
   /
  3
 /
4
```

```
Node 2

left = 2
right = 0

Difference = 2

Return -1
```

Tree is not balanced.

---

## 📊 Complexity Analysis

| Complexity | Value |
|------------|-------|
| Time | O(n) |
| Space | O(h) |

Where

- **n** = number of nodes
- **h** = height of tree

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

### Perfect Binary Tree

```
        1
      /   \
     2     2
```

Balanced ✅

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

Not Balanced ❌

---

## ✅ Why This Approach?

Naive solution:

- Compute height for every node.
- Time complexity becomes **O(n²)**.

Optimized solution:

- Checks balance while computing height.
- Visits every node only once.
- Stops immediately when an imbalance is found.

---

## 🎯 Interview Follow-up

### Why return `-1`?

`-1` acts as a sentinel value indicating the subtree is already unbalanced.

This allows early termination and avoids unnecessary recursive calls.

### Can it be solved iteratively?

Yes.

Using postorder traversal with an explicit stack.

However, recursive DFS is simpler and the most common interview solution.

---

## 📚 Concepts Used

- Binary Tree
- DFS
- Postorder Traversal
- Recursion
- Tree Height

---

## 🔗 Related Problems

- 104. Maximum Depth of Binary Tree
- 101. Symmetric Tree
- 100. Same Tree
- 108. Convert Sorted Array to BST
- 543. Diameter of Binary Tree