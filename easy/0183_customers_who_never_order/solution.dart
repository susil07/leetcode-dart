// In-Memory Dart Implementation of SQL Anti-Join
// Simulating LeetCode 183: Customers Who Never Order

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
    // 1. Collect all customer IDs who placed orders into a Set for O(1) lookups
    final Set<int> orderedCustomerIds = orders.map((o) => o.customerId).toSet();

    // 2. Filter customers whose ID is NOT present in the orderedCustomerIds set
    return customers
        .where((customer) => !orderedCustomerIds.contains(customer.id))
        .map((customer) => customer.name)
        .toList();
  }
}
