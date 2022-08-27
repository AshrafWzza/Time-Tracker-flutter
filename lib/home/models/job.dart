import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

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

  @override
  // TODO: implement hashCode
  int get hashCode => hashValues(id, name, ratePerHour);
  @override
  bool operator ==(other) {
    if (identical(this, other)) return true;
    if (runtimeType != other.runtimeType) return false;
    final Job otherJob = other as Job;
    return id == otherJob.id &&
        name == otherJob.name &&
        ratePerHour == otherJob.ratePerHour;
  }

  @override
  String toString() => 'id:$id, name:$name, ratePerHour:$ratePerHour';
}
