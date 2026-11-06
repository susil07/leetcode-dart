# 🚀 LeetCode 0061 - Rotate List

## 📝 Problem Statement

Given the `head` of a singly-linked list, rotate the list to the right by `k` places.

---

## 🔒 Constraints

- The number of nodes in the list is in the range `[0, 500]`.
- `-100 <= Node.val <= 100`
- `0 <= k <= 2 * 10^9`

---

## 💡 Examples

### Example 1
```text
Input: head = [1, 2, 3, 4, 5], k = 2
Output: [4, 5, 1, 2, 3]
```

```text
Original:    [ 1 ] ──► [ 2 ] ──► [ 3 ] ──► [ 4 ] ──► [ 5 ] ──► null

Rotate 1:    [ 5 ] ──► [ 1 ] ──► [ 2 ] ──► [ 3 ] ──► [ 4 ] ──► null

Rotate 2:    [ 4 ] ──► [ 5 ] ──► [ 1 ] ──► [ 2 ] ──► [ 3 ] ──► null
```

### Example 2
```text
Input: head = [0, 1, 2], k = 4
Output: [2, 0, 1]
```

```text
Original:    [ 0 ] ──► [ 1 ] ──► [ 2 ] ──► null

Rotate 1:    [ 2 ] ──► [ 0 ] ──► [ 1 ] ──► null
Rotate 2:    [ 1 ] ──► [ 2 ] ──► [ 0 ] ──► null
Rotate 3:    [ 0 ] ──► [ 1 ] ──► [ 2 ] ──► null  (identical to original!)
Rotate 4:    [ 2 ] ──► [ 0 ] ──► [ 1 ] ──► null
```

---

# 📐 Core Architectural Insight: Modulo Arithmetic & Ring Closure

### 1. The Periodic Symmetry of Rotation
A linked list of length $N$ rotated $N$ times returns to its exact original state.
Therefore, any arbitrary rotation count $k$ can be reduced via the modulo operator:

$$k_{\text{eff}} = k \pmod N$$

When $k = 2 \times 10^9$ and $N = 5$, computing $2 \times 10^9 \pmod 5 = 0$ reduces billions of operations to **zero** work!

### 2. Identifying the Pivot Cut
Rotating right by $k_{\text{eff}}$ places means that:
- The **last $k_{\text{eff}}$ nodes** are detached and moved to the front.
- The **first $(N - k_{\text{eff}})$ nodes** remain together and move to the back.
- The **new tail** is at position index $(N - k_{\text{eff}} - 1)$ (0-indexed from the original `head`).
- The **new head** is the immediate successor at position $(N - k_{\text{eff}})$.

```text
                       (N - k) nodes                 k nodes
               ┌───────────────────────────┐ ┌───────────────────┐
head ──► [ 1 ] ──► [ 2 ] ──► [ 3 ] ──► [ 4 ] ──► [ 5 ] ──► [ 6 ] ──► null
                                │        ▲
                                │        │
                             New Tail  New Head
                                │
                                ▼
                       Break: next = null
```

### 3. Forming a Temporary Ring
By connecting the original tail back to the head:
$$\text{tail}.\text{next} = \text{head}$$
The singly-linked list becomes a **circular ring**. To complete the rotation, we simply advance $(N - k_{\text{eff}})$ steps around the ring, designate that node as `newTail`, capture `newTail.next` as `newHead`, and sever `newTail.next = null`.

---

# 🧠 Evolution of Solutions: How We Make It Better

