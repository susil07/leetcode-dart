# 🚀 LeetCode 0019 - Remove Nth Node From End of List

## 📝 Problem Statement

Given the `head` of a linked list, remove the $n^{\text{th}}$ node from the **end of the list** and return its `head`.

---

## 🔒 Constraints

- The number of nodes in the list is $sz$.
- $1 \le sz \le 30$
- $0 \le \text{Node.val} \le 100$
- $1 \le n \le sz$

**Follow up:** Could you do this in **one pass**?

---

## 💡 Examples

### Example 1
```text
Input: head = [1, 2, 3, 4, 5], n = 2
Output: [1, 2, 3, 5]
Explanation: The 2nd node from the end is node 4. Removing node 4 yields [1, 2, 3, 5].
```

### Example 2
```text
Input: head = [1], n = 1
Output: []
Explanation: The list contains only 1 node. Removing the 1st node from the end yields an empty list.
```

### Example 3
```text
Input: head = [1, 2], n = 1
Output: [1]
Explanation: Removing the last node yields [1].
```

### Example 4 (Removing the Head Node)
```text
Input: head = [1, 2], n = 2
Output: [2]
Explanation: The 2nd node from the end is the head node 1.
```

---

# 🧠 Evolution of Solutions: How We Make It Better

```text
┌────────────────────────────────────────────────────────────────────────┐
│  1. Two-Pass Length Counting                                          │
│     • Pass 1: Traverse entire list to compute length L                 │
│     • Pass 2: Traverse (L - n) steps to locate node before target      │
│     • Relink: curr.next = curr.next.next                               │
│     • Time: O(L) [2 passes = 2L operations] | Space: O(1)              │
│     • Bottleneck: Traverses list twice; not single-pass                │
└──────────────────────────────────┬─────────────────────────────────────┘
                                   │
                                   ▼ Single-Pass via Stack
┌────────────────────────────────────────────────────────────────────────┐
│  2. Single-Pass Using Stack                                            │
│     • Push all nodes onto a stack                                      │
│     • Pop n nodes; stack top is now node before target                 │
│     • Time: O(L) [1 pass] | Space: O(L) Stack Memory                   │
│     • Bottleneck: Extra O(L) memory overhead                           │
└──────────────────────────────────┬─────────────────────────────────────┘
                                   │
                                   ▼ Maintain Constant Distance Window
┌────────────────────────────────────────────────────────────────────────┐
│  3. One-Pass Fast & Slow Two Pointers with Dummy Node (Optimal)        │
│     • Initialize dummy node pointing to head: dummy = ListNode(0, head)│
│     • Advance fast pointer by (n + 1) steps to create a fixed gap      │
│     • Move fast and slow in lockstep until fast reaches null           │
│     • slow is now GUARANTEED to be right before the target node!       │
│     • Relink: slow.next = slow.next.next                               │
│     • Time: O(L) [Exactly 1 pass] | Space: O(1) Auxiliary Space       │
└────────────────────────────────────────────────────────────────────────┘
```

---

# 💡 Core Concept: Fixed-Gap Two Pointers

By maintaining a constant distance of **$n + 1$** between `fast` and `slow`, when `fast` falls off the end of the list (`fast == null`), `slow` lands **strictly on the node before the one to be deleted**.

```text
Target: Remove n = 2 from end of list [1, 2, 3, 4, 5] (sz = 5)

Step 1: Place dummy node and advance fast by (n + 1 = 3) steps:
  dummy ──► [ 1 ] ──► [ 2 ] ──► [ 3 ] ──► [ 4 ] ──► [ 5 ] ──► null
    ▲                             ▲
  slow                          fast (Gap = 3 nodes)

Step 2: Advance both pointers in lockstep until fast == null:
  dummy ──► [ 1 ] ──► [ 2 ] ──► [ 3 ] ──► [ 4 ] ──► [ 5 ] ──► null
                                  ▲                             ▲
                                slow                          fast

Step 3: Relink slow.next = slow.next.next (Node 4 is bypassed):
  dummy ──► [ 1 ] ──► [ 2 ] ──► [ 3 ] ───────┐
                                  ▲          │
                                slow         ▼
                               [ 4 ]      [ 5 ] ──► null

Result: dummy.next => [1, 2, 3, 5] 🎉
```

---

# 💻 Solutions

## 1. Approach 1: Two-Pass Length Counting ($O(L)$ Time, $O(1)$ Space)

