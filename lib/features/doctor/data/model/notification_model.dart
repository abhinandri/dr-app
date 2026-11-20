import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/notification_entity.dart';

class NotificationModel extends NotificationEntity {
  const NotificationModel({
    required super.notificationId,
    required super.title,
    required super.body,
    required super.type,
    super.appointmentId,
    required super.isRead,
    required super.createdAt,
  });

  factory NotificationModel.fromMap(
    Map<String, dynamic> map,
    String id,
  ) {
    return NotificationModel(
      notificationId: id,
      title: map['title'] ?? '',
      body: map['body'] ?? '',
      type: map['type'] ?? '',
      appointmentId: map['appointmentId'],
      isRead: map['isRead'] ?? false,
      createdAt: map['createdAt'] is Timestamp
          ? (map['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }
}