import 'package:dr_app/features/doctor/presentation/controllers/notifiers/splash_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../data/repositories/doctor_auth_repository_impl.dart';
import '../../../domain/repositories/doctor_auth_repository.dart';

final doctorAuthRepositoryProvider = Provider<DoctorAuthRepository>((ref) {
  return DoctorAuthRepositoryImpl(
    firebaseAuth: FirebaseAuth.instance,
    firestore: FirebaseFirestore.instance,
  );
});

final doctorAuthControllerProvider =
    StateNotifierProvider<DoctorAuthController, AsyncValue<void>>((ref) {
  final repo = ref.read(doctorAuthRepositoryProvider);
  return DoctorAuthController(repo);
});

class DoctorAuthController extends StateNotifier<AsyncValue<void>> {
  final DoctorAuthRepository _repo;

  DoctorAuthController(this._repo) : super(const AsyncValue.data(null));

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
    required String licenseNumber,
    required String phone,
    required String experience,
    required String about,
    required String departmentId,
    required String departmentName,
    required List<String> certificateUrls,
    required String profileImageUrl,
    required double consultationFee,
    required List<String>languages,
    required List<Map<String,String>>qualifications,

    
  }) async {
    state = const AsyncValue.loading();
    try {
      await _repo.signUpDoctor(
        name: name,
        email: email,
        password: password,
        licenseNumber: licenseNumber,
        phone: phone,
        experience: experience,
        about: about,
        departmentId: departmentId,
        departmentName: departmentName,
        certificateUrls: certificateUrls,
        profileImageUrl:profileImageUrl,
        
        consultationFee: consultationFee,
        languages: languages,
        qualifications: qualifications,
      );
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<SplashRoute> login({
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();

    try {
      await _repo.loginDoctor(
        email: email,
        password: password,
      );

      // 🔥 Immediately decide route
      final route = await _repo.getInitialRoute();

      state = const AsyncValue.data(null);
      return route;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> logout() async {
    await _repo.logoutDoctor();
  }

  Future<void> sendPasswordReset(String email) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }
}
