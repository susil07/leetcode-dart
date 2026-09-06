# 🚀 LeetCode 160 - Intersection of Two Linked Lists

## 📝 Problem

Given the heads of two singly linked lists `headA` and `headB`, return the node at which the two lists intersect.

If the two linked lists have no intersection, return `null`.

Two nodes are considered the same node when they refer to the **same memory/reference**, not simply when they have the same value.

---

## Example 1

Input

```text
A: 4 → 1 → 8 → 4 → 5
B: 5 → 6 → 1 → 8 → 4 → 5
              ↑
          Intersection
```

Output

```text
8
```

---

## Example 2

Input

```text
A: 1 → 9 → 1 → 2 → 4
B: 3 → 2 → 4
```

Output

```text
2
```

---

## Example 3

Input

```text
A: 2 → 6 → 4

B: 1 → 5
```

Output

```text
null
```

---

# 💡 Approach (Two Pointers)

Use two pointers:

```text
a → headA
b → headB
```

Move both pointers one node at a time.

When a pointer reaches the end of its list, move it to the head of the other list.

```text
a = a.next
b = b.next
```

When reaching the end:

```text
a → headB
b → headA
```

This makes both pointers travel the same total distance.

Eventually:

- They meet at the intersection node, or
- They both become `null` if there is no intersection.

---

## 🧠 Why Does This Work?

Suppose:

```text
List A:

A1 → A2 → C1 → C2 → C3
             ↑
             |
List B:      B1 → B2
```

The two lists have different lengths before the intersection.

Instead of calculating the length difference, we make each pointer traverse:

```text
A + B
```

and

```text
B + A
```

Therefore, both pointers travel the same total distance.

Eventually they will meet at:

```text
C1
```

if an intersection exists.

Otherwise:

```text
a == null
b == null
```

and the loop ends.

---

## 🛠️ Algorithm

1. Set `a = headA`.
2. Set `b = headB`.
3. Continue while `a != b`.
4. If `a` reaches `null`, move it to `headB`.
5. If `b` reaches `null`, move it to `headA`.
6. Move both pointers forward.
7. Return `a`.

---

## 🧪 Dry Run

Consider:

```text
A: 4 → 1 → 8 → 4 → 5
B: 5 → 6 → 1 → 8 → 4 → 5
```

Initially:

```text
a = 4
b = 5
```

After moving:

```text
a: 4 → 1 → 8 → 4 → 5 → null → 5 → 6 → 1 → 8
b: 5 → 6 → 1 → 8 → 4 → 5 → null → 4 → 1 → 8
```

Both pointers eventually reach:

```text
8
```

Therefore:

```text
return 8
```

---

## 🔍 Important Point

Do **not** compare only the node values.

For example:

```text
A: 1 → 2 → 3

B: 4 → 2 → 5
```

The two `2` values do not necessarily represent the same node.

Intersection means:

```text
a == b
```

not:

```text
a.val == b.val
```

---

## 📊 Complexity Analysis

| Complexity | Value |
|------------|-------|
| Time | O(m + n) |
| Space | O(1) |

Where:

- `m` = number of nodes in list A
- `n` = number of nodes in list B

---

## ⚠️ Edge Cases

### No Intersection

```text
A: 1 → 2 → 3

B: 4 → 5
```

Output:

```text
null
```

---

### Intersection at Head

```text
A: 1 → 2 → 3

B: 1 → 2 → 3
```

Both heads refer to the same linked structure.

Output:

```text
1
```

---

### Intersection at Last Node

```text
A: 1 → 2 → 3
           \
            5
           /
B: 4 → 5
```

Output:

```text
5
```

---

## 📚 Concepts Used

- Linked List
- Two Pointers
- Reference Comparison
- O(1) Space
- Pointer Traversal

---

## 🔗 Related Problems

- 141. Linked List Cycle
- 142. Linked List Cycle II
- 206. Reverse Linked List
- 876. Middle of the Linked List
# 🚀 LeetCode 160 - Intersection of Two Linked Lists

## 📝 Problem

Given the heads of two singly linked lists `headA` and `headB`, return the node at which the two lists intersect.

If the two linked lists have no intersection, return `null`.

The intersection is based on the actual node reference, not the node value.

---

## Example 1

```text
A: 4 → 1 ─┐
          ↓
          8 → 4 → 5
          ↑
B: 5 → 6 → 1 ─┘