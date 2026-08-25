import '../entities/doctor_entities.dart';
import '../repositories/doctor_repository.dart';

class UpdateDoctorProfile {
  final DoctorRepository repository;

  UpdateDoctorProfile(this.repository);

  Future<void> call(DoctorEntity doctor) {
    return repository.updateDoctorProfile(doctor);
  }
}
