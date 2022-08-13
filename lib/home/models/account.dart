import 'package:flutter/material.dart';

class Account {
  Account({required this.name});
  final String name;
  // Factory Constructor when implementing a constructor that doesn’t always create a new instance of its class
  //Job.fromMap(Map<String, dynamic> data) to use StreamBuilder<List<Job>>, ListView .toList()
  factory Account.fromMap(Map<String, dynamic> data) {
    final String name = data['name'];
    return Account(name: name);
  }
  //toMap() to use .Set() firestore
  Map<String, dynamic> toMap() {
    debugPrint('tttttttttttttt');

    return {
      'name': name,
    };
  }
}
