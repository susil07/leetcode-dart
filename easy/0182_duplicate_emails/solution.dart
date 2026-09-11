// In-Memory Dart Implementation of SQL GROUP BY ... HAVING
// Simulating LeetCode 182: Duplicate Emails

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
    // 1. Frequency Map (corresponds to GROUP BY email and COUNT(email))
    final Map<String, int> emailCount = {};
    for (var person in personList) {
      emailCount[person.email] = (emailCount[person.email] ?? 0) + 1;
    }

    // 2. Filter emails with frequency > 1 (corresponds to HAVING COUNT(email) > 1)
    return emailCount.entries
        .where((entry) => entry.value > 1)
        .map((entry) => entry.key)
        .toList();
  }
}
