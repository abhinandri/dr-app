import 'package:dr_app/core/services/app_navigator.dart';
import 'package:dr_app/core/services/notification_service.dart';
import 'package:dr_app/features/doctor/presentation/screens/splash_screen.dart';
import 'package:dr_app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp( 
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await NotificationService.initialize();       

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        navigatorKey: navigatorKey,

      debugShowCheckedModeBanner: false,
      home: const SplashScreen(), // ✅ ONLY ON APP START
    );
  }
}
