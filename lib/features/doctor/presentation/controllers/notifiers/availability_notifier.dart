// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../../../domain/usecases/add_availability.dart';

// class AvailabilityNotifier extends StateNotifier<bool> {
//   final AddAvailability addAvailabilityUsecase;

//   AvailabilityNotifier(this.addAvailabilityUsecase)
//       : super(false);

//   Future<void> addAvailability({
//     required String doctorId,
//     required String date,
//     required String time,
//   }) async {
//     state = true; // loading
//     await addAvailabilityUsecase(
//       doctorId: doctorId,
//       date: date,
//       time: time,
//     );
//     state =  state.copyWith(
//       isLoading: false,
//       availability: updated,
//     );; // done
//   }
// }
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dr_app/features/doctor/domain/usecases/add_availability.dart';
import 'package:dr_app/features/doctor/presentation/controllers/state/availability_state.dart';

class AvailabilityNotifier extends StateNotifier<AvailabilityState> {
  final AddAvailability addAvailabilityUseCase;

  AvailabilityNotifier(this.addAvailabilityUseCase)
      : super(const AvailabilityState());

  Future<void> addAvailability({
    required String doctorId,
    required String date,
    required String time,
  }) async {
    state = state.copyWith(isLoading: true);

    await addAvailabilityUseCase(
      doctorId: doctorId,
      date: date,
      time: time,
    );

    // 🔥 TODO: Ideally refetch from Firestore
    // For now we update locally

    final updated = Map<String, List<String>>.from(state.availability);

    if (updated.containsKey(date)) {
      updated[date] = [...updated[date]!, time];
    } else {
      updated[date] = [time];
    }

    state = state.copyWith(
      isLoading: false,
      availability: updated,
    );
  }

  Future<void> removeAvailability({
  required String doctorId,
  required String date,
  required String time,
}) async {
  state = state.copyWith(isLoading: true);

  // 🔴 TODO: call repository delete method if you have one
  // For now we update local state safely

  final updated = Map<String, List<String>>.from(state.availability);

  if (updated.containsKey(date)) {
    updated[date] = updated[date]!.where((t) => t != time).toList();

    // remove date key if empty
    if (updated[date]!.isEmpty) {
      updated.remove(date);
    }
  }

  state = state.copyWith(
    isLoading: false,
    availability: updated,
  );
}
}