// class Solution {
//   List<int> preorderTraversal(TreeNode? root) {
//     if (root == null) return [];

//     List<int> result = [];
//     List<TreeNode> stack = [root];

//     while (stack.isNotEmpty) {
//       TreeNode node = stack.removeLast();
//       result.add(node.val);

//       if (node.right != null) {
//         stack.add(node.right!);
//       }

//       if (node.left != null) {
//         stack.add(node.left!);
//       }
//     }

//     return result;
//   }
// }
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
  List<int> preorderTraversal(TreeNode? root) {
    List<int> result = [];

    void dfs(TreeNode? node) {
      if (node == null) return;

      result.add(node.val);
      dfs(node.left);
      dfs(node.right);
    }

    dfs(root);
    return result;
  }
}