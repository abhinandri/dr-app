

import 'dart:io';
import 'package:dr_app/core/theme/app_colors.dart';
import 'package:dr_app/features/doctor/presentation/controllers/providers/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../domain/entities/doctor_entities.dart';

class EditDoctorProfileScreen extends ConsumerStatefulWidget {
  final DoctorEntity doctor;

  const EditDoctorProfileScreen({
    super.key,
    required this.doctor,
  });

  @override
  ConsumerState<EditDoctorProfileScreen> createState() =>
      _EditDoctorProfileScreenState();
}

class _EditDoctorProfileScreenState
    extends ConsumerState<EditDoctorProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController experienceController;
  late TextEditingController aboutController;
  late TextEditingController feeController;

  // ── New: Languages ──
  final List<String> _allLanguages = [
    'English', 'Hindi', 'Malayalam', 'Tamil',
    'Telugu', 'Kannada', 'Bengali', 'Marathi',
  ];
  late List<String> _selectedLanguages;

  // ── New: Qualifications ──
  late List<Map<String, String>> _qualifications;
  final _degreeController = TextEditingController();
  final _collegeController = TextEditingController();
  final _yearController = TextEditingController();

  File? selectedImage;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(text: widget.doctor.name);
    phoneController = TextEditingController(text: widget.doctor.phone);
    experienceController =
        TextEditingController(text: widget.doctor.experience);
    aboutController = TextEditingController(text: widget.doctor.about);
    feeController = TextEditingController(
        text: widget.doctor.consultationFee.toString());

    // Pre-fill languages from existing doctor data
    _selectedLanguages =
        (widget.doctor.languages as List?)
            ?.map((e) => e.toString())
            .toList() ??
        [];

    // Pre-fill qualifications from existing doctor data
    _qualifications =
        (widget.doctor.qualifications as List?)
            ?.map((e) => Map<String, String>.from(e))
            .toList() ??
        [];
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    experienceController.dispose();
    aboutController.dispose();
    feeController.dispose();
    _degreeController.dispose();
    _collegeController.dispose();
    _yearController.dispose();
    super.dispose();
  }

  // ── ALL ORIGINAL FUNCTIONS UNCHANGED ──

