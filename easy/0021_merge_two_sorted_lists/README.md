# 0021. Merge Two Sorted Lists

- **Difficulty:** Easy
- **Category:** Linked List, Two Pointers
- **Language:** Dart

---

# Problem Statement

You are given the heads of two sorted linked lists `list1` and `list2`.

Merge the two lists into one sorted linked list by splicing together the nodes of the two input lists.

Return the head of the merged linked list.

---

# Example

### Example 1

```text
Input:

list1 = [1,2,4]
list2 = [1,3,4]

Output:

[1,1,2,3,4,4]
```

---

### Example 2

```text
Input:

list1 = []
list2 = []

Output:

[]
```

---

### Example 3

```text
Input:

list1 = []
list2 = [0]

Output:

[0]
```

---

# Solution

```dart
class Solution {
  ListNode? mergeTwoLists(ListNode? list1, ListNode? list2) {
    ListNode dummy = ListNode(0);
    ListNode current = dummy;

    while (list1 != null && list2 != null) {
      if (list1.val <= list2.val) {
        current.next = list1;
        list1 = list1.next;
      } else {
        current.next = list2;
        list2 = list2.next;
      }

      current = current.next!;
    }

    if (list1 != null) {
      current.next = list1;
    }

    if (list2 != null) {
      current.next = list2;
    }

    return dummy.next;
  }
}
```

---

# Technique Used

- Linked List
- Two Pointers
- Dummy Node
- Merge Technique

---

# Understanding the Problem

Both linked lists are already sorted.

Our goal is to merge them while maintaining the sorted order.

Instead of creating new nodes, we simply rearrange the existing nodes by updating their `next` pointers.

---

# Algorithm

1. Create a dummy node.
2. Create a pointer `current` pointing to the dummy node.
3. Compare the first nodes of both lists.
4. Attach the smaller node to the merged list.
5. Move the pointer of the list from which the node was taken.
6. Move `current` to the newly attached node.
7. Continue until one list becomes empty.
8. Attach the remaining nodes of the other list.
9. Return `dummy.next`.

---

# Dry Run

Input

```text
list1

1 → 2 → 4

list2

1 → 3 → 4
```

Initially

```text
dummy

↓

0

current = dummy
```

---

### Step 1

Compare

```text
1 and 1
```

Choose

```text
1 (list1)
```

Merged List

```text
1
```

Move

```text
list1

2 → 4
```

---

### Step 2

Compare

```text
2 and 1
```

Choose

```text
1 (list2)
```

Merged List

```text
1 → 1
```

Move

```text
list2

3 → 4
```

---

### Step 3

Compare

```text
2 and 3
```

Choose

```text
2
```

Merged List

```text
1 → 1 → 2
```

---

### Step 4

Compare

```text
4 and 3
```

Choose

```text
3
```

Merged List

```text
1 → 1 → 2 → 3
```

---

### Step 5

Compare

```text
4 and 4
```

Choose

```text
4 (list1)
```

Merged List

```text
1 → 1 → 2 → 3 → 4
```

Now `list1` becomes `null`.

Attach the remaining nodes from `list2`.

Final Result

```text
1 → 1 → 2 → 3 → 4 → 4
```

---

# Visualization

```text
List 1

1 → 2 → 4

List 2

1 → 3 → 4

↓

Merged

1 → 1 → 2 → 3 → 4 → 4
```

---

# Why do we use a Dummy Node?

Instead of handling the first node separately, we create a dummy node.

```text
dummy

↓

0 → null
```

Every selected node is attached after `current`.

Finally,

```dart
return dummy.next;
```

This simplifies the implementation and avoids special cases.

---

# Why do we use Two Pointers?

We use one pointer for each linked list.

```text
list1 → current node

list2 → current node
```

At every step, we compare both nodes and attach the smaller one.

---

# Why don't we create new nodes?

The existing nodes are already available.

We only change the `next` pointers.

This saves memory and makes the solution more efficient.

---

# Time Complexity

Let

```text
m = length of list1

n = length of list2
```

Each node is visited exactly once.

Therefore,

```text
Time Complexity = O(m + n)
```

---

# Space Complexity

The algorithm only uses:

- Dummy node
- Current pointer

No additional linked list is created.

Therefore,

```text
Auxiliary Space = O(1)
```

---

# Advantages

- Efficient
- Single traversal
- Constant extra space
- Easy to understand
- Reuses existing nodes

---

# Disadvantages

- Requires understanding linked list pointer manipulation.

---

# Key Concepts Learned

- Linked List Traversal
- Dummy Node
- Two Pointers
- Merge Technique
- Pointer Manipulation

---

# Interview Questions

### Why use a Dummy Node?

It avoids special handling for the first node of the merged list.

---

### Why use Two Pointers?

To compare the current nodes of both sorted lists efficiently.

---

### Why is Time Complexity O(m + n)?

Each node from both lists is processed exactly once.

---

### Why is Space Complexity O(1)?

Only a few pointers are used.

The existing nodes are reused instead of creating new ones.

---

### What happens if one list becomes empty?

Simply attach the remaining nodes of the other list.

Example

```text
List 1

4 → 5

List 2

null
```

Attach

```text
4 → 5
```

directly to the merged list.

---

# Final Complexity

| Property | Value |
|----------|-------|
| Technique | Merge Technique |
| Data Structure | Linked List |
| Time Complexity | O(m + n) |
| Space Complexity | O(1) |
| Difficulty | Easy |

---

# Takeaway

This problem introduces one of the most important Linked List patterns used in interviews.

It teaches:

- Using a **Dummy Node** to simplify list construction.
- Using **Two Pointers** to process two sorted lists simultaneously.
- Reusing existing nodes instead of creating new ones.
- The merge technique, which is also used in **Merge Sort**, **Merge K Sorted Lists**, and several interval-based problems.