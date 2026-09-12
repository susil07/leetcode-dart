# 🚀 LeetCode 183 - Customers Who Never Order

## 📝 Problem Statement

Table: `Customers`

```text
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| id          | int     |
| name        | varchar |
+-------------+---------+
id is the primary key (column with unique values) for this table.
Each row of this table indicates the ID and name of a customer.
```

Table: `Orders`

```text
+-------------+------+
| Column Name | Type |
+-------------+------+
| id          | int  |
| customerId  | int  |
+-------------+------+
id is the primary key (column with unique values) for this table.
customerId is a foreign key (reference column) of the ID from the Customers table.
Each row of this table indicates the ID of an order and the ID of the customer who ordered it.
```

Write a solution to find all customers who never order anything.

Return the result table in **any order**.

---

## Example 1

Input:

`Customers` table:

```text
+----+-------+
| id | name  |
+----+-------+
| 1  | Joe   |
| 2  | Henry |
| 3  | Sam   |
| 4  | Max   |
+----+-------+
```

`Orders` table:

```text
+----+------------+
| id | customerId |
+----+------------+
| 1  | 3          |
| 2  | 1          |
+----+------------+
```

Output:

```text
+-----------+
| Customers |
+-----------+
| Henry     |
| Max       |
+-----------+
```

---

# 💡 Core Concept: SQL Anti-Join

An **Anti-Join** returns rows from the first table that have **no matching rows** in the second table.

### Visualizing `LEFT JOIN ... WHERE Orders.customerId IS NULL`:

```text
Customers (c)                       Orders (o)
┌────┬───────┐                     ┌────┬────────────┐
│ id │ name  │                     │ id │ customerId │
├────┼───────┤                     ├────┼────────────┤
│ 1  │ Joe   │                     │ 1  │ 3          │
│ 2  │ Henry │                     │ 2  │ 1          │
│ 3  │ Sam   │                     └────┴────────────┘
│ 4  │ Max   │
└────┴───────┘
                     ▼ LEFT JOIN ON c.id = o.customerId
┌──────┬─────────┬────────┬──────────────┐
│ c.id │ c.name  │  o.id  │ o.customerId │
├──────┼─────────┼────────┼──────────────┤
│ 1    │ Joe     │ 2      │ 1            │ ──► Has order (customerId is NOT NULL)
│ 2    │ Henry   │ NULL   │ NULL         │ ──► No order  (customerId IS NULL ✅)
│ 3    │ Sam     │ 1      │ 3            │ ──► Has order (customerId is NOT NULL)
│ 4    │ Max     │ NULL   │ NULL         │ ──► No order  (customerId IS NULL ✅)
└──────┴─────────┴────────┴──────────────┘
                     ▼ WHERE o.customerId IS NULL
┌───────────┐
│ Customers │
├───────────┤
│ Henry     │
│ Max       │
└───────────┘
```

---

# 💻 Solutions

## 1. SQL Solution (Recommended: `LEFT JOIN` Anti-Join)

```sql
SELECT 
    c.name AS Customers
FROM Customers c
LEFT JOIN Orders o ON c.id = o.customerId
WHERE o.customerId IS NULL;
```

> **Why this is recommended**: In MySQL and relational databases, `LEFT JOIN ... WHERE right_col IS NULL` is optimized using the engine's built-in `Not_exists` optimization (it stops scanning the right table as soon as a single match is found).

---

## 2. Alternative SQL Solution (`NOT EXISTS`)

```sql
SELECT 
    c.name AS Customers
FROM Customers c
WHERE NOT EXISTS (
    SELECT 1 
    FROM Orders o 
    WHERE o.customerId = c.id
);
```

> **Advantage**: `NOT EXISTS` short-circuits as soon as a single matching order row is discovered and is completely NULL-safe.

---

## 3. Alternative SQL Solution (`NOT IN`)

```sql
SELECT 
    name AS Customers
FROM Customers
WHERE id NOT IN (
    SELECT customerId 
    FROM Orders
);
```

---

## 4. In-Memory Dart Implementation (`HashSet` Anti-Join)

```dart
class Customer {
  final int id;
  final String name;

  Customer({
    required this.id,
    required this.name,
  });
}

class Order {
  final int id;
  final int customerId;

  Order({
    required this.id,
    required this.customerId,
  });
}

class Solution {
  List<String> findCustomers(List<Customer> customers, List<Order> orders) {
    // 1. Collect all ordered customer IDs into a Set: O(M) time
    final Set<int> orderedCustomerIds = orders.map((o) => o.customerId).toSet();

    // 2. Filter customers whose ID is NOT in the set: O(N) time
    return customers
        .where((customer) => !orderedCustomerIds.contains(customer.id))
        .map((customer) => customer.name)
        .toList();
  }
}
```

---

# 📊 Complexity Analysis

### SQL Engine:
- **Index Scan / Hash Anti-Join**: If `customerId` is indexed, each customer lookup takes $O(1)$ or $O(\log M)$, yielding $O(N \log M)$ or $O(N + M)$ overall runtime.
- **Space**: $O(M)$ for intermediate hash tables during join processing.

### Dart Implementation:
- **Time Complexity**: **$O(N + M)$** where $N$ is the number of customers and $M$ is the number of orders.
  - Converting order IDs into a `Set`: $O(M)$.
  - Filtering $N$ customers with $O(1)$ set lookups: $O(N)$.
- **Space Complexity**: **$O(M)$** for storing unique ordered customer IDs in the `Set`.

---

# ⚠️ Key Interview Gotchas

1. **Output Column Alias**:
   The problem specifies the output column must be named `Customers`. Don't forget `c.name AS Customers`.
2. **The `NOT IN` NULL Trap**:
   In SQL, if the subquery for `NOT IN` returns any row containing `NULL`, the entire `NOT IN` condition evaluates to `UNKNOWN` (producing 0 rows).
   - If `Orders.customerId` can be `NULL`, `NOT IN` fails unless filtered with `WHERE customerId IS NOT NULL`.
   - `LEFT JOIN ... IS NULL` and `NOT EXISTS` do NOT suffer from this pitfall and are always safe.
