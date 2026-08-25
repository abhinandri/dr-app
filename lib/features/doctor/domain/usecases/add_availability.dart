import 'package:dr_app/features/doctor/domain/repositories/doctor_repository.dart';

class AddAvailability {
  final DoctorRepository repository;

  AddAvailability(this.repository);

  Future<void> call({
    required String doctorId,
    required String date,
    required String time,
  }) {
    return repository.addAvailability(
      doctorId: doctorId,
      date: date,
      time: time,
    );
  }
}