First count the total number of nodes, then find the $(L - n)^{\text{th}}$ node:

```dart
class SolutionTwoPass {
  ListNode? removeNthFromEnd(ListNode? head, int n) {
    int length = 0;
    ListNode? curr = head;
    while (curr != null) {
      length++;
      curr = curr.next;
    }

    final ListNode dummy = ListNode(0, head);
    curr = dummy;
    for (int i = 0; i < length - n; i++) {
      curr = curr!.next;
    }

    curr!.next = curr.next?.next;
    return dummy.next;
  }
}
```

### 🔴 Bottlenecks:
- Requires traversing the list twice ($2L - n$ node visits).
- Does not satisfy the interview follow-up challenge of solving in **a single pass**.

---

## 2. Approach 2: One-Pass with Stack ($O(L)$ Time, $O(L)$ Space)

Push nodes onto a stack to reverse the traversal order:

```dart
class SolutionStack {
  ListNode? removeNthFromEnd(ListNode? head, int n) {
    final ListNode dummy = ListNode(0, head);
    final List<ListNode> stack = [];
    ListNode? curr = dummy;

    while (curr != null) {
      stack.add(curr);
      curr = curr.next;
    }

    for (int i = 0; i < n; i++) {
      stack.removeLast();
    }

    final ListNode prev = stack.last;
    prev.next = prev.next?.next;

    return dummy.next;
  }
}
```

### 🔴 Bottlenecks:
- Allocates an array of size $L$, consuming unnecessary $O(L)$ memory.

---

## 3. Approach 3: One-Pass Two Pointers with Dummy Node (Optimal)

### 💡 How We Make It Better:
1. Advance `fast` by $n + 1$ steps.
2. Advance both `fast` and `slow` together until `fast == null`.
3. `slow` stops directly at the predecessor node, allowing deletion in $O(1)$ time with zero extra allocations.

```dart
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
```

---

# 🧪 Step-by-Step Dry Run (Removing Head: `[1, 2]`, `n = 2`)

| Step | `fast` Pointer | `slow` Pointer | Description |
| :---: | :---: | :---: | :--- |
| **Initial** | `dummy (0)` | `dummy (0)` | Setup dummy pointing to `1 -> 2 -> null` |
| **Advance `fast`** | `null` (after 3 steps: `0 -> 1 -> 2 -> null`) | `dummy (0)` | Fast advanced $n + 1 = 3$ steps |
| **While loop** | `null` | `dummy (0)` | `while (fast != null)` condition is false immediately! |
| **Relink** | — | `dummy.next = dummy.next.next` | `dummy.next` bypassed `1`, now points to `2` |

**Final Output:** `[2]` 🎉

---

# 📊 Comprehensive Comparison Matrix

| Metric | 1. Two-Pass Counting | 2. Stack-Based | 3. Fast & Slow Two Pointers (Optimal) |
| :--- | :--- | :--- | :--- |
| **Time Complexity** | $O(L)$ (2 passes) | $O(L)$ (1 pass) | **$O(L)$ (Strictly 1 pass)** |
| **Auxiliary Space** | $O(1)$ | $O(L)$ stack | **$O(1)$ (Pointer variables only)** |
| **Number of Traversal Passes** | 2 | 1 | **1** |
| **Deletes Head Cleanly?** | With Dummy | With Dummy | **With Dummy** |
| **Interview Suitability** | Acceptable | Suboptimal space | 🏆 **Gold Standard Expected** |

---

# ⚠️ Key Interview Gotchas & Edge Cases

1. **Why Advance by $n + 1$ instead of $n$?**
   - If you advance `fast` by $n$ steps, `slow` would land on the **target node itself** when `fast` reaches the end node.
   - Advancing by $n + 1$ steps places `slow` on the **predecessor** of the target node, which is required to change `slow.next = slow.next.next`.
2. **Deleting the Head Node ($n = \text{length}$)**:
   - When deleting the head node, `dummy` acts as the predecessor, eliminating any special-case `if (n == length)` branch.
3. **Single Node List ($[1], n = 1$)**:
   - `fast` advances to `null`, `slow` stays at `dummy`.
   - `dummy.next = null`, returning empty list `[]` correctly.
4. **Dart Null-Safety**:
   - Marking `ListNode? fast` and using `fast?.next` during the initial advance avoids runtime `NullPointer` exceptions when `n == length`.
