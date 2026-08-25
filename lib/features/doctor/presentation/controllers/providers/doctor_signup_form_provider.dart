import 'package:flutter_riverpod/flutter_riverpod.dart';

class DoctorSignupFormState {
  String? name;
  String? email;
  String? password;
  String? profileImageUrl;
  String? departmentId;
  String? departmentName;
  String? licenseNumber;
  String? phone;
  String? experience;
  String? about;
  List<String> certificateUrls = [];

  double consultationFee = 0;
  List<String> languages = [];
  List<Map<String, String>> qualifications = [];

  DoctorSignupFormState();
}

class DoctorSignupFormNotifier extends StateNotifier<DoctorSignupFormState> {
  DoctorSignupFormNotifier() : super(DoctorSignupFormState());

  void setBasicInfo({
    required String name,
    required String email,
    required String password,
    required String profileImageUrl,
    required String departmentId,
    required String departmentName,
    required String license,
    required String phone,
    required String experience,
    required String about,
    required List<String> certificates,
  }) {
    state.name = name;
    state.email = email;
    state.password = password;
    state.profileImageUrl = profileImageUrl;
    state.departmentId = departmentId;
    state.departmentName = departmentName;
    state.licenseNumber = license;
    state.phone = phone;
    state.experience = experience;
    state.about = about;
    state.certificateUrls = certificates;

    state = state;
  }

  void setProfessionalInfo({
    required double fee,
    required List<String> languages,
    required List<Map<String, String>> qualifications,
  }) {
    state.consultationFee = fee;
    state.languages = languages;
    state.qualifications = qualifications;

    state = state;
  }
}

final doctorSignupFormProvider =
    StateNotifierProvider<DoctorSignupFormNotifier, DoctorSignupFormState>(
  (ref) => DoctorSignupFormNotifier(),
);
