

import 'package:dr_app/features/doctor/domain/entities/doctor_entities.dart';

class DoctorModel extends DoctorEntity {
  const DoctorModel({
    required super.id,
    required super.name,
    required super.email,
    required super.specialization,
    required super.licenseNumber,
    required super.phone,
    required super.experience,
    required super.about,
    required super.departmentId,
    required super.departmentName,
    required super.certificateUrls,
    required super.status,
    required super.consultationFee, 
    required super.profileImageUrl, 
    
    required super.languages, required super.qualifications,
  
  });


    //used for data uploade to firebase
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'specialization': specialization, 
      'licenseNumber': licenseNumber,
      'phone': phone,
      'experience': experience,
      'about': about,
      'departmentId': departmentId,
      'departmentName': departmentName,
      'certificateUrls': certificateUrls,
      'status': status,
      'consultationFee': consultationFee,

      'languages':languages,
      'qualifications':qualifications,


      'profileImageUrl':profileImageUrl
    };
  }

    //used for retrieve data from hte firebase
  factory DoctorModel.fromMap(Map<String, dynamic> map) {
    return DoctorModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      specialization: map['specialization'] ?? '',
      licenseNumber: map['licenseNumber'] ?? '',
       phone: map['phone'] ?? '',
      experience: map['experience'] ?? '',
      about: map['about'] ?? '',
      departmentId: map['departmentId'] ?? '',
      departmentName: map['departmentName'] ?? '',
      certificateUrls: List<String>.from(map['certificateUrls'] ?? []),
      status: map['status'] ?? 'pending',

      consultationFee:
          (map['consultationFee'] ?? 0).toDouble(),

      languages: List<String>.from(map['languages'] ?? []),
      qualifications: List<Map<String, dynamic>>.from(
  map['qualifications'] ?? [],
),

      profileImageUrl: map['profileImageUrl']??'',

    );
  }
}
