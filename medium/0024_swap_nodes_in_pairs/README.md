# 🚀 LeetCode 0024 - Swap Nodes in Pairs

## 📝 Problem Statement

Given a linked list, swap every two adjacent nodes and return its head.

You must solve the problem **without modifying the values in the list's nodes** (i.e., only nodes themselves may be changed).

---

## 🔒 Constraints

- The number of nodes in the list is in the range $[0, 100]$.
- $0 \le \text{Node.val} \le 100$

---

## 💡 Examples

### Example 1
```text
Input: head = [1, 2, 3, 4]
Output: [2, 1, 4, 3]
Explanation:
Pair (1, 2) swapped -> (2, 1)
Pair (3, 4) swapped -> (4, 3)
```

### Example 2
```text
Input: head = []
Output: []
```

### Example 3
```text
Input: head = [1]
Output: [1]
```

### Example 4 (Odd Length)
```text
Input: head = [1, 2, 3, 4, 5]
Output: [2, 1, 4, 3, 5]
Explanation: The last node 5 has no pair, so it remains unchanged.
```

---

# 🧠 Evolution of Solutions: How We Make It Better

```text
┌────────────────────────────────────────────────────────────────────────┐
│  1. Recursive Swap                                                     │
│     • Base case: head == null || head.next == null -> return head      │
│     • Let second = head.next; head.next = swapPairs(second.next)       │
│     • second.next = head; return second                                │
│     • Time: O(N) | Space: O(N) Call Stack                              │
│     • Bottleneck: Uses O(N) stack memory; vulnerable to stack overflow │
└──────────────────────────────────┬─────────────────────────────────────┘
                                   │
                                   ▼ Eliminate Stack Memory with Dummy Head
┌────────────────────────────────────────────────────────────────────────┐
│  2. Iterative with Dummy Node (Optimal Interview Solution)             │
│     • Create dummy node pointing to head: dummy = ListNode(0, head)    │
│     • Track prev, first = prev.next, second = first.next               │
│     • Rewire 3 pointers in-place: O(1) auxiliary memory                │
│     • Advance prev = first                                             │
│     • Time: O(N) | Space: O(1) Auxiliary Space                         │
│     • Improvement: True constant memory, no recursion overhead         │
└──────────────────────────────────┬─────────────────────────────────────┘
                                   │
                                   ▼ Generalization
┌────────────────────────────────────────────────────────────────────────┐
│  3. Generalization to Reverse Nodes in k-Group (k = 2)                 │
│     • Swap Nodes in Pairs is the special case k = 2 of LeetCode 25     │
│     • Counts k nodes, reverses the sublist, stitches back to main list │
│     • Time: O(N) | Space: O(1) Auxiliary Space                         │
└────────────────────────────────────────────────────────────────────────┘
```

---

# 💡 Core Concept: 3-Pointer In-Place Rewiring

When swapping adjacent nodes `first` and `second`, we must maintain the link from the previous node (`prev`) and the link to the remaining list (`second.next`):

```text
Initial State:
  prev ──► [ 1 (first) ] ──► [ 2 (second) ] ──► [ 3 (nextPair) ] ──► ...

Step 1: first.next = second.next
  prev ──► [ 1 ] ──┬──────────────────────────► [ 3 ] ──► ...
                   │
           [ 2 ] ──┘

Step 2: second.next = first
           ┌────────────────┐
           ▼                │
  prev ──► [ 1 ]            [ 2 ] ─────────────► [ 3 ] ──► ...

Step 3: prev.next = second
  prev ──► [ 2 ] ──► [ 1 ] ────────────────────► [ 3 ] ──► ...

Step 4: prev = first (Advance prev for the next pair)
                     prev ─────────────────────► [ 3 ] ──► ...
```

---

# 💻 Solutions

## 1. Approach 1: Recursive Traversal ($O(N)$ Time, $O(N)$ Space)

Swap current pair and recursively solve for the remaining sublist:

```dart
class SolutionRecursive {
  ListNode? swapPairs(ListNode? head) {
    // Base case: 0 or 1 node remaining
    if (head == null || head.next == null) return head;

    // Nodes to swap
    final ListNode first = head;
    final ListNode second = head.next!;

    // Recurse on remaining list and rewire
    first.next = swapPairs(second.next);
    second.next = first;

    return second; // New head of this swapped pair
  }
}
```

