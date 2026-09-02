# 🚀 LeetCode 141 - Linked List Cycle

## 📝 Problem

Given the head of a linked list, determine whether the linked list contains a cycle.

A cycle exists if a node can be reached again by continuously following the `next` pointer.

Return:

- `true` if a cycle exists.
- `false` otherwise.

---

## Example 1

Input

```
3 → 2 → 0 → -4
     ↑       |
     |_______|
```

Output

```
true
```

---

## Example 2

Input

```
1 → 2
↑   |
|___|
```

Output

```
true
```

---

## Example 3

Input

```
1 → null
```

Output

```
false
```

---

# 💡 Approach (Floyd's Cycle Detection)

Use two pointers:

- **Slow Pointer** moves one step.
- **Fast Pointer** moves two steps.

If there is a cycle, the fast pointer will eventually catch the slow pointer.

If the fast pointer reaches `nullptr`, no cycle exists.

---

## Why Does It Work?

Imagine a circular race track.

One runner moves one step.

Another runner moves two steps.

Eventually the faster runner catches the slower one.

The same happens inside a linked list cycle.

---

## 🛠️ Algorithm

1. Initialize

```
slow = head
fast = head
```

2. While

```
fast != nullptr
&& fast->next != nullptr
```

Move

```
slow = slow->next
fast = fast->next->next
```

3. If

```
slow == fast
```

Return

```
true
```

4. End of list reached

Return

```
false
```

---

## 🧪 Dry Run

Input

```
3 → 2 → 0 → -4
     ↑       |
     |_______|
```

Iteration 1

```
Slow -> 2
Fast -> 0
```

Iteration 2

```
Slow -> 0
Fast -> 2
```

Iteration 3

```
Slow -> -4
Fast -> -4
```

Pointers meet.

Answer

```
true
```

---

## Another Dry Run

Input

```
1 → 2 → null
```

Iteration 1

```
Slow -> 2
Fast -> null
```

Fast reached the end.

Answer

```
false
```

---

## 📊 Complexity Analysis

| Complexity | Value |
|------------|-------|
| Time | **O(n)** |
| Space | **O(1)** |

---

## ⚠️ Edge Cases

### Empty List

```
head = null
```

Output

```
false
```

---

### Single Node

```
1
```

Output

```
false
```

---

### Single Node Pointing to Itself

```
1
↑
└───
```

Output

```
true
```

---

### Large Cycle

Works in linear time regardless of cycle size.

---

## ❌ Brute Force

Store every visited node inside a HashSet.

Time

```
O(n)
```

Space

```
O(n)
```

Not optimal.

---

## ✅ Why Floyd's Algorithm?

- No extra memory
- Single traversal
- Elegant interview solution
- Standard answer expected by interviewers

---

## 📚 Concepts Used

- Linked List
- Two Pointers
- Fast & Slow Pointer
- Floyd's Cycle Detection

---

## 🔗 Related Problems

- 142. Linked List Cycle II
- 876. Middle of the Linked List
- 234. Palindrome Linked List