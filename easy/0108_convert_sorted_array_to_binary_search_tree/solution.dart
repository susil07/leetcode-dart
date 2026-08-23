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
  TreeNode? sortedArrayToBST(List<int> nums) {
    return _build(nums, 0, nums.length - 1);
  }

  TreeNode? _build(List<int> nums, int left, int right) {
    if (left > right) return null;

    int mid = left + (right - left) ~/ 2;

    TreeNode root = TreeNode(nums[mid]);
    root.left = _build(nums, left, mid - 1);
    root.right = _build(nums, mid + 1, right);

    return root;
  }
}