### 🔴 Bottlenecks:
- $O(N)$ call stack frames. For long lists, recursion can cause stack overflow.

---

## 2. Approach 2: Iterative with Dummy Node ($O(N)$ Time, $O(1)$ Space) — Optimal

Use a `dummy` node to seamlessly track the head pointer even when the original first node is moved:

```dart
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
```

---

## 3. Approach 3: Generalization (Reverse Nodes in $k$-Group where $k = 2$)

Swap Nodes in Pairs is the base case of **LeetCode 25: Reverse Nodes in $k$-Group**:

```dart
class SolutionKGroup {
  ListNode? swapPairs(ListNode? head) {
    return reverseKGroup(head, 2);
  }

  ListNode? reverseKGroup(ListNode? head, int k) {
    final ListNode dummy = ListNode(0, head);
    ListNode groupPrev = dummy;

    while (true) {
      // Find the k-th node
      ListNode? kth = groupPrev;
      for (int i = 0; i < k && kth != null; i++) {
        kth = kth.next;
      }
      if (kth == null) break;

      final ListNode groupNext = kth.next!;
      ListNode? prev = groupNext;
      ListNode? curr = groupPrev.next;

      // Reverse k nodes
      while (curr != groupNext) {
        final tmp = curr!.next;
        curr.next = prev;
        prev = curr;
        curr = tmp;
      }

      final tmp = groupPrev.next;
      groupPrev.next = kth;
      groupPrev = tmp!;
    }

    return dummy.next;
  }
}
```

---

# 🧪 Step-by-Step Dry Run

Input: `head = [1, 2, 3, 4]`

| Iteration | `prev` node | `first` node | `second` node | List state after iteration | Next `prev` |
| :---: | :---: | :---: | :---: | :--- | :---: |
| **Start** | `dummy (0)` | — | — | `0 -> 1 -> 2 -> 3 -> 4` | `dummy` |
| **1** | `dummy (0)` | `1` | `2` | `0 -> 2 -> 1 -> 3 -> 4` | `1` |
| **2** | `1` | `3` | `4` | `0 -> 2 -> 1 -> 4 -> 3 -> null` | `3` |
| **End** | `3` | `null` | — | Loop terminates (`prev.next == null`) | — |

**Final Return**: `dummy.next` $\rightarrow$ `[2, 1, 4, 3]` 🎉

---

# 📊 Comprehensive Comparison Matrix

| Metric | 1. Recursive Approach | 2. Iterative with Dummy (Optimal) | 3. Reverse in $k$-Group ($k = 2$) |
| :--- | :--- | :--- | :--- |
| **Time Complexity** | $O(N)$ | **$O(N)$** | **$O(N)$** |
| **Auxiliary Space** | $O(N)$ (Call stack) | **$O(1)$ (Pointer variables only)** | **$O(1)$** |
| **Risk of Stack Overflow** | ⚠️ Yes (Deep recursion) | ❌ None | ❌ None |
| **Pointer Manipulations** | 2 per frame | **3 per loop** | $k + 2$ per group |
| **Extensibility** | Fixed to $k = 2$ | Fixed to $k = 2$ | **Scales to arbitrary $k$** |
| **Interview Rating** | Good discussion point | 🏆 **Gold Standard Expected** | 🌟 **Senior Follow-Up Ready** |

---

# ⚠️ Key Interview Gotchas & Edge Cases

1. **"You must not modify values inside nodes"**:
   - Swapping values (`final temp = first.val; first.val = second.val; second.val = temp;`) is specifically forbidden in the problem statement and will result in an automatic rejection in real interviews.
2. **Odd Number of Nodes**:
   - The loop condition `while (prev.next != null && prev.next!.next != null)` guarantees that if the remaining sublist has only 1 node, the loop cleanly terminates and leaves the last node untouched.
3. **Empty List / Single Node**:
   - Returns `head` immediately in $O(1)$ time without entering the loop.
4. **Why `dummy` Node is Essential**:
   - In linked list problems where the original head node changes position (`1` moves to index 1, `2` becomes the new head), a dummy node ensures you never lose the reference to the new head (`dummy.next`).
