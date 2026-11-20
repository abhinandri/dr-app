import '../repositories/doctor_repository.dart';

class GetDoctorRevenue {
  final DoctorRepository repository;

  GetDoctorRevenue(this.repository);

  Future<List<Map<String, dynamic>>> call(String doctorId) {
    return repository.getDoctorAppointments(doctorId);
  }
}