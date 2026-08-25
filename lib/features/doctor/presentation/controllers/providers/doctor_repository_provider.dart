import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/repositories/doctor_repository_impl.dart';
import '../../../domain/repositories/doctor_repository.dart';

final doctorRepositoryProvider =
    Provider<DoctorRepository>((ref) {
  return DoctorRepositoryImpl(
    FirebaseFirestore.instance,
  );
});
