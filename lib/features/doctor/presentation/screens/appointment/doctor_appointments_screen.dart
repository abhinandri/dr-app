// // import 'package:dr_app/features/doctor/presentation/controllers/providers/appointment_provider.dart';
// // import 'package:dr_app/features/doctor/presentation/screens/appointment/appointment_details_screen.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // import '../../widgets/appointments/appointment_card.dart';

// // class DoctorAppointmentsScreen extends ConsumerStatefulWidget {
// //   const DoctorAppointmentsScreen({super.key});

// //   @override
// //   ConsumerState<DoctorAppointmentsScreen> createState() =>
// //       _DoctorAppointmentsScreenState();
// // }

// // class _DoctorAppointmentsScreenState
// //     extends ConsumerState<DoctorAppointmentsScreen> {
// //   @override
// //   void initState() {
// //     super.initState();

// //     final uid = FirebaseAuth.instance.currentUser!.uid;

// //     Future.microtask(() {
// //       ref.read(doctorAppointmentProvider.notifier).loadAppointments(uid);
// //     });
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       body: ref.watch(doctorAppointmentProvider).when(
// //             loading: () => const Center(
// //               child: CircularProgressIndicator(),
// //             ),
// //             error: (error, stack) => Center(
// //               child: Text(error.toString()),
// //             ),
// //             data: (appointments) {
// //               if (appointments.isEmpty) {
// //                 return const Center(
// //                   child: Text(
// //                     "No appointments found",
// //                   ),
// //                 );
// //               }

// //               return ListView.builder(
// //                 padding: const EdgeInsets.all(16),
// //                 itemCount: appointments.length,
// //                 itemBuilder: (context, index) {
// //                   final appointment = appointments[index];

// //                   return AppointmentCard(
// //   appointment: appointment,

// //   onTap: () {

// //     Navigator.push(
// //       context,
// //       MaterialPageRoute(
// //         builder: (_) => AppointmentDetailsScreen(
// //           appointment: appointment,
// //         ),
// //       ),
// //     );

// //   },

// //   onAccept: () {

// //     ref
// //       .read(doctorAppointmentProvider.notifier)
// //       .updateStatus(
// //         appointmentId: appointment['id'],
// //         status: 'accepted',
// //       );

// //   },


// //   onReject: () {

// //     ref
// //       .read(doctorAppointmentProvider.notifier)
// //       .updateStatus(
// //         appointmentId: appointment['id'],
// //         status: 'rejected',
// //       );

// //   },

// // );
// //                   // return AppointmentCard(
// //                   //   appointment: appointment,
// //                   //   onAccept: () {
// //                   //     ref
// //                   //         .read(
// //                   //           doctorAppointmentProvider.notifier,
// //                   //         )
// //                   //         .updateStatus(
// //                   //           appointmentId: appointment['id'],
// //                   //           status: 'accepted',
// //                   //         );
// //                   //   },
// //                   //   onReject: () {
// //                   //     ref
// //                   //         .read(
// //                   //           doctorAppointmentProvider.notifier,
// //                   //         )
// //                   //         .updateStatus(
// //                   //           appointmentId: appointment['id'],
// //                   //           status: 'rejected',
// //                   //         );
// //                   //   },
// //                   // );
// //                 },
// //               );
// //             },
// //           ),
// //     );
// //   }
// // }
// //
// import 'package:dr_app/core/theme/app_colors.dart';
// import 'package:dr_app/features/doctor/presentation/controllers/providers/appointment_provider.dart';
// import 'package:dr_app/features/doctor/presentation/screens/appointment/appointment_details_screen.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../../widgets/appointments/appointment_card.dart';

// class DoctorAppointmentsScreen extends ConsumerStatefulWidget {
//   const DoctorAppointmentsScreen({super.key});

//   @override
//   ConsumerState<DoctorAppointmentsScreen> createState() =>
//       _DoctorAppointmentsScreenState();
// }

// class _DoctorAppointmentsScreenState
//     extends ConsumerState<DoctorAppointmentsScreen> {
//   int _selectedFilterIndex = 0;

//   static const _filterLabels = ['All', 'Pending', 'Accepted', 'Rejected'];
//   static const _filterStatuses = [null, 'confirmed', 'accepted', 'rejected'];
//   static const _filterIcons = [
//     Icons.apps_rounded,
//     Icons.hourglass_top_rounded,
//     Icons.check_circle_rounded,
//     Icons.cancel_rounded,
//   ];

//   String get _doctorId => FirebaseAuth.instance.currentUser!.uid;

//   @override
//   void initState() {
//     super.initState();
//     Future.microtask(() {
//       ref.read(doctorAppointmentProvider.notifier).loadAppointments(_doctorId);
//     });
//   }

//   Future<void> _refresh() async {
//     await ref
//         .read(doctorAppointmentProvider.notifier)
//         .loadAppointments(_doctorId);
//   }

//   DateTime? _tryParseDate(String? date) {
//     if (date == null) return null;
//     try {
//       return DateTime.parse(date);
//     } catch (_) {
//       return null;
//     }
//   }

//   List<Object> _groupAppointments(List<Map<String, dynamic>> appointments) {
//     final today = DateTime.now();
//     final todayOnly = DateTime(today.year, today.month, today.day);

//     final buckets = <String, List<Map<String, dynamic>>>{
//       'Today': [],
//       'Tomorrow': [],
//       'This Week': [],
//       'Later': [],
//       'Earlier': [],
//     };

//     for (final appointment in appointments) {
//       final parsed = _tryParseDate(appointment['date']);
//       if (parsed == null) {
//         buckets['Later']!.add(appointment);
//         continue;
//       }
//       final dateOnly = DateTime(parsed.year, parsed.month, parsed.day);
//       final diff = dateOnly.difference(todayOnly).inDays;

//       if (diff < 0) {
//         buckets['Earlier']!.add(appointment);
//       } else if (diff == 0) {
//         buckets['Today']!.add(appointment);
//       } else if (diff == 1) {
//         buckets['Tomorrow']!.add(appointment);
//       } else if (diff <= 7) {
//         buckets['This Week']!.add(appointment);
//       } else {
//         buckets['Later']!.add(appointment);
//       }
//     }

//     for (final list in buckets.values) {
//       list.sort((a, b) {
//         final da = _tryParseDate(a['date']);
//         final db = _tryParseDate(b['date']);
//         if (da == null || db == null) return 0;
//         return da.compareTo(db);
//       });
//     }

//     final result = <Object>[];
//     for (final entry in buckets.entries) {
//       if (entry.value.isEmpty) continue;
//       result.add(entry.key);
//       result.addAll(entry.value);
//     }
//     return result;
//   }

//   IconData _groupIcon(String group) {
//     switch (group) {
//       case 'Today':
//         return Icons.wb_sunny_rounded;
//       case 'Tomorrow':
//         return Icons.wb_twilight_rounded;
//       case 'This Week':
//         return Icons.date_range_rounded;
//       case 'Earlier':
//         return Icons.history_rounded;
//       default:
//         return Icons.event_rounded;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final appointmentState = ref.watch(doctorAppointmentProvider);

//     final appointmentsForSummary = appointmentState.maybeWhen(
//       data: (data) => data.cast<Map<String, dynamic>>(),
//       orElse: () => const <Map<String, dynamic>>[],
//     );

//     final today = DateTime.now();
//     final todayCount = appointmentsForSummary.where((a) {
//       final d = _tryParseDate(a['date']);
//       return d != null &&
//           d.year == today.year &&
//           d.month == today.month &&
//           d.day == today.day;
//     }).length;
//     final pendingCount = appointmentsForSummary
//         .where((a) => a['status'] == 'confirmed')
//         .length;

//     return Scaffold(
//       backgroundColor: AppColors.scaffoldBg,
//       body: Stack(
//         children: [
//           // ── Gradient header ──
//           Container(
//             height: 210,
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//                 colors: [AppColors.primaryStart, AppColors.primaryEnd],
//               ),
//             ),
//           ),

//           // ── Curved overlay into scaffold bg ──
//           Positioned(
//             top: 170,
//             left: 0,
//             right: 0,
//             child: Container(
//               height: 50,
//               decoration: BoxDecoration(
//                 color: AppColors.scaffoldBg,
//                 borderRadius: const BorderRadius.only(
//                   topLeft: Radius.circular(36),
//                   topRight: Radius.circular(36),
//                 ),
//               ),
//             ),
//           ),

//           SafeArea(
//             child: Column(
//               children: [
//                 // ── Title row ──
//                 Padding(
//                   padding: const EdgeInsets.fromLTRB(20, 6, 20, 0),
//                   child: Row(
//                     children: [
//                       Container(
//                         width: 42,
//                         height: 42,
//                         decoration: BoxDecoration(
//                           color: Colors.white.withOpacity(0.18),
//                           shape: BoxShape.circle,
//                           border: Border.all(
//                             color: Colors.white.withOpacity(0.3),
//                           ),
//                         ),
//                         child: const Icon(
//                           Icons.calendar_month_rounded,
//                           color: Colors.white,
//                           size: 20,
//                         ),
//                       ),
//                       const SizedBox(width: 12),
//                       const Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               'Appointments',
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 20,
//                                 fontWeight: FontWeight.w700,
//                                 letterSpacing: 0.2,
//                               ),
//                             ),
//                             Text(
//                               'Manage your patient schedule',
//                               style: TextStyle(
//                                 color: Colors.white70,
//                                 fontSize: 12.5,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),

//                 const SizedBox(height: 18),

//                 // ── Glass stat chips ──
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 20),
//                   child: Row(
//                     children: [
//                       _GlassStatChip(
//                         icon: Icons.today_rounded,
//                         value: '$todayCount',
//                         label: 'Today',
//                       ),
//                       const SizedBox(width: 10),
//                       _GlassStatChip(
//                         icon: Icons.hourglass_top_rounded,
//                         value: '$pendingCount',
//                         label: 'Pending',
//                       ),
//                       const SizedBox(width: 10),
//                       _GlassStatChip(
//                         icon: Icons.event_note_rounded,
//                         value: '${appointmentsForSummary.length}',
//                         label: 'Total',
//                       ),
//                     ],
//                   ),
//                 ),

