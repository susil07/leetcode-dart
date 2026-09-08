# 🔗 Linked Lists in Dart

A Linked List consists of nodes where each node contains data (`val`) and a reference pointer (`next`) to the subsequent node.

```dart
class ListNode {
  int val;
  ListNode? next;
  ListNode([this.val = 0, this.next]);
}
```

---

## ⚡ 1. Linked List vs. Array Complexities

| Operation | Linked List | Array (`List<T>`) |
| :--- | :---: | :---: |
| **Random Access (`nodeAt(k)`)** | $O(N)$ | **$O(1)$** |
| **Insert / Delete at Head** | **$O(1)$** | $O(N)$ |
| **Insert / Delete at Middle** | **$O(1)$** *(given node pointer)* | $O(N)$ |
| **Search** | $O(N)$ | $O(N)$ |
| **Cache Locality** | Poor (scattered in memory) | Excellent (contiguous) |

---

## 🧩 2. Core Linked List Patterns

### Pattern A: The Dummy Head Pattern

Whenever an algorithm might create a new list or remove the original head node, use a **Dummy Node** (or Sentinel Node). This completely eliminates edge-case checks for empty lists or null heads.

```dart
ListNode dummy = ListNode(0);
ListNode current = dummy;

while (l1 != null && l2 != null) {
  if (l1.val <= l2.val) {
    current.next = l1;
    l1 = l1.next;
  } else {
    current.next = l2;
    l2 = l2.next;
  }
  current = current.next!;
}
current.next = l1 ?? l2;

return dummy.next; // The real head of the new list
```

**Solved in Repo**:
- [0021. Merge Two Sorted Lists](../easy/0021_merge_two_sorted_lists/)
- [0002. Add Two Numbers](../medium/0002_add_two_numbers/)

---

### Pattern B: Fast & Slow Pointers (Floyd's Cycle-Finding Algorithm)

- **Slow pointer**: moves 1 step at a time (`slow = slow.next`).
- **Fast pointer**: moves 2 steps at a time (`fast = fast.next.next`).

If there is a cycle, the fast pointer will eventually lap the slow pointer inside the cycle:

```dart
ListNode? slow = head;
ListNode? fast = head;

while (fast != null && fast.next != null) {
  slow = slow!.next;
  fast = fast.next!.next;

  if (slow == fast) {
    return true; // Cycle detected!
  }
}
return false; // Reached end of list -> No cycle
```

**Solved in Repo**:
- [0141. Linked List Cycle](../easy/0141_linked_list_cycle/)

---

### Pattern C: Two-Pointer Traversal Switch (Intersection)

To find where two lists merge without computing their lengths in advance:
- Advance pointer `a` along List A, and pointer `b` along List B.
- When `a` reaches `null`, redirect it to the head of List B.
- When `b` reaches `null`, redirect it to the head of List A.
- Both pointers travel exactly `Length(A) + Length(B)` steps and meet at the intersection node (or both hit `null`).

```dart
ListNode? a = headA;
ListNode? b = headB;

while (a != b) {
  a = (a == null) ? headB : a.next;
  b = (b == null) ? headA : b.next;
}
return a;
```

**Solved in Repo**:
- [0160. Intersection of Two Linked Lists](../easy/0160_intersection_of_two_linked_lists/)

---

### Pattern D: In-Place Pointer Rewiring

Bypass nodes by repointing the `next` pointer to `next.next`.

```dart
ListNode? curr = head;
while (curr != null && curr.next != null) {
  if (curr.val == curr.next!.val) {
    curr.next = curr.next!.next; // Skip duplicate node
  } else {
    curr = curr.next;
  }
}
return head;
```

**Solved in Repo**:
- [0083. Remove Duplicates from Sorted List](../easy/0083_remove_duplicates_from_sorted_list/)

---

## 🎯 3. The 3 Golden Rules of Linked Lists

1. **Always check for null**: Before accessing `curr.next.val`, ensure both `curr != null` and `curr.next != null`.
2. **Save references before overwriting**: If you plan to change `curr.next`, save the original target (`ListNode? temp = curr.next`) first so you do not orphan the rest of the list.
3. **Draw the nodes**: Trace pointer movements on paper or comments before writing code.
