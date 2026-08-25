import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dr_app/core/services/cloudinary_service.dart';
import 'package:dr_app/core/theme/app_colors.dart';
import 'package:dr_app/core/utils/validators_login_signup.dart';
import 'package:dr_app/features/doctor/presentation/controllers/notifiers/doctor_auth_controller.dart';
import 'package:dr_app/features/doctor/presentation/controllers/providers/doctor_signup_form_provider.dart';
import 'package:dr_app/features/doctor/presentation/screens/dr_signup_step_two_screen.dart';
import 'package:dr_app/features/doctor/presentation/screens/login_screen.dart';
import 'package:dr_app/features/doctor/presentation/screens/waiting_approval_screen.dart';
import 'package:dr_app/features/doctor/presentation/widgets/custome_dropdown_field.dart';
import 'package:dr_app/features/doctor/presentation/widgets/custome_text_field_signup_screen.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DoctorSignupScreen extends ConsumerStatefulWidget {
  const DoctorSignupScreen({super.key});

  @override
  ConsumerState<DoctorSignupScreen> createState() => _DoctorSignupScreenState();
}

class _DoctorSignupScreenState extends ConsumerState<DoctorSignupScreen> {
  final _formKey = GlobalKey<FormState>();

  List<PlatformFile> certificateFiles = [];
  File? profileImage;
  String? selectedDepartmentId;
  String? selectedDepartmentName;

