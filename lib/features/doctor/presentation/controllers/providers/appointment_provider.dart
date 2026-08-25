import 'package:dr_app/features/doctor/data/repositories/doctor_repository_impl.dart';
import 'package:dr_app/features/doctor/domain/repositories/doctor_repository.dart';
import 'package:dr_app/features/doctor/presentation/controllers/providers/doctor_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../notifiers/appointment_notifier.dart';





// Appointment Provider
final doctorAppointmentProvider =
    StateNotifierProvider<
        DoctorAppointmentNotifier,
        AsyncValue<List<Map<String, dynamic>>>>((ref) {

  final repository = ref.read(
    doctorRepositoryProvider,
  );


  return DoctorAppointmentNotifier(
    repository,
  );
});