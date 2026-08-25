import 'package:dr_app/features/doctor/domain/repositories/doctor_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DoctorAppointmentNotifier 
    extends StateNotifier<AsyncValue<List<Map<String,dynamic>>>> {


  final DoctorRepository repository;


  DoctorAppointmentNotifier(this.repository)
      : super(const AsyncLoading());

Future<void> loadAppointments(String doctorId) async {

  try {

    final appointments =
        await repository.getDoctorAppointments(doctorId);


    for (var appointment in appointments) {

      final user =
          await repository.getUserDetails(
            appointment['userId'],
          );


      appointment['userName'] =
          user['name'] ?? '';

      appointment['userEmail'] =
          user['email'] ?? '';

    }


    state = AsyncData(appointments);


  } catch(e,st){

    state = AsyncError(e,st);

  }

}


 Future<void> updateStatus({
  required String appointmentId,
  required String status,
}) async {

  try {

    await repository.updateAppointmentStatus(
      appointmentId: appointmentId,
      status: status,
    );


    final currentState = state.value;

    if (currentState != null) {

      final updatedAppointments =
          currentState.map((appointment) {

        if (appointment['id'] == appointmentId) {

          return {
            ...appointment,
            'status': status,
          };

        }

        return appointment;

      }).toList();


      state = AsyncData(updatedAppointments);

    }


  } catch(e,st){

    state = AsyncError(e, st);

  }

}

}