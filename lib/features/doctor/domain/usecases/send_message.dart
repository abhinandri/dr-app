import '../entities/message_entity.dart';
import '../repositories/chat_repository.dart';

class SendMessage {
  final ChatRepository repository;

  SendMessage(this.repository);

  Future<void> call({
    required String chatId,
    required String doctorId,
    required String userId,
    required MessageEntity message,
  }) async {
    await repository.sendMessage(
      chatId: chatId,
      doctorId: doctorId,
      userId: userId,
      message: message,
    );
  }
}