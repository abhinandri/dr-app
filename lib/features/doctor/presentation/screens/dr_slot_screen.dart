
import 'package:dr_app/core/theme/app_colors.dart';
import 'package:dr_app/core/utils/time_utils.dart';
import 'package:dr_app/features/doctor/presentation/controllers/providers/availability_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DoctorSlotScreen extends ConsumerStatefulWidget {
  const DoctorSlotScreen({super.key});

  @override
  ConsumerState<DoctorSlotScreen> createState() => _DoctorSlotScreenState();
}

class _DoctorSlotScreenState extends ConsumerState<DoctorSlotScreen> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  // ================= DATE PICKER =================
  Future<void> pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(
            primary: AppColors.primaryStart,
            onPrimary: Colors.white,
            surface: Colors.white,
            onSurface: AppColors.heading,
          ),
        ),
        child: child!,
      ),
    );
    if (date != null) setState(() => selectedDate = date);
  }

  // ================= TIME PICKER =================
  Future<void> pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(
            primary: AppColors.primaryStart,
            onPrimary: Colors.white,
            surface: Colors.white,
            onSurface: AppColors.heading,
          ),
        ),
        child: child!,
      ),
    );
    if (time != null) setState(() => selectedTime = time);
  }

  // ================= SAVE SLOT =================
  Future<void> saveSlot() async {
    if (selectedDate == null || selectedTime == null) {
      _showSnackBar("Please select both date and time", isError: true);
      return;
    }

    final doctorId = FirebaseAuth.instance.currentUser!.uid;

    final formattedDate =
        "${selectedDate!.year}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.day.toString().padLeft(2, '0')}";

    final formattedTime =
        "${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}";

    await ref.read(availabilityProvider.notifier).addAvailability(
          doctorId: doctorId,
          date: formattedDate,
          time: formattedTime,
        );

    _showSnackBar("Slot added successfully!");
    setState(() {
      selectedDate = null;
      selectedTime = null;
    });
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError ? Icons.error_outline : Icons.check_circle_outline,
              color: Colors.white,
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(message),
          ],
        ),
        backgroundColor: isError ? AppColors.error : AppColors.primaryStart,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  // ================= BUILD =================
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(availabilityProvider);
    final isLoading = state.isLoading;
    final availability = state.availability;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: Stack(
        children: [
          // ── Gradient header (same as profile screen) ──
          Container(
            height: 220,
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

          // ── Curved white overlay ──
          Positioned(
            top: 180,
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

          // ── Content ──
          SafeArea(
            child: Column(
              children: [
                // Custom App Bar
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Row(
                    children: [
                      const SizedBox(width: 48), // Balance for centering
                      const Expanded(
                        child: Text(
                          "Manage Slots",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                ),

                // ── Slot Summary Chips ──
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 12),
                  child: Row(
                    children: [
                      _buildSummaryChip(
                        icon: Icons.event_available_rounded,
                        label:
                            "${availability.length} Day${availability.length != 1 ? 's' : ''}",
                        subtitle: "Scheduled",
                      ),
                      const SizedBox(width: 12),
                      _buildSummaryChip(
                        icon: Icons.access_time_rounded,
                        label:
                            "${availability.values.fold(0, (sum, times) => sum + times.length)} Slot${availability.values.fold(0, (s, t) => s + t.length) != 1 ? 's' : ''}",
                        subtitle: "Total",
                      ),
                    ],
                  ),
                ),

                // ── Main Scrollable Body ──
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Add Slot Card ──
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primaryStart.withOpacity(0.08),
                                blurRadius: 24,
                                spreadRadius: 0,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Card header
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            AppColors.primaryStart
                                                .withOpacity(0.15),
                                            AppColors.primaryEnd
                                                .withOpacity(0.15),
                                          ],
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(12),
                                      ),
                                      child: Icon(
                                        Icons.add_circle_outline_rounded,
                                        color: AppColors.primaryStart,
                                        size: 22,
                                      ),
                                    ),
                                    const SizedBox(width: 14),
                                    Text(
                                      "Add New Slot",
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.heading,
                                        letterSpacing: 0.2,
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 20),

                                // Date Picker
                                _label("Date"),
                                const SizedBox(height: 8),
                                _PickerTile(
                                  icon: Icons.calendar_today_rounded,
                                  value: selectedDate == null
                                      ? "Select Date"
                                      : _formatDate(selectedDate!),
                                  isSelected: selectedDate != null,
                                  onTap: pickDate,
                                ),

                                const SizedBox(height: 16),

                                // Time Picker
                                _label("Time"),
                                const SizedBox(height: 8),
                                _PickerTile(
                                  icon: Icons.access_time_rounded,
                                  value: selectedTime == null
                                      ? "Select Time"
                                      : selectedTime!.format(context),
                                  isSelected: selectedTime != null,
                                  onTap: pickTime,
                                ),

                                const SizedBox(height: 24),

                                // Add Slot Button
                                SizedBox(
                                  width: double.infinity,
                                  height: 52,
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: isLoading
                                            ? [
                                                Colors.grey.shade300,
                                                Colors.grey.shade300,
                                              ]
                                            : [
                                                AppColors.primaryStart,
                                                AppColors.primaryEnd,
                                              ],
                                      ),
                                      borderRadius:
                                          BorderRadius.circular(16),
                                      boxShadow: isLoading
                                          ? []
                                          : [
                                              BoxShadow(
                                                color: AppColors.primaryStart
                                                    .withOpacity(0.35),
                                                blurRadius: 16,
                                                offset: const Offset(0, 6),
                                              ),
                                            ],
                                    ),
                                    child: ElevatedButton(
                                      onPressed: isLoading ? null : saveSlot,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                        shadowColor: Colors.transparent,
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                      ),
                                      child: isLoading
                                          ? const SizedBox(
                                              width: 22,
                                              height: 22,
                                              child: CircularProgressIndicator(
                                                color: Colors.white,
                                                strokeWidth: 2.5,
                                              ),
                                            )
                                          : Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: const [
                                                Icon(Icons.add_rounded,
                                                    size: 20),
                                                SizedBox(width: 8),
                                                Text(
                                                  "Add Slot",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                    letterSpacing: 0.3,
                                                  ),
                                                ),
                                              ],
                                            ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 28),

                        // ── Added Slots Section ──
                        if (availability.isNotEmpty) ...[
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      AppColors.primaryStart.withOpacity(0.15),
                                      AppColors.primaryEnd.withOpacity(0.15),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Icons.event_note_rounded,
                                  color: AppColors.primaryStart,
                                  size: 22,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Text(
                                "Scheduled Slots",
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.heading,
                                  letterSpacing: 0.2,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          ...availability.entries.map((entry) {
                            final date = entry.key;
                            final times = entry.value;

                            return Container(
                              width: double.infinity,
                              margin: const EdgeInsets.only(bottom: 14),
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
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    // Date header row
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                AppColors.primaryStart,
                                                AppColors.primaryEnd,
                                              ],
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Icon(
                                                Icons.calendar_today_rounded,
                                                color: Colors.white,
                                                size: 14,
                                              ),
                                              const SizedBox(width: 6),
                                              Text(
                                                _formatDate(
                                                    DateTime.parse(date)),
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 13,
                                                  letterSpacing: 0.2,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Spacer(),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: AppColors.primaryStart
                                                .withOpacity(0.1),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Text(
                                            "${times.length} slot${times.length != 1 ? 's' : ''}",
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.primaryStart,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 14),

                                    Wrap(
                                      spacing: 8,
                                      runSpacing: 8,
                                      children: times.map<Widget>((time) {
                                        return Container(
                                          decoration: BoxDecoration(
                                            color: AppColors.primaryStart
                                                .withOpacity(0.08),
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            border: Border.all(
                                              color: AppColors.primaryStart
                                                  .withOpacity(0.25),
                                              width: 1.2,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        12, 7, 6, 7),
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons
                                                          .access_time_rounded,
                                                      size: 14,
                                                      color:
                                                          AppColors.primaryStart,
                                                    ),
                                                    const SizedBox(width: 5),
                                                    Text(
                                                      formatToAmPm(time),
                                                      style: TextStyle(
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: AppColors
                                                            .primaryStart,
                                                        letterSpacing: 0.2,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  final doctorId =
                                                      FirebaseAuth.instance
                                                          .currentUser!.uid;
                                                  ref
                                                      .read(availabilityProvider
                                                          .notifier)
                                                      .removeAvailability(
                                                        doctorId: doctorId,
                                                        date: date,
                                                        time: time,
                                                      );
                                                },
                                                child: Container(
                                                  margin:
                                                      const EdgeInsets.only(
                                                          right: 6),
                                                  padding:
                                                      const EdgeInsets.all(3),
                                                  decoration: BoxDecoration(
                                                    color: AppColors.primaryStart
                                                        .withOpacity(0.15),
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Icon(
                                                    Icons.close_rounded,
                                                    size: 13,
                                                    color:
                                                        AppColors.primaryStart,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ] else ...[
                          // Empty state
                          const SizedBox(height: 20),
                          Center(
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(24),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        AppColors.primaryStart.withOpacity(0.1),
                                        AppColors.primaryEnd.withOpacity(0.1),
                                      ],
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: ShaderMask(
                                    shaderCallback: (bounds) =>
                                        LinearGradient(
                                      colors: [
                                        AppColors.primaryStart,
                                        AppColors.primaryEnd,
                                      ],
                                    ).createShader(bounds),
                                    child: const Icon(
                                      Icons.event_busy_rounded,
                                      size: 48,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  "No slots added yet",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.heading,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  "Add your availability above",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.subtext,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
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

  // ── Summary Chip (header stat) ──────────────────────────────────────────
  Widget _buildSummaryChip({
    required IconData icon,
    required String label,
    required String subtitle,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withOpacity(0.4),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ── Helper Widgets ───────────────────────────────────────────────────────
  Widget _label(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: AppColors.subtext,
        letterSpacing: 0.4,
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return "${months[date.month - 1]} ${date.day}, ${date.year}";
  }
}

// ================= Picker Tile =================

class _PickerTile extends StatelessWidget {
  final IconData icon;
  final String value;
  final bool isSelected;
  final VoidCallback onTap;

  const _PickerTile({
    required this.icon,
    required this.value,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryStart.withOpacity(0.05)
              : AppColors.scaffoldBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? AppColors.primaryStart.withOpacity(0.5)
                : Colors.grey.withOpacity(0.2),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primaryStart.withOpacity(0.12)
                    : Colors.grey.withOpacity(0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                size: 18,
                color: isSelected ? AppColors.primaryStart : Colors.grey,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight:
                      isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected ? AppColors.heading : Colors.grey,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: isSelected
                  ? AppColors.primaryStart.withOpacity(0.6)
                  : Colors.grey.withOpacity(0.4),
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}