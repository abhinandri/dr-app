import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dr_app/features/doctor/data/model/notification_model.dart';
import 'package:firebase_auth/firebase_auth.dart';


class NotificationRemoteDatasource {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  NotificationRemoteDatasource(this.firestore, this.auth);

  CollectionReference<Map<String, dynamic>> get _notifications {
    final doctor = auth.currentUser;

    if (doctor == null) {
      throw Exception('Doctor not logged in');
    }

    return firestore
        .collection('doctors')
        .doc(doctor.uid)
        .collection('notifications');
  }

  Stream<List<NotificationModel>> getNotifications() {
    return _notifications
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return NotificationModel.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }

  Future<void> markAsRead(String notificationId) async {
    await _notifications.doc(notificationId).update({
      'isRead': true,
    });
  }

  Future<void> markAllAsRead() async {
    final snapshot = await _notifications
        .where('isRead', isEqualTo: false)
        .get();

    final batch = firestore.batch();

    for (final doc in snapshot.docs) {
      batch.update(doc.reference, {'isRead': true});
    }

    await batch.commit();
  }
}