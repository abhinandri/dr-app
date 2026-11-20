// import 'package:dr_app/features/doctor/presentation/controllers/providers/appointment_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class AppointmentDetailsScreen extends ConsumerWidget {
//   final Map<String, dynamic> appointment;

//   const AppointmentDetailsScreen({
//     super.key,
//     required this.appointment,
//   });

//   @override
//   Widget build(BuildContext context,WidgetRef ref) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Appointment Details"),
//       ),

//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [

//             Text(
//               appointment['userName'] ?? 'Unknown',
//               style: const TextStyle(
//                 fontSize: 22,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),

//             const SizedBox(height: 8),

//             Text(
//               appointment['userEmail'] ?? '',
//               style: const TextStyle(
//                 color: Colors.grey,
//               ),
//             ),

//             const SizedBox(height: 24),

//             Text(
//               "Date: ${appointment['date'] ?? ''}",
//             ),

//             const SizedBox(height: 12),

//             Text(
//               "Time: ${appointment['time'] ?? ''}",
//             ),

//             const SizedBox(height: 12),

//             Text(
//               "Status: ${appointment['status'] ?? ''}",
//             ),

//             const SizedBox(height: 24),

//            ElevatedButton(
//   onPressed: () {

//     ref
//         .read(doctorAppointmentProvider.notifier)
//         .updateStatus(
//           appointmentId: appointment['id'],
//           status: 'accepted',
//         );

//   },
//   child: const Text("Accept"),
// ),

//             ElevatedButton(
//   onPressed: () {

//     ref
//         .read(doctorAppointmentProvider.notifier)
//         .updateStatus(
//           appointmentId: appointment['id'],
//           status: 'rejected',
//         );

//   },
//   child: const Text("Reject"),
// ),

//             // We'll add these later
//             // Chat
//             // Video Call
//             // Audio Call
//             // Prescription

//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:dr_app/core/theme/app_colors.dart';
import 'package:dr_app/core/utils/date_utils.dart';
import 'package:dr_app/core/utils/time_utils.dart';
import 'package:dr_app/features/doctor/presentation/controllers/providers/appointment_provider.dart';
import 'package:dr_app/features/doctor/presentation/screens/appointment/prescription_upload_screen.dart';
import 'package:dr_app/features/doctor/presentation/screens/call/audio_call_screen.dart';
import 'package:dr_app/features/doctor/presentation/screens/chat/chat_screen.dart';
import 'package:dr_app/features/doctor/presentation/screens/call/video_call_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppointmentDetailsScreen extends ConsumerWidget {
  final Map<String, dynamic> appointment;

  const AppointmentDetailsScreen({
    super.key,
    required this.appointment,
  });

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return const Color(0xFFE8A317);
      case 'accepted':
      case 'confirmed':
        return const Color(0xFF1E9E6B);
      case 'rejected':
        return AppColors.error;
      case 'completed':
        return AppColors.primaryStart;
      default:
        return Colors.grey;
    }
  }

  String _initials(String name) {
    if (name.trim().isEmpty) return '?';
    final parts = name.trim().split(RegExp(r'\s+'));
    final first = parts.first.isNotEmpty ? parts.first[0] : '';
    final last = parts.length > 1 && parts.last.isNotEmpty ? parts.last[0] : '';
    return (first + last).toUpperCase();
  }

  

  @override
  Widget build(BuildContext context, WidgetRef ref) {

final appointmentsState = ref.watch(doctorAppointmentProvider);

final currentAppointment = appointmentsState.when(
  data: (appointments) {
    return appointments.firstWhere(
      (item) => item['id'] == appointment['id'],
      orElse: () => appointment,
    );
  },
  loading: () => appointment,
  error: (_, __) => appointment,
);


    final String userName = currentAppointment['userName'] ?? 'Unknown';
final String userEmail = currentAppointment['userEmail'] ?? '';
final String date = currentAppointment['date'] ?? '';
final String time = currentAppointment['time'] ?? '';
final String status =(currentAppointment['status'] ?? '').toString().toLowerCase();
    final statusColor = _statusColor(status);
    final statusLabel = status.isEmpty
        ? 'Unknown'
        : status[0].toUpperCase() + status.substring(1);

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      extendBodyBehindAppBar: true,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ══════════════════════════════════════
          //  HERO HEADER
          // ══════════════════════════════════════
          SliverToBoxAdapter(
            child: _HeroHeader(
              userName: userName,
              userEmail: userEmail,
              initials: _initials(userName),
              statusLabel: statusLabel,
              statusColor: statusColor,
            ),
          ),

          // ══════════════════════════════════════
          //  BODY CONTENT
          // ══════════════════════════════════════
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 22, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionLabel(label: 'Schedule'),
                  const SizedBox(height: 12),
                  _ScheduleCard(
                    date: DateFormatter.formatDate(date),
                    time: formatToAmPm(time),
                    statusLabel: statusLabel,
                    statusColor: statusColor,
                  ),

                  const SizedBox(height: 28),
                  _SectionLabel(label: 'More'),
                  const SizedBox(height: 12),
                  _MoreFeaturesCard(  
                    appointment: currentAppointment,
                  ),

                  // Breathing room so content never sits under the
                  // floating action bar.
                  const SizedBox(height: 110),
                ],
              ),
            ),
          ),
        ],
      ),

      // ══════════════════════════════════════
      //  FLOATING ACCEPT / REJECT BAR
      //  (same logic as before — always available)
      // ══════════════════════════════════════
      bottomNavigationBar:status=='pending'
      ? _ActionBar( 
        onAccept: () {
          ref.read(doctorAppointmentProvider.notifier).updateStatus(
                appointmentId: appointment['id'],
                status: 'confirmed',
              );
        },
        onReject: () {
          ref.read(doctorAppointmentProvider.notifier).updateStatus(
                appointmentId: appointment['id'],
                status: 'rejected',
              );
        },
      ):null,
    );
  }
}

