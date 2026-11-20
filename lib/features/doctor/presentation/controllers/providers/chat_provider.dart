  import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dr_app/features/doctor/data/datasource/chat_remote_datasource.dart';
import 'package:dr_app/features/doctor/domain/usecases/get_message.dart';
import 'package:dr_app/features/doctor/presentation/controllers/notifiers/chat_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/repositories/chat_repository_impl.dart';
import '../../../domain/entities/message_entity.dart';
import '../../../domain/repositories/chat_repository.dart';
import '../../../domain/usecases/send_message.dart';

final chatRemoteDatasourceProvider =
    Provider<ChatRemoteDatasource>((ref) {
  return ChatRemoteDatasource(
    FirebaseFirestore.instance,
  );
});

final chatRepositoryProvider =
    Provider<ChatRepository>((ref) {
  final datasource =
      ref.read(chatRemoteDatasourceProvider);

  return ChatRepositoryImpl(datasource);
});

final sendMessageUseCaseProvider =
    Provider<SendMessage>((ref) {
  final repository =
      ref.read(chatRepositoryProvider);

  return SendMessage(repository);
});

final getMessagesUseCaseProvider =
    Provider<GetMessages>((ref) {
  final repository =
      ref.read(chatRepositoryProvider);

  return GetMessages(repository);
});

final chatNotifierProvider = StateNotifierProvider.autoDispose<
    ChatNotifier,
    AsyncValue<List<MessageEntity>>>((ref) {
  final sendMessage =
      ref.read(sendMessageUseCaseProvider);

  final getMessages =
      ref.read(getMessagesUseCaseProvider);

  return ChatNotifier(
    sendMessage: sendMessage,
    getMessages: getMessages,
  );
});