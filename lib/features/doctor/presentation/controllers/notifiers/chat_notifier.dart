import 'dart:async';

import 'package:dr_app/features/doctor/domain/entities/message_entity.dart';
import 'package:dr_app/features/doctor/domain/usecases/get_message.dart';
import 'package:dr_app/features/doctor/domain/usecases/send_message.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';


class ChatNotifier
    extends StateNotifier<AsyncValue<List<MessageEntity>>> {
  final SendMessage sendMessage;
  final GetMessages getMessages;

  StreamSubscription<List<MessageEntity>>? _messagesSubscription;

  ChatNotifier({
    required this.sendMessage,
    required this.getMessages,
  }) : super(const AsyncValue.loading());

  void listenToMessages(String chatId) {
    _messagesSubscription?.cancel();

    state = const AsyncValue.loading();

    _messagesSubscription = getMessages(
      chatId: chatId,
    ).listen(
      (messages) {
        state = AsyncValue.data(messages);
      },
      onError: (error, stackTrace) {
        state = AsyncValue.error(
          error,
          stackTrace,
        );
      },
    );
  }

  Future<void> send({
    required String chatId,
    required String userId,
    required String message,
  }) async {
    try {
      final doctorId =
          FirebaseAuth.instance.currentUser?.uid;

      if (doctorId == null) {
        throw Exception('Doctor is not logged in.');
      }

      if (message.trim().isEmpty) {
        return;
      }

      final newMessage = MessageEntity(
        messageId: '',
        senderId: doctorId,
        receiverId: userId,
        message: message.trim(),
        createdAt: DateTime.now(),
        type: 'text',
      );

      await sendMessage(
        chatId: chatId,
        doctorId: doctorId,
        userId: userId,
        message: newMessage,
      );
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  @override
  void dispose() {
    _messagesSubscription?.cancel();
    super.dispose();
  }
}