  late final TextEditingController nameController;
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  late final TextEditingController specializationController;
  late final TextEditingController licenseController;
  late final TextEditingController phoneController;
  late final TextEditingController experienceController;
  late final TextEditingController aboutController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    specializationController = TextEditingController();
    licenseController = TextEditingController();
    phoneController = TextEditingController();
    experienceController = TextEditingController();
    aboutController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    specializationController.dispose();
    licenseController.dispose();
    phoneController.dispose();
    experienceController.dispose();
    aboutController.dispose();
    super.dispose();
  }

  Future<void> pickProfileImage() async {
    final picker = ImagePicker();

    final image = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (image != null) {
      setState(() {
        profileImage = File(image.path);
      });
    }
  }

  Future<void> pickCertificate() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      withData: true, // ✅ THIS IS THE KEY
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'png', 'jpeg'],
    );

    if (result != null) {
      setState(() {
        certificateFiles = result.files;
      });
    }
  }

  Future<void> handleNext() async {

    if (profileImage == null) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text("Please upload profile image"),
    ),
  );

  return;
}






    if (certificateFiles.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please upload certificate')),
      );
      return;
    }

    List<String> certificateUrls = [];

    for (final file in certificateFiles) {
      final url = await CloudinaryService.uploadCertificate(file);
      if (url != null) {
        certificateUrls.add(url);
      }
    }

    if (selectedDepartmentId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select department')),
      );
      return;
    }

    if (certificateUrls.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Certificate upload failed')),
      );
      return;
    }

    String? imageUrl;
    if (profileImage != null) {
      imageUrl = await CloudinaryService.uploadProfileImage(profileImage!);
    }

    // SAVE STEP1 DATA TO PROVIDER
    ref.read(doctorSignupFormProvider.notifier).setBasicInfo(
          name: nameController.text.trim(),
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
          profileImageUrl: imageUrl ?? '',
          departmentId: selectedDepartmentId!,
          departmentName: selectedDepartmentName!,
          license: licenseController.text.trim(),
          phone: phoneController.text.trim(),
          experience: experienceController.text.trim(),
          about: aboutController.text.trim(),
          certificates: certificateUrls,
        );

    // NAVIGATE TO STEP 2
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const DoctorSignupStep2Screen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final signupState = ref.watch(doctorAuthControllerProvider);

    ref.listen<AsyncValue<void>>(
      doctorAuthControllerProvider,
      (previous, next) {
        next.whenOrNull(
          data: (_) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const WaitingApprovalScreen(),
              ),
            );
          },
          error: (e, _) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(e.toString()),
                behavior: SnackBarBehavior.floating,
                backgroundColor: const Color(0xFFE63946),
              ),
            );
          },
        );
      },
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 60),
                // Header Section
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Create Account,',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1F36),
                        letterSpacing: -1,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                      ).createShader(bounds),
                      child: const Text(
                        'Doctor',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: -1,
                          height: 1.2,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Join our healthcare network today',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                // Form Section
                Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    children: [
                      AppTextFormField(
                          controller: nameController,
                          label: 'Full Name',
                          icon: Icons.person_outline_rounded,
                          validator: (v) => Validators.required(v,
                              message: 'Enter full name')),
                      AppTextFormField(
                        controller: emailController,
                        label: 'Email Address',
                        icon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        validator: Validators.email,
                      ),
                      AppTextFormField(
                        controller: passwordController,
                        label: 'Password',
                        icon: Icons.lock_outline_rounded,
                        obscureText: true,
                        validator: Validators.password,
                      ),
                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('departments')
                            .where('isActive', isEqualTo: true)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const SizedBox(height: 60);
                          }

                          final docs = snapshot.data!.docs;

                          return AppDropdownFormField<String>(
                            value: selectedDepartmentId,
                            label: 'Department',
                            icon: Icons.local_hospital_outlined,
                            items: docs.map((doc) {
                              final data = doc.data() as Map<String, dynamic>;
                              return DropdownMenuItem<String>(
                                value: doc.id,
                                child: Text(data['name']),
                              );
                            }).toList(),
                            onChanged: (value) {
                              final doc = docs.firstWhere((e) => e.id == value);
                              final data = doc.data() as Map<String, dynamic>;

                              setState(() {
                                selectedDepartmentId = value;
                                selectedDepartmentName = data['name'];
                              });
                            },
                            validator: (value) => value == null
                                ? 'Please select department'
                                : null,
                          );
                        },
                      ),

                      AppTextFormField(
                        controller: licenseController,
                        label: 'License Number',
                        icon: Icons.badge_outlined,
                        validator: (v) => Validators.required(v,
                            message: 'License number required'),
                      ),
                      AppTextFormField(
                        controller: phoneController,
                        label: 'Phone Number',
                        icon: Icons.phone_outlined,
                        keyboardType: TextInputType.phone,
                        validator: (v) =>
                            Validators.required(v, message: 'Phone required'),
                      ),

                      AppTextFormField(
                        controller: experienceController,
                        label: 'Experience (e.g. 5 years)',
                        icon: Icons.timeline_outlined,
                        validator: (v) => Validators.required(v,
                            message: 'Experience required'),
                      ),

                      AppTextFormField(
                        controller: aboutController,
                        label: 'About',
                        icon: Icons.info_outline,
                        // maxLines: 3,
                        validator: (v) =>
                            Validators.required(v, message: 'About required'),
                      ),

                      const SizedBox(height: 12),

                      GestureDetector(
                        onTap: pickProfileImage,
                        child: Container(
                          height: 120,
                          width: 120,
                          child: profileImage == null
                              ? const Icon(
                                  Icons.add_a_photo,
                                )
                              : ClipOval(
                                  child: Image.file(
                                    profileImage!,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                      ),

                      InkWell(
                        onTap: pickCertificate,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                            border: Border.all(color: AppColors.primaryStart),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.upload_file,
                                  color: AppColors.primaryStart),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  certificateFiles.isEmpty
                                      ? 'Upload Certificates (PDF / Images)'
                                      : '${certificateFiles.length} files selected',
                                  style: TextStyle(
                                    color: certificateFiles.isEmpty
                                        ? Colors.grey[600]
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Sign Up Button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF667EEA).withOpacity(0.4),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: signupState.isLoading
                                ? null
                                : () {
                                    if (_formKey.currentState!.validate()) {
                                      // handleSignup();
                                      // Navigator.push(
                                      //     context,
                                      //     MaterialPageRoute(
                                      //         builder: (context) =>
                                      //             DoctorSignupStep2Screen()));
                                      handleNext();
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: signupState.isLoading
                                ? const SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                : const Text(
                                    'Next',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Login Link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already have an account? ',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey[600],
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (ctx) => const DoctorLoginScreen(),
                                ),
                              );
                            },
                            style: TextButton.styleFrom(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: const Text(
                              'Login',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primaryStart,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
