import 'package:dr_app/features/doctor/domain/usecases/add_availability.dart';
import 'package:dr_app/features/doctor/presentation/controllers/notifiers/availability_notifier.dart';
import 'package:dr_app/features/doctor/presentation/controllers/providers/doctor_repository_provider.dart';
import 'package:dr_app/features/doctor/presentation/controllers/state/availability_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final availabilityProvider = 
    StateNotifierProvider<AvailabilityNotifier, AvailabilityState>((ref) {

  final repository =
      ref.read(doctorRepositoryProvider);

  return AvailabilityNotifier(
    AddAvailability(repository),
  );
});
