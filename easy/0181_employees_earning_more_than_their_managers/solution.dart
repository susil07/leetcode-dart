// In-Memory Dart Implementation of SQL Self-Join
// Simulating LeetCode 181: Employees Earning More Than Their Managers

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
    // 1. Build a Map of id -> Employee for O(1) lookup
    final Map<int, Employee> employeeMap = {
      for (var e in employees) e.id: e,
    };

    final List<String> result = [];

    // 2. Filter employees earning more than their managers
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
