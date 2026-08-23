# 🚀 LeetCode 108 - Convert Sorted Array to Binary Search Tree

## 📝 Problem

Given an integer array `nums` sorted in **ascending order**, convert it into a **height-balanced Binary Search Tree (BST)**.

A height-balanced BST is a binary tree where the depth of the two subtrees of every node never differs by more than one.

---

## Examples

### Example 1

Input

```
nums = [-10,-3,0,5,9]
```

One possible output

```
        0
      /   \
    -3     9
    /     /
 -10     5
```

---

### Example 2

Input

```
nums = [1,3]
```

Possible outputs

```
  3
 /
1
```

or

```
1
 \
  3
```

Both are accepted because they are height-balanced.

---

## 💡 Approach (Divide & Conquer)

Since the array is already sorted:

- Choose the **middle element** as the root.
- Left half becomes the left subtree.
- Right half becomes the right subtree.
- Repeat recursively.

Choosing the middle element ensures the tree remains balanced.

---

## 🛠️ Algorithm

1. If `left > right`, return `null`.
2. Find the middle index.
3. Create a node using the middle element.
4. Recursively build the left subtree.
5. Recursively build the right subtree.
6. Return the root node.

---

## 🧪 Dry Run

Input

```
[-10,-3,0,5,9]
```

Step 1

```
Mid = 2

        0
```

Step 2

Left half

```
[-10,-3]
```

Right half

```
[5,9]
```

Tree

```
        0
      /   \
    -3     9
```

Step 3

Left subtree

```
-3
/
-10
```

Right subtree

```
9
/
5
```

Final Tree

```
        0
      /   \
    -3     9
    /     /
 -10     5
```

Balanced BST ✅

---

## 📊 Complexity Analysis

| Complexity | Value |
|------------|-------|
| Time | O(n) |
| Space | O(log n) Average |
| Space | O(n) Worst (recursion stack) |

Where

- **n** = number of nodes

---

## ⚠️ Edge Cases

### Single Element

```
[5]
```

Output

```
5
```

---

### Two Elements

```
[1,3]
```

Possible output

```
1
 \
 3
```

or

```
 3
/
1
```

---

### Empty Array

(Not applicable because constraints guarantee at least one element.)

---

### Negative Numbers

```
[-8,-3,-1]
```

Works exactly the same.

---

## ✅ Why This Approach?

- Uses the sorted property.
- Always creates a balanced BST.
- Visits every element exactly once.
- Clean recursive Divide & Conquer solution.
- Most expected interview solution.

---

## 🎯 Interview Follow-up

### Why choose the middle element?

Choosing the middle minimizes the height difference between left and right subtrees, ensuring the BST remains height-balanced.

### Can we always choose the left middle or right middle?

Yes.

For even-sized arrays, either middle element is acceptable.

Both produce valid height-balanced BSTs.

---

## 📚 Concepts Used

- Binary Search Tree (BST)
- Divide and Conquer
- Recursion
- Binary Tree
- Tree Construction

---

## 🔗 Related Problems

- 104. Maximum Depth of Binary Tree
- 98. Validate Binary Search Tree
- 100. Same Tree
- 101. Symmetric Tree
- 110. Balanced Binary Tree