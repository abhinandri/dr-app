    import 'package:dr_app/features/doctor/data/datasource/chat_remote_datasource.dart';
import 'package:dr_app/features/doctor/data/model/message_model.dart';

import '../../domain/entities/message_entity.dart';
import '../../domain/repositories/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDatasource remoteDatasource;

  ChatRepositoryImpl(this.remoteDatasource);

  @override
  Future<void> sendMessage({
    required String chatId,
    required String doctorId,
    required String userId,
    required MessageEntity message,
  }) async {
    final model = MessageModel(
      messageId: message.messageId,
      senderId: message.senderId,
      receiverId: message.receiverId,
      message: message.message,
      createdAt: message.createdAt,
      type: message.type,
    );

    await remoteDatasource.sendMessage(
      chatId: chatId,
      doctorId: doctorId,
      userId: userId,
      message: model,
    );
  }

  @override
  Stream<List<MessageEntity>> getMessages({
    required String chatId,
  }) {
    return remoteDatasource.getMessages(
      chatId: chatId,
    );
  }
}