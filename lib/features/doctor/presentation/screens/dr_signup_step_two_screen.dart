// import 'package:dr_app/features/doctor/presentation/controllers/providers/doctor_signup_form_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// import 'package:dr_app/features/doctor/presentation/controllers/notifiers/doctor_auth_controller.dart';
// import 'package:dr_app/features/doctor/presentation/screens/waiting_approval_screen.dart';

// class DoctorSignupStep2Screen extends ConsumerStatefulWidget {
//   const DoctorSignupStep2Screen({super.key});

//   @override
//   ConsumerState<DoctorSignupStep2Screen> createState() =>
//       _DoctorSignupStep2ScreenState();
// }

// class _DoctorSignupStep2ScreenState
//     extends ConsumerState<DoctorSignupStep2Screen> {

//   final feeController = TextEditingController();

//   final List<String> languages = [];
//   final List<Map<String, String>> qualifications = [];

//   final degreeController = TextEditingController();
//   final collegeController = TextEditingController();
//   final yearController = TextEditingController();

//   void addQualification() {

//     if (degreeController.text.isEmpty ||
//         collegeController.text.isEmpty ||
//         yearController.text.isEmpty) {
//       return;
//     }

//     qualifications.add({
//       "degree": degreeController.text,
//       "college": collegeController.text,
//       "year": yearController.text,
//     });

//     degreeController.clear();
//     collegeController.clear();
//     yearController.clear();

//     setState(() {});
//   }

//   void completeSignup() {

//     final signupData = ref.read(doctorSignupFormProvider);

//     ref.read(doctorAuthControllerProvider.notifier).signUp(
//       name: signupData.name!,
//       email: signupData.email!,
//       password: signupData.password!,
//       departmentId: signupData.departmentId!,
//       departmentName: signupData.departmentName!,
//       licenseNumber: signupData.licenseNumber!,
//       phone: signupData.phone!,
//       experience: signupData.experience!,
//       about: signupData.about!,
//       certificateUrls: signupData.certificateUrls,

//       consultationFee: double.tryParse(feeController.text) ?? 0,
//       languages: languages,
//       qualifications: qualifications,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {

//     final signupState = ref.watch(doctorAuthControllerProvider);

//     ref.listen(
//       doctorAuthControllerProvider,
//       (previous, next) {
//         next.whenOrNull(
//           data: (_) {
//             Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(
//                 builder: (_) => const WaitingApprovalScreen(),
//               ),
//             );
//           },
//           error: (e, _) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(content: Text(e.toString())),
//             );
//           },
//         );
//       },
//     );

//     return Scaffold(
//       appBar: AppBar(title: const Text("Professional Details")),
//       body: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           children: [

//             TextField(
//               controller: feeController,
//               keyboardType: TextInputType.number,
//               decoration: const InputDecoration(
//                 labelText: "Consultation Fee",
//                 prefixIcon: Icon(Icons.currency_rupee),
//               ),
//             ),

//             const SizedBox(height: 20),

//             const Align(
//               alignment: Alignment.centerLeft,
//               child: Text(
//                 "Languages",
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               ),
//             ),

//             Wrap(
//               spacing: 10,
//               children: ["English", "Malayalam", "Hindi"].map((lang) {

//                 final selected = languages.contains(lang);

//                 return ChoiceChip(
//                   label: Text(lang),
//                   selected: selected,
//                   onSelected: (value) {

//                     setState(() {

//                       if (selected) {
//                         languages.remove(lang);
//                       } else {
//                         languages.add(lang);
//                       }

//                     });
//                   },
//                 );

//               }).toList(),
//             ),

//             const SizedBox(height: 20),

//             const Align(
//               alignment: Alignment.centerLeft,
//               child: Text(
//                 "Add Qualification",
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               ),
//             ),

//             TextField(
//               controller: degreeController,
//               decoration: const InputDecoration(labelText: "Degree"),
//             ),

//             TextField(
//               controller: collegeController,
//               decoration: const InputDecoration(labelText: "College"),
//             ),

//             TextField(
//               controller: yearController,
//               keyboardType: TextInputType.number,
//               decoration: const InputDecoration(labelText: "Year"),
//             ),

//             const SizedBox(height: 10),

//             ElevatedButton(
//               onPressed: addQualification,
//               child: const Text("Add Qualification"),
//             ),

//             const SizedBox(height: 10),

//             Expanded(
//               child: ListView.builder(
//                 itemCount: qualifications.length,
//                 itemBuilder: (_, index) {

//                   final q = qualifications[index];

