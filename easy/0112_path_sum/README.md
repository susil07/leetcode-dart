# 🚀 LeetCode 112 - Path Sum

## 📝 Problem

Given the `root` of a binary tree and an integer `targetSum`, return **true** if the tree has a **root-to-leaf** path such that adding up all the node values along the path equals `targetSum`.

A **leaf** is a node with no left and right children.

---

## Examples

### Example 1

```
            5
          /   \
         4     8
        /     / \
      11     13  4
     /  \         \
    7    2         1
```

Target Sum

```
22
```

Path

```
5 → 4 → 11 → 2
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
  2   3
```

Target

```
5
```

Possible sums

```
1 → 2 = 3
1 → 3 = 4
```

Output

```
false
```

---

### Example 3

```
[]
```

Output

```
false
```

---

## 💡 Approach (Recursive DFS)

Instead of calculating the total path sum from the root, we subtract the current node's value from the target while traversing.

At every node:

```
remainingSum = targetSum - currentNode.val
```

When we reach a leaf node:

- If the remaining sum equals the leaf's value → Path found ✅
- Otherwise → Continue searching.

---

## 🛠️ Algorithm

1. If the node is `null`, return `false`.
2. If the node is a leaf:
   - Return whether `targetSum == node.val`.
3. Subtract the current node's value from the target.
4. Recursively search the left and right subtrees.
5. Return `true` if either subtree contains a valid path.

---

## 🧪 Dry Run

Input

```
            5
          /   \
         4     8
        /
      11
     /  \
    7    2
```

Target

```
22
```

Steps

```
22 - 5 = 17

17 - 4 = 13

13 - 11 = 2

Leaf node = 2

Remaining Sum = 2

2 == 2 ✅
```

Return

```
true
```

---

### Another Example

```
    1
   / \
  2   3
```

Target

```
5
```

Left

```
5 - 1 = 4

4 - 2 = 2

Leaf reached

2 != 0
```

Right

```
5 - 1 = 4

4 - 3 = 1

Leaf reached

1 != 0
```

Output

```
false
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
false
```

---

### Single Node

```
5
```

Target

```
5
```

Output

```
true
```

---

### Negative Values

```
      -2
        \
        -3
```

Target

```
-5
```

Output

```
true
```

---

### No Valid Path

```
    1
   / \
  2   3
```

Target

```
10
```

Output

```
false
```

---

## ✅ Why This Approach?

Instead of storing the entire path or repeatedly calculating sums,

we continuously reduce the target value.

Advantages:

- No extra list required.
- Constant work at every node.
- Very clean recursive solution.
- Standard interview solution.

---

## 🎯 Interview Follow-up

### Can it be solved iteratively?

Yes.

Use:

- Stack for DFS
- Queue for BFS

Store:

```
(node, remainingSum)
```

The recursive DFS solution is simpler and usually preferred.

---

## 📚 Concepts Used

- Binary Tree
- Depth First Search (DFS)
- Recursion
- Backtracking
- Tree Traversal

---

## 🔗 Related Problems

- 104. Maximum Depth of Binary Tree
- 111. Minimum Depth of Binary Tree
- 113. Path Sum II
- 257. Binary Tree Paths
- 437. Path Sum III