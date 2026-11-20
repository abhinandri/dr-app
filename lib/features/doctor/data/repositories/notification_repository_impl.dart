import 'package:dr_app/features/doctor/data/datasource/notification_remote_datasource.dart';

import '../../domain/entities/notification_entity.dart';
import '../../domain/repositories/notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDatasource remoteDatasource;

  NotificationRepositoryImpl(this.remoteDatasource);

  @override
  Stream<List<NotificationEntity>> getNotifications() {
    return remoteDatasource.getNotifications();
  }

  @override
  Future<void> markAsRead(String notificationId) {
    return remoteDatasource.markAsRead(notificationId);
  }

  @override
  Future<void> markAllAsRead() {
    return remoteDatasource.markAllAsRead();
  }
}