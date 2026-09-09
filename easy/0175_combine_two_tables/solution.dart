// In-Memory Dart Implementation of SQL LEFT JOIN
// Simulating LeetCode 175: Combine Two Tables

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

  @override
  String toString() =>
      '($firstName, $lastName, ${city ?? "null"}, ${state ?? "null"})';
}

class Solution {
  List<PersonAddressResult> combineTwoTables(
    List<Person> personList,
    List<Address> addressList,
  ) {
    // Hash Join: Index addresses by personId in O(M) time
    final Map<int, Address> addressMap = {
      for (var address in addressList) address.personId: address,
    };

    // Left Join: Iterate all persons and match with address in O(N) time
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
