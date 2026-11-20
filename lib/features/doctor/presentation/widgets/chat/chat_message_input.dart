import 'package:dr_app/features/doctor/presentation/controllers/providers/chat_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class ChatMessageInput extends ConsumerStatefulWidget {
  final String chatId;
  final String userId;

  const ChatMessageInput({
    super.key,
    required this.chatId,
    required this.userId,
  });

  @override
  ConsumerState<ChatMessageInput> createState() =>
      _ChatMessageInputState();
}

class _ChatMessageInputState
    extends ConsumerState<ChatMessageInput> {
  final TextEditingController _controller =
      TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _controller.text.trim();

    if (text.isEmpty) return;

    ref.read(chatNotifierProvider.notifier).send(
          chatId: widget.chatId,
          userId: widget.userId,
          message: text,
        );

    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            Expanded(
              child:TextField(
  controller: _controller,
  minLines: 1,
  maxLines: 5,
  keyboardType: TextInputType.multiline,
  textInputAction: TextInputAction.newline,
  decoration: InputDecoration(
    hintText: 'Type a message...',
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(24),
    ),
    contentPadding: const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 10,
    ),
  ),
),
            ),
            const SizedBox(width: 6),   
            IconButton(
              onPressed: _sendMessage,
              icon: const Icon(Icons.send),
            ),
          ],
        ),
      ),
    );
  }
}