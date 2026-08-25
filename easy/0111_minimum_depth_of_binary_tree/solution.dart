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
  int minDepth(TreeNode? root) {
    if (root == null) return 0;

    if (root.left == null) {
      return 1 + minDepth(root.right);
    }

    if (root.right == null) {
      return 1 + minDepth(root.left);
    }

    int leftDepth = minDepth(root.left);
    int rightDepth = minDepth(root.right);

    return 1 + (leftDepth < rightDepth ? leftDepth : rightDepth);
  }
}