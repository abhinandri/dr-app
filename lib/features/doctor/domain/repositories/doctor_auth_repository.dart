
import 'package:dr_app/features/doctor/presentation/controllers/notifiers/splash_controller.dart';

abstract class DoctorAuthRepository {
  Future<void> signUpDoctor({
    required String name,
    required String email,
    required String password,
    required String licenseNumber,
    required String phone,
    required String experience,
    required String about,
    required String departmentId,
    required String departmentName,
    required List<String> certificateUrls,
    
    required double consultationFee,
    required List<String>languages,
    required List<Map<String,String>>qualifications, required String profileImageUrl,

    
  });

  Future<void> loginDoctor({
    required String email,
    required String password,
  });
  Future<void> logoutDoctor();

   /// Determines initial navigation based on auth & approval status.
  Future<SplashRoute> getInitialRoute();

  // Future<String> getDoctorStatus(String uid);
   Stream<String> watchDoctorStatus(String uid);

  
}
