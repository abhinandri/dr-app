import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dr_app/features/doctor/data/model/message_model.dart';

class ChatRemoteDatasource {
  final FirebaseFirestore firestore;

  ChatRemoteDatasource(this.firestore);

  Future<void> sendMessage({
    required String chatId,
    required String doctorId,
    required String userId,
    required MessageModel message,
  }) async {
    final chatRef = firestore
        .collection('chats')
        .doc(chatId);

    final messageRef = chatRef
        .collection('messages')
        .doc();

    final batch = firestore.batch();

    // Create/update the chat document.
    batch.set(
      chatRef,
      {
        'userId': userId,
        'doctorId': doctorId,
        'lastMessage': message.message,
        'lastMessageAt': Timestamp.fromDate(
          message.createdAt,
        ),
      },
      SetOptions(merge: true),
    );

    // Create the message document.
    batch.set(
      messageRef,
      message.toMap(),
    );

    await batch.commit();
  }

  Stream<List<MessageModel>> getMessages({
    required String chatId,
  }) {
    return firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('createdAt')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return MessageModel.fromMap(
          doc.data(),
          doc.id,
        );
      }).toList();
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getDoctorChats({
  required String doctorId,
}) {
  return firestore
      .collection('chats')
      .where('doctorId', isEqualTo: doctorId)
      .snapshots();
}
}