import 'dart:io';

import 'package:dr_app/features/doctor/domain/entities/doctor_entities.dart';
import 'package:dr_app/features/doctor/domain/repositories/doctor_repository.dart';
import 'package:dr_app/features/doctor/domain/usecases/get_doctor_profile.dart';
import 'package:dr_app/features/doctor/domain/usecases/update_doctor_profile.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileNotifier extends StateNotifier<AsyncValue<DoctorEntity>> {
  final DoctorRepository repository;
  final GetDoctorProfile getDoctorProfile;
  final UpdateDoctorProfile updateDoctorProfile;

  ProfileNotifier({
    required this.repository,
    required this.getDoctorProfile,
    required this.updateDoctorProfile,
  }) : super(const AsyncLoading());

  Future<void> loadProfile(String uid) async {
    try {
      final doctor = await getDoctorProfile(uid);
      state = AsyncData(doctor);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  Future<void> updateProfile(DoctorEntity doctor) async {
    try {
      await updateDoctorProfile(doctor);
      state = AsyncData(doctor);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  Future<String> uploadProfileImage(File file) async {
    return await repository.uploadProfileImage(file);
  }
}
