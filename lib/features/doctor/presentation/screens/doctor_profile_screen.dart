
import 'package:dr_app/core/theme/app_colors.dart';
import 'package:dr_app/features/doctor/presentation/controllers/providers/profile_provider.dart';
import 'package:dr_app/features/doctor/presentation/screens/edit_doctor_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DoctorProfileScreen extends ConsumerStatefulWidget {
  const DoctorProfileScreen({super.key});

  @override
  ConsumerState<DoctorProfileScreen> createState() =>
      _DoctorProfileScreenState();
}

class _DoctorProfileScreenState extends ConsumerState<DoctorProfileScreen> {
  @override
  void initState() {
    super.initState();
    final uid = FirebaseAuth.instance.currentUser!.uid;
    Future.microtask(() {
      ref.read(profileNotifierProvider.notifier).loadProfile(uid);
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: profileState.when(
        loading: () => Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryStart),
          ),
        ),
        error: (e, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 80, color: AppColors.error),
              const SizedBox(height: 24),
              Text(
                "Oops! Something went wrong",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.heading,
                ),
              ),
              const SizedBox(height: 8),
              Text("$e", style: TextStyle(color: AppColors.subtext)),
            ],
          ),
        ),
        data: (doctor) => _buildProfile(doctor),
      ),
    );
  }

  Widget _buildProfile(doctor) {
    // Parse qualifications & languages safely
    final List<Map<String, dynamic>> qualifications =
        (doctor.qualifications as List?)
            ?.map((e) => Map<String, dynamic>.from(e))
            .toList() ??
        [];

    final List<String> languages =
        (doctor.languages as List?)?.map((e) => e.toString()).toList() ?? [];

    return Stack(
      children: [
        // Gradient Header
        Container(
          height: 320,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.primaryStart, AppColors.primaryEnd],
            ),
          ),
        ),

        // Curved white overlay
        Positioned(
          top: 280,
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
              // AppBar Row
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Profile",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                EditDoctorProfileScreen(doctor: doctor),
                          ),
                        );
                      },
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(Icons.edit,
                            color: AppColors.primaryStart, size: 20),
                      ),
                    ),
                  ],
                ),
              ),

              // Scrollable Content
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),

                      // Avatar
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
                              AppColors.primaryEnd
                            ]),
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            child: CircleAvatar(
                              radius: 55,
                              backgroundColor: AppColors.scaffoldBg,
                              backgroundImage: (doctor.profileImageUrl != null &&
                                      doctor.profileImageUrl.isNotEmpty)
                                  ? NetworkImage(doctor.profileImageUrl)
                                  : null,
                              child: (doctor.profileImageUrl == null ||
                                      doctor.profileImageUrl.isEmpty)
                                  ? ShaderMask(
                                      shaderCallback: (bounds) =>
                                          LinearGradient(colors: [
                                        AppColors.primaryStart,
                                        AppColors.primaryEnd
                                      ]).createShader(bounds),
                                      child: const Icon(Icons.person_rounded,
                                          size: 60, color: Colors.white),
                                    )
                                  : null,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Name
                      Padding(
                        padding: const EdgeInsets.only(top: 32.0),
                        child: Text(
                          doctor.name,
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: AppColors.heading,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Department badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [
                            AppColors.primaryStart.withOpacity(0.15),
                            AppColors.primaryEnd.withOpacity(0.15),
                          ]),
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                              color: AppColors.primaryStart.withOpacity(0.3),
                              width: 1.5),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.verified,
                                size: 18, color: AppColors.primaryStart),
                            const SizedBox(width: 8),
                            Text(
                              doctor.departmentName,
                              style: TextStyle(
                                color: AppColors.primaryStart,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // ── Languages chips (if any) ──
                      if (languages.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 8,
                          runSpacing: 6,
                          alignment: WrapAlignment.center,
                          children: languages
                              .map((lang) => Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 14, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                          color: AppColors.primaryStart
                                              .withOpacity(0.25)),
                                      boxShadow: [
                                        BoxShadow(
                                          color:
                                              Colors.black.withOpacity(0.04),
                                          blurRadius: 6,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.language,
                                            size: 14,
                                            color: AppColors.primaryStart),
                                        const SizedBox(width: 5),
                                        Text(
                                          lang,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: AppColors.heading,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ))
                              .toList(),
                        ),
                      ],

                      const SizedBox(height: 32),

                      // Stats Row
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            Expanded(
                              child: _buildStatCard(
                                icon: Icons.access_time_rounded,
                                title: "Experience",
                                value: doctor.experience,
                                gradient: [
                                  AppColors.primaryStart,
                                  AppColors.primaryEnd
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildStatCard(
                                icon: Icons.account_balance_wallet_rounded,
                                title: "Consultation",
                                value: "₹${doctor.consultationFee}",
                                gradient: [
                                  AppColors.primaryEnd,
                                  AppColors.primaryStart
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            // Contact Card
                            // _buildInfoCard(
                            //   icon: Icons.phone_rounded,
                            //   title: "Contact Information",
                            //   children: [
                            //     _buildInfoRow(
                            //       Icons.call_rounded,
                            //       "Phone Number",
                            //       doctor.phone,
                            //     ),
                            //   ],
                            // ),

                            const SizedBox(height: 16),

                            // About Card
                            _buildInfoCard(
                              icon: Icons.person_outline_rounded,
                              title: "About Doctor",
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: AppColors.scaffoldBg,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    doctor.about,
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: AppColors.subtext,
                                      height: 1.7,
                                      letterSpacing: 0.2,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            // ── Qualifications Card ──
                            if (qualifications.isNotEmpty) ...[
                              const SizedBox(height: 16),
                              _buildInfoCard(
                                icon: Icons.school_outlined,
                                title: "Qualifications",
                                children: qualifications
                                    .asMap()
                                    .entries
                                    .map((entry) => _buildQualificationRow(
                                        entry.key, entry.value))
                                    .toList(),
                              ),
                            ],
                          ],
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
    );
  }

  // ── Qualification Row ──
  Widget _buildQualificationRow(int index, Map<String, dynamic> q) {
    return Padding(
      padding: EdgeInsets.only(bottom: index == 0 ? 0 : 10, top: index == 0 ? 0 : 10),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.scaffoldBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
              color: AppColors.primaryStart.withOpacity(0.15), width: 1),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primaryStart, AppColors.primaryEnd],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  '${index + 1}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    q['degree'] ?? '',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: AppColors.heading,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${q['college'] ?? ''}  •  ${q['year'] ?? ''}',
                    style: TextStyle(fontSize: 13, color: AppColors.subtext),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Stat Card ──
  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required List<Color> gradient,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: gradient[0].withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: gradient),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: gradient[0].withOpacity(0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 26),
          ),
          const SizedBox(height: 14),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 13,
                color: AppColors.subtext,
                fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.heading),
          ),
        ],
      ),
    );
  }

  // ── Info Card ──
  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      AppColors.primaryStart.withOpacity(0.15),
                      AppColors.primaryEnd.withOpacity(0.15),
                    ]),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child:
                      Icon(icon, color: AppColors.primaryStart, size: 22),
                ),
                const SizedBox(width: 14),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: AppColors.heading,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }

  // ── Info Row ──
  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.scaffoldBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                  color: AppColors.primaryStart.withOpacity(0.2)),
            ),
            child:
                Icon(icon, size: 20, color: AppColors.primaryStart),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: TextStyle(
                        fontSize: 13,
                        color: AppColors.subtext,
                        fontWeight: FontWeight.w500)),
                const SizedBox(height: 4),
                Text(value,
                    style: TextStyle(
                        fontSize: 16,
                        color: AppColors.heading,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}