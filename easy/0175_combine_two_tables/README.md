# 🚀 LeetCode 175 - Combine Two Tables

## 📝 Problem Statement

Table: `Person`

```text
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| personId    | int     |
| lastName    | varchar |
| firstName   | varchar |
+-------------+---------+
personId is the primary key (column with unique values) for this table.
This table contains information about the ID of some persons and their first and last names.
```

Table: `Address`

```text
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| addressId   | int     |
| personId    | int     |
| city        | varchar |
| state       | varchar |
+-------------+---------+
addressId is the primary key (column with unique values) for this table.
Each row of this table contains information about the city and state of one person with ID = PersonId.
```

Write a solution to report the `firstName`, `lastName`, `city`, and `state` of each person in the `Person` table. If the address of a `personId` is not present in the `Address` table, report `null` instead.

Return the result table in **any order**.

---

## Example 1

Input:

`Person` table:

```text
+----------+----------+-----------+
| personId | lastName | firstName |
+----------+----------+-----------+
| 1        | Wang     | Allen     |
| 2        | Alice    | Bob       |
+----------+----------+-----------+
```

`Address` table:

```text
+-----------+----------+---------------+----------+
| addressId | personId | city          | state    |
+-----------+----------+---------------+----------+
| 1         | 2        | New York City | New York |
| 2         | 3        | Leetcode      | California|
+-----------+----------+---------------+----------+
```

Output:

```text
+-----------+----------+---------------+----------+
| firstName | lastName | city          | state    |
+-----------+----------+---------------+----------+
| Allen     | Wang     | Null          | Null     |
| Bob       | Alice    | New York City | New York |
+-----------+----------+---------------+----------+
```

---

# 💡 SQL Approach: Why `LEFT JOIN`?

In relational databases (SQL), combining data from two tables is performed using **`JOIN`**:

```text
       Person (Left)                 Address (Right)
    ┌─────────────────┐             ┌─────────────────┐
    │ personId: 1     │             │ personId: 2     │
    │ personId: 2     ├─────────────┤                 │
    └─────────────────┘             │ personId: 3     │
                                    └─────────────────┘
```

### 1. Why `INNER JOIN` Fails:
An `INNER JOIN` only returns rows where there is a match in **both** tables.
If person `1` (Allen Wang) has no address in the `Address` table, an `INNER JOIN` drops him completely from the result set!

### 2. Why `LEFT JOIN` (or `LEFT OUTER JOIN`) is Required:
A `LEFT JOIN` guarantees that **every row from the left table (`Person`) is preserved**.
- If a matching `personId` exists in `Address`, its `city` and `state` are filled in.
- If no matching `personId` exists in `Address`, SQL automatically fills `city` and `state` with `NULL`.

---

# 💻 Solutions

## 1. SQL Solution (Submit on LeetCode)

```sql
SELECT 
    p.firstName,
    p.lastName,
    a.city,
    a.state
FROM Person p
LEFT JOIN Address a 
    ON p.personId = a.personId;
```

---

## 2. In-Memory Dart Simulation (Hash Join)

In software development and in-memory processing, a database `LEFT JOIN` is executed using a **Hash Join**:
1. Index the right table (`Address`) into a `Map<int, Address>` using `personId` as the key ($O(M)$ time).
2. Traverse the left table (`Person`), performing an $O(1)$ lookup in the map for each person.

```dart
class Person {
  final int personId;
  final String lastName;
  final String firstName;

  Person({
    required this.personId,
    required this.lastName,
    required this.firstName,
  });
}

class Address {
  final int addressId;
  final int personId;
  final String city;
  final String state;

  Address({
    required this.addressId,
    required this.personId,
    required this.city,
    required this.state,
  });
}

class PersonAddressResult {
  final String firstName;
  final String lastName;
  final String? city;
  final String? state;

  PersonAddressResult({
    required this.firstName,
    required this.lastName,
    this.city,
    this.state,
  });
}

class Solution {
  List<PersonAddressResult> combineTwoTables(
    List<Person> personList,
    List<Address> addressList,
  ) {
    // 1. Build Hash Table for right table O(M)
    final Map<int, Address> addressMap = {
      for (var address in addressList) address.personId: address,
    };

    // 2. Probe Hash Table for left table O(N)
    return personList.map((person) {
      final address = addressMap[person.personId];
      return PersonAddressResult(
        firstName: person.firstName,
        lastName: person.lastName,
        city: address?.city,
        state: address?.state,
      );
    }).toList();
  }
}
```

---

# 📊 Complexity Analysis

### SQL Engine:
- **Index Available on `Address.personId`**: $O(N)$ lookup time where $N$ is the number of rows in `Person`.
- **No Index (Hash Join)**: $O(N + M)$ time to build hash table on `Address` and probe from `Person`.

### Dart Implementation:
- **Time Complexity**: $O(N + M)$ where $N$ is the size of `Person` and $M$ is the size of `Address`.
- **Space Complexity**: $O(M)$ auxiliary space to store the `addressMap`.

---

# ⚠️ Common SQL Interview Gotchas

1. **`ON` vs `WHERE` Clause**:
   Always place the join condition in the `ON` clause (`ON p.personId = a.personId`). Filtering a left-joined table in the `WHERE` clause can inadvertently convert a `LEFT JOIN` into an `INNER JOIN`.
2. **Table Aliases**:
   Always use short aliases (`p` and `a`) to avoid ambiguous column name errors and improve readability.
3. **Column Ambiguity**:
   Notice `p.firstName` vs `firstName`. When columns exist in only one table, prefixing with the alias is still best practice for defensive coding.
