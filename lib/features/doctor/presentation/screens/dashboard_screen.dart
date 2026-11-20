// // import 'package:dr_app/features/doctor/presentation/screens/login_screen.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // import 'package:dr_app/features/doctor/presentation/controllers/doctor_auth_controller.dart';

// // class DashboardScreen extends ConsumerWidget {
// //   const DashboardScreen({super.key});

// //   @override
// //   Widget build(BuildContext context, WidgetRef ref) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text('Dashboard'),
// //         backgroundColor: Colors.teal,
// //       ),
// //       body: Center(
// //         child: Column(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: [
// //             const Text(
// //               'Dashboard',
// //               style: TextStyle(fontSize: 20),
// //             ),
// //             const SizedBox(height: 20),

// //             ElevatedButton(
// //   onPressed: () async {
// //     await ref
// //         .read(doctorAuthControllerProvider.notifier)
// //         .logout();

// //     if (!context.mounted) return;

// //     Navigator.pushAndRemoveUntil(
// //       context,
// //       MaterialPageRoute(
// //         builder: (_) => const DoctorLoginScreen(),
// //       ),
// //       (_) => false,
// //     );
// //   },
// //   child: const Text('Logout'),
// // ),

// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
// import 'package:dr_app/features/doctor/presentation/screens/login_screen.dart';
// import 'package:dr_app/features/doctor/presentation/screens/revenue_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:dr_app/features/doctor/presentation/controllers/notifiers/doctor_auth_controller.dart';

