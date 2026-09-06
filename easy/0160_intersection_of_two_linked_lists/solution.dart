/**
 * Definition for singly-linked list.

 */
  class ListNode {
    int val;
    ListNode? next;
    ListNode([this.val = 0, this.next]);
 }
class Solution {
  ListNode? getIntersectionNode(ListNode? headA, ListNode? headB) {
    ListNode? a = headA;
    ListNode? b = headB;

    while (a != b) {
      a = a == null ? headB : a.next;
      b = b == null ? headA : b.next;
    }

    return a;
  }
}