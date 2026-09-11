# 🚀 LeetCode 182 - Duplicate Emails

## 📝 Problem Statement

Table: `Person`

```text
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| id          | int     |
| email       | varchar |
+-------------+---------+
id is the primary key (column with unique values) for this table.
Each row of this table contains an email. The emails will not contain uppercase letters.
```

Write a solution to report all the duplicate emails. Note that it's guaranteed that the email field is not `NULL`.

Return the result table in **any order**.

---

## Example 1

Input:

`Person` table:

```text
+----+---------+
| id | email   |
+----+---------+
| 1  | a@b.com |
| 2  | c@d.com |
| 3  | a@b.com |
+----+---------+
```

Output:

```text
+---------+
| Email   |
+---------+
| a@b.com |
+---------+
```

Explanation:
`a@b.com` appears 2 times, which is more than once.

---

# 💡 Core Concept: `GROUP BY` vs `HAVING`

This problem tests SQL group aggregation:

```text
               Original Table                            Grouped & Aggregated
       ┌────┬─────────┐                                 ┌─────────┬──────────────┐
       │ id │ email   │                                 │ email   │ COUNT(email) │
       ├────┼─────────┤                                 ├─────────┼──────────────┤
       │ 1  │ a@b.com │ ───► GROUP BY email ───►        │ a@b.com │ 2  (> 1 ✅)   │
       │ 2  │ c@d.com │                                 │ c@d.com │ 1  (<= 1 ❌)  │
       │ 3  │ a@b.com │                                 └─────────┴──────────────┘
       └────┴─────────┘
```

### Why `WHERE` Cannot Be Used:
- `WHERE` filters individual rows **before** groups are formed.
- It cannot evaluate aggregate functions like `COUNT()`, `SUM()`, or `AVG()`.
- Writing `WHERE COUNT(email) > 1` results in a SQL syntax error!

### Why `HAVING` is Required:
- `HAVING` filters aggregated groups **after** the `GROUP BY` clause has organized the data.
- It is specifically designed to filter on aggregate conditions like `COUNT(email) > 1`.

---

# 💻 Solutions

## 1. SQL Solution (Recommended: `GROUP BY ... HAVING`)

```sql
SELECT 
    email AS Email
FROM Person
GROUP BY email
HAVING COUNT(email) > 1;
```

---

## 2. Alternative SQL Solution (Subquery)

```sql
SELECT email AS Email
FROM (
    SELECT email, COUNT(email) AS cnt
    FROM Person
    GROUP BY email
) AS temp
WHERE cnt > 1;
```

---

## 3. Alternative SQL Solution (Self-Join)

```sql
SELECT DISTINCT p1.email AS Email
FROM Person p1
JOIN Person p2 
    ON p1.email = p2.email 
   AND p1.id != p2.id;
```

---

## 4. In-Memory Dart Implementation (Frequency Map)

```dart
class Person {
  final int id;
  final String email;

  Person({
    required this.id,
    required this.email,
  });
}

class Solution {
  List<String> findDuplicateEmails(List<Person> personList) {
    // 1. Group & Count frequencies: O(N) time
    final Map<String, int> emailCount = {};
    for (var person in personList) {
      emailCount[person.email] = (emailCount[person.email] ?? 0) + 1;
    }

    // 2. Filter groups with count > 1: O(U) time where U <= N
    return emailCount.entries
        .where((entry) => entry.value > 1)
        .map((entry) => entry.key)
        .toList();
  }
}
```

---

# 📊 Complexity Analysis

### SQL Engine:
- **Hash Aggregate (`GROUP BY email`)**: Builds a hash table of distinct emails in **$O(N)$** time.
- **Index Scan (if index on `email`)**: Reads the index in sorted order in **$O(N)$** time with minimal CPU overhead.

### Dart Implementation:
- **Time Complexity**: **$O(N)$** — Single pass to build frequency map and single pass through unique entries.
- **Space Complexity**: **$O(N)$** — Space used by the hash map to store distinct email strings.

---

# ⚠️ Key Interview Gotchas

1. **Header Name**:
   LeetCode requires the output column to be capitalized as `Email`. Use `email AS Email`.
2. **`COUNT(email)` vs `COUNT(*)`**:
   Both work identically here since the problem specifies `email IS NOT NULL`.
3. **`DISTINCT` with Self-Join**:
   If an email appears 3 or more times, a self-join produces multiple duplicate rows, requiring `SELECT DISTINCT`. `GROUP BY` avoids this issue completely.
