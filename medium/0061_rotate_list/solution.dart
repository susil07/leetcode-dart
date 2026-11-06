/**
 * Definition for singly-linked list.
 * class ListNode {
 *   int val;
 *   ListNode? next;
 *   ListNode([this.val = 0, this.next]);
 * }
 */

// LeetCode 0061: Rotate List
// Optimal Solution: Ring / Circular Linked List Closure
// Time Complexity: O(N) where N is the number of nodes in the linked list
// Space Complexity: O(1) auxiliary space (operates entirely in-place)

class ListNode {
  int val;
  ListNode? next;
  ListNode([this.val = 0, this.next]);
}

class Solution {
  ListNode? rotateRight(ListNode? head, int k) {
    // Fast path: Empty list, single node, or no rotations required
    if (head == null || head.next == null || k == 0) return head;

    // Step 1: Compute total length and locate the tail node
    int length = 1;
    ListNode tail = head;
    while (tail.next != null) {
      tail = tail.next!;
      length++;
    }

    // Step 2: Normalize k using modulo arithmetic
    // A rotation of length N produces the original list identically
    k = k % length;
    if (k == 0) return head;

    // Step 3: Connect tail to head to temporarily form a circular ring
    tail.next = head;

    // Step 4: Locate the new tail
    // The new head is at index (length - k) from the original head,
    // which means the new tail is at (length - k - 1) from head,
    // or (length - k) forward steps starting from tail.
    int stepsToNewTail = length - k;
    ListNode newTail = tail;
    while (stepsToNewTail > 0) {
      newTail = newTail.next!;
      stepsToNewTail--;
    }

    // Step 5: The node immediately following newTail is the new head
    final ListNode? newHead = newTail.next;

    // Step 6: Break the circular ring to restore a linear singly-linked list
    newTail.next = null;

    return newHead;
  }
}
