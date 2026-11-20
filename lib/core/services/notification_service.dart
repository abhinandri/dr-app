import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:dr_app/core/services/app_navigator.dart';
import 'package:dr_app/features/doctor/data/repositories/doctor_repository_impl.dart';
import 'package:dr_app/features/doctor/presentation/screens/appointment/appointment_details_screen.dart';

class NotificationService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static String? _pendingAppointmentId;

  static Future<void> initialize() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    await initializeLocalNotifications();

    // await testNotification();

    debugPrint(
      'Doctor notification permission: ${settings.authorizationStatus}',
    );

    final token = await _messaging.getToken();

    if (token != null) {
      await saveToken(token);
    }

    _messaging.onTokenRefresh.listen((newToken) {
      saveToken(newToken);
    });

 FirebaseMessaging.onMessage.listen((message) {
  final notification = message.notification;
  final appointmentId = message.data['appointmentId']?.toString();

  if (notification != null) {
    showNotification(
      title: notification.title ?? 'Medivo',
      body: notification.body ?? '',
      appointmentId: appointmentId,
    );
  }
});
FirebaseMessaging.onMessageOpenedApp.listen((message) {
  final appointmentId = message.data['appointmentId'];

  if (appointmentId != null) {
    openAppointment(appointmentId.toString());
  }
});

 final initialMessage = await _messaging.getInitialMessage();

if (initialMessage != null) {
  final appointmentId =
      initialMessage.data['appointmentId'];

  if (appointmentId != null) {
    _pendingAppointmentId = appointmentId.toString();
  }
}
  }

  static Future<void> saveToken(String token) async {
    final doctor = FirebaseAuth.instance.currentUser;

    if (doctor == null) {
      debugPrint('No logged-in doctor. Token not saved.');
      return;
    }

    try {
      await _firestore
          .collection('doctors')
          .doc(doctor.uid)
          .collection('fcmTokens')
          .doc(token)
          .set({
        'token': token,
        'platform': 'android',
        'updatedAt': FieldValue.serverTimestamp(),
      });

      debugPrint('Doctor FCM token saved successfully.');
    } catch (e) {
      debugPrint('Error saving doctor FCM token: $e');
    }
  }

  static Future<void> initializeLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const initializationSettings = InitializationSettings(
      android: androidSettings,
    );

  await _localNotifications.initialize(
  settings: initializationSettings,
  onDidReceiveNotificationResponse: (response) {
    final appointmentId = response.payload;

    if (appointmentId != null && appointmentId.isNotEmpty) {
      openAppointment(appointmentId);
    }
  },
);

    const androidChannel = AndroidNotificationChannel(
      'doctor_notifications',
      'Doctor Notifications',
      description: 'Notifications for doctor appointments',
      importance: Importance.max,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannel);
  }

  static Future<void> showNotification({
    required String title,
    required String body,
    String? appointmentId,

  }) async {
    const androidDetails = AndroidNotificationDetails(
      'doctor_notifications',
      'Doctor Notifications',
      channelDescription: 'Notifications for doctor appointments',
      importance: Importance.max,
      priority: Priority.high,
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    await _localNotifications.show(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: title,
      body: body,
      notificationDetails: notificationDetails,
      payload: appointmentId
    );
  }

  static Future<void> testNotification() async {
    await showNotification(
      title: 'Medivo Test',
      body: 'Your local notification is working successfully!',
    );
  }


  static Future<void> openAppointment(String appointmentId) async {
  try {
    final doctor = FirebaseAuth.instance.currentUser;

    if (doctor == null) return;

    final repository = DoctorRepositoryImpl(_firestore);

    final appointment =
        await repository.getAppointmentById(appointmentId);

    // Verify appointment belongs to logged-in doctor.
    if (appointment['doctorId'] != doctor.uid) {
      debugPrint('Unauthorized appointment notification.');
      return;
    }

    final patient = await repository.getUserDetails(
      appointment['userId'],
    );

    appointment['userName'] = patient['name'] ?? '';
    appointment['userEmail'] = patient['email'] ?? '';

    navigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (_) => AppointmentDetailsScreen(
          appointment: appointment,
        ),
      ),
    );
  } catch (e) {
    debugPrint('Unable to open appointment: $e');
  }
}


static Future<void> openPendingAppointment() async {
  final appointmentId = _pendingAppointmentId;

  if (appointmentId == null) return;

  _pendingAppointmentId = null;

  await openAppointment(appointmentId);
}

static Future<void> registerCurrentUserToken() async {
  final token = await _messaging.getToken();

  if (token != null) {
    await saveToken(token);
  }
}
}