//                 const SizedBox(height: 8),

//                 // ── Floating pill filter bar ──
//                 Padding(
//                   padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
//                   child: Container(
//                     padding: const EdgeInsets.all(5),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(30),
//                       boxShadow: [
//                         BoxShadow(
//                           color: AppColors.primaryStart.withOpacity(0.10),
//                           blurRadius: 20,
//                           offset: const Offset(0, 8),
//                         ),
//                       ],
//                     ),
//                     child: Row(
//                       children: List.generate(_filterLabels.length, (index) {
//                         final selected = _selectedFilterIndex == index;
//                         return Expanded(
//                           child: GestureDetector(
//                             onTap: () =>
//                                 setState(() => _selectedFilterIndex = index),
//                             child: AnimatedContainer(
//                               duration: const Duration(milliseconds: 220),
//                               curve: Curves.easeOut,
//                               padding:
//                                   const EdgeInsets.symmetric(vertical: 10),
//                               decoration: BoxDecoration(
//                                 gradient: selected
//                                     ? LinearGradient(
//                                         colors: [
//                                           AppColors.primaryStart,
//                                           AppColors.primaryEnd,
//                                         ],
//                                       )
//                                     : null,
//                                 borderRadius: BorderRadius.circular(24),
//                                 boxShadow: selected
//                                     ? [
//                                         BoxShadow(
//                                           color: AppColors.primaryStart
//                                               .withOpacity(0.35),
//                                           blurRadius: 10,
//                                           offset: const Offset(0, 4),
//                                         ),
//                                       ]
//                                     : null,
//                               ),
//                               child: Column(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   Icon(
//                                     _filterIcons[index],
//                                     size: 15,
//                                     color: selected
//                                         ? Colors.white
//                                         : AppColors.subtext,
//                                   ),
//                                   const SizedBox(height: 3),
//                                   Text(
//                                     _filterLabels[index],
//                                     style: TextStyle(
//                                       fontSize: 11.5,
//                                       fontWeight: selected
//                                           ? FontWeight.w700
//                                           : FontWeight.w500,
//                                       color: selected
//                                           ? Colors.white
//                                           : AppColors.subtext,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         );
//                       }),
//                     ),
//                   ),
//                 ),

