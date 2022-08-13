import 'package:time_tracker_flutter/services/firestore_service.dart';
import '../home/models/account.dart';
import '../home/models/entry.dart';
import '../home/models/job.dart';
import 'api_path.dart';

abstract class Database {
  Future<void> setJob(Job job);
  Future<void> deleteJob(Job job);
  Stream<Job> jobStreaming({required String jobId});
  Stream<List<Job>> jobStream();
  Future<void> setEntry(Entry entry);
  Future<void> deleteEntry(Entry entry);
  Stream<List<Entry>> entriesStream({Job job});
  Future<void> nameAccount(Account account);
  Stream<Account> accountStreaming({required String accountId});
}

//job unique document Id
// String documentIdFromCurrentDate = DateTime.now().toIso8601String();
// NOTE: dont hard code it because it will create documentIdFromCurrentDate only once then every time you will add new job willNOT add but will EDit instead
// so impicit it inside path: APIPATH.job(uid, DateTime.now().toIso8601String()),
String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

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
  /*Important
  when delete job all its Entries must be deleted also
  if you made entries a subCollection of jobs, they will be deleted whenever job deleted
  because entries are separated collection not subCollection so you must delete them explicitly*/
  @override
  Future<void> deleteJob(Job job) async {
    final allEntries = await entriesStream(job: job).first;
    for (Entry entry in allEntries) {
      if (entry.jobId == job.id) {
        await deleteEntry(entry);
      }
    }
    await _service.deleteData(path: APIPATH.job(uid, job.id));
  }

  //jobStreaming for any change like appBar after editing
  @override
  Stream<Job> jobStreaming({required String jobId}) => _service.documentStream(
        path: APIPATH.job(uid, jobId),
        builder: (data, documentId) => Job.fromMap(data, documentId),
      );
  @override
  Stream<List<Job>> jobStream() => _service.collectionStream(
        path: APIPATH.jobs(uid),
        builder: (data, documentId) => Job.fromMap(data, documentId),
      );
  @override
  Future<void> setEntry(Entry entry) => _service.setData(
        path: APIPATH.entry(uid, entry.id),
        data: entry.toMap(),
      );

  @override
  Future<void> deleteEntry(Entry entry) => _service.deleteData(
        path: APIPATH.entry(uid, entry.id),
      );

  @override
  Stream<List<Entry>> entriesStream({Job? job}) =>
      _service.collectionStream<Entry>(
        path: APIPATH.entries(uid),
        queryBuilder: job != null
            ? (query) => query.where('jobId', isEqualTo: job.id)
            : null,
        builder: (data, documentID) => Entry.fromMap(data, documentID),
        sort: (lhs, rhs) => rhs.start.compareTo(lhs.start),
      );

  @override
  Future<void> nameAccount(Account account) => _service.setData(
        path: APIPATH.account(uid),
        data: account.toMap(),
      );
  @override
  Stream<Account> accountStreaming({required String accountId}) =>
      _service.documentStream(
        path: APIPATH.account(uid),
        builder: (data, documentId) => Account.fromMap(data),
      );
}
