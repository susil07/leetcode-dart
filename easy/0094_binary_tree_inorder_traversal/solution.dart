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
  List<int> inorderTraversal(TreeNode? root) {
    List<int> result = [];

    void dfs(TreeNode? node) {
      if (node == null) return;

      dfs(node.left);
      result.add(node.val);
      dfs(node.right);
    }

    dfs(root);
    return result;
  }
}