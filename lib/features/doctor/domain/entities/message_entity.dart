import 'package:equatable/equatable.dart';

class MessageEntity extends Equatable {
  final String messageId;
  final String senderId;
  final String receiverId;
  final String message;
  final DateTime createdAt;
  final String type;

  const MessageEntity({
    required this.messageId,
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.createdAt,
    required this.type,
  });

  @override
  List<Object?> get props => [
        messageId,
        senderId,
        receiverId,
        message,
        createdAt,
        type,
      ];
}