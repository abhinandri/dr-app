class NotificationEntity {
  final String notificationId;
  final String title;
  final String body;
  final String type;
  final String? appointmentId;
  final bool isRead;
  final DateTime createdAt;

  const NotificationEntity({
    required this.notificationId,
    required this.title,
    required this.body,
    required this.type,
    this.appointmentId,
    required this.isRead,
    required this.createdAt,
  });
}