//                 const SizedBox(height: 6),

//                 // ── Schedule list ──
//                 Expanded(
//                   child: appointmentState.when(
//                     loading: () => _buildLoadingState(),
//                     error: (error, stack) => _buildErrorState(error),
//                     data: (appointmentsRaw) {
//                       final appointments =
//                           appointmentsRaw.cast<Map<String, dynamic>>();
//                       final activeStatus =
//                           _filterStatuses[_selectedFilterIndex];
//                       final filtered = activeStatus == null
//                           ? appointments
//                           : appointments
//                               .where((a) => a['status'] == activeStatus)
//                               .toList();

//                       if (filtered.isEmpty) {
//                         return _buildEmptyState(
//                           isFiltered: _selectedFilterIndex != 0,
//                         );
//                       }

//                       final items = _groupAppointments(filtered);

//                       return RefreshIndicator(
//                         color: AppColors.primaryStart,
//                         onRefresh: _refresh,
//                         child: ListView.builder(
//                           physics: const BouncingScrollPhysics(
//                             parent: AlwaysScrollableScrollPhysics(),
//                           ),
//                           padding: const EdgeInsets.fromLTRB(20, 18, 20, 30),
//                           itemCount: items.length,
//                           itemBuilder: (context, index) {
//                             final item = items[index];