// ════════════════════════════════════════════════════════════
//  HERO HEADER — gradient backdrop, floating glass avatar card
// ════════════════════════════════════════════════════════════
class _HeroHeader extends StatelessWidget {
  final String userName;
  final String userEmail;
  final String initials;
  final String statusLabel;
  final Color statusColor;

  const _HeroHeader({
    required this.userName,
    required this.userEmail,
    required this.initials,
    required this.statusLabel,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // ── Gradient backdrop with decorative circles ──
        Container(
          height: 210 + topPad,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.primaryStart, AppColors.primaryEnd],
            ),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                top: -40,
                right: -30,
                child: _decorCircle(120, 0.12),
              ),
              Positioned(
                bottom: -60,
                left: -40,
                child: _decorCircle(160, 0.10),
              ),
              SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(6, 4, 20, 0),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        'Appointment',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.3,
                        ),
                      ),
                      const Spacer(),
                      const SizedBox(width: 40),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // ── Floating glass identity card, straddling the gradient ──
        Positioned(
          top: 130 + topPad,
          left: 20,
          right: 20,
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryStart.withOpacity(0.18),
                  blurRadius: 24,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.primaryStart, AppColors.primaryEnd],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryStart.withOpacity(0.30),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    initials,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.heading,
                          letterSpacing: -0.2,
                        ),
                      ),
                      if (userEmail.isNotEmpty) ...[
                        const SizedBox(height: 3),
                        Text(
                          userEmail,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12.5,
                            color: AppColors.subtext,
                          ),
                        ),
                      ],
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: statusColor.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              height: 6,
                              width: 6,
                              decoration: BoxDecoration(
                                color: statusColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              statusLabel,
                              style: TextStyle(
                                color: statusColor,
                                fontSize: 11.5,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Reserves layout space for the floating card below the gradient.
        SizedBox(height: 130 + topPad + 92),
      ],
    );
  }

  Widget _decorCircle(double size, double opacity) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(opacity),
        shape: BoxShape.circle,
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════
//  Small uppercase section label
// ════════════════════════════════════════════════════════════
class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      style: TextStyle(
        fontSize: 11.5,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.8,
        color: AppColors.subtext,
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════
//  Schedule card — timeline style with connecting line
// ════════════════════════════════════════════════════════════
class _ScheduleCard extends StatelessWidget {
  final String date;
  final String time;
  final String statusLabel;
  final Color statusColor;

  const _ScheduleCard({
    required this.date,
    required this.time,
    required this.statusLabel,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          _timelineRow(
            icon: Icons.calendar_today_rounded,
            label: 'Date',
            value: date.isEmpty ? '—' : date,
            isFirst: true,
            iconColor: AppColors.primaryStart,
          ),
          _timelineRow(
            icon: Icons.access_time_filled_rounded,
            label: formatToAmPm(time),
            value: time.isEmpty ? '—' : time,
            iconColor: AppColors.primaryStart,
          ),
          _timelineRow(
            icon: Icons.verified_rounded,
            label: 'Status',
            value: statusLabel,
            valueColor: statusColor,
            isLast: true,
            iconColor: statusColor,
          ),
        ],
      ),
    );
  }

  Widget _timelineRow({
    required IconData icon,
    required String label,
    required String value,
    required Color iconColor,
    Color? valueColor,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Icon + connecting line ──
          Column(
            children: [
              Container(
                height: 36,
                width: 36,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.10),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Icon(icon, size: 17, color: iconColor),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    color: const Color(0xFFEEF0F4),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 14),
          // ── Label + value ──
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                top: 6,
                bottom: isLast ? 4 : 22,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF9AA0AC),
                    ),
                  ),
                  const Spacer(),
                  Flexible(
                    child: Text(
                      value,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w700,
                        color: valueColor ?? AppColors.heading,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════
//  More features — premium "coming soon" grid
//  Visual only, not wired up — matches the original placeholder
//  intent (Chat / Video / Audio / Prescription to be added later).
// ════════════════════════════════════════════════════════════
class _MoreFeaturesCard extends StatelessWidget {
  final Map<String, dynamic> appointment;

  const _MoreFeaturesCard({
    required this.appointment,
  });

  static const _features = [
    (Icons.chat_bubble_rounded, 'Chat'),
    (Icons.videocam_rounded, 'Video Call'),
    (Icons.call_rounded, 'Audio Call'),
    (Icons.description_rounded, 'Prescription'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: GridView.count(
        crossAxisCount: 4,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 6,
        children: [
          _FeatureTile(
            icon: Icons.chat_bubble_rounded,
            label: 'Chat',
            showSoon: false,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChatScreen(
                    chatId: appointment['id'],
                    userId: appointment['userId'],
                    userName: appointment['userName'] ?? 'Patient',
                  ),
                ),
              );
            },
          ),
          _FeatureTile(
            icon: Icons.videocam_rounded,
            label: 'Video Call',
            showSoon: false,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => VideoCallScreen(
                    appointment:  appointment['id'],
                  ),
                ),
              );
            },
          ), 
          _FeatureTile(
            onTap: () { 
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          AudioCallScreen(appointmentId: appointment['id'])));
            },
            icon: Icons.call_rounded,
            label: 'Audio Call',
          ),
       _FeatureTile(
  icon: Icons.description_rounded,
  label: 'Prescription',
  showSoon: false,
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PrescriptionUploadScreen(
          appointment: appointment,
        ),
      ),
    );
  },
),
        ],
      ),
    );
  }
}

