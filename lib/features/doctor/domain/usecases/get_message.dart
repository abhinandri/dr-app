    import '../entities/message_entity.dart';
import '../repositories/chat_repository.dart';

class GetMessages {
  final ChatRepository repository;

  GetMessages(this.repository);

  Stream<List<MessageEntity>> call({
    required String chatId,
  }) {
    return repository.getMessages(
      chatId: chatId,
    );
  }
}