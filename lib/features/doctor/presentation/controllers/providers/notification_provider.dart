import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dr_app/features/doctor/data/datasource/notification_remote_datasource.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/repositories/notification_repository_impl.dart';
import '../../../domain/entities/notification_entity.dart';
import '../../../domain/repositories/notification_repository.dart';

// Data source
final notificationRemoteDatasourceProvider =
    Provider<NotificationRemoteDatasource>((ref) {
  return NotificationRemoteDatasource(
    FirebaseFirestore.instance,
    FirebaseAuth.instance,
  );
});

// Repository
final notificationRepositoryProvider =
    Provider<NotificationRepository>((ref) {
  return NotificationRepositoryImpl(
    ref.read(notificationRemoteDatasourceProvider),
  );
});

// Real-time notification stream
final doctorNotificationsProvider =
    StreamProvider<List<NotificationEntity>>((ref) {
  return ref
      .watch(notificationRepositoryProvider)
      .getNotifications();
});