import 'package:cloud_firestore/cloud_firestore.dart';

class Job {
  Job({required this.id, required this.name, required this.ratePerHour});
  final String id;
  final String name;
  final int ratePerHour;
  final timeStamp = FieldValue.serverTimestamp(); //to orderBy
  // Factory Constructor when implementing a constructor that doesn’t always create a new instance of its class
  //Job.fromMap(Map<String, dynamic> data) to use StreamBuilder<List<Job>>, ListView .toList()
  factory Job.fromMap(Map<String, dynamic> data, String documentId) {
    final String name = data['name'];
    final int ratePerHour = data['ratePerHour'];
    return Job(id: documentId, name: name, ratePerHour: ratePerHour);
  }
  //toMap() to use .Set() firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'ratePerHour': ratePerHour,
      'timeStamp': timeStamp,
    };
  }
}