// class DashboardScreen extends ConsumerWidget {
//   const DashboardScreen({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF8F9FA),
//       body: SafeArea(
//         child: CustomScrollView(
//           slivers: [
//             // Custom App Bar
//             // SliverAppBar(
//             //   expandedHeight: 120,
//             //   floating: false,
//             //   pinned: true,
//             //   backgroundColor: Colors.transparent,
//             //   elevation: 0,
//             //   flexibleSpace: FlexibleSpaceBar(
//             //     background: Container(
//             //       decoration: const BoxDecoration(
//             //         gradient: LinearGradient(
//             //           colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
//             //           begin: Alignment.topLeft,
//             //           end: Alignment.bottomRight,
//             //         ),
//             //       ),
//             //     ),
//             //     title: const Text(
//             //       'Dashboard',
//             //       style: TextStyle(
//             //         color: Colors.white,
//             //         fontWeight: FontWeight.bold,
//             //         fontSize: 20,
//             //       ),
//             //     ),
//             //     centerTitle: false,
//             //     titlePadding: const EdgeInsets.only(left: 24, bottom: 16),
//             //   ),
//             //   actions: [
//             //     Padding(
//             //       padding: const EdgeInsets.only(right: 16.0),
//             //       child: Container(
//             //         decoration: BoxDecoration(
//             //           color: Colors.white.withOpacity(0.2),
//             //           borderRadius: BorderRadius.circular(12),
//             //         ),
//             //         child: IconButton(
//             //           icon: const Icon(Icons.notifications_outlined),
//             //           color: Colors.white,
//             //           onPressed: () {},
//             //         ),
//             //       ),
//             //     ),
//             //   ],
//             // ),
//             // Content
//             SliverToBoxAdapter(
//               child: Padding(
//                 padding: const EdgeInsets.all(24.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Welcome Card
//                     Container(
//                       padding: const EdgeInsets.all(24),
//                       decoration: BoxDecoration(
//                         gradient: const LinearGradient(
//                           colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
//                           begin: Alignment.topLeft,
//                           end: Alignment.bottomRight,
//                         ),
//                         borderRadius: BorderRadius.circular(20),
//                         boxShadow: [
//                           BoxShadow(
//                             color: const Color(0xFF667EEA).withOpacity(0.3),
//                             blurRadius: 20,
//                             offset: const Offset(0, 10),
//                           ),
//                         ],
//                       ),
//                       child: Row(
//                         children: [
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   'Welcome Back,',
//                                   style: TextStyle(
//                                     fontSize: 16,
//                                     color: Colors.white.withOpacity(0.9),
//                                     fontWeight: FontWeight.w400,
//                                   ),
//                                 ),
//                                 const SizedBox(height: 8),
//                                 const Text(
//                                   'Doctor',
//                                   style: TextStyle(
//                                     fontSize: 28,
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.white,
//                                     letterSpacing: -0.5,
//                                   ),
//                                 ),
//                                 const SizedBox(height: 12),
//                                 Container(
//                                   padding: const EdgeInsets.symmetric(
//                                     horizontal: 12,
//                                     vertical: 6,
//                                   ),
//                                   decoration: BoxDecoration(
//                                     color: Colors.white.withOpacity(0.2),
//                                     borderRadius: BorderRadius.circular(20),
//                                   ),
//                                   child: const Row(
//                                     mainAxisSize: MainAxisSize.min,
//                                     children: [
//                                       Icon(
//                                         Icons.verified_rounded,
//                                         color: Colors.white,
//                                         size: 16,
//                                       ),
//                                       SizedBox(width: 6),
//                                       Text(
//                                         'Verified',
//                                         style: TextStyle(
//                                           color: Colors.white,
//                                           fontSize: 13,
//                                           fontWeight: FontWeight.w600,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           Container(
//                             padding: const EdgeInsets.all(16),
//                             decoration: BoxDecoration(
//                               color: Colors.white.withOpacity(0.2),
//                               shape: BoxShape.circle,
//                             ),
//                             child: const Icon(
//                               Icons.medical_services_rounded,
//                               size: 40,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(height: 32),
//                     // Stats Grid
//                     const Text(
//                       'Overview',
//                       style: TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                         color: Color(0xFF1A1F36),
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     Row(
//                       children: [
//                         Expanded(
//                           child: _buildStatCard(
//                             icon: Icons.people_outline_rounded,
//                             label: 'Patients',
//                             value: '0',
//                             color: const Color(0xFF667EEA),
//                           ),
//                         ),
//                         const SizedBox(width: 16),
//                         Expanded(
//                           child: InkWell(
//                             onTap: () {
//                               Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                       builder: (context) => RevenueScreen()));
//                             },
//                             child: _buildStatCard(
//                               icon: Icons.account_balance_wallet,
//                               label: 'Revenue',
//                               value: '0',
//                               color: const Color(0xFFFFA726),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 32),
//                     // Quick Actions
//                     const Text(
//                       'Quick Actions',
//                       style: TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                         color: Color(0xFF1A1F36),
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     _buildActionCard(
//                       icon: Icons.schedule_rounded,
//                       title: 'View Schedule',
//                       subtitle: 'Check your upcoming appointments',
//                       onTap: () {},
//                     ),
//                     const SizedBox(height: 12),
//                     _buildActionCard(
//                       icon: Icons.person_outline_rounded,
//                       title: 'Patient Records',
//                       subtitle: 'Access patient information',
//                       onTap: () {},
//                     ),
//                     const SizedBox(height: 12),
//                     _buildActionCard(
//                       icon: Icons.settings_outlined,
//                       title: 'Settings',
//                       subtitle: 'Manage your account',
//                       onTap: () {},
//                     ),
//                     const SizedBox(height: 32),
//                     // Logout Button
//                     SizedBox(
//                       width: double.infinity,
//                       height: 56,
//                       child: OutlinedButton(
//                         onPressed: () {
//                           _showLogoutDialog(context, ref);
//                         },
//                         style: OutlinedButton.styleFrom(
//                           side: const BorderSide(
//                             color: Color(0xFFE63946),
//                             width: 2,
//                           ),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(16),
//                           ),
//                         ),
//                         child: const Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Icon(
//                               Icons.logout_rounded,
//                               color: Color(0xFFE63946),
//                               size: 20,
//                             ),
//                             SizedBox(width: 8),
//                             Text(
//                               'Logout',
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w600,
//                                 color: Color(0xFFE63946),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 24),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildStatCard({
//     required IconData icon,
//     required String label,
//     required String value,
//     required Color color,
//   }) {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.04),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             padding: const EdgeInsets.all(10),
//             decoration: BoxDecoration(
//               color: color.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Icon(
//               icon,
//               color: color,
//               size: 24,
//             ),
//           ),
//           const SizedBox(height: 16),
//           Text(
//             value,
//             style: const TextStyle(
//               fontSize: 28,
//               fontWeight: FontWeight.bold,
//               color: Color(0xFF1A1F36),
//             ),
//           ),
//           const SizedBox(height: 4),
//           Text(
//             label,
//             style: TextStyle(
//               fontSize: 14,
//               color: Colors.grey[600],
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildActionCard({
//     required IconData icon,
//     required String title,
//     required String subtitle,
//     required VoidCallback onTap,
//   }) {
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(16),
//       child: Container(
//         padding: const EdgeInsets.all(20),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(16),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.04),
//               blurRadius: 10,
//               offset: const Offset(0, 4),
//             ),
//           ],
//         ),
//         child: Row(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 color: const Color(0xFF667EEA).withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Icon(
//                 icon,
//                 color: const Color(0xFF667EEA),
//                 size: 24,
//               ),
//             ),
//             const SizedBox(width: 16),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     title,
//                     style: const TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w600,
//                       color: Color(0xFF1A1F36),
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     subtitle,
//                     style: TextStyle(
//                       fontSize: 14,
//                       color: Colors.grey[600],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Icon(
//               Icons.arrow_forward_ios_rounded,
//               size: 16,
//               color: Colors.grey[400],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// void _showLogoutDialog(BuildContext context, WidgetRef ref) {
//   showDialog(
//     context: context,
//     barrierDismissible: false,
//     builder: (context) {
//       return AlertDialog(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(20),
//         ),
//         title: const Text(
//           'Logout',
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         content: const Text(
//           'Are you sure you want to logout from Elvara?',
//           style: TextStyle(height: 1.4),
//         ),
//         actionsPadding: const EdgeInsets.only(
//           left: 16,
//           right: 16,
//           bottom: 16,
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text(
//               'Cancel',
//               style: TextStyle(color: Colors.black),
//             ),
//           ),

//           // 🔥 LOGOUT BUTTON
//           Container(
//             decoration: BoxDecoration(
//               gradient: const LinearGradient(
//                 colors: [Color(0xFFE63946), Color(0xFFB71C1C)],
//               ),
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: ElevatedButton(
//               onPressed: () async {
//                 Navigator.pop(context); // close dialog

//                 await ref.read(doctorAuthControllerProvider.notifier).logout();

//                 if (!context.mounted) return;

//                 Navigator.pushAndRemoveUntil(
//                   context,
//                   MaterialPageRoute(
//                     builder: (_) => const DoctorLoginScreen(),
//                   ),
//                   (_) => false,
//                 );
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.transparent,
//                 shadowColor: Colors.transparent,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//               child: const Text(
//                 'Logout',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       );
//     },
//   );
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dr_app/core/theme/app_colors.dart';
import 'package:dr_app/features/doctor/presentation/controllers/notifiers/doctor_auth_controller.dart';
import 'package:dr_app/features/doctor/presentation/controllers/providers/appointment_provider.dart';
import 'package:dr_app/features/doctor/presentation/controllers/providers/revenue_provider.dart';
import 'package:dr_app/features/doctor/presentation/screens/appointment/doctor_appointments_screen.dart';
import 'package:dr_app/features/doctor/presentation/screens/chat/chat_list_screen.dart';
import 'package:dr_app/features/doctor/presentation/screens/doctor_patients_screen.dart';
import 'package:dr_app/features/doctor/presentation/screens/login_screen.dart';
import 'package:dr_app/features/doctor/presentation/screens/notification_screen.dart';
import 'package:dr_app/features/doctor/presentation/screens/revenue_screen.dart';
import 'package:dr_app/features/doctor/presentation/screens/review_screen.dart';
import 'package:dr_app/features/doctor/presentation/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dr_app/features/doctor/presentation/controllers/providers/doctor_repository_provider.dart';
import 'package:dr_app/features/doctor/domain/entities/doctor_entities.dart';

/// Theme matching the Appointments screen.
class _C {
  static const ink = AppColors.primaryStart;
  static const inkSoft = AppColors.primaryEnd;
  static const brand = AppColors.primaryStart;
  static const brandDeep = AppColors.primaryEnd;
  static const gold = Color(0xFFDCD6FF);
  static const bg = AppColors.scaffoldBg;
  static const text = AppColors.heading;
  static const muted = AppColors.subtext;
  static const danger = AppColors.error;
}

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  late Future<DoctorEntity> _doctorFuture;

  @override
  void initState() {
    super.initState();

    final doctorId = FirebaseAuth.instance.currentUser?.uid;

    _doctorFuture = doctorId == null
        ? Future.error(Exception('Doctor not logged in'))
        : ref.read(doctorRepositoryProvider).getDoctorById(doctorId);

    if (doctorId != null) {
      Future.microtask(() {
        ref.read(doctorAppointmentProvider.notifier).loadAppointments(doctorId);
        ref.read(revenueProvider.notifier).loadRevenue(doctorId);
      });
    }
  }

  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  DateTime? _parseAppointmentDate(dynamic value) {
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value);
    if (value is Timestamp) return value.toDate();
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: _C.bg,
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // const _SectionTitle('Next consultation'),
                    // const SizedBox(height: 12),
                    // _buildNextConsultation(),
                    // const SizedBox(height: 28),
                    const _SectionTitle('Quick actions'),
                    const SizedBox(height: 6),
                    _buildActionsGrid(),
                    const SizedBox(height: 28),
                    // _buildLogoutButton(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ───────────────────────── HEADER ─────────────────────────

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [_C.ink, _C.inkSoft],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Stack(
        children: [
          // Decorative background glow.
          Positioned(
            top: -60,
            right: -40,
            child: Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    _C.brand.withOpacity(0.35),
                    _C.brand.withOpacity(0.0),
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
FutureBuilder<DoctorEntity>(
  future: _doctorFuture,
  builder: (context, snapshot) {
    return _buildAvatar(
      snapshot.data?.profileImageUrl ?? '',
    );
  },
),                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _greeting,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.white.withOpacity(0.75),
                              ),
                            ),
                            const SizedBox(height: 2),
                          FutureBuilder<DoctorEntity>(
  future: _doctorFuture,
  builder: (context, snapshot) {
    final doctor = snapshot.data;

    final name = doctor?.name ?? 'Loading profile...';

    return Text(
      name,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: Colors.white,
        letterSpacing: -0.4,
      ),
    );
  },
),
                          ],
                        ),
                      ),
                      _buildBell(),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      FutureBuilder<DoctorEntity>(
                        future: _doctorFuture,
                        builder: (context, snapshot) {
                          final specialty =
                              snapshot.data?.specialization ?? 'Specialty';

                          return Text(
                            specialty,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.85),
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _C.gold.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: _C.gold.withOpacity(0.5),
                          ),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.verified_rounded,
                              size: 14,
                              color: _C.gold,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Verified',
                              style: TextStyle(
                                color: _C.gold,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildStatsRow(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

Widget _buildAvatar(String profileImageUrl) {
  return Container(
    padding: const EdgeInsets.all(2.5),
    decoration: const BoxDecoration(
      shape: BoxShape.circle,
      gradient: LinearGradient(
        colors: [_C.gold, Color(0xFFAAA1F2)],
      ),
    ),
    child: CircleAvatar(
      radius: 26,
      backgroundColor: _C.inkSoft,
      backgroundImage: profileImageUrl.isNotEmpty
          ? NetworkImage(profileImageUrl)
          : null,
      child: profileImageUrl.isEmpty
          ? const Icon(
              Icons.person_rounded,
              color: Colors.white,
              size: 28,
            )
          : null,
    ),
  );
}

  Widget _buildBell() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.12),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
            ),
          ),
          child: IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DoctorNotificationScreen()));
            },
            icon: const Icon(
              Icons.notifications_none_rounded,
              color: Colors.white,
            ),
          ),
        ),
        Positioned(
          top: 10,
          right: 11,
          child: Container(
            height: 9,
            width: 9,
            decoration: BoxDecoration(
              color: _C.danger,
              shape: BoxShape.circle,
              border: Border.all(
                color: _C.ink,
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ───────────────────────── STATISTICS ─────────────────────────

  Widget _buildStatsRow(BuildContext context) {
    final appointmentState = ref.watch(doctorAppointmentProvider);

    final appointments = appointmentState.maybeWhen(
      data: (data) => data,
      orElse: () => <Map<String, dynamic>>[],
    );

    final uniquePatientIds = appointments
        .map((a) => a['userId']?.toString())
        .whereType<String>()
        .where((id) => id.isNotEmpty)
        .toSet();

    final today = DateTime.now();

    final todayCount = appointments.where((appointment) {
      final date = _parseAppointmentDate(appointment['date']);

      return date != null &&
          date.year == today.year &&
          date.month == today.month &&
          date.day == today.day;
    }).length;

    final revenueState = ref.watch(revenueProvider);

    final totalRevenue = revenueState.maybeWhen(
      data: (appointments) => appointments.fold<double>(
        0,
        (total, appointment) {
          if (appointment['paymentStatus'] != 'paid') {
            return total;
          }

          final fee = appointment['consultationFee'];

          return total + (fee is num ? fee.toDouble() : 0);
        },
      ),
      orElse: () => 0,
    );

    return Row(
      children: [
        Expanded(
          child: _GlassStat(
            icon: Icons.people_alt_rounded,
            label: 'Patients',
            value: '${uniquePatientIds.length}',
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DoctorPatientsScreen()));
            },
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _GlassStat(
            icon: Icons.event_available_rounded,
            label: 'Today',
            value: '$todayCount',
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DoctorAppointmentsScreen(
                            initialDate: DateTime.now(),
                          )));
            },
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _GlassStat(
            icon: Icons.account_balance_wallet_rounded,
            label: 'Revenue',
            value: '₹${totalRevenue.toStringAsFixed(0)}',
            highlight: true,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => RevenueScreen(),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ───────────────────────── NEXT CONSULTATION ─────────────────────────

  Widget _buildNextConsultation() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: _cardDecoration(),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                height: 52,
                width: 52,
                decoration: BoxDecoration(
                  color: _C.brand.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.person_outline_rounded,
                  color: _C.brand,
                  size: 28,
                ),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'No upcoming consultation',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: _C.text,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Your next booked patient will appear here',
                      style: TextStyle(
                        fontSize: 13,
                        color: _C.muted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.schedule_rounded,
                    size: 18,
                  ),
                  label: const Text('Reschedule'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: _C.brand,
                    side: BorderSide(
                      color: _C.brand.withOpacity(0.35),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _GradientButton(
                  label: 'Start call',
                  icon: Icons.videocam_rounded,
                  onTap: () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ───────────────────────── QUICK ACTIONS ─────────────────────────

  Widget _buildActionsGrid() {
    final actions = [
      (
        Icons.calendar_month_rounded,
        'Schedule',
        'Appointments',
        AppColors.primaryStart,
      ),
      (
        Icons.chat_bubble_outline,
        'Messages',
        'Chat with patients',
        AppColors.primaryEnd,
      ),
      (
        Icons.star_outline_rounded,
        'My Reviews',
        'View patients feedback',
        const Color(0xFF8B7FE8),
      ),
      (
        Icons.settings_rounded,
        'Settings',
        'Your account',
        const Color(0xFFAAA1F2)
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: actions.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
        childAspectRatio: 1.45,
      ),
      itemBuilder: (context, index) { 
        final action = actions[index];

        return _ActionTile(
          icon: action.$1,
          title: action.$2,
          subtitle: action.$3,
          color: action.$4,
          onTap: () {
            if (action.$2 == 'Settings') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const DoctorSettingsScreen(),
                ),
              );
            } else if (action.$2 == 'My Reviews') {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DoctorReviewsScreen()));
            } else if (action.$2 == 'Messages') {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DoctorChatListScreen()));
            } else if (action.$2 == 'Schedule') {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DoctorAppointmentsScreen()));
            }
          },
        );
      },
    );
  }


}

