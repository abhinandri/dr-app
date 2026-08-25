import 'package:cloud_firestore/cloud_firestore.dart';

abstract class DoctorRemoteDataSource {
  Future<String> getDoctorStatus(String uid);
}

class DoctorRemoteDataSourceImpl implements DoctorRemoteDataSource {
  final FirebaseFirestore firestore;

  DoctorRemoteDataSourceImpl(this.firestore);

  @override
  Future<String> getDoctorStatus(String uid) async {
    final doc = await firestore.collection('doctors').doc(uid).get();
    return doc['status'];
  }
}
