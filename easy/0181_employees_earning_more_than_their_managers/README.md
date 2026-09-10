# 🚀 LeetCode 181 - Employees Earning More Than Their Managers

## 📝 Problem Statement

Table: `Employee`

```text
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| id          | int     |
| name        | varchar |
| salary      | int     |
| managerId   | int     |
+-------------+---------+
id is the primary key (column with unique values) for this table.
Each row of this table indicates the ID of an employee, their name, salary, and the ID of their manager.
```

Write a solution to find the employees who earn more than their managers.

Return the result table in **any order**.

---

## Example 1

Input:

`Employee` table:

```text
+----+-------+--------+-----------+
| id | name  | salary | managerId |
+----+-------+--------+-----------+
| 1  | Joe   | 70000  | 3         |
| 2  | Henry | 80000  | 4         |
| 3  | Sam   | 60000  | Null      |
| 4  | Max   | 90000  | Null      |
+----+-------+--------+-----------+
```

Output:

```text
+----------+
| Employee |
+----------+
| Joe      |
+----------+
```

Explanation:
- **Joe** earns `70000` and his manager is **Sam** (`id = 3`), who earns `60000`. `70000 > 60000` ✅.
- **Henry** earns `80000` and his manager is **Max** (`id = 4`), who earns `90000`. `80000 < 90000` ❌.
- **Sam** and **Max** have no manager (`managerId` is `Null`).

---

# 💡 Core Concept: SQL Self-Join

A **Self-Join** is a regular join where a table is joined with **itself**. 

To conceptualize this, imagine duplicating the `Employee` table into two virtual tables:
1. **`e` (The Employee)**: Contains the worker's details (`id`, `name`, `salary`, `managerId`).
2. **`m` (The Manager)**: Contains the manager's details (`id`, `name`, `salary`).

```text
       Employee e                            Manager m
 ┌────┬──────┬────────┬───────────┐       ┌────┬──────┬────────┐
 │ id │ name │ salary │ managerId │       │ id │ name │ salary │
 ├────┼──────┼────────┼───────────┤       ├────┼──────┼────────┤
 │ 1  │ Joe  │ 70000  │ 3         ├───┐   │ 1  │ Joe  │ 70000  │
 │ 2  │ Henry│ 80000  │ 4         ├─┐ │   │ 2  │ Henry│ 80000  │
 └────┴──────┴────────┴───────────┘ │ └──►│ 3  │ Sam  │ 60000  │
                                    └────►│ 4  │ Max  │ 90000  │
                                          └────┴──────┴────────┘
```

### Joining Condition:
```sql
e.managerId = m.id
```

### Filtering Condition:
```sql
e.salary > m.salary
```

Employees with `managerId IS NULL` will automatically be excluded because `NULL = m.id` evaluates to `UNKNOWN` in SQL.

---

# 💻 Solutions

## 1. SQL Solution (Recommended)

```sql
SELECT 
    e.name AS Employee
FROM Employee e
JOIN Employee m 
    ON e.managerId = m.id
WHERE e.salary > m.salary;
```

---

## 2. Alternative SQL Solution (`WHERE` Clause)

```sql
SELECT 
    e.name AS Employee
FROM Employee e, Employee m
WHERE e.managerId = m.id 
  AND e.salary > m.salary;
```

---

## 3. In-Memory Dart Implementation (Hash Join)

```dart
class Employee {
  final int id;
  final String name;
  final int salary;
  final int? managerId;

  Employee({
    required this.id,
    required this.name,
    required this.salary,
    this.managerId,
  });
}

class Solution {
  List<String> findEmployees(List<Employee> employees) {
    // 1. Index all employees by id for O(1) manager lookup
    final Map<int, Employee> employeeMap = {
      for (var e in employees) e.id: e,
    };

    final List<String> result = [];

    // 2. Compare each employee's salary with their manager's salary
    for (var emp in employees) {
      if (emp.managerId != null) {
        final manager = employeeMap[emp.managerId];
        if (manager != null && emp.salary > manager.salary) {
          result.add(emp.name);
        }
      }
    }

    return result;
  }
}
```

---

# 📊 Complexity Analysis

### SQL Engine:
- **With Primary Key Index on `id`**: The database performs an indexed lookup for each employee's `managerId` $\to$ **$O(N)$** time.
- **Without Index**: Requires a nested loop join $\to$ $O(N^2)$ time.

### Dart Implementation:
- **Time Complexity**: **$O(N)$** — Single pass to build the map, and single pass to filter.
- **Space Complexity**: **$O(N)$** — To store the `employeeMap`.

---

# ⚠️ Key Interview Takeaways

1. **Column Aliasing**:
   LeetCode requires the output column to be named `Employee`. Forgetting `AS Employee` will result in a *"Wrong Answer"*.
2. **Handling `NULL`s**:
   In SQL, `NULL` represents an unknown value. Comparisons like `NULL > 50000` or `NULL = 3` do not return `TRUE` or `FALSE`—they return `UNKNOWN`. An `INNER JOIN` automatically handles top-level managers cleanly.
