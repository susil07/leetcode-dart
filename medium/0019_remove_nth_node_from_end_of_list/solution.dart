/**
 * Definition for singly-linked list.
 * class ListNode {
 *   int val;
 *   ListNode? next;
 *   ListNode([this.val = 0, this.next]);
 * }
 */

// LeetCode 0019: Remove Nth Node From End of List
// Optimal Solution: One-Pass Two Pointers (Fast & Slow) with Dummy Node
// Time Complexity: O(L) | Space Complexity: O(1) Auxiliary Space

class ListNode {
  int val;
  ListNode? next;
  ListNode([this.val = 0, this.next]);
}

class Solution {
  ListNode? removeNthFromEnd(ListNode? head, int n) {
    // Dummy node points to head, seamlessly handling deletion of the head node
    final ListNode dummy = ListNode(0, head);
    ListNode? fast = dummy;
    ListNode? slow = dummy;

    // Advance fast pointer by n + 1 steps to establish a gap of n between fast and slow
    for (int i = 0; i <= n; i++) {
      fast = fast?.next;
    }

    // Move both pointers forward until fast moves beyond the end of the list
    while (fast != null) {
      fast = fast.next;
      slow = slow!.next;
    }

    // slow is now positioned immediately before the target node
    slow!.next = slow.next?.next;

    return dummy.next;
  }
}
