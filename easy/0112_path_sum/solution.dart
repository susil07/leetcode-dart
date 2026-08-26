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
  bool hasPathSum(TreeNode? root, int targetSum) {
    if (root == null) return false;

    targetSum -= root.val;

    if (root.left == null && root.right == null) {
      return targetSum == 0;
    }

    return hasPathSum(root.left, targetSum) ||
           hasPathSum(root.right, targetSum);
  }
}