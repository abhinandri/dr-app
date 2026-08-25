import '../entities/doctor_entities.dart';
import '../repositories/doctor_repository.dart';

class GetDoctorProfile {
  final DoctorRepository repository;

  GetDoctorProfile(this.repository);

  Future<DoctorEntity> call(String uid) {
    return repository.getDoctorById(uid);
  }
}
