# 🥞 Stacks in Dart

A **Stack** follows the **LIFO** (Last In, First Out) principle. The most recently added item is always the first one removed.

---

## ⚡ 1. Stack Implementation in Dart

In Dart, there is no separate built-in `Stack` class because a `List<T>` provides native, highly optimized stack methods:

```dart
List<T> stack = [];

// Push: O(1) amortized
stack.add(item);

// Pop: O(1)
T item = stack.removeLast();

// Peek (Top element): O(1)
T top = stack.last;

// Check Empty / Size: O(1)
bool empty = stack.isEmpty;
int size = stack.length;
```

---

## 🧩 2. Core Stack Patterns

### Pattern A: Bracket Matching & Balanced Delimiters

When verifying matching pairs (parentheses, brackets, XML/HTML tags):
- An opening delimiter must match the most recent unmatched opening delimiter.
- When an opening bracket is seen, push its expected closing counterpart onto the stack.
- When a closing bracket is seen, the stack's top must match it.

```dart
bool isValid(String s) {
  List<String> stack = [];

  for (int i = 0; i < s.length; i++) {
    String char = s[i];
    if (char == '(') stack.add(')');
    else if (char == '{') stack.add('}');
    else if (char == '[') stack.add(']');
    else {
      if (stack.isEmpty || stack.removeLast() != char) {
        return false;
      }
    }
  }

  return stack.isEmpty;
}
```

**Solved in Repo**:
- [0020. Valid Parentheses](../easy/0020_valid_parentheses/)

---

### Pattern B: Simulating Call-Stack Recursion Iteratively

Every recursive algorithm implicitly uses the system call stack. You can convert any recursive algorithm into an iterative one by using an explicit stack:

```dart
// Iterative Binary Tree Preorder Traversal
List<int> preorderTraversal(TreeNode? root) {
  if (root == null) return [];
  List<int> result = [];
  List<TreeNode> stack = [root];

  while (stack.isNotEmpty) {
    TreeNode node = stack.removeLast();
    result.add(node.val);

    // Push right child first so left child is processed first (LIFO)
    if (node.right != null) stack.add(node.right!);
    if (node.left != null) stack.add(node.left!);
  }
  return result;
}
```

**Solved in Repo**:
- [0094. Binary Tree Inorder Traversal](../easy/0094_binary_tree_inorder_traversal/)
- [0144. Binary Tree Preorder Traversal](../easy/0144_binary_tree_preorder_traversal/)
- [0145. Binary Tree Postorder Traversal](../easy/0145_binary_tree_postorder_traversal/)

---

### Pattern C: Monotonic Stack (Upcoming Medium Pattern)

Maintain elements in strictly increasing or decreasing order. Whenever an incoming element breaks the monotonicity, pop elements and record their **Next Greater Element** or **Previous Smaller Element**.

```dart
// Template: Next Greater Element
List<int> stack = []; // Stores indices
List<int> result = List.filled(nums.length, -1);

for (int i = 0; i < nums.length; i++) {
  while (stack.isNotEmpty && nums[i] > nums[stack.last]) {
    int prevIndex = stack.removeLast();
    result[prevIndex] = nums[i];
  }
  stack.add(i);
}
```
*(Key target problems to practice next: 739. Daily Temperatures, 496. Next Greater Element I).*