//                   return ListTile(
//                     title: Text(q["degree"] ?? ""),
//                     subtitle: Text(
//                       "${q["college"]} • ${q["year"]}",
//                     ),
//                   );
//                 },
//               ),
//             ),

//             SizedBox(
//               width: double.infinity,
//               height: 50,
//               child: ElevatedButton(
//                 onPressed: signupState.isLoading
//                     ? null
//                     : completeSignup,
//                 child: signupState.isLoading
//                     ? const CircularProgressIndicator()
//                     : const Text("Complete Signup"),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:dr_app/features/doctor/presentation/controllers/providers/doctor_signup_form_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:dr_app/features/doctor/presentation/controllers/notifiers/doctor_auth_controller.dart';
import 'package:dr_app/features/doctor/presentation/screens/waiting_approval_screen.dart';

class DoctorSignupStep2Screen extends ConsumerStatefulWidget {
  const DoctorSignupStep2Screen({super.key});

  @override
  ConsumerState<DoctorSignupStep2Screen> createState() =>
      _DoctorSignupStep2ScreenState();
}

class _DoctorSignupStep2ScreenState
    extends ConsumerState<DoctorSignupStep2Screen> {

  final feeController = TextEditingController();
  final List<String> languages = [];
  final List<Map<String, String>> qualifications = [];

  final degreeController = TextEditingController();
  final collegeController = TextEditingController();
  final yearController = TextEditingController();

  // ── ALL ORIGINAL FUNCTIONS UNCHANGED ──

  void addQualification() {
    if (degreeController.text.isEmpty ||
        collegeController.text.isEmpty ||
        yearController.text.isEmpty) {
      return;
    }

    qualifications.add({
      "degree": degreeController.text,
      "college": collegeController.text,
      "year": yearController.text,
    });

    degreeController.clear();
    collegeController.clear();
    yearController.clear();

    setState(() {});
  }

  void completeSignup() {
    final signupData = ref.read(doctorSignupFormProvider);

    ref.read(doctorAuthControllerProvider.notifier).signUp(
          name: signupData.name!,
          email: signupData.email!,
          password: signupData.password!,
          departmentId: signupData.departmentId!,
          departmentName: signupData.departmentName!,
          licenseNumber: signupData.licenseNumber!,
          phone: signupData.phone!,
          experience: signupData.experience!,
          about: signupData.about!,
          certificateUrls: signupData.certificateUrls,
          profileImageUrl:signupData.profileImageUrl ??'',
          consultationFee: double.tryParse(feeController.text) ?? 0,
          languages: languages,
          qualifications: qualifications,
        );
  }

  // ── UI HELPER ──
  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFFE63946),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final signupState = ref.watch(doctorAuthControllerProvider);

    ref.listen(doctorAuthControllerProvider, (previous, next) {
      next.whenOrNull(
        data: (_) => Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const WaitingApprovalScreen()),
        ),
        error: (e, _) => _showSnack(e.toString()),
      );
    });

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),

              // ── Header ──
              _buildHeader(),

              const SizedBox(height: 32),

              // ── Consultation Fee ──
              _sectionLabel('Consultation Fee', Icons.currency_rupee),
              const SizedBox(height: 10),
              _buildFeeField(),

              const SizedBox(height: 28),

              // ── Languages ──
              _sectionLabel('Languages Spoken', Icons.language_outlined),
              const SizedBox(height: 10),
              _buildLanguageChips(),

              const SizedBox(height: 28),

              // ── Qualifications Input ──
              _sectionLabel('Add Qualification', Icons.school_outlined),
              const SizedBox(height: 10),
              _buildQualificationInputCard(),

              const SizedBox(height: 12),

              // Add Qualification Button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: addQualification,
                  icon: const Icon(Icons.add_circle_outline,
                      color: Color(0xFF667EEA)),
                  label: const Text(
                    'Add Qualification',
                    style: TextStyle(
                      color: Color(0xFF667EEA),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: const BorderSide(color: Color(0xFF667EEA)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),

              // ── Added Qualifications List ──
              if (qualifications.isNotEmpty) ...[
                const SizedBox(height: 20),
                _sectionLabel(
                  'Added Qualifications (${qualifications.length})',
                  Icons.verified_outlined,
                ),
                const SizedBox(height: 10),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: qualifications.length,
                  itemBuilder: (_, index) =>
                      _qualificationChip(index, qualifications[index]),
                ),
              ],

              const SizedBox(height: 32),

              // ── Complete Signup Button ──
              _buildSubmitButton(signupState),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // HEADER with Step Indicator
  // ─────────────────────────────────────────────
  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Step indicator row
        Row(
          children: [
            _miniStep('1', isDone: true),
            Expanded(
              child: Container(
                height: 2,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                  ),
                ),
              ),
            ),
            _miniStep('2', isDone: false),
          ],
        ),
        const SizedBox(height: 20),

        const Text(
          'Professional',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A1F36),
            letterSpacing: -1,
            height: 1.2,
          ),
        ),
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
          ).createShader(bounds),
          child: const Text(
            'Details',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: -1,
              height: 1.2,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Almost there! Fill in your professional info',
          style: TextStyle(
            fontSize: 15,
            color: Colors.grey[600],
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _miniStep(String label, {required bool isDone}) {
    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF667EEA).withOpacity(0.4),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: isDone
                ? const Icon(Icons.check, color: Colors.white, size: 16)
                : Text(
                    label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label == '1' ? 'Identity' : 'Profile',
          style: const TextStyle(
            fontSize: 10,
            color: Color(0xFF667EEA),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────
  // CONSULTATION FEE FIELD
  // ─────────────────────────────────────────────
  Widget _buildFeeField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: feeController,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          hintText: 'Enter amount (e.g. 500)',
          hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
          prefixIcon: Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF667EEA).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.currency_rupee,
                color: Color(0xFF667EEA), size: 18),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // LANGUAGE CHIPS
  // ─────────────────────────────────────────────
  Widget _buildLanguageChips() {
    final allLanguages = [
      'English', 'Malayalam', 'Hindi',
      'Tamil', 'Telugu', 'Kannada', 'Bengali', 'Marathi',
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: allLanguages.map((lang) {
        final selected = languages.contains(lang);
        return GestureDetector(
          onTap: () {
            setState(() {
              selected ? languages.remove(lang) : languages.add(lang);
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
            decoration: BoxDecoration(
              gradient: selected
                  ? const LinearGradient(
                      colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                    )
                  : null,
              color: selected ? null : Colors.white,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: selected
                    ? Colors.transparent
                    : Colors.grey.shade300,
              ),
              boxShadow: [
                BoxShadow(
                  color: selected
                      ? const Color(0xFF667EEA).withOpacity(0.3)
                      : Colors.black.withOpacity(0.04),
                  blurRadius: selected ? 8 : 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Text(
              lang,
              style: TextStyle(
                color: selected ? Colors.white : Colors.grey[700],
                fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                fontSize: 13,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // ─────────────────────────────────────────────
  // QUALIFICATION INPUT CARD
  // ─────────────────────────────────────────────
  Widget _buildQualificationInputCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        children: [
          _qualifInputField(
            controller: degreeController,
            hint: 'Degree (e.g. MBBS, MD)',
            icon: Icons.school_outlined,
          ),
          const SizedBox(height: 10),
          _qualifInputField(
            controller: collegeController,
            hint: 'College / University',
            icon: Icons.account_balance_outlined,
          ),
          const SizedBox(height: 10),
          _qualifInputField(
            controller: yearController,
            hint: 'Passing Year (e.g. 2015)',
            icon: Icons.calendar_today_outlined,
            keyboardType: TextInputType.number,
          ),
        ],
      ),
    );
  }

  Widget _qualifInputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey[400], fontSize: 13),
        prefixIcon: Icon(icon, color: const Color(0xFF667EEA), size: 20),
        filled: true,
        fillColor: const Color(0xFFF8F9FA),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // QUALIFICATION LIST ITEM
  // ─────────────────────────────────────────────
  Widget _qualificationChip(int index, Map<String, String> q) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border.all(
            color: const Color(0xFF667EEA).withOpacity(0.15)),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                '${index + 1}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  q['degree'] ?? '',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: Color(0xFF1A1F36),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${q['college']}  •  ${q['year']}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => setState(() => qualifications.removeAt(index)),
            child: const Icon(Icons.remove_circle_outline,
                color: Colors.redAccent, size: 20),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // SUBMIT BUTTON
  // ─────────────────────────────────────────────
  Widget _buildSubmitButton(AsyncValue<void> signupState) {
    return SizedBox(
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
          onPressed: signupState.isLoading ? null : completeSignup,
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
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : const Text(
                  'Complete Signup',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // SECTION LABEL
  // ─────────────────────────────────────────────
  Widget _sectionLabel(String label, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: const Color(0xFF667EEA).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: const Color(0xFF667EEA), size: 18),
        ),
        const SizedBox(width: 10),
        Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A1F36),
          ),
        ),
      ],
    );
  }
}