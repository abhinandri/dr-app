import 'package:dr_app/features/doctor/presentation/controllers/providers/doctor_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../notifiers/appointment_notifier.dart';


// Appointment Provider
final doctorAppointmentProvider = StateNotifierProvider<
    DoctorAppointmentNotifier, AsyncValue<List<Map<String, dynamic>>>>((ref) {
  final repository = ref.read(
    doctorRepositoryProvider,
  );

  return DoctorAppointmentNotifier(
    repository,
  );
});
