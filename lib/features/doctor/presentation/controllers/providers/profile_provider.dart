import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dr_app/features/doctor/data/repositories/doctor_repository_impl.dart';
import 'package:dr_app/features/doctor/domain/entities/doctor_entities.dart';
import 'package:dr_app/features/doctor/domain/usecases/get_doctor_profile.dart';
import 'package:dr_app/features/doctor/domain/usecases/update_doctor_profile.dart';
import 'package:dr_app/features/doctor/presentation/controllers/notifiers/profile_notifier.dart';
import 'package:dr_app/features/doctor/presentation/controllers/providers/doctor_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final profileNotifierProvider = StateNotifierProvider<
    ProfileNotifier, AsyncValue<DoctorEntity>>((ref) {
final repository = ref.read(doctorRepositoryProvider);


  return ProfileNotifier(
     repository: repository,
    getDoctorProfile: GetDoctorProfile(repository),
    updateDoctorProfile:
        UpdateDoctorProfile(repository),
  );
});
