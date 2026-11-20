
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dr_app/features/doctor/presentation/screens/chat/chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DoctorChatListScreen extends StatelessWidget {
  const DoctorChatListScreen({super.key});

  static const Color _primary = Color(0xFF00897B);
  static const Color _background = Color(0xFFF5F8FA);

  @override
  Widget build(BuildContext context) {
    final doctorId = FirebaseAuth.instance.currentUser?.uid;

    if (doctorId == null) {
      return const Scaffold(
        body: Center(child: Text('Please log in to view your chats.')),
      );
    }

    return Scaffold(
      backgroundColor: _background,
      appBar: AppBar(
        title: const Text(
          'Messages',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF17313B),
        elevation: 0,
        centerTitle: false,
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('chats')
            .where('doctorId', isEqualTo: doctorId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Unable to load chats.'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: _primary),
            );
          }

          final chats = [...?snapshot.data?.docs];

          chats.sort((a, b) {
            final aTime = a.data()['lastMessageAt'];
            final bTime = b.data()['lastMessageAt'];

            final aDate = aTime is Timestamp
                ? aTime.toDate()
                : DateTime.fromMillisecondsSinceEpoch(0);
            final bDate = bTime is Timestamp
                ? bTime.toDate()
                : DateTime.fromMillisecondsSinceEpoch(0);

            return bDate.compareTo(aDate);
          });

          if (chats.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.chat_bubble_outline_rounded,
                      size: 56,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'No conversations yet',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Patient conversations will appear here.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: chats.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final chatDoc = chats[index];
              final chat = chatDoc.data();

              final userId = chat['userId']?.toString() ?? '';
              final lastMessage =
                  chat['lastMessage']?.toString() ?? '';
              final lastMessageAt = chat['lastMessageAt'];

              if (userId.isEmpty) {
                return const SizedBox.shrink();
              }

              return FutureBuilder<
                  DocumentSnapshot<Map<String, dynamic>>>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(userId)
                    .get(),
                builder: (context, userSnapshot) {
                  final patient = userSnapshot.data?.data();
                  final patientName =
                      patient?['name']?.toString().trim().isNotEmpty == true
                          ? patient!['name'].toString()
                          : 'Patient';
                  final photoUrl =
                      patient?['photoUrl']?.toString() ?? '';

                  final time = lastMessageAt is Timestamp
                      ? TimeOfDay.fromDateTime(
                          lastMessageAt.toDate(),
                        ).format(context)
                      : '';

                  return Card(
                    color: Colors.white,
                    elevation: 1,
                    shadowColor: Colors.black12,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      leading: CircleAvatar(
                        radius: 26,
                        backgroundColor: const Color(0xFFE0F2F1),
                        backgroundImage: photoUrl.isNotEmpty
                            ? NetworkImage(photoUrl)
                            : null,
                        child: photoUrl.isEmpty
                            ? const Icon(
                                Icons.person_outline_rounded,
                                color: _primary,
                              )
                            : null,
                      ),
                      title: Text(
                        patientName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(
                          lastMessage.isEmpty
                              ? 'Start a conversation'
                              : lastMessage,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.blueGrey,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            time,
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.blueGrey,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Icon(
                            Icons.chevron_right_rounded,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ChatScreen(
                              chatId: chatDoc.id,
                              userId: userId,
                              userName: patientName,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