// ───────────────────────── SHARED WIDGETS ─────────────────────────

BoxDecoration _cardDecoration() => BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: AppColors.primaryStart.withOpacity(0.08),
          blurRadius: 24,
          offset: const Offset(0, 8),
        ),
      ],
    );

class _SectionTitle extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  const _SectionTitle(
    this.title, {
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: _C.text,
            letterSpacing: -0.3,
          ),
        ),
        if (actionLabel != null)
          GestureDetector(
            onTap: onAction,
            child: Text(
              actionLabel!,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: _C.brand,
              ),
            ),
          ),
      ],
    );
  }
}

class _GlassStat extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool highlight;
  final VoidCallback? onTap;

  const _GlassStat({
    required this.icon,
    required this.label,
    required this.value,
    this.highlight = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final accent = highlight ? _C.gold : Colors.white;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(
              highlight ? 0.18 : 0.12,
            ),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: highlight
                  ? _C.gold.withOpacity(0.45)
                  : Colors.white.withOpacity(0.2),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 20, color: accent),
              const SizedBox(height: 10),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: accent,
                  ),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _ActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          padding: const EdgeInsets.all(16),
          decoration: _cardDecoration(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 22,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: _C.text,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: _C.muted,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GradientButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _GradientButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [_C.brand, _C.brandDeep],
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: _C.brand.withOpacity(0.3),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: Colors.white, size: 18),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
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

// ───────────────────────── LOGOUT DIALOG ─────────────────────────

void _showLogoutDialog(BuildContext context, WidgetRef ref) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) {
      return AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        title: const Text(
          'Log out',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: _C.text,
          ),
        ),
        content: const Text(
          'Are you sure you want to log out of Elvara?',
          style: TextStyle(
            height: 1.4,
            color: _C.muted,
          ),
        ),
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text(
              'Cancel',
              style: TextStyle(color: _C.text),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: _C.danger,
              borderRadius: BorderRadius.circular(12),
            ),
            child: ElevatedButton(
              onPressed: () async {
                Navigator.pop(dialogContext);

                await ref.read(doctorAuthControllerProvider.notifier).logout();

                if (!context.mounted) return;

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const DoctorLoginScreen(),
                  ),
                  (_) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Log out',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      );
    },
  );
}
