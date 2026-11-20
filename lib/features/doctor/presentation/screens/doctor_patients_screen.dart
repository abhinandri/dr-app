
import 'package:dr_app/core/theme/app_colors.dart';
import 'package:dr_app/features/doctor/presentation/controllers/providers/appointment_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DoctorPatientsScreen extends ConsumerStatefulWidget {
  const DoctorPatientsScreen({super.key});

  @override
  ConsumerState<DoctorPatientsScreen> createState() =>
      _DoctorPatientsScreenState();
}

class _DoctorPatientsScreenState
    extends ConsumerState<DoctorPatientsScreen> {
  final TextEditingController _searchController =
      TextEditingController();

  String _searchQuery = '';

  String get _doctorId => FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(doctorAppointmentProvider.notifier)
          .loadAppointments(_doctorId);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> _getUniquePatients(
    List<Map<String, dynamic>> appointments,
  ) {
    final Map<String, Map<String, dynamic>> patients = {};

    for (final appointment in appointments) {
      final userId = appointment['userId']?.toString() ?? '';

      if (userId.isEmpty) continue;

      if (!patients.containsKey(userId)) {
        patients[userId] = {
          'userId': userId,
          'userName': appointment['userName']?.toString() ?? 'Unknown',
          'userEmail': appointment['userEmail']?.toString() ?? '',
          'appointmentCount': 0,
          'appointments': <Map<String, dynamic>>[],
        };
      }

      patients[userId]!['appointmentCount'] =
          (patients[userId]!['appointmentCount'] as int) + 1;

      (patients[userId]!['appointments']
              as List<Map<String, dynamic>>)
          .add(appointment);
    }

    return patients.values.toList()
      ..sort((a, b) => a['userName']
          .toString()
          .toLowerCase()
          .compareTo(b['userName'].toString().toLowerCase()));
  }

  String _getInitials(String name) {
    if (name.trim().isEmpty || name == 'Unknown') return '?';

    final parts = name.trim().split(RegExp(r'\s+'));

    final first = parts.first[0];
    final last = parts.length > 1 ? parts.last[0] : '';

    return (first + last).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final appointmentState = ref.watch(doctorAppointmentProvider);

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        title: const Text(
          'Patients',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.primaryStart,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: appointmentState.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text('Unable to load patients: $error'),
          ),
        ),
        data: (rawAppointments) {
          final appointments =
              rawAppointments.cast<Map<String, dynamic>>();

          final allPatients = _getUniquePatients(appointments);

          final filteredPatients = allPatients.where((patient) {
            final name =
                patient['userName'].toString().toLowerCase();
            final email =
                patient['userEmail'].toString().toLowerCase();

            return name.contains(_searchQuery) ||
                email.contains(_searchQuery);
          }).toList();

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${allPatients.length} Total Patients',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.heading,
                      ),
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: _searchController,
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value.trim().toLowerCase();
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Search patients...',
                        prefixIcon: const Icon(Icons.search_rounded),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() {
                                    _searchQuery = '';
                                  });
                                },
                                icon: const Icon(Icons.close_rounded),
                              )
                            : null,
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: filteredPatients.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.people_outline_rounded,
                              size: 55,
                              color: AppColors.subtext,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              _searchQuery.isEmpty
                                  ? 'No patients found'
                                  : 'No matching patients',
                              style: TextStyle(
                                color: AppColors.subtext,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: () async {
                          await ref
                              .read(doctorAppointmentProvider.notifier)
                              .loadAppointments(_doctorId);
                        },
                        child: ListView.separated(
                          padding: const EdgeInsets.fromLTRB(
                              20, 0, 20, 24),
                          itemCount: filteredPatients.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final patient = filteredPatients[index];

                            final name =
                                patient['userName'].toString();
                            final email =
                                patient['userEmail'].toString();
                            final count =
                                patient['appointmentCount'] as int;

                            return Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(18),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black
                                        .withOpacity(0.035),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 26,
                                    backgroundColor:
                                        AppColors.primaryStart
                                            .withOpacity(0.12),
                                    child: Text(
                                      _getInitials(name),
                                      style: TextStyle(
                                        color:
                                            AppColors.primaryStart,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          name,
                                          maxLines: 1,
                                          overflow:
                                              TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: AppColors.heading,
                                            fontSize: 15,
                                            fontWeight:
                                                FontWeight.w700,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          email.isEmpty
                                              ? 'No email available'
                                              : email,
                                          maxLines: 1,
                                          overflow:
                                              TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: AppColors.subtext,
                                            fontSize: 12,
                                          ),
                                        ),
                                        const SizedBox(height: 7),
                                        Text(
                                          '$count appointment${count == 1 ? '' : 's'}',
                                          style: TextStyle(
                                            color:
                                                AppColors.primaryStart,
                                            fontSize: 12,
                                            fontWeight:
                                                FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Icon(
                                    Icons.chevron_right_rounded,
                                    color: AppColors.subtext,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
