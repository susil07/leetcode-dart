/**
 * Definition for a binary tree node.

 */
class TreeNode {
  int val;
  TreeNode? left;
  TreeNode? right;
  TreeNode([this.val = 0, this.left, this.right]);
 }
class Solution {
  bool isSymmetric(TreeNode? root) {
    return _isMirror(root?.left, root?.right);
  }

  bool _isMirror(TreeNode? left, TreeNode? right) {
    if (left == null && right == null) return true;
    if (left == null || right == null) return false;

    return left.val == right.val &&
        _isMirror(left.left, right.right) &&
        _isMirror(left.right, right.left);
  }
}