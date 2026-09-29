/**
 * Definition for singly-linked list.
 * class ListNode {
 *   int val;
 *   ListNode? next;
 *   ListNode([this.val = 0, this.next]);
 * }
 */

// LeetCode 0024: Swap Nodes in Pairs
// Optimal Solution: Iterative Pointer Rewiring with Dummy Node
// Time Complexity: O(N) | Space Complexity: O(1) Auxiliary Space

class ListNode {
  int val;
  ListNode? next;
  ListNode([this.val = 0, this.next]);
}

class Solution {
  ListNode? swapPairs(ListNode? head) {
    // Fast path: Empty list or single node requires no swaps
    if (head == null || head.next == null) return head;

    // Dummy node points to head to simplify edge cases at the start of the list
    final ListNode dummy = ListNode(0, head);
    ListNode prev = dummy;

    // Continue as long as there is an adjacent pair (first and second) to swap
    while (prev.next != null && prev.next!.next != null) {
      final ListNode first = prev.next!;
      final ListNode second = first.next!;

      // Rewire pointers:
      // prev -> first -> second -> nextPair
      // becomes:
      // prev -> second -> first -> nextPair
      first.next = second.next;
      second.next = first;
      prev.next = second;

      // Advance prev to 'first', which is now the second node in this swapped pair
      prev = first;
    }

    return dummy.next;
  }
}
