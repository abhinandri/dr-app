// // import 'package:dr_app/features/doctor/domain/entities/message_entity.dart';
// // import 'package:dr_app/features/doctor/presentation/controllers/providers/chat_provider.dart';
// // import 'package:dr_app/features/doctor/presentation/widgets/chat/chat_message_input.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_riverpod/flutter_riverpod.dart';


// // class ChatScreen extends ConsumerStatefulWidget {
// //   final String chatId;
// //   final String userId;
// //   final String userName;

// //   const ChatScreen({
// //     super.key,
// //     required this.chatId,
// //     required this.userId,
// //     required this.userName,
// //   });
 
// //   @override
// //   ConsumerState<ChatScreen> createState() => _ChatScreenState();
// // }

// // class _ChatScreenState extends ConsumerState<ChatScreen> {
// //   final ScrollController _scrollController = ScrollController();

 

// //   int _previousMessageCount = 0;

// // @override
// // void initState() {
// //   super.initState();

// //   WidgetsBinding.instance.addPostFrameCallback((_) {
// //     ref
// //         .read(chatNotifierProvider.notifier)
// //         .listenToMessages(widget.chatId);
// //   });

// //   ref.listenManual<AsyncValue<List<MessageEntity>>>(
// //     chatNotifierProvider,
// //     (previous, next) {
// //       next.whenData((messages) {
// //         if (messages.length != _previousMessageCount) {
// //           _previousMessageCount = messages.length;
// //           _scrollToBottom();
// //         }
// //       });
// //     },
// //   );
// // }
// //   @override
// //   void dispose() {
// //     _scrollController.dispose();
// //     super.dispose();
// //   }

// //   void _scrollToBottom() {
// //     if (!_scrollController.hasClients) return;

// //     WidgetsBinding.instance.addPostFrameCallback((_) {
// //       if (!_scrollController.hasClients) return;

// //       _scrollController.animateTo(
// //         _scrollController.position.maxScrollExtent,
// //         duration: const Duration(milliseconds: 300),
// //         curve: Curves.easeOut,
// //       );
// //     });
// //   }

// //    bool _isSameDay(DateTime first, DateTime second) {
// //   return first.year == second.year &&
// //       first.month == second.month &&
// //       first.day == second.day;
// // }

// //   @override
// //   Widget build(BuildContext context) {
// //     final chatState = ref.watch(chatNotifierProvider);

// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text(widget.userName),
// //       ),
// //       body: Column(
// //         children: [
// //           Expanded(
// //             child: chatState.when(
// //               loading: () {
// //                 return const Center(
// //                   child: CircularProgressIndicator(),
// //                 );
// //               },
// //               error: (error, stackTrace) {
// //                 return Center(
// //                   child: Text(
// //                     error.toString(),
// //                   ),
// //                 );
// //               },
// //               data: (messages) {
// //                 if (messages.isEmpty) {
// //                   return const Center(
// //                     child: Text('No messages yet'),
// //                   );
// //                 }

// //                 if (messages.length != _previousMessageCount) {
// //                   _previousMessageCount = messages.length;
// //                   _scrollToBottom();
// //                 }

// //                 return ListView.builder(
// //                   controller: _scrollController,
// //                   padding: const EdgeInsets.all(12),
// //                   itemCount: messages.length,
// //                 itemBuilder: (context, index) {
// //   final message = messages[index];

// //   final bool showDateSeparator =
// //       index == 0 ||
// //       !_isSameDay(
// //         messages[index - 1].createdAt,
// //         message.createdAt,
// //       );

// //   return Column(
// //     children: [
// //       if (showDateSeparator)
// //         _DateSeparator(
// //           date: message.createdAt,
// //         ),

// //       _MessageBubble(
// //         message: message.message,
// //         createdAt: message.createdAt,
// //         isMe: message.senderId ==
// //             FirebaseAuth.instance.currentUser?.uid,
// //       ),
// //     ],
// //   );
// // },
// //                 );
// //               },
// //             ),
// //           ),

