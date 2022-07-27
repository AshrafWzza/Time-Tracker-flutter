import 'package:time_tracker_flutter/services/firestore_service.dart';
import '../home/models/job.dart';
import 'api_path.dart';

abstract class Database {
  Future<void> setJob(Job job);
  Future<void> deleteJob(Job job);

  Stream<List<Job>> jobStream();
}

//job unique document Id
// String documentIdFromCurrentDate = DateTime.now().toIso8601String();
// NOTE: dont hard code it because it will create documentIdFromCurrentDate only once then every time you will add new job willNOT add but will EDit instead
// so impicit it inside path: APIPATH.job(uid, DateTime.now().toIso8601String()),

class FirestoreDatabase implements Database {
  FirestoreDatabase({required this.uid}) : assert(uid != null);
  final String uid;
  final _service = FirestoreService.instance;
  @override
  Future<void> setJob(Job job) => _service.setData(
        //path: APIPATH.job(uid, documentIdFromCurrentDate), // Dont HardCode it
        //path: APIPATH.job(uid, DateTime.now().toIso8601String()),
        path: APIPATH.job(uid, job.id),
        // edit or add if null - make DateTime.now().toIso8601String() inside editjobpage
        data: job.toMap(),
      );
  @override
  Future<void> deleteJob(Job job) =>
      _service.deleteData(path: APIPATH.job(uid, job.id));

  @override
  Stream<List<Job>> jobStream() => _service.collectionStream(
        path: APIPATH.jobs(uid),
        builder: (data, documentId) => Job.fromMap(data, documentId),
      );
}
