# 🌳 Trees & Binary Search Trees in Dart

A **Binary Tree** is a hierarchical data structure where each node has at most two children (`left` and `right`).

```dart
class TreeNode {
  int val;
  TreeNode? left;
  TreeNode? right;
  TreeNode([this.val = 0, this.left, this.right]);
}
```

---

## ⚡ 1. The 3 Depth-First Search (DFS) Orders

| Traversal Order | Sequence | Key Use Case |
| :--- | :--- | :--- |
| **Preorder** | **Root** $\to$ Left $\to$ Right | Serialization, copying trees, prefix expressions |
| **Inorder** | Left $\to$ **Root** $\to$ Right | **In a BST, gives nodes in strictly sorted order!** |
| **Postorder** | Left $\to$ Right $\to$ **Root** | Bottom-up calculations (height, subtree sum, deletion) |

**Solved in Repo**:
- [0094. Binary Tree Inorder Traversal](../easy/0094_binary_tree_inorder_traversal/)
- [0144. Binary Tree Preorder Traversal](../easy/0144_binary_tree_preorder_traversal/)
- [0145. Binary Tree Postorder Traversal](../easy/0145_binary_tree_postorder_traversal/)

---

## 🧩 2. The Universal Tree Recursion Template

90% of binary tree problems follow this 3-step recursive pattern:

```dart
ReturnType solveTree(TreeNode? root) {
  // 1. Base Case
  if (root == null) return defaultValue;

  // 2. Divide & Conquer
  var leftResult = solveTree(root.left);
  var rightResult = solveTree(root.right);

  // 3. Combine
  return combine(root.val, leftResult, rightResult);
}
```

---

## 🧩 3. Core Tree Patterns in the Repository

### Pattern A: Maximum & Minimum Depth (Height)

Calculate the maximum or minimum distance from root to a leaf node.

```dart
// Maximum Depth
int maxDepth(TreeNode? root) {
  if (root == null) return 0;
  return 1 + math.max(maxDepth(root.left), maxDepth(root.right));
}
```

**Solved in Repo**:
- [0104. Maximum Depth of Binary Tree](../easy/0104_maximum_depth_of_binary_tree/)
- [0111. Minimum Depth of Binary Tree](../easy/0111_minimum_depth_of_binary_tree/)

---

### Pattern B: Dual Tree Comparison (Symmetry & Equality)

Traverse two nodes simultaneously to compare their shapes and values.

```dart
bool isMirror(TreeNode? t1, TreeNode? t2) {
  if (t1 == null && t2 == null) return true;
  if (t1 == null || t2 == null) return false;
  if (t1.val != t2.val) return false;

  return isMirror(t1.left, t2.right) && isMirror(t1.right, t2.left);
}
```

**Solved in Repo**:
- [0100. Same Tree](../easy/0100_same_tree/)
- [0101. Symmetric Tree](../easy/0101_symmetric_tree/)

---

### Pattern C: Balanced Tree Validation (Bottom-Up $O(N)$)

Avoid checking height repeatedly from the top down ($O(N^2)$). Instead, calculate height bottom-up and return `-1` immediately if an imbalance is discovered.

```dart
int checkHeight(TreeNode? root) {
  if (root == null) return 0;

  int leftH = checkHeight(root.left);
  if (leftH == -1) return -1;

  int rightH = checkHeight(root.right);
  if (rightH == -1) return -1;

  if ((leftH - rightH).abs() > 1) return -1;

  return 1 + math.max(leftH, rightH);
}
```

**Solved in Repo**:
- [0110. Balanced Binary Tree](../easy/0110_balanced_binary_tree/)

---

### Pattern D: BST Construction from Sorted Array

Pick the middle element as root to ensure height balance, then recursively build left and right subtrees.

```dart
TreeNode? buildBST(List<int> nums, int left, int right) {
  if (left > right) return null;

  int mid = left + (right - left) ~/ 2;
  TreeNode root = TreeNode(nums[mid]);
  root.left = buildBST(nums, left, mid - 1);
  root.right = buildBST(nums, mid + 1, right);

  return root;
}
```

**Solved in Repo**:
- [0108. Convert Sorted Array to Binary Search Tree](../easy/0108_convert_sorted_array_to_binary_search_tree/)

---

### Pattern E: Path Sum (Top-Down Accumulation)

Subtract node values along the path until reaching a leaf with remaining `sum == 0`.

**Solved in Repo**:
- [0112. Path Sum](../easy/0112_path_sum/)