// //           ChatMessageInput(
// //             chatId: widget.chatId,
// //             userId: widget.userId,
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
// // class _DateSeparator extends StatelessWidget {
// //   final DateTime date;

// //   const _DateSeparator({
// //     required this.date,
// //   });

// //   String _getDateText() {
// //     final now = DateTime.now();

// //     final today = DateTime(
// //       now.year,
// //       now.month,
// //       now.day,
// //     );

// //     final messageDate = DateTime(
// //       date.year,
// //       date.month,
// //       date.day,
// //     );

// //     final difference = today.difference(messageDate).inDays;

// //     if (difference == 0) {
// //       return 'Today';
// //     }

// //     if (difference == 1) {
// //       return 'Yesterday';
// //     }

// //     return '${date.day}/${date.month}/${date.year}';
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Padding(
// //       padding: const EdgeInsets.symmetric(vertical: 12),
// //       child: Text(
// //         _getDateText(),
// //         style: const TextStyle(
// //           fontSize: 12,
// //           fontWeight: FontWeight.w500,
// //         ),
// //       ),
// //     );
// //   }
// // }
// //   class _MessageBubble extends StatelessWidget {
// //   final String message;
// //   final DateTime createdAt;
// //   final bool isMe;

// //   const _MessageBubble({
// //     required this.message,
// //     required this.createdAt,
// //     required this.isMe,
// //   });

// //   @override
// //   Widget build(BuildContext context) {
// //     final time = TimeOfDay.fromDateTime(createdAt);

// //     return Align(
// //       alignment: isMe
// //           ? Alignment.centerRight
// //           : Alignment.centerLeft,
// //       child: Container(
// //         constraints: BoxConstraints(
// //           maxWidth:
// //               MediaQuery.of(context).size.width * 0.75,
// //         ),
// //         margin: const EdgeInsets.only(bottom: 8),
// //         padding: const EdgeInsets.symmetric(
// //           horizontal: 14,
// //           vertical: 10,
// //         ),
// //         decoration: BoxDecoration(
// //           color: isMe
// //               ? Theme.of(context).colorScheme.primary
// //               : Colors.grey.shade300,
// //           borderRadius: BorderRadius.only(
// //             topLeft: const Radius.circular(16),
// //             topRight: const Radius.circular(16),
// //             bottomLeft:
// //                 Radius.circular(isMe ? 16 : 4),
// //             bottomRight:
// //                 Radius.circular(isMe ? 4 : 16),
// //           ),
// //         ),
// //         child: Column(
// //           crossAxisAlignment: isMe
// //               ? CrossAxisAlignment.end
// //               : CrossAxisAlignment.start,
// //           children: [
// //             Text(
// //               message,
// //               style: TextStyle(
// //                 color: isMe
// //                     ? Colors.white
// //                     : Colors.black,
// //                 fontSize: 15,
// //               ),
// //             ),
// //             const SizedBox(height: 4),
// //             Text(
// //               time.format(context),
// //               style: TextStyle(
// //                 color: isMe
// //                     ? Colors.white70
// //                     : Colors.black54,
// //                 fontSize: 10,
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
// import 'package:dr_app/features/doctor/presentation/controllers/providers/chat_provider.dart';
// import 'package:dr_app/features/doctor/presentation/widgets/chat/chat_message_input.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class ChatScreen extends ConsumerStatefulWidget {
//   final String chatId;
//   final String userId;
//   final String userName;

//   const ChatScreen({
//     super.key,
//     required this.chatId,
//     required this.userId,
//     required this.userName,
//   });

//   @override
//   ConsumerState<ChatScreen> createState() => _ChatScreenState();
// }

// class _ChatScreenState extends ConsumerState<ChatScreen> {
//   final ScrollController _scrollController = ScrollController();

//   int _previousMessageCount = 0;

//   @override
//   void initState() {
//     super.initState();

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       ref
//           .read(chatNotifierProvider.notifier)
//           .listenToMessages(widget.chatId);
//     });
//   }

//   @override
//   void dispose() {
//     _scrollController.dispose();
//     super.dispose();
//   }

//   void _scrollToBottom({bool animated = true}) {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (!_scrollController.hasClients) return;

//       final maxScrollExtent =
//           _scrollController.position.maxScrollExtent;

//       if (animated) {
//         _scrollController.animateTo(
//           maxScrollExtent,
//           duration: const Duration(milliseconds: 300),
//           curve: Curves.easeOut,
//         );
//       } else {
//         _scrollController.jumpTo(maxScrollExtent);
//       }
//     });
//   }

//   bool _isSameDay(DateTime first, DateTime second) {
//     return first.year == second.year &&
//         first.month == second.month &&
//         first.day == second.day;
//   }

//   String _getDateText(DateTime date) {
//     final now = DateTime.now();

//     final today = DateTime(
//       now.year,
//       now.month,
//       now.day,
//     );

//     final messageDate = DateTime(
//       date.year,
//       date.month,
//       date.day,
//     );

//     final difference = today.difference(messageDate).inDays;

//     if (difference == 0) {
//       return 'Today';
//     }

//     if (difference == 1) {
//       return 'Yesterday';
//     }

//     return '${date.day}/${date.month}/${date.year}';
//   }

//   @override
//   Widget build(BuildContext context) {
//     final chatState = ref.watch(chatNotifierProvider);

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.userName),
//         centerTitle:  true,
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: chatState.when(
//               loading: () {
//                 return const Center(
//                   child: CircularProgressIndicator(),
//                 );
//               },
//               error: (error, stackTrace) {
//                 return Center(
//                   child: Text(
//                     error.toString(),
//                   ),
//                 );
//               },
//               data: (messages) {
//                 if (messages.isEmpty) {     
//                   return const Center(
//                     child: Text('No messages yet'),
//                   );
//                 }

//                 // Scroll after the ListView has been rendered.
//                 if (messages.length != _previousMessageCount) {
//                   _previousMessageCount = messages.length;

//                   _scrollToBottom(
//                     animated: false,
//                   );
//                 }

//                 return ListView.builder(
//                   controller: _scrollController,
//                   padding: const EdgeInsets.fromLTRB(
//                     12,
//                     16,
//                     12,
//                     16,
//                   ),
//                   itemCount: messages.length,
//                   itemBuilder: (context, index) {
//                     final message = messages[index];

//                     final bool showDateSeparator =
//                         index == 0 ||
//                         !_isSameDay(
//                           messages[index - 1].createdAt,
//                           message.createdAt,
//                         );

//                     return Column(
//                       children: [
//                         if (showDateSeparator)
//                           _DateSeparator(
//                             dateText: _getDateText(
//                               message.createdAt,
//                             ),
//                           ),

//                         _MessageBubble(
//                           message: message.message,
//                           createdAt: message.createdAt,
//                           isMe: message.senderId ==
//                               FirebaseAuth
//                                   .instance
//                                   .currentUser
//                                   ?.uid,
//                         ),
//                       ],
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//           ChatMessageInput(
//             chatId: widget.chatId,
//             userId: widget.userId,
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _DateSeparator extends StatelessWidget {
//   final String dateText;

//   const _DateSeparator({
//     required this.dateText,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(
//         vertical: 12,
//       ),
//       child: Text(
//         dateText,
//         style: const TextStyle(
//           fontSize: 12,
//           fontWeight: FontWeight.w500,
//         ),
//       ),
//     );
//   }
// }

// class _MessageBubble extends StatelessWidget {
//   final String message;
//   final DateTime createdAt;
//   final bool isMe;

//   const _MessageBubble({
//     required this.message,
//     required this.createdAt,
//     required this.isMe,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final time = TimeOfDay.fromDateTime(createdAt);

//     return Align(
//       alignment: isMe
//           ? Alignment.centerRight
//           : Alignment.centerLeft,
//       child: Container(
//         constraints: BoxConstraints(
//           maxWidth:
//               MediaQuery.of(context).size.width * 0.75,
//         ),
//         margin: const EdgeInsets.only(
//           bottom: 8,
//         ),
//         padding: const EdgeInsets.symmetric(
//           horizontal: 14,
//           vertical: 10,
//         ),
//         decoration: BoxDecoration(
//           color: isMe
//               ? Theme.of(context).colorScheme.primary
//               : Colors.grey.shade300,
//           borderRadius: BorderRadius.only(
//             topLeft: const Radius.circular(16),
//             topRight: const Radius.circular(16),
//             bottomLeft: Radius.circular(
//               isMe ? 16 : 4,
//             ),
//             bottomRight: Radius.circular(
//               isMe ? 4 : 16,
//             ),
//           ),
//         ),
//         child: Column(
//           crossAxisAlignment: isMe
//               ? CrossAxisAlignment.end
//               : CrossAxisAlignment.start,
//           children: [
//             Text(
//               message,
//               style: TextStyle(
//                 color: isMe
//                     ? Colors.white
//                     : Colors.black,
//                 fontSize: 15,
//               ),
//             ),
//             const SizedBox(height: 4),
//             Text(
//               time.format(context),
//               style: TextStyle(
//                 color: isMe
//                     ? Colors.white70
//                     : Colors.black54,
//                 fontSize: 10,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:dr_app/core/theme/app_colors.dart';
import 'package:dr_app/features/doctor/presentation/controllers/providers/chat_provider.dart';
import 'package:dr_app/features/doctor/presentation/widgets/chat/chat_message_input.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final String chatId;
  final String userId;
  final String userName;

  const ChatScreen({
    super.key,
    required this.chatId,
    required this.userId,
    required this.userName,
  });

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final ScrollController _scrollController = ScrollController();

  int _previousMessageCount = 0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(chatNotifierProvider.notifier)
          .listenToMessages(widget.chatId);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom({bool animated = true}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;

      final maxScrollExtent = _scrollController.position.maxScrollExtent;

      if (animated) {
        _scrollController.animateTo(
          maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      } else {
        _scrollController.jumpTo(maxScrollExtent);
      }
    });
  }

  bool _isSameDay(DateTime first, DateTime second) {
    return first.year == second.year &&
        first.month == second.month &&
        first.day == second.day;
  }

  String _getDateText(DateTime date) {
    final now = DateTime.now();

    final today = DateTime(now.year, now.month, now.day);
    final messageDate = DateTime(date.year, date.month, date.day);

    final difference = today.difference(messageDate).inDays;

    if (difference == 0) {
      return 'Today';
    }

    if (difference == 1) {
      return 'Yesterday';
    }

    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(chatNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.primaryStart.withOpacity(0.06),
                    AppColors.scaffoldBg,
                  ],
                  stops: const [0.0, 0.18],
                ),
              ),
              child: chatState.when(
                loading: () => _buildLoadingState(),
                error: (error, stackTrace) => _buildErrorState(error),
                data: (messages) {
                  if (messages.isEmpty) {
                    return _buildEmptyState();
                  }

                  // Scroll after the ListView has been rendered.
                  if (messages.length != _previousMessageCount) {
                    _previousMessageCount = messages.length;

                    _scrollToBottom(animated: false);
                  }

                  return ListView.builder(
                    controller: _scrollController,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(14, 18, 14, 18),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];

                      final bool showDateSeparator =
                          index == 0 ||
                          !_isSameDay(
                            messages[index - 1].createdAt,
                            message.createdAt,
                          );

                      return Column(
                        children: [
                          if (showDateSeparator)
                            _DateSeparator(
                              dateText: _getDateText(message.createdAt),
                            ),
                          _MessageBubble(
                            message: message.message,
                            createdAt: message.createdAt,
                            isMe:
                                message.senderId ==
                                FirebaseAuth.instance.currentUser?.uid,
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ),

          // Input bar container — visual wrapper only, widget untouched.
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 16,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: ChatMessageInput(
                chatId: widget.chatId,
                userId: widget.userId,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ════════════════════════════════════════
  //  APP BAR — gradient header, matches
  //  DoctorAppointmentsScreen's visual language
  // ════════════════════════════════════════
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(78),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primaryStart, AppColors.primaryEnd],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryStart.withOpacity(0.25),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(6, 4, 16, 10),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.maybePop(context),
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
                Stack(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.18),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withOpacity(0.35),
                        ),
                      ),
                      child: const Icon(
                        Icons.person_rounded,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 11,
                        height: 11,
                        decoration: BoxDecoration(
                          color: const Color(0xFF3DDC84),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.primaryEnd,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.userName,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'Patient',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                _circleIconBtn(Icons.call_outlined),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _circleIconBtn(IconData icon) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.18),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.white, size: 18),
    );
  }

  // ════════════════════════════════════════
  //  LOADING STATE
  // ════════════════════════════════════════
  Widget _buildLoadingState() {
    return Center(
      child: SizedBox(
        width: 34,
        height: 34,
        child: CircularProgressIndicator(
          strokeWidth: 3,
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryStart),
        ),
      ),
    );
  }

  // ════════════════════════════════════════
  //  ERROR STATE
  // ════════════════════════════════════════
  Widget _buildErrorState(Object error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 36),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline_rounded,
                color: AppColors.error,
                size: 34,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Something went wrong',
              style: TextStyle(
                fontSize: 15.5,
                fontWeight: FontWeight.w700,
                color: AppColors.heading,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              error.toString(),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12.5, color: AppColors.subtext),
            ),
          ],
        ),
      ),
    );
  }

  // ════════════════════════════════════════
  //  EMPTY STATE
  // ════════════════════════════════════════
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(26),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primaryStart.withOpacity(0.12),
                  AppColors.primaryEnd.withOpacity(0.12),
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: [AppColors.primaryStart, AppColors.primaryEnd],
              ).createShader(bounds),
              child: const Icon(
                Icons.chat_bubble_outline_rounded,
                size: 40,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'No messages yet',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.heading,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Start the conversation with your patient',
            style: TextStyle(fontSize: 12.5, color: AppColors.subtext),
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════
//  DATE SEPARATOR — gradient pill, matches appointment screen
//  section headers
// ════════════════════════════════════════════════════════════
class _DateSeparator extends StatelessWidget {
  final String dateText;

  const _DateSeparator({required this.dateText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
            border: Border.all(color: const Color(0xFFEBEDF2)),
          ),
          child: Text(
            dateText,
            style: TextStyle(
              color: AppColors.subtext,
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.2,
            ),
          ),
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════
//  MESSAGE BUBBLE
// ════════════════════════════════════════════════════════════
class _MessageBubble extends StatelessWidget {
  final String message;
  final DateTime createdAt;
  final bool isMe;

  const _MessageBubble({
    required this.message,
    required this.createdAt,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    final time = TimeOfDay.fromDateTime(createdAt);

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.76,
        ),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 11),
        decoration: BoxDecoration(
          gradient: isMe
              ? LinearGradient(
                  colors: [AppColors.primaryStart, AppColors.primaryEnd],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isMe ? null : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: Radius.circular(isMe ? 20 : 4),
            bottomRight: Radius.circular(isMe ? 4 : 20),
          ),
          boxShadow: [
            BoxShadow(
              color: isMe
                  ? AppColors.primaryStart.withOpacity(0.25)
                  : Colors.black.withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
          border: isMe ? null : Border.all(color: const Color(0xFFEBEDF2)),
        ),
        child: Column(
          crossAxisAlignment: isMe
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Text(
              message,
              style: TextStyle(
                color: isMe ? Colors.white : AppColors.heading,
                fontSize: 14.5,
                height: 1.4,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  time.format(context),
                  style: TextStyle(
                    color: isMe ? Colors.white70 : AppColors.subtext,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (isMe) ...[
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.done_all_rounded,
                    size: 13,
                    color: Colors.white70,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}