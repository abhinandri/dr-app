import 'dart:convert';
import 'dart:io';

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

    // Send notification to patient
try {
  final client = HttpClient();

  try {
    final uri = Uri.parse(
      'http://192.168.1.3:3000/notify-patient',
    );

    final request = await client.postUrl(uri);

    request.headers.set(
      HttpHeaders.contentTypeHeader,
      'application/json',
    );

    request.write(jsonEncode({
      'appointmentId': appointmentId,
    }));

    final response = await request.close();

if (response.statusCode == 200) {
  print('Patient notification sent successfully.');
} else {
  print('Patient notification failed: ${response.statusCode}');
}  } finally {
    client.close();
  }
} catch (e) {
  print('Patient notification error: $e');
}


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