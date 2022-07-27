import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  FirestoreService._(); //Private Constructor - SingleTon
  static final instance = FirestoreService._();
  Future<void> setData(
      {required String path, required Map<String, dynamic> data}) async {
    final reference = FirebaseFirestore.instance.doc(path);
    print('$path: $data');
    await reference.set(data);
  }

  Stream<List<T>> collectionStream<T>(
      {required String path,
      required T Function(Map<String, dynamic> data, String documentId)
          builder}) {
    final reference = FirebaseFirestore.instance.collection(path);
    // final snapshots = reference.orderBy('timeStamp').snapshots(); //BY timeStamp
    //ToDo: orderBy
    final snapshots = reference.snapshots(); //BY timeStamp
    // snapshots.listen((snapshots) {
    //   snapshots.docs.forEach((snapshot) => print(snapshot.data()));
    // });

    return snapshots.map((snapshot) => snapshot.docs
        .map((snapshot) => builder(snapshot.data(), snapshot.id))
        .toList()); //MAndatory toList() error: The return type 'Iterable<Job>' isn't a 'List<Job>', as required by the closure's context
  }
}