//                             if (item is String) {
//                               return Padding(
//                                 padding: EdgeInsets.only(
//                                   top: index == 0 ? 0 : 22,
//                                   bottom: 12,
//                                 ),
//                                 child: _SectionHeader(
//                                   label: item,
//                                   icon: _groupIcon(item),
//                                 ),
//                               );
//                             }

//                             final appointment = item as Map<String, dynamic>;

//                             return Padding(
//                               padding: const EdgeInsets.only(bottom: 12),
//                               child: AppointmentCard(
//                                 appointment: appointment,
//                                 onTap: () {
//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (_) =>
//                                           AppointmentDetailsScreen(
//                                         appointment: appointment,
//                                       ),
//                                     ),
//                                   );
//                                 },
                              
                              
//                               ),
//                             );
//                           },
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // ════════════════════════════════════════
//   //  LOADING STATE — shimmer-style skeleton
//   // ════════════════════════════════════════
//   Widget _buildLoadingState() {
//     return ListView.separated(
//       physics: const BouncingScrollPhysics(),
//       padding: const EdgeInsets.fromLTRB(20, 18, 20, 30),
//       itemCount: 5,
//       separatorBuilder: (_, __) => const SizedBox(height: 14),
//       itemBuilder: (_, __) => _ShimmerCard(),
//     );
//   }

