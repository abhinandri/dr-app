
import 'package:dr_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:dr_app/core/utils/time_utils.dart';

class AppointmentCard extends StatelessWidget {
  final Map<String, dynamic> appointment;

  final VoidCallback? onTap;

  const AppointmentCard({
    super.key,
    required this.appointment,
    this.onTap,
  });

  // ── Status → gradient + icon ──
  List<Color> _statusGradient(String status) {
  switch (status.toLowerCase()) {
    case 'pending':
      return const [Color(0xFFF2AF3D), Color(0xFFE8A317)];

    case 'confirmed':
    case 'accepted':
      return const [Color(0xFF34C58E), Color(0xFF1E9E6B)];

    case 'rejected':
      return [AppColors.error.withOpacity(0.85), AppColors.error];

    case 'completed':
      return [AppColors.primaryStart, AppColors.primaryEnd];

    default:
      return const [Color(0xFFB3BAC6), Color(0xFF98A1B0)];
  }
}

IconData _statusIcon(String status) {
  switch (status.toLowerCase()) {
    case 'pending':
      return Icons.hourglass_top_rounded;

    case 'confirmed':
    case 'accepted':
      return Icons.check_circle_rounded;

    case 'rejected':
      return Icons.cancel_rounded;

    case 'completed':
      return Icons.task_alt_rounded;

    default:
      return Icons.help_outline_rounded;
  }
}

  DateTime? _tryParseDate(String date) {
    try {
      return DateTime.parse(date);
    } catch (_) {
      return null;
    }
  }

  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  String _displayDate(String raw) {
    final parsed = _tryParseDate(raw);
    if (parsed == null) return raw;
    return '${_months[parsed.month - 1]} ${parsed.day}, ${parsed.year}';
  }

  String _initials(String name) {
    if (name.trim().isEmpty) return '?';
    final parts = name.trim().split(RegExp(r'\s+'));
    final first = parts.first.isNotEmpty ? parts.first[0] : '';
    final last = parts.length > 1 && parts.last.isNotEmpty ? parts.last[0] : '';
    return (first + last).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final String userName = appointment['userName'] ?? 'Unknown';
    final String date = appointment['date'] ?? '';
    final String time = appointment['time'] ?? '';
    final String status = (appointment['status'] ?? '').toString();
    final gradient = _statusGradient(status);
   final statusLabel = switch (status.toLowerCase()) {
  'confirmed' || 'accepted' => 'Accepted',
  'pending' => 'Pending',
  'rejected' => 'Rejected',
  'completed' => 'Completed',
  _ => 'Unknown',
};

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryStart.withOpacity(0.07),
                blurRadius: 22,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // ── Gradient avatar ──
                    Container(
                      height: 46,
                      width: 46,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [AppColors.primaryStart, AppColors.primaryEnd],
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryStart.withOpacity(0.30),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        _initials(userName),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const SizedBox(width: 13),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userName,
                            style: TextStyle(
                              fontSize: 15.5,
                              fontWeight: FontWeight.w700,
                              color: AppColors.heading,
                              letterSpacing: -0.1,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Patient',
                            style: TextStyle(
                              fontSize: 11.5,
                              color: AppColors.subtext,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    // ── Gradient status pill ──
                    Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: gradient),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: gradient.last.withOpacity(0.30),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(_statusIcon(status), size: 12, color: Colors.white),
                          const SizedBox(width: 4),
                          Text(
                            statusLabel,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // ── Date / time pills ──
                Row(
                  children: [
                    Expanded(
                      child: _InfoPill(
                        icon: Icons.calendar_today_rounded,
                        label: _displayDate(date),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _InfoPill(
                        icon: Icons.access_time_rounded,
                        label: formatToAmPm(time),
                      ),
                    ),
                  ],
                ),

            
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Small soft-tinted pill used for the date / time row.
class _InfoPill extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoPill({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: AppColors.primaryStart.withOpacity(0.06),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.primaryStart),
          const SizedBox(width: 7),
          Flexible(
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: AppColors.heading,
              ),
            ),
          ),
        ],
      ),
    );
  }
}