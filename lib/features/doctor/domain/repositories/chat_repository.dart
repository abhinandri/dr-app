import '../entities/message_entity.dart';

abstract class ChatRepository {
  Future<void> sendMessage({
    required String chatId,
    required String doctorId,
    required String userId,
    required MessageEntity message,
  });

  Stream<List<MessageEntity>> getMessages({
    required String chatId,
  });
}