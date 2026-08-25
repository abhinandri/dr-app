import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../notifiers/doctor_auth_controller.dart';

final doctorStatusProvider = StreamProvider<String>((ref) {
  final repo = ref.read(doctorAuthRepositoryProvider);
  final user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    return const Stream.empty();
  }

  return repo.watchDoctorStatus(user.uid);
});
