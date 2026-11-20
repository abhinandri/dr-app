import 'dart:io';

import '../entities/doctor_entities.dart';

abstract class DoctorRepository {

  Future<DoctorEntity> getDoctorById(String uid);

  Future<void> updateDoctorProfile(DoctorEntity doctor);

  Future<String> uploadProfileImage(File file);

  Future<void> addAvailability({
  required String doctorId,
  required String date,
  required String time,
});

// Appointment

  Future<List<Map<String, dynamic>>> getDoctorAppointments(
      String doctorId);

      Future<Map<String, dynamic>> getAppointmentById(
  String appointmentId,
);


  Future<void> updateAppointmentStatus({
    required String appointmentId,
    required String status,
  });


Future<Map<String, dynamic>> getUserDetails(String uid);

}
