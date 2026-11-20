import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/message_entity.dart';

class MessageModel extends MessageEntity {
  const MessageModel({
    required super.messageId,
    required super.senderId,
    required super.receiverId,
    required super.message,
    required super.createdAt,
    required super.type,
  });

  factory MessageModel.fromMap(
    Map<String, dynamic> map,
    String id,
  ) {
    return MessageModel(
      messageId: id,
      senderId: map['senderId'] ?? '',
      receiverId: map['receiverId'] ?? '',
      message: map['message'] ?? '',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      type: map['type'] ?? 'text',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'message': message,
      'createdAt': Timestamp.fromDate(createdAt),
      'type': type,
    };
  }
}