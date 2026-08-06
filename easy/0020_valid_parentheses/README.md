# 0020. Valid Parentheses

- **Difficulty:** Easy
- **Category:** Stack, String
- **Language:** Dart

---

# Problem Statement

Given a string `s` containing just the characters:

```text
'(' ')' '{' '}' '[' ']'
```

Determine if the input string is **valid**.

A string is valid if:

1. Every opening bracket has a corresponding closing bracket of the same type.
2. Brackets are closed in the correct order.
3. Every closing bracket has a matching opening bracket.

---

# Example

### Example 1

```text
Input:

s = "()"

Output:

true
```

---

### Example 2

```text
Input:

s = "()[]{}"

Output:

true
```

---

### Example 3

```text
Input:

s = "(]"

Output:

false
```

---

### Example 4

```text
Input:

s = "([)]"

Output:

false
```

---

### Example 5

```text
Input:

s = "{[]}"

Output:

true
```

---

# Solution

```dart
class Solution {
  bool isValid(String s) {
    List<String> stack = [];

    for (int i = 0; i < s.length; i++) {
      String ch = s[i];

      if (ch == '(' || ch == '{' || ch == '[') {
        stack.add(ch);
      } else {
        if (stack.isEmpty) {
          return false;
        }

        String top = stack.removeLast();

        if ((ch == ')' && top != '(') ||
            (ch == '}' && top != '{') ||
            (ch == ']' && top != '[')) {
          return false;
        }
      }
    }

    return stack.isEmpty;
  }
}
```

---

# Technique Used

- Stack
- String Traversal
- LIFO (Last In First Out)

---

# Understanding the Problem

Whenever we encounter an **opening bracket**, we store it.

Whenever we encounter a **closing bracket**, we check whether it matches the most recent opening bracket.

The most recently opened bracket must always close first.

This behavior is exactly how a **Stack** works.

---

# Algorithm

1. Create an empty stack.
2. Traverse the string from left to right.
3. If the character is an opening bracket:
   - Push it onto the stack.
4. Otherwise:
   - If the stack is empty, return `false`.
   - Pop the top element.
   - Check whether it matches the current closing bracket.
   - If not, return `false`.
5. After processing all characters:
   - If the stack is empty, return `true`.
   - Otherwise, return `false`.

---

# Dry Run

Input

```text
([{}])
```

Initially

```text
Stack = []
```

---

### Character = (

Push

```text
Stack

(
```

---

### Character = [

Push

```text
Stack

(
[
```

---

### Character = {

Push

```text
Stack

(
[
{
```

---

### Character = }

Top

```text
{
```

Matches.

Pop.

```text
Stack

(
[
```

---

### Character = ]

Top

```text
[
```

Matches.

Pop.

```text
Stack

(
```

---

### Character = )

Top

```text
(
```

Matches.

Pop.

```text
Stack

[]
```

Stack becomes empty.

Answer

```text
true
```

---

# Another Dry Run

Input

```text
([)]
```

Stack

```text
(
[
```

Current character

```text
)
```

Top of stack

```text
[
```

Expected

```text
(
```

Mismatch.

Return

```text
false
```

---

# Visualization

```text
Input

( [ { } ] )

Stack

↓

[]

Push (

[(]

Push [

[( []

Push {

[( [ {]

Read }

Pop {

[( []

Read ]

Pop [

[(]

Read )

Pop (

[]
```

Empty stack means all brackets are matched correctly.

---

# Why Stack?

A Stack follows the **LIFO (Last In First Out)** principle.

Example

```text
Push (

Push [

Push {
```

Stack

```text
(
[
{
```

The last opening bracket `{` must be closed first.

That is exactly how a Stack works.

---

# Why not Queue?

A Queue follows

```text
FIFO

First In First Out
```

Brackets do not close in FIFO order.

They close in reverse order.

Therefore,

```text
Queue cannot solve this problem.
```

---

# Why check `stack.isEmpty`?

Example

```text
")"
```

There is no opening bracket.

Without checking

```dart
stack.isEmpty
```

calling

```dart
removeLast()
```

would cause an error.

Instead,

```text
return false
```

---

# Why return `stack.isEmpty` at the end?

Example

```text
(((
```

No mismatch occurs.

But

```text
(
(
(
```

are still waiting to be closed.

Therefore,

```text
false
```

Only an empty stack means every opening bracket has a matching closing bracket.

---

# Time Complexity

Each character is processed exactly once.

```text
Time Complexity = O(n)
```

---

# Space Complexity

Worst case

```text
((((((((
```

Every character is stored in the stack.

```text
Space Complexity = O(n)
```

---

# Advantages

- Simple and efficient.
- Single traversal.
- Easy to understand.
- Uses the correct data structure for nested matching.

---

# Disadvantages

- Requires extra memory for the stack.

---

# Key Concepts Learned

- Stack
- LIFO
- String Traversal
- Matching Symbols
- Push Operation
- Pop Operation

---

# Interview Questions

### Why do we use a Stack?

Because the last opened bracket must be closed first.

---

### Why is Queue not suitable?

Queue removes the oldest element first.

Brackets must close in reverse order.

---

### Why is Time Complexity O(n)?

Each character is pushed and popped at most once.

---

### Why is Space Complexity O(n)?

In the worst case, every opening bracket is stored in the stack.

---

### What happens if the stack is not empty at the end?

It means there are unmatched opening brackets.

The string is invalid.

---

# Final Complexity

| Property | Value |
|----------|-------|
| Technique | Stack |
| Data Structure | Stack (`List<String>`) |
| Time Complexity | O(n) |
| Space Complexity | O(n) |
| Difficulty | Easy |

---

# Takeaway

This problem introduces the **Stack** pattern.

Whenever you encounter problems involving:

- Matching symbols
- Nested structures
- Undo operations
- Expression evaluation

Think about using a **Stack**.

Mastering this problem makes many other Stack problems much easier, including:

- Min Stack
- Evaluate Reverse Polish Notation
- Daily Temperatures
- Next Greater Element
- Decode String