Future<void> pickImage() async {
  final picker = ImagePicker();

  final pickedImage = await picker.pickImage(
    source: ImageSource.gallery,
    imageQuality: 80,
  );

  if (pickedImage != null) {
    setState(() {
      selectedImage = File(pickedImage.path);
    });
  }
}

  Future<void> updateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isSaving = true);

    try {
      String imageUrl = widget.doctor.profileImageUrl;

      if (selectedImage != null) {
        imageUrl = await ref
            .read(profileNotifierProvider.notifier)
            .uploadProfileImage(selectedImage!);
      }

      final updatedDoctor = DoctorEntity(
        id: widget.doctor.id,
        name: nameController.text.trim(),
        email: widget.doctor.email,
        specialization: widget.doctor.specialization,
        licenseNumber: widget.doctor.licenseNumber,
        status: widget.doctor.status,
        phone: phoneController.text.trim(),
        experience: experienceController.text.trim(),
        about: aboutController.text.trim(),
        departmentId: widget.doctor.departmentId,
        departmentName: widget.doctor.departmentName,
        certificateUrls: widget.doctor.certificateUrls,
        consultationFee:
            double.tryParse(feeController.text.trim()) ?? 0,
        profileImageUrl: imageUrl,
        // ── New fields ──
        languages: _selectedLanguages,
        qualifications: _qualifications,
      );

      await ref
          .read(profileNotifierProvider.notifier)
          .updateProfile(updatedDoctor);

      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error: $e"),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => isSaving = false);
    }
  }

  // ── Add qualification to list ──
  void _addQualification() {
    if (_degreeController.text.isEmpty ||
        _collegeController.text.isEmpty ||
        _yearController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please fill all qualification fields'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    setState(() {
      _qualifications.add({
        'degree': _degreeController.text.trim(),
        'college': _collegeController.text.trim(),
        'year': _yearController.text.trim(),
      });
      _degreeController.clear();
      _collegeController.clear();
      _yearController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: Stack(
        children: [
          // Gradient Header
          Container(
            height: 280,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.primaryStart, AppColors.primaryEnd],
              ),
            ),
          ),

          // Curved overlay
          Positioned(
            top: 240,
            left: 0,
            right: 0,
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                color: AppColors.scaffoldBg,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // AppBar
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.25),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.arrow_back_ios_new,
                              color: Colors.white, size: 20),
                        ),
                      ),
                      const Text(
                        "Edit Profile",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Profile Avatar
                Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryEnd.withOpacity(0.3),
                            blurRadius: 30,
                            spreadRadius: 5,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(colors: [
                            AppColors.primaryStart,
                            AppColors.primaryEnd,
                          ]),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: Colors.white),
                          child: CircleAvatar(
                            radius: 55,
                            backgroundColor: AppColors.scaffoldBg,
                            backgroundImage: selectedImage != null
                                ? FileImage(selectedImage!)
                                : (widget.doctor.profileImageUrl.isNotEmpty
                                        ? NetworkImage(
                                            widget.doctor.profileImageUrl)
                                        : null)
                                    as ImageProvider?,
                            child: selectedImage == null &&
                                    widget.doctor.profileImageUrl.isEmpty
                                ? ShaderMask(
                                    shaderCallback: (bounds) =>
                                        LinearGradient(colors: [
                                      AppColors.primaryStart,
                                      AppColors.primaryEnd,
                                    ]).createShader(bounds),
                                    child: const Icon(Icons.person_rounded,
                                        size: 60, color: Colors.white),
                                  )
                                : null,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: pickImage,
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                              AppColors.primaryStart,
                              AppColors.primaryEnd,
                            ]),
                            shape: BoxShape.circle,
                            border:
                                Border.all(color: Colors.white, width: 3),
                            boxShadow: [
                              BoxShadow(
                                color:
                                    AppColors.primaryStart.withOpacity(0.4),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Icon(Icons.camera_alt_rounded,
                              size: 20, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // Form
                Expanded(
                  child: Form(
                    key: _formKey,
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      physics: const BouncingScrollPhysics(),
                      children: [
                        // ── Personal Information ──
                        _buildSectionTitle(
                            "Personal Information", Icons.person_outline_rounded),
                        const SizedBox(height: 16),

                        _buildField(
                          label: "Full Name",
                          controller: nameController,
                          icon: Icons.person_outline_rounded,
                          hint: "Enter your full name",
                        ),
                        const SizedBox(height: 16),
                        _buildField(
                          label: "Phone Number",
                          controller: phoneController,
                          icon: Icons.phone_outlined,
                          hint: "Enter your phone number",
                          keyboardType: TextInputType.phone,
                        ),
                        const SizedBox(height: 16),
                        _buildField(
                          label: "Experience",
                          controller: experienceController,
                          icon: Icons.work_outline_rounded,
                          hint: "e.g., 5 Years",
                        ),

                        const SizedBox(height: 28),

                        // ── Professional Details ──
                        _buildSectionTitle(
                            "Professional Details", Icons.medical_services_outlined),
                        const SizedBox(height: 16),

                        _buildField(
                          label: "Consultation Fee",
                          controller: feeController,
                          icon: Icons.currency_rupee_rounded,
                          hint: "Enter consultation fee",
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 16),
                        _buildField(
                          label: "About",
                          controller: aboutController,
                          icon: Icons.info_outline_rounded,
                          hint: "Write about yourself",
                          maxLines: 4,
                        ),

                        const SizedBox(height: 28),

                        // ── Languages ──
                        _buildSectionTitle(
                            "Languages Spoken", Icons.language_outlined),
                        const SizedBox(height: 12),
                        _buildLanguageChips(),

                        const SizedBox(height: 28),

                        // ── Qualifications ──
                        _buildSectionTitle(
                            "Qualifications", Icons.school_outlined),
                        const SizedBox(height: 12),

                        // Existing qualifications list
                        if (_qualifications.isNotEmpty) ...[
                          ..._qualifications.asMap().entries.map(
                                (entry) => _buildQualificationItem(
                                    entry.key, entry.value),
                              ),
                          const SizedBox(height: 12),
                        ],

                        // Add new qualification input card
                        Container(
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryStart
                                          .withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(Icons.add_circle_outline,
                                        color: AppColors.primaryStart,
                                        size: 16),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    "Add New Qualification",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                      color: AppColors.heading,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              _qualifInputField(
                                controller: _degreeController,
                                hint: 'Degree (e.g. MBBS, MD)',
                                icon: Icons.school_outlined,
                              ),
                              const SizedBox(height: 10),
                              _qualifInputField(
                                controller: _collegeController,
                                hint: 'College / University',
                                icon: Icons.account_balance_outlined,
                              ),
                              const SizedBox(height: 10),
                              _qualifInputField(
                                controller: _yearController,
                                hint: 'Passing Year (e.g. 2015)',
                                icon: Icons.calendar_today_outlined,
                                keyboardType: TextInputType.number,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Add qualification button
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: _addQualification,
                            icon: Icon(Icons.add_circle_outline,
                                color: AppColors.primaryStart),
                            label: Text(
                              'Add Qualification',
                              style: TextStyle(
                                color: AppColors.primaryStart,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 14),
                              side: BorderSide(color: AppColors.primaryStart),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14)),
                            ),
                          ),
                        ),

                        const SizedBox(height: 40),

                        // Save Button
                        Container(
                          height: 56,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                              AppColors.primaryStart,
                              AppColors.primaryEnd,
                            ]),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color:
                                    AppColors.primaryStart.withOpacity(0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: isSaving ? null : updateProfile,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16)),
                            ),
                            child: isSaving
                                ? const SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2.5),
                                  )
                                : const Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                          Icons
                                              .check_circle_outline_rounded,
                                          color: Colors.white,
                                          size: 22),
                                      SizedBox(width: 8),
                                      Text(
                                        "Save Changes",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),

                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // LANGUAGE CHIPS
  // ─────────────────────────────────────────────
  Widget _buildLanguageChips() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _allLanguages.map((lang) {
        final selected = _selectedLanguages.contains(lang);
        return GestureDetector(
          onTap: () {
            setState(() {
              selected
                  ? _selectedLanguages.remove(lang)
                  : _selectedLanguages.add(lang);
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
            decoration: BoxDecoration(
              gradient: selected
                  ? LinearGradient(
                      colors: [AppColors.primaryStart, AppColors.primaryEnd])
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
                      ? AppColors.primaryStart.withOpacity(0.3)
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
                fontWeight:
                    selected ? FontWeight.w600 : FontWeight.normal,
                fontSize: 13,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // ─────────────────────────────────────────────
  // QUALIFICATION ITEM (existing)
  // ─────────────────────────────────────────────
  Widget _buildQualificationItem(int index, Map<String, String> q) {
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
              offset: const Offset(0, 3)),
        ],
        border: Border.all(
            color: AppColors.primaryStart.withOpacity(0.15)),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [AppColors.primaryStart, AppColors.primaryEnd]),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                '${index + 1}',
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14),
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
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: AppColors.heading),
                ),
                const SizedBox(height: 2),
                Text(
                  '${q['college']}  •  ${q['year']}',
                  style:
                      TextStyle(fontSize: 12, color: AppColors.subtext),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () =>
                setState(() => _qualifications.removeAt(index)),
            child: const Icon(Icons.remove_circle_outline,
                color: Colors.redAccent, size: 20),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // QUALIFICATION INPUT FIELD
  // ─────────────────────────────────────────────
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
        prefixIcon: Icon(icon, color: AppColors.primaryStart, size: 20),
        filled: true,
        fillColor: AppColors.scaffoldBg,
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
  // SECTION TITLE
  // ─────────────────────────────────────────────
  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [AppColors.primaryStart, AppColors.primaryEnd]),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 10),
        Icon(icon, color: AppColors.primaryStart, size: 20),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: AppColors.heading,
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────
  // FORM FIELD
  // ─────────────────────────────────────────────
  Widget _buildField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required String hint,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 15,
              offset: const Offset(0, 4)),
        ],
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        style: TextStyle(
            fontSize: 15,
            color: AppColors.heading,
            fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          hintStyle: TextStyle(
              color: AppColors.subtext.withOpacity(0.5), fontSize: 14),
          labelStyle: TextStyle(
              color: AppColors.subtext,
              fontSize: 14,
              fontWeight: FontWeight.w500),
          prefixIcon: Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                AppColors.primaryStart.withOpacity(0.15),
                AppColors.primaryEnd.withOpacity(0.15),
              ]),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.primaryStart, size: 20),
          ),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide:
                BorderSide(color: AppColors.primaryStart, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: AppColors.error, width: 1.5),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: AppColors.error, width: 2),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(
              horizontal: 16, vertical: maxLines > 1 ? 16 : 18),
        ),
        validator: (value) => value == null || value.isEmpty
            ? "This field is required"
            : null,
      ),
    );
  }
}