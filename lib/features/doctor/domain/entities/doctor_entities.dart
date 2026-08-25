import 'package:equatable/equatable.dart';

class DoctorEntity extends Equatable {
  final String id;
  final String name;
  final String email;
  final String specialization;
  final String licenseNumber;
  final String phone;
  final String experience;
  final String about;
  final String departmentId;
  final String departmentName;
  final List<String> certificateUrls;
  final String status;
  final double consultationFee;
  final List<dynamic> languages;
  final List<dynamic> qualifications;
  final String profileImageUrl;

  const DoctorEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.specialization,
    required this.licenseNumber,
    required this.status,
    required this.phone,
    required this.experience,
    required this.about,
    required this.departmentId,
    required this.departmentName,
    required this.certificateUrls,
    required this.consultationFee, 
    required this.profileImageUrl,
    required this.languages, 
    required this.qualifications,
    
  });

  @override
  List<Object?> get props => [id, email, status, consultationFee];
}