```text
┌────────────────────────────────────────────────────────────────────────┐
│  1. Naive Simulation (One-by-One Rotation)                             │
│     • Repeatedly find second-to-last node and move tail to front k times│
│     • Time: O(k * N) | Space: O(1) auxiliary                           │
│     • Fatal Flaw: TLE when k = 2 * 10^9 (~10^12 operations)           │
└──────────────────────────────────┬─────────────────────────────────────┘
                                   │
                                   ▼ Eliminate Redundancy via Modulo + Buffering
┌────────────────────────────────────────────────────────────────────────┐
│  2. Array / Vector Buffer                                              │
│     • Store node references in an array; index directly via modulo     │
│     • Time: O(N) | Space: O(N) auxiliary                               │
│     • Bottleneck: O(N) extra heap memory allocated for node pointers   │
└──────────────────────────────────┬─────────────────────────────────────┘
                                   │
                                   ▼ In-Place Traversal with Two Pointers
┌────────────────────────────────────────────────────────────────────────┐
│  3. Fast & Slow Pointer Window                                         │
│     • Advance fast pointer by k_eff steps, then move both to find split │
│     • Time: O(N) | Space: O(1) auxiliary                               │
│     • Limitation: Requires two separate traversal passes over list     │
└──────────────────────────────────┬─────────────────────────────────────┘
                                   │
                                   ▼ Seamless Circular Ring Rewiring
┌────────────────────────────────────────────────────────────────────────┐
│  4. Ring / Circular Linked List Closure (Optimal & Gold Standard)       │
│     • Connect tail to head into a cycle in pass 1                      │
│     • Walk (N - k_eff) steps directly from tail to cut the ring        │
│     • Time: O(N) | Space: O(1) auxiliary                               │
│     • Value: Minimal pointer writes, single-phase logic, elegant code   │
└────────────────────────────────────────────────────────────────────────┘
```

---

# 💻 Solutions

## 1. Approach 1: Naive Simulation (One-by-One Rotation)

Simulate rotating the list by 1 step, repeated $k$ times:

```dart
class SolutionNaiveSimulation {
  ListNode? rotateRight(ListNode? head, int k) {
    if (head == null || head.next == null || k == 0) return head;

    for (int step = 0; step < k; step++) {
      // Find the second-to-last node
      ListNode prev = head;
      while (prev.next!.next != null) {
        prev = prev.next!;
      }

      // Detach the last node and make it the new head
      ListNode tail = prev.next!;
      prev.next = null;
      tail.next = head;
      head = tail;
    }

    return head;
  }
}
```

### 🔴 Bottlenecks:
- **Catastrophic Time Complexity**: For $N = 500$ and $k = 2 \times 10^9$, this executes $10^{12}$ pointer operations, timing out by orders of magnitude.
- Even if $k$ is reduced via $k = k \pmod N$ upfront, simulation still costs $\mathcal{O}(k_{\text{eff}} \cdot N) = \mathcal{O}(N^2)$ in the worst case.

---

## 2. Approach 2: Array / Vector Buffer ($\mathcal{O}(N)$ Time, $\mathcal{O}(N)$ Space)

Extract node references into a dynamic list, enabling $\mathcal{O}(1)$ random access to the split points:

```dart
class SolutionArrayBuffer {
  ListNode? rotateRight(ListNode? head, int k) {
    if (head == null || head.next == null || k == 0) return head;

    // Collect all nodes into a linear list
    final List<ListNode> nodes = [];
    ListNode? curr = head;
    while (curr != null) {
      nodes.add(curr);
      curr = curr.next;
    }

    final int n = nodes.length;
    k = k % n;
    if (k == 0) return head;

    // Rewire links
    nodes[n - 1].next = nodes[0]; // Tail points to head
    nodes[n - k - 1].next = null; // New tail terminates
    return nodes[n - k];          // New head
  }
}
```

### 🔴 Bottlenecks:
- Allocates $\mathcal{O}(N)$ additional heap memory to store node references.
- Unnecessary when linked lists can be rearranged purely by rewiring internal pointers.

---

## 3. Approach 3: Fast & Slow Pointer Window ($\mathcal{O}(N)$ Time, $\mathcal{O}(1)$ Space)

Find the list length $N$, normalize $k$, then use two pointers spaced $k$ nodes apart to locate the cut position:

