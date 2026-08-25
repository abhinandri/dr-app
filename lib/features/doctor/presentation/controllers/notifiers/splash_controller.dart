import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dr_app/features/doctor/presentation/controllers/notifiers/doctor_auth_controller.dart';
import '../../../domain/repositories/doctor_auth_repository.dart';

/// Represents all possible routes the splash screen can decide.
enum SplashRoute {
  login,
  waiting,
  rejected,
  dashboard,
}

final splashControllerProvider =
    StateNotifierProvider<SplashController, AsyncValue<SplashRoute>>(
  (ref) {
    final repository = ref.read(doctorAuthRepositoryProvider);
    return SplashController(repository);
  },
);

class SplashController extends StateNotifier<AsyncValue<SplashRoute>> {
  final DoctorAuthRepository _repository;

  SplashController(this._repository)
      : super(const AsyncValue.loading());

  Future<void> checkAuthAndStatus() async {
    try {
      // ⏳ Keep splash visible for 3 seconds
      await Future.delayed(const Duration(seconds: 3));

      // 🔍 Decide where to go
      final route = await _repository.getInitialRoute();

      // 📤 Emit route to UI
      state = AsyncValue.data(route);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
