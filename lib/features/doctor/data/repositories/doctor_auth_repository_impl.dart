
import 'package:dr_app/core/services/notification_service.dart';
import 'package:dr_app/features/doctor/presentation/controllers/notifiers/splash_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../../domain/repositories/doctor_auth_repository.dart';

class DoctorAuthRepositoryImpl implements DoctorAuthRepository {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;
  DoctorAuthRepositoryImpl({
    required this.firebaseAuth,
    required this.firestore,
  });

  @override
  Future<SplashRoute> getInitialRoute() async {

    // Step 1: Check authentication
    final user = firebaseAuth.currentUser;

    if (user == null) {
      return SplashRoute.login;
    }

    // Step 2: Fetch doctor profile
    final doctorDoc = await firestore.collection('doctors').doc(user.uid).get();

    // Safety: Auth user exists but Firestore document missing
    if (!doctorDoc.exists) {
      await firebaseAuth.signOut();
      return SplashRoute.login;
    }

    // Step 3: Read approval status
    final status = doctorDoc.data()?['status'] ?? 'pending';

    switch (status) {
      case 'approved':
        return SplashRoute.dashboard;
      case 'pending':
        return SplashRoute.waiting;
      default:
        return SplashRoute.rejected;
    }
  }

  @override
  Future<void> signUpDoctor(
    {
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
      required String profileImageUrl,

      required double consultationFee,
      required List<String>languages,
      required List<Map<String,String>>qualifications
      }) async {
    // 1️⃣ Create Auth User
    final userCredential = await firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final uid = userCredential.user!.uid;


    await firestore.collection('doctors').doc(uid).set({
      'id': uid,
      'name': name,
      'email': email,
      'licenseNumber': licenseNumber,
      'phone': phone,
      'experience': experience,
      'about': about,
      'departmentId': departmentId,
      'departmentName': departmentName,
      'certificateUrls': certificateUrls,

      'consultationFee':consultationFee,
      'languages': languages,
      'qualifications': qualifications,



      'profileImageUrl':profileImageUrl,
      'status': 'pending',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> loginDoctor({
    required String email,
    required String password,
  }) async {
    // 1️⃣ Firebase Auth login
    final credential = await firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final uid = credential.user!.uid;

    // 2️⃣ Fetch doctor document
    final doctorDoc = await firestore.collection('doctors').doc(uid).get();

    // Safety check
    if (!doctorDoc.exists) {
      await firebaseAuth.signOut();
      throw Exception('Doctor profile not found');
    }

    final status = doctorDoc['status'];

    // 3️⃣ Block login if not approved
    if (status != 'approved') {
      await firebaseAuth.signOut();

      if (status == 'pending') {
        throw Exception('Your account is waiting for admin approval');
      } else {
        throw Exception('Your account has been rejected');
      }
    }

    // ✅ Only approved doctors reach here

    final token = await FirebaseMessaging.instance.getToken();

if (token != null) {
  await NotificationService.saveToken(token);
}
  }

  @override
  Future<void> logoutDoctor() async => firebaseAuth.signOut();

  @override
  Stream<String> watchDoctorStatus(String uid) {
    return firestore.collection('doctors').doc(uid).snapshots().map((doc) {
      if (!doc.exists) return 'pending';
      return doc.data()?['status'] ?? 'pending';
    });
  }
}