```dart
class SolutionTwoPointers {
  ListNode? rotateRight(ListNode? head, int k) {
    if (head == null || head.next == null || k == 0) return head;

    // Pass 1: Measure length
    int length = 0;
    ListNode? curr = head;
    while (curr != null) {
      length++;
      curr = curr.next;
    }

    k = k % length;
    if (k == 0) return head;

    // Pass 2: Maintain a window of size k
    ListNode fast = head;
    ListNode slow = head;

    for (int i = 0; i < k; i++) {
      fast = fast.next!;
    }

    while (fast.next != null) {
      fast = fast.next!;
      slow = slow.next!;
    }

    // slow is now at newTail, fast is at old tail
    final ListNode? newHead = slow.next;
    slow.next = null;
    fast.next = head;

    return newHead;
  }
}
```

### 🟢 Advantages:
- $\mathcal{O}(1)$ auxiliary space.
- Clean two-pointer sliding window concept.

---

## 4. Approach 4: Circular Ring Closure (Optimal & Gold Standard)

Traverse once to find the length and stop **on the tail node** (`tail.next == null`). Immediately link `tail.next = head` into a circular ring, then traverse $(N - k)$ steps to cut the ring:

```dart
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
```

### 🟢 Why This is the Most Optimal:
- **Linear Time $\mathcal{O}(N)$**:
  - Exactly $(N - 1)$ pointer steps in pass 1 to reach tail and compute length.
  - Exactly $(N - k)$ pointer steps in pass 2 to reach `newTail`.
  - Total steps $= 2N - 1 - k \le 2N$ node visits.
- **Strictly $\mathcal{O}(1)$ Space**: Only three local pointer references (`tail`, `newTail`, `newHead`).
- **Minimal Link Rewiring**: Exactly **two** pointer assignments:
  1. `tail.next = head` (close ring)
  2. `newTail.next = null` (break ring)

---

# 📊 Comprehensive Comparison Matrix

| Metric | Approach 1: Naive Simulation | Approach 2: Array Buffer | Approach 3: Fast & Slow Window | Approach 4: Circular Ring Closure (Optimal) |
| :--- | :--- | :--- | :--- | :--- |
| **Time Complexity** | $\mathcal{O}(k \cdot N)$ | $\mathcal{O}(N)$ | $\mathcal{O}(N)$ | $\mathcal{O}(N)$ |
| **Auxiliary Space** | $\mathcal{O}(1)$ | $\mathcal{O}(N)$ | $\mathcal{O}(1)$ | $\mathcal{O}(1)$ |
| **Max Node Visits** | Up to $10^{12}$ (TLE) | $N$ visits | $2N - k$ visits | $2N - 1 - k$ visits |
| **Pointer Rewires** | $2 \times k$ writes | 2 writes | 2 writes | **2 writes** |
| **Memory Allocations**| $0$ | $1$ `List<ListNode>` of size $N$ | $0$ | **$0$** |
| **Handles $k \gg N$** | ❌ TLE | ✅ via $k \pmod N$ | ✅ via $k \pmod N$ | ✅ via $k \pmod N$ |
| **Code Simplicity** | Low | High | Medium | **High** |

---

# ⚠️ Key Interview Gotchas & Edge Cases

1. **$k$ Greater Than List Length ($k \ge N$)**:
   - $k$ can be up to $2 \times 10^9$, whereas $N \le 500$.
   - Failing to compute `k = k % length` will cause excessive work or out-of-bounds indexing.

2. **$k \pmod N == 0$**:
   - When $k$ is an exact multiple of $N$ (or $k = 0$), rotating by $k$ results in no change.
   - Guard condition `if (k == 0) return head;` avoids unnecessary cyclic rewiring.

3. **Empty List ($N = 0$) & Single-Node List ($N = 1$)**:
   - For `head == null` or `head.next == null`, return `head` immediately.
   - Prevents null dereferences when measuring `tail.next` or calculating modulo with zero.

4. **Severing the Circular Ring**:
   - Forgetting `newTail.next = null;` leaves a cyclic linked list, resulting in an infinite loop when serialized or traversed during testing.

5. **Step Offset Calculation**:
   - From `head`, `newTail` is at offset $(N - k - 1)$.
   - From `tail`, `newTail` is at offset $(N - k)$ because `tail.next == head`.
   - Starting from `tail` is cleaner and saves an extra pointer variable.
