import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:time_tracker_flutter/home/models/job.dart';

void main() {
  group('fromMap', () {
    // Error :The argument type 'Null' can't be assigned to the parameter type 'Map<String, dynamic>'
    /*test('null', () {
      final job = Job.fromMap(null, 'abc');
      expect(job, null);
    });*/
    //Solution that Factory constructor can't accept Null so instead you can use static Job?
    test('job with all properties', () {
      final job = Job.fromMap({'name': 'Blogging', 'ratePerHour': 10}, 'abc');
      expect(job, Job(id: 'abc', name: 'Blogging', ratePerHour: 10));
    });
    //Factory constructor can't accept Null so instead you can use static Job?
    /*test('missing name', () {
      final job = Job.fromMap({'ratePerHour': 10}, 'abc');
      expect(job, null);
    });*/
  });
  group('toMap', () {
    test('valid name, ratePerHour', () {
      final job = Job(id: 'abc', name: 'Blogging', ratePerHour: 10);
      expect(job.toMap(), {
        'name': 'Blogging',
        'ratePerHour': 10,
        'timeStamp': FieldValue.serverTimestamp()
      });
    });
  });
}