class _FeatureTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final bool showSoon;

  const _FeatureTile(
      {required this.icon,
      required this.label,
      this.onTap,
      this.showSoon = true});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 46,
                width: 46,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primaryStart.withOpacity(0.10),
                      AppColors.primaryEnd.withOpacity(0.10),
                    ],
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 20, color: AppColors.primaryStart),
              ),
              const SizedBox(height: 7),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.subtext,
                ),
              ),
            ],
          ),
          
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════
//  Floating Accept / Reject action bar
// ════════════════════════════════════════════════════════════
class _ActionBar extends StatelessWidget {
  final VoidCallback onAccept;
  final VoidCallback onReject;

  const _ActionBar({required this.onAccept, required this.onReject});

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).padding.bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(20, 14, 20, 14 + bottomPad),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 52,
              child: OutlinedButton(
                onPressed: onReject,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFFDADDE3)),
                  foregroundColor: AppColors.subtext,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                
child: const Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: const [
    Icon(Icons.close_rounded, size: 18),
    SizedBox(width: 5),
    Flexible(
      child: Text(
        'Reject',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 14,
        ),
      ),
    ),
  ],
)

                // child: Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: const [
                //     Icon(Icons.close_rounded, size: 19),
                //     SizedBox(width: 7),
                //     Text(
                //       'Reject',
                //       style: TextStyle(
                //         fontWeight: FontWeight.w700,
                //         fontSize: 15,
                //       ),
                //     ),
                //   ],
                // ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: Container(
              height: 52,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primaryStart, AppColors.primaryEnd],
                ),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryStart.withOpacity(0.35),
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: onAccept,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.check_rounded, size: 20, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        'Accept Appointment',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
