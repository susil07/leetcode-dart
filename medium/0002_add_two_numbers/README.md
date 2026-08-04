# 0002. Add Two Numbers

- **Difficulty:** Medium
- **Category:** Linked List, Math
- **Language:** Dart

---

# Problem Statement

You are given two **non-empty linked lists** representing two non-negative integers.

The digits are stored in **reverse order**, and each node contains a single digit.

Add the two numbers and return the sum as a linked list.

You may assume the two numbers do not contain any leading zeros except the number `0` itself.

---

# Example

### Example 1

```text
Input:

l1 = [2,4,3]
l2 = [5,6,4]

Output:

[7,0,8]
```

Explanation

```text
342 + 465 = 807
```

Since the digits are stored in reverse order,

```text
2 → 4 → 3

represents

342
```

Similarly,

```text
5 → 6 → 4

represents

465
```

The answer is

```text
342 + 465 = 807
```

Return

```text
7 → 0 → 8
```

because the answer must also be stored in reverse order.

---

# Solution

```dart
class Solution {
  ListNode? addTwoNumbers(ListNode? l1, ListNode? l2) {
    ListNode dummy = ListNode(0);
    ListNode current = dummy;

    int carry = 0;

    while (l1 != null || l2 != null || carry != 0) {
      int sum = carry;

      if (l1 != null) {
        sum += l1.val;
        l1 = l1.next;
      }

      if (l2 != null) {
        sum += l2.val;
        l2 = l2.next;
      }

      carry = sum ~/ 10;

      current.next = ListNode(sum % 10);
      current = current.next!;
    }

    return dummy.next;
  }
}
```

---

# Technique Used

- Linked List Traversal
- Simulation
- Carry Forward
- Dummy Node

---

# Understanding the Problem

Unlike normal integer addition, we cannot convert the linked list into an integer because the number may be very large.

Instead, we perform addition exactly like we do on paper.

We process one digit at a time.

Example

```text
  342
+ 465
-----
  807
```

Since the linked lists are stored in reverse,

```text
2 → 4 → 3

means

342
```

which is actually convenient because addition always starts from the one's place.

---

# Algorithm

1. Create a dummy node.
2. Create a pointer (`current`) pointing to the dummy node.
3. Initialize `carry = 0`.
4. Traverse both linked lists simultaneously.
5. Calculate

```text
sum = carry + l1 value + l2 value
```

6. Store

```text
sum % 10
```

inside a new node.

7. Update carry

```text
carry = sum ~/ 10
```

8. Move to the next nodes.
9. Continue until

- both linked lists become `null`
- carry becomes `0`

10. Return

```text
dummy.next
```

---

# Dry Run

Input

```text
l1 = 2 → 4 → 3

l2 = 5 → 6 → 4
```

Carry = 0

---

### Iteration 1

```text
2 + 5 + 0 = 7
```

Digit

```text
7
```

Carry

```text
0
```

Result

```text
7
```

---

### Iteration 2

```text
4 + 6 + 0 = 10
```

Digit

```text
10 % 10 = 0
```

Carry

```text
10 ~/ 10 = 1
```

Result

```text
7 → 0
```

---

### Iteration 3

```text
3 + 4 + 1 = 8
```

Digit

```text
8
```

Carry

```text
0
```

Final Result

```text
7 → 0 → 8
```

---

# Why do we use a Dummy Node?

Instead of handling the first node separately, we create a dummy node.

Example

```text
dummy

↓

0 → null
```

Every newly created node is attached after the dummy node.

Finally,

```text
return dummy.next
```

This avoids writing extra code for the head node.

---

# Why do we use Carry?

Example

```text
9 + 8 = 17
```

Store

```text
7
```

Carry

```text
1
```

The carry is added to the next digit exactly like manual addition.

---

# Why do we continue while carry exists?

Example

```text
l1 = [9]

l2 = [1]
```

```text
9 + 1 = 10
```

After both linked lists finish,

we still have

```text
carry = 1
```

So we must create one final node.

Without checking

```text
carry != 0
```

the answer would become incorrect.

---

# Visualization

```text
l1

2 → 4 → 3

l2

5 → 6 → 4

--------------------

2 + 5 = 7

Result

7

Carry = 0

--------------------

4 + 6 + Carry

4 + 6 + 0 = 10

Digit = 0

Carry = 1

Result

7 → 0

--------------------

3 + 4 + Carry

3 + 4 + 1 = 8

Result

7 → 0 → 8
```

---

# Time Complexity

Let

```text
n = length of l1

m = length of l2
```

Each node is visited exactly once.

Therefore,

```text
Time Complexity = O(max(n, m))
```

---

# Space Complexity

The algorithm uses only

- one dummy node
- one pointer
- one carry variable

The output linked list is required by the problem, so it is **not counted** as extra space.

Therefore,

```text
Auxiliary Space = O(1)
```

---

# Advantages

- Single traversal
- Efficient
- Easy to understand
- Handles different length linked lists
- Handles carry automatically

---

# Disadvantages

- Requires creating a new linked list.
- Requires understanding linked list manipulation.

---

# Key Concepts Learned

- Linked List Traversal
- Dummy Node
- Carry Forward
- Pointer Manipulation
- Simulation

---

# Interview Questions

### Why are digits stored in reverse order?

Because addition starts from the least significant digit.

---

### Why do we use a dummy node?

To simplify linked list construction and avoid handling the first node separately.

---

### Why is carry required?

To handle sums greater than 9.

---

### Why is Time Complexity O(max(n, m))?

Because each node is processed exactly once.

---

### Why is Auxiliary Space O(1)?

The algorithm only uses a few variables.

The output linked list is not counted as extra memory.

---

### Can we solve this without creating a new linked list?

Yes, by modifying one of the input lists in place, but that changes the original input and makes the solution less clean. Creating a new list is the preferred interview approach.

---

# Final Complexity

| Property | Value |
|----------|-------|
| Technique | Linked List Traversal + Simulation |
| Data Structure | Linked List |
| Time Complexity | O(max(n, m)) |
| Auxiliary Space | O(1) |
| Difficulty | Medium |

---

# Takeaway

This problem introduces one of the most important Linked List interview patterns:

- Traverse multiple linked lists simultaneously.
- Use a dummy node to simplify list construction.
- Handle carry exactly like manual addition.
- Process each node only once for an efficient O(max(n, m)) solution.