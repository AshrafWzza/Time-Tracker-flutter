import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  FirestoreService._(); //Private Constructor - SingleTon
  static final instance = FirestoreService._();
  Future<void> setData(
      {required String path, required Map<String, dynamic> data}) async {
    final reference =
        FirebaseFirestore.instance.doc(path); //1 DocumentReference
    print('$path: $data');
    await reference.set(data);
  }

  Future<void> deleteData({required String path}) async {
    final reference = FirebaseFirestore.instance.doc(path);
    print('delete: $path');
    await reference.delete();
  }

  Stream<List<T>> collectionStream<T>({
    required String path,
    required T Function(Map<String, dynamic> data, String documentId) builder,
    Query Function(Query query)? queryBuilder,
    int Function(T lhs, T rhs)? sort,
  }) {
    Query query = FirebaseFirestore.instance.collection(path);
    //Filtering
    if (queryBuilder != null) {
      query = queryBuilder(query);
    }
    // final reference = FirebaseFirestore.instance.collection(path); //2 CollectionReference
    // final snapshots = reference
    //     .orderBy('timeStamp', descending: true)
    //     .snapshots(); //BY timeStamp
    //ToDo: orderBy
    final snapshots = query.snapshots(); //BY timeStamp
    // snapshots.listen((snapshots) {
    //   snapshots.docs.forEach((snapshot) => print(snapshot.data()));
    // });

    //error snapshot.data() : The argument type 'Object?' can't be assigned to the parameter type 'Map<dynamic, dynamic>'
    //Solved By : as Map<String, dynamic>   MAndatory
    return snapshots.map((snapshot) {
      final result = snapshot.docs
          .map((snapshot) =>
              builder(snapshot.data() as Map<String, dynamic>, snapshot.id))
          .where((value) => value != null) // Filter
          .toList();
      if (sort != null) {
        result.sort(sort);
      }
      return result;
    }); //MAndatory toList() error: The return type 'Iterable<Job>' isn't a 'List<Job>', as required by the closure's context
  }

  Stream<T> documentStream<T>({
    required String path,
    required T Function(Map<String, dynamic> data, String documentID) builder,
  }) {
    final reference = FirebaseFirestore.instance.doc(path);
    final snapshots = reference.snapshots();
    return snapshots.map((snapshot) => builder(snapshot.data()!, snapshot.id));
  }
}
