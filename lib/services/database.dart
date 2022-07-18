import 'package:time_tracker_flutter/services/firestore_service.dart';
import '../home/models/job.dart';
import 'api_path.dart';

abstract class Database {
  Future<void> createJob(Job job);
  Stream<List<Job>> jobStream();
}

class FirestoreDatabase implements Database {
  FirestoreDatabase({required this.uid}) : assert(uid != null);
  final String uid;
  final _service = FirestoreService.instance;
  @override
  Future<void> createJob(Job job) => _service.setData(
        path: APIPATH.job(uid, 'job_abc'),
        data: job.toMap(),
      );
  @override
  Stream<List<Job>> jobStream() => _service.collectionStream(
        path: APIPATH.jobs(uid),
        builder: (data) => Job.fromMap(data),
      );
}
