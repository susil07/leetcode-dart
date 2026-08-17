# 83. Remove Duplicates from Sorted List

**Difficulty:** Easy  
**LeetCode Link:** https://leetcode.com/problems/remove-duplicates-from-sorted-list/

---

## Problem Statement

Given the head of a **sorted linked list**, delete all duplicate nodes so that each value appears only once.

Return the linked list after removing duplicates.

---

## Example

### Example 1

**Input**

```text
head = [1,1,2]
```

**Output**

```text
[1,2]
```

---

### Example 2

**Input**

```text
head = [1,1,2,3,3]
```

**Output**

```text
[1,2,3]
```

---

## Approach

Since the linked list is already sorted, duplicate values will always appear next to each other.

Traverse the list:

- Compare the current node with the next node.
- If both values are equal, skip the duplicate node.
- Otherwise, move to the next node.

---

## Algorithm

1. Start from the head node.
2. While the current node and next node exist:
   - If values are equal:
     - Remove the duplicate by changing the `next` pointer.
   - Otherwise:
     - Move to the next node.
3. Return the head.

---

## Dry Run

Input

```text
1 -> 1 -> 2 -> 3 -> 3
```

Step 1

```text
1 == 1
```

Remove duplicate

```text
1 -> 2 -> 3 -> 3
```

Step 2

```text
2 != 3
```

Move ahead

Step 3

```text
3 == 3
```

Remove duplicate

Final

```text
1 -> 2 -> 3
```

---

## Complexity Analysis

### Time Complexity

```text
O(n)
```

Each node is visited once.

### Space Complexity

```text
O(1)
```

No extra memory is used.

---

## Technique Used

- Linked List Traversal
- Two Pointer
- In-place Modification

---

## Key Takeaways

- Sorted linked lists make duplicate removal straightforward.
- Only adjacent nodes need to be compared.
- No additional data structures are required.
- The solution modifies the list in place.

---

## Dart Solution

```dart
class Solution {
  ListNode? deleteDuplicates(ListNode? head) {
    ListNode? current = head;

    while (current != null && current.next != null) {
      if (current.val == current.next!.val) {
        current.next = current.next!.next;
      } else {
        current = current.next;
      }
    }

    return head;
  }
}
```