//   // ════════════════════════════════════════
//   //  ERROR STATE
//   // ════════════════════════════════════════
//   Widget _buildErrorState(Object error) {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 36),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Container(
//               padding: const EdgeInsets.all(22),
//               decoration: BoxDecoration(
//                 color: AppColors.error.withOpacity(0.08),
//                 shape: BoxShape.circle,
//               ),
//               child: Icon(
//                 Icons.error_outline_rounded,
//                 color: AppColors.error,
//                 size: 34,
//               ),
//             ),
//             const SizedBox(height: 16),
//             Text(
//               'Something went wrong',
//               style: TextStyle(
//                 fontSize: 15.5,
//                 fontWeight: FontWeight.w700,
//                 color: AppColors.heading,
//               ),
//             ),
//             const SizedBox(height: 6),
//             Text(
//               error.toString(),
//               textAlign: TextAlign.center,
//               style: TextStyle(fontSize: 12.5, color: AppColors.subtext),
//             ),
//             const SizedBox(height: 18),
//             TextButton.icon(
//               onPressed: _refresh,
//               icon: Icon(Icons.refresh_rounded, color: AppColors.primaryStart),
//               label: Text(
//                 'Try again',
//                 style: TextStyle(
//                   color: AppColors.primaryStart,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // ════════════════════════════════════════
//   //  EMPTY STATE
//   // ════════════════════════════════════════
//   Widget _buildEmptyState({bool isFiltered = false}) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Container(
//             padding: const EdgeInsets.all(26),
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [
//                   AppColors.primaryStart.withOpacity(0.12),
//                   AppColors.primaryEnd.withOpacity(0.12),
//                 ],
//               ),
//               shape: BoxShape.circle,
//             ),
//             child: ShaderMask(
//               shaderCallback: (bounds) => LinearGradient(
//                 colors: [AppColors.primaryStart, AppColors.primaryEnd],
//               ).createShader(bounds),
//               child: Icon(
//                 isFiltered
//                     ? Icons.filter_alt_off_rounded
//                     : Icons.event_busy_rounded,
//                 size: 44,
//                 color: Colors.white,
//               ),
//             ),
//           ),
//           const SizedBox(height: 18),
//           Text(
//             isFiltered ? 'No matching appointments' : 'No appointments yet',
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.w700,
//               color: AppColors.heading,
//             ),
//           ),
//           const SizedBox(height: 6),
//           Text(
//             isFiltered
//                 ? 'Try a different filter above'
//                 : 'New patient bookings will appear here',
//             style: TextStyle(fontSize: 13, color: AppColors.subtext),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ════════════════════════════════════════════════════════════
// //  Glass stat chip — translucent, sits on the gradient header
// // ════════════════════════════════════════════════════════════
// class _GlassStatChip extends StatelessWidget {
//   final IconData icon;
//   final String value;
//   final String label;

//   const _GlassStatChip({
//     required this.icon,
//     required this.value,
//     required this.label,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
//         decoration: BoxDecoration(
//           color: Colors.white.withOpacity(0.18),
//           borderRadius: BorderRadius.circular(16),
//           border: Border.all(color: Colors.white.withOpacity(0.35)),
//         ),
//         child: Row(
//           children: [
//             Icon(icon, color: Colors.white, size: 18),
//             const SizedBox(width: 8),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   value,
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 15,
//                   ),
//                 ),
//                 Text(
//                   label,
//                   style: TextStyle(
//                     color: Colors.white.withOpacity(0.85),
//                     fontSize: 10.5,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // ════════════════════════════════════════════════════════════
// //  Section header — gradient pill + trailing divider
// // ════════════════════════════════════════════════════════════
// class _SectionHeader extends StatelessWidget {
//   final String label;
//   final IconData icon;

//   const _SectionHeader({required this.label, required this.icon});

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Container(
//           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [AppColors.primaryStart, AppColors.primaryEnd],
//             ),
//             borderRadius: BorderRadius.circular(20),
//           ),
//           child: Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Icon(icon, size: 13, color: Colors.white),
//               const SizedBox(width: 6),
//               Text(
//                 label.toUpperCase(),
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.w700,
//                   fontSize: 11.5,
//                   letterSpacing: 0.4,
//                 ),
//               ),
//             ],
//           ),
//         ),
//         const SizedBox(width: 10),
//         Expanded(
//           child: Container(height: 1, color: const Color(0xFFEBEDF2)),
//         ),
//       ],
//     );
//   }
// }

// // ════════════════════════════════════════════════════════════
// //  Shimmer-style loading placeholder card
// // ════════════════════════════════════════════════════════════
// class _ShimmerCard extends StatefulWidget {
//   @override
//   State<_ShimmerCard> createState() => _ShimmerCardState();
// }

// class _ShimmerCardState extends State<_ShimmerCard>
//     with SingleTickerProviderStateMixin {
//   late final AnimationController _controller = AnimationController(
//     vsync: this,
//     duration: const Duration(milliseconds: 1200),
//   )..repeat(reverse: true);

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: _controller,
//       builder: (context, child) {
//         final opacity = 0.5 + (_controller.value * 0.4);
//         return Container(
//           height: 96,
//           padding: const EdgeInsets.all(16),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(20),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.03),
//                 blurRadius: 16,
//                 offset: const Offset(0, 4),
//               ),
//             ],
//           ),
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Opacity(
//                 opacity: opacity,
//                 child: Container(
//                   width: 56,
//                   height: 56,
//                   decoration: BoxDecoration(
//                     color: AppColors.primaryStart.withOpacity(0.15),
//                     shape: BoxShape.circle,
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 14),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Opacity(
//                       opacity: opacity,
//                       child: Container(
//                         width: 130,
//                         height: 12,
//                         decoration: BoxDecoration(
//                           color: AppColors.primaryStart.withOpacity(0.15),
//                           borderRadius: BorderRadius.circular(6),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                     Opacity(
//                       opacity: opacity,
//                       child: Container(
//                         width: 90,
//                         height: 10,
//                         decoration: BoxDecoration(
//                           color: AppColors.primaryStart.withOpacity(0.10),
//                           borderRadius: BorderRadius.circular(6),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 14),
//                     Opacity(
//                       opacity: opacity,
//                       child: Container(
//                         width: double.infinity,
//                         height: 10,
//                         decoration: BoxDecoration(
                           
//                           color: AppColors.primaryStart.withOpacity(0.08),
//                           borderRadius: BorderRadius.circular(6),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }

import 'package:dr_app/core/theme/app_colors.dart';
import 'package:dr_app/features/doctor/presentation/controllers/providers/appointment_provider.dart';
import 'package:dr_app/features/doctor/presentation/screens/appointment/appointment_details_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../widgets/appointments/appointment_card.dart';

class DoctorAppointmentsScreen extends ConsumerStatefulWidget {
    final DateTime? initialDate;

  const DoctorAppointmentsScreen({super.key,this.initialDate});

  @override
  ConsumerState<DoctorAppointmentsScreen> createState() =>
      _DoctorAppointmentsScreenState();
}

class _DoctorAppointmentsScreenState
    extends ConsumerState<DoctorAppointmentsScreen> {
  int _selectedFilterIndex = 0;
  DateTimeRange? _selectedDateRange;
static const _filterLabels = [
  'All',
  'Pending',
  'Accepted',
  'Rejected',
];

static const _filterStatuses = [
  null,
  'pending',
  'confirmed',
  'rejected',
];

  static const _filterIcons = [
    Icons.apps_rounded,
    Icons.hourglass_top_rounded,
    Icons.check_circle_rounded,
    Icons.cancel_rounded,
  ];

  String get _doctorId => FirebaseAuth.instance.currentUser!.uid;

 @override
void initState() {
  super.initState();

  final initialDate = widget.initialDate;

  if (initialDate != null) {
    final today = DateTime(
      initialDate.year,
      initialDate.month,
      initialDate.day,
    );

    _selectedDateRange = DateTimeRange(
      start: today,
      end: today,
    );
  }

  Future.microtask(() {
    ref.read(doctorAppointmentProvider.notifier).loadAppointments(_doctorId);
  });
}

  Future<void> _refresh() async {
    await ref
        .read(doctorAppointmentProvider.notifier)
        .loadAppointments(_doctorId);
  }

  // NEW: Open the calendar date-range picker.
  Future<void> _selectDateRange() async {
    final pickedRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      initialDateRange: _selectedDateRange,
      helpText: 'Filter appointments by date',
      saveText: 'Apply',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryStart,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Color(0xFF172033),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedRange != null && mounted) {
      setState(() {
        _selectedDateRange = pickedRange;
      });
    }
  }

  // NEW: Format the selected dates for the filter label.
  String _formatFilterDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }

  // NEW: Filter appointments using the selected date range.
  List<Map<String, dynamic>> _filterAppointmentsByDateRange(
    List<Map<String, dynamic>> appointments,
  ) {
    final range = _selectedDateRange;
    if (range == null) return appointments;

    final start = DateTime(
      range.start.year,
      range.start.month,
      range.start.day,
    );

    final end = DateTime(
      range.end.year,
      range.end.month,
      range.end.day,
    );

    return appointments.where((appointment) {
      final parsed = _tryParseDate(appointment['date']?.toString());
      if (parsed == null) return false;

      final date = DateTime(parsed.year, parsed.month, parsed.day);

      return !date.isBefore(start) && !date.isAfter(end);
    }).toList();
  }

  DateTime? _tryParseDate(String? date) {
    if (date == null) return null;

    try {
      return DateTime.parse(date);
    } catch (_) {
      return null;
    }
  }

  List<Object> _groupAppointments(List<Map<String, dynamic>> appointments) {
    final today = DateTime.now();
    final todayOnly = DateTime(today.year, today.month, today.day);

    final buckets = <String, List<Map<String, dynamic>>>{
      'Today': [],
      'Tomorrow': [],
      'This Week': [],
      'Later': [],
      'Earlier': [],
    };

    for (final appointment in appointments) {
      final parsed = _tryParseDate(appointment['date']);

      if (parsed == null) {
        buckets['Later']!.add(appointment);
        continue;
      }

      final dateOnly = DateTime(parsed.year, parsed.month, parsed.day);
      final diff = dateOnly.difference(todayOnly).inDays;

      if (diff < 0) {
        buckets['Earlier']!.add(appointment);
      } else if (diff == 0) {
        buckets['Today']!.add(appointment);
      } else if (diff == 1) {
        buckets['Tomorrow']!.add(appointment);
      } else if (diff <= 7) {
        buckets['This Week']!.add(appointment);
      } else {
        buckets['Later']!.add(appointment);
      }
    }

    for (final list in buckets.values) {
      list.sort((a, b) {
        final da = _tryParseDate(a['date']);
        final db = _tryParseDate(b['date']);

        if (da == null || db == null) return 0;

        return da.compareTo(db);
      });
    }

    final result = <Object>[];

    for (final entry in buckets.entries) {
      if (entry.value.isEmpty) continue;

      result.add(entry.key);
      result.addAll(entry.value);
    }

    return result;
  }

  IconData _groupIcon(String group) {
    switch (group) {
      case 'Today':
        return Icons.wb_sunny_rounded;
      case 'Tomorrow':
        return Icons.wb_twilight_rounded;
      case 'This Week':
        return Icons.date_range_rounded;
      case 'Earlier':
        return Icons.history_rounded;
      default:
        return Icons.event_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final appointmentState = ref.watch(doctorAppointmentProvider);

    final appointmentsForSummary = appointmentState.maybeWhen(
      data: (data) => data.cast<Map<String, dynamic>>(),
      orElse: () => const <Map<String, dynamic>>[],
    );

    final today = DateTime.now();

    final todayCount = appointmentsForSummary.where((a) {
      final d = _tryParseDate(a['date']);

      return d != null &&
          d.year == today.year &&
          d.month == today.month &&
          d.day == today.day;
    }).length;

    final pendingCount = appointmentsForSummary
        .where((a) => a['status'] == 'pending')
        .length;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: Stack(
        children: [
          // Gradient header.
          Container(
            height: 210,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primaryStart,
                  AppColors.primaryEnd,
                ],
              ),
            ),
          ),

          // Curved overlay into scaffold background.
          Positioned(
            top: 170,
            left: 0,
            right: 0,
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: AppColors.scaffoldBg,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(36),
                  topRight: Radius.circular(36),
                ),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // Title row with calendar filter.
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 6, 20, 0),
                  child: Row(
                    children: [
                      Material(
                        color: Colors.white.withOpacity(0.18),
                        shape: const CircleBorder(),
                        child: InkWell(
                          customBorder: const CircleBorder(),
                          onTap: _selectDateRange,
                          child: Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                              ),
                            ),
                            child: const Icon(
                              Icons.calendar_month_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Appointments',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.2,
                              ),
                            ),
                            Text(
                              'Manage your patient schedule',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                // Glass stat chips.
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      _GlassStatChip(
                        icon: Icons.today_rounded,
                        value: '$todayCount',
                        label: 'Today',
                      ),
                      const SizedBox(width: 10),
                      _GlassStatChip(
                        icon: Icons.hourglass_top_rounded,
                        value: '$pendingCount',
                        label: 'Pending',
                      ),
                      const SizedBox(width: 10),
                      _GlassStatChip(
                        icon: Icons.calendar_month_rounded,
                        value: '${appointmentsForSummary.length}',
                        label: 'Total',
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // The rest of the screen continues below
                                // Floating pill filter bar.
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryStart.withOpacity(0.10),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Row(
                      children: List.generate(_filterLabels.length, (index) {
                        final selected = _selectedFilterIndex == index;

                        return Expanded(
                          child: GestureDetector(
                            onTap: () =>
                                setState(() => _selectedFilterIndex = index),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 220),
                              curve: Curves.easeOut,
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                gradient: selected
                                    ? LinearGradient(
                                        colors: [
                                          AppColors.primaryStart,
                                          AppColors.primaryEnd,
                                        ],
                                      )
                                    : null,
                                borderRadius: BorderRadius.circular(24),
                                boxShadow: selected
                                    ? [
                                        BoxShadow(
                                          color: AppColors.primaryStart
                                              .withOpacity(0.35),
                                          blurRadius: 10,
                                          offset: const Offset(0, 4),
                                        ),
                                      ]
                                    : null,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    _filterIcons[index],
                                    size: 15,
                                    color: selected
                                        ? Colors.white
                                        : AppColors.subtext,
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    _filterLabels[index],
                                    style: TextStyle(
                                      fontSize: 11.5,
                                      fontWeight: selected
                                          ? FontWeight.w700
                                          : FontWeight.w500,
                                      color: selected
                                          ? Colors.white
                                          : AppColors.subtext,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),

                const SizedBox(height: 6),

                // NEW: Selected date range and Clear button.
                if (_selectedDateRange != null)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.date_range_rounded,
                          size: 17,
                          color: AppColors.primaryStart,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '${_formatFilterDate(_selectedDateRange!.start)}'
                            ' – '
                            '${_formatFilterDate(_selectedDateRange!.end)}',
                            style: TextStyle(
                              color: AppColors.heading,
                              fontWeight: FontWeight.w600,
                              fontSize: 12.5,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _selectedDateRange = null;
                            });
                          },
                          child: Text(
                            'Clear',
                            style: TextStyle(
                              color: AppColors.primaryStart,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                // Schedule list.
                Expanded(
                  child: appointmentState.when(
                    loading: () => _buildLoadingState(),
                    error: (error, stack) => _buildErrorState(error),
                    data: (appointmentsRaw) {
                      final appointments =
                          appointmentsRaw.cast<Map<String, dynamic>>();

                      final activeStatus =
                          _filterStatuses[_selectedFilterIndex];

                      final statusFiltered = activeStatus == null
                          ? appointments
                          : appointments
                              .where((a) => a['status'] == activeStatus)
                              .toList();

                      // NEW: Apply date filtering after status filtering.
                      final filtered =
                          _filterAppointmentsByDateRange(statusFiltered);

                      if (filtered.isEmpty) {
                        return _buildEmptyState(
                          isFiltered: _selectedFilterIndex != 0 ||
                              _selectedDateRange != null,
                        );
                      }

                      final items = _groupAppointments(filtered);

                      return RefreshIndicator(
                        color: AppColors.primaryStart,
                        onRefresh: _refresh,
                        child: ListView.builder(
                          physics: const BouncingScrollPhysics(
                            parent: AlwaysScrollableScrollPhysics(),
                          ),
                          padding: const EdgeInsets.fromLTRB(20, 18, 20, 30),
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            final item = items[index];

                            if (item is String) {
                              return Padding(
                                padding: EdgeInsets.only(
                                  top: index == 0 ? 0 : 22,
                                  bottom: 12,
                                ),
                                child: _SectionHeader(
                                  label: item,
                                  icon: _groupIcon(item),
                                ),
                              );
                            }

                            final appointment = item as Map<String, dynamic>;

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: AppointmentCard(
                                appointment: appointment,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          AppointmentDetailsScreen(
                                        appointment: appointment,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // LOADING STATE — shimmer-style skeleton.
  Widget _buildLoadingState() {
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 30),
      itemCount: 5,
      separatorBuilder: (_, __) => const SizedBox(height: 14),
      itemBuilder: (_, __) => _ShimmerCard(),
    );
  }

  // ERROR STATE.
  Widget _buildErrorState(Object error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 36),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline_rounded,
                color: AppColors.error,
                size: 34,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Something went wrong',
              style: TextStyle(
                fontSize: 15.5,
                fontWeight: FontWeight.w700,
                color: AppColors.heading,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              error.toString(),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12.5, color: AppColors.subtext),
            ),
            const SizedBox(height: 18),
            TextButton.icon(
              onPressed: _refresh,
              icon: Icon(Icons.refresh_rounded, color: AppColors.primaryStart),
              label: Text(
                'Try again',
                style: TextStyle(
                  color: AppColors.primaryStart,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // EMPTY STATE.
  Widget _buildEmptyState({bool isFiltered = false}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(26),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primaryStart.withOpacity(0.12),
                  AppColors.primaryEnd.withOpacity(0.12),
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: [AppColors.primaryStart, AppColors.primaryEnd],
              ).createShader(bounds),
              child: Icon(
                isFiltered
                    ? Icons.filter_alt_off_rounded
                    : Icons.event_busy_rounded,
                size: 44,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 18),
          Text(
            isFiltered ? 'No matching appointments' : 'No appointments yet',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.heading,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            isFiltered
                ? 'Try a different filter above'
                : 'New patient bookings will appear here',
            style: TextStyle(fontSize: 13, color: AppColors.subtext),
          ),
        ],
      ),
    );
  }
}

// Glass stat chip — translucent, sits on the gradient header.
class _GlassStatChip extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _GlassStatChip({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.18),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.35)),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.85),
                    fontSize: 10.5,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Section header — gradient pill + trailing divider.
class _SectionHeader extends StatelessWidget {
  final String label;
  final IconData icon;

  const _SectionHeader({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primaryStart, AppColors.primaryEnd],
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 13, color: Colors.white),
              const SizedBox(width: 6),
              Text(
                label.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 11.5,
                  letterSpacing: 0.4,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Container(height: 1, color: const Color(0xFFEBEDF2)),
        ),
      ],
    );
  }
}

// Shimmer-style loading placeholder card.
class _ShimmerCard extends StatefulWidget {
  @override
  State<_ShimmerCard> createState() => _ShimmerCardState();
}

class _ShimmerCardState extends State<_ShimmerCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final opacity = 0.5 + (_controller.value * 0.4);

        return Container(
          height: 96,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Opacity(
                opacity: opacity,
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppColors.primaryStart.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Opacity(
                      opacity: opacity,
                      child: Container(
                        width: 130,
                        height: 12,
                        decoration: BoxDecoration(
                          color: AppColors.primaryStart.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Opacity(
                      opacity: opacity,
                      child: Container(
                        width: 90,
                        height: 10,
                        decoration: BoxDecoration(
                          color: AppColors.primaryStart.withOpacity(0.10),
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Opacity(
                      opacity: opacity,
                      child: Container(
                        width: double.infinity,
                        height: 10,
                        decoration: BoxDecoration(
                          color: AppColors.primaryStart.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}