import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dr_app/core/services/cloudinary_service.dart';
import 'package:dr_app/features/doctor/data/model/doctor_model.dart';
import 'package:dr_app/features/doctor/domain/entities/doctor_entities.dart';
import 'package:dr_app/features/doctor/domain/repositories/doctor_repository.dart';

class DoctorRepositoryImpl implements DoctorRepository {
  final FirebaseFirestore firestore;

  DoctorRepositoryImpl(this.firestore);

  @override
  Future<DoctorEntity> getDoctorById(String uid) async {
    final doc = await firestore.collection('doctors').doc(uid).get();

    return DoctorModel.fromMap(doc.data()!);
  }

  @override
  Future<void> updateDoctorProfile(DoctorEntity doctor) async {
    final model = DoctorModel(
        id: doctor.id,
        name: doctor.name,
        email: doctor.email,
        specialization: doctor.specialization,
        licenseNumber: doctor.licenseNumber,
        status: doctor.status,
        phone: doctor.phone,
        experience: doctor.experience,
        about: doctor.about,
        departmentId: doctor.departmentId,
        departmentName: doctor.departmentName,
        certificateUrls: doctor.certificateUrls,
        consultationFee: doctor.consultationFee,
        profileImageUrl: doctor.profileImageUrl,
        languages: doctor.languages,
        qualifications: doctor.qualifications);

    await firestore
        .collection('doctors')
        .doc(doctor.id)
        .update({'profileImageUrl': doctor.profileImageUrl});
  }

  @override
  Future<String> uploadProfileImage(File file) async {
    final url = await CloudinaryService.uploadProfileImage(file);

    if (url == null) {
      throw Exception("Image upload failed");
    }

    return url;
  }

  @override
  Future<void> addAvailability({
    required String doctorId,
    required String date,
    required String time,
  }) async {
    final docRef = firestore.collection('doctors').doc(doctorId);

    final doc = await docRef.get();

    Map<String, dynamic> availability =
        Map<String, dynamic>.from(doc.data()?['availability'] ?? {});

    List<dynamic> slots = List<dynamic>.from(availability[date] ?? []);

    if (!slots.contains(time)) {
      slots.add(time);
    }

    availability[date] = slots;

    await docRef.update({
      'availability': availability,
    });
  }

  @override
  Future<List<Map<String, dynamic>>> getDoctorAppointments(
      String doctorId) async {
    final snapshot = await firestore
        .collection('appointments')
        .where(
          'doctorId',
          isEqualTo: doctorId,
        )
        .orderBy(
          'createdAt',
          descending: true,
        )
        .get();

    return snapshot.docs.map((doc) {
      return {
        'id': doc.id,
        ...doc.data(),
      };
    }).toList();
  }

  @override
  Future<void> updateAppointmentStatus({
    required String appointmentId,
    required String status,
  }) async {
    await firestore.collection('appointments').doc(appointmentId).update({
      'status': status,
    });
  }

  @override
  Future<Map<String, dynamic>> getUserDetails(String uid) async {
    print("Searching user: $uid");
    final doc = await firestore.collection('users').doc(uid).get();

     print("User found: ${doc.exists}");
  print("User data: ${doc.data()}");

    if (!doc.exists) {
      throw Exception("User not found");
    }

    return doc.data()!;
  }
}
