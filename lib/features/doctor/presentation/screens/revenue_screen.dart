import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:dr_app/core/theme/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../controllers/providers/revenue_provider.dart';
class RevenueScreen extends ConsumerStatefulWidget {
   RevenueScreen({super.key});

  @override
  ConsumerState<RevenueScreen> createState() => _RevenueScreenState();
}

class _RevenueScreenState extends ConsumerState<RevenueScreen>{

  @override
void initState() {
  super.initState();

  final doctorId = FirebaseAuth.instance.currentUser!.uid;

  Future.microtask(() {
    ref.read(revenueProvider.notifier).loadRevenue(doctorId);
  });
}
DateTime? _startDate;
DateTime? _endDate;

Future<DateTime?> _selectDate(BuildContext context) async {
  return showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(2020),
    lastDate: DateTime.now(),
  );
}

@override
Widget build(BuildContext context) {
  final revenueState = ref.watch(revenueProvider);

  return revenueState.when(
    loading: () => const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    ),
    error: (error, stack) => Scaffold(
      body: Center(
        child: Text(error.toString()),
      ),
    ),
    data: (appointments) {

     
final paidRecords = appointments.where((appointment) {
  if (appointment['paymentStatus'] != 'paid') {
    return false;
  }

  final rawDate = appointment['createdAt'] ??
      appointment['date'];

DateTime? appointmentDate;

if (rawDate is Timestamp) {
  appointmentDate = rawDate.toDate();
} else if (rawDate is DateTime) {
  appointmentDate = rawDate;
} else if (rawDate is String) {
  appointmentDate = DateTime.tryParse(rawDate);
}

  if (appointmentDate == null) return false;

  final date = DateTime(
    appointmentDate.year,
    appointmentDate.month,
    appointmentDate.day,
  );

  if (_startDate != null && date.isBefore(_startDate!)) {
    return false;
  }

  // if (_endDate != null &&
  //     date.isAfter(
  //       DateTime(_endDate!.year, _endDate!.month, _endDate!.day, 23, 59, 59),
  //     )) {
  //   return false;
  // }

if (_endDate != null) {
  final endExclusive = DateTime(
    _endDate!.year,
    _endDate!.month,
    _endDate!.day + 1,
  );

  if (!date.isBefore(endExclusive)) return false;
}


  return true;
}).toList();

final paidAppointments = paidRecords.length;


      double totalRevenue = 0;

      for (final appointment in paidRecords) {
        final fee = appointment['consultationFee'];

        if (fee is num) {
          totalRevenue += fee.toDouble();
        }
      }

      final averageEarnings = paidAppointments == 0
          ? 0.0
          : totalRevenue / paidAppointments;

       return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: Stack(
        children: [
          // Gradient header
          Container(
            height: 310,
            decoration: const BoxDecoration(
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

          // Curved transition
          Positioned(
            top: 400,
            left: 0,
            right: 0,
            child: Container(
              height: 100,
              decoration: const BoxDecoration(
                color: AppColors.scaffoldBg,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(36),
                  topRight: Radius.circular(36),
                ),
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.18),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withOpacity(0.30),
                          ),
                        ),
                        child: const Icon(
                          Icons.account_balance_wallet_rounded,
                          color: Colors.white,
                          size: 21,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Revenue',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 21,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 3),
                          Text(
                            'Track your earnings',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12.5,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  // Total Revenue Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.18),
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.30),
                      ),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Total Revenue',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '₹${totalRevenue.toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'From paid appointments',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 11.5,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 22),

                  
const SizedBox(height: 18),

Container(
  padding: const EdgeInsets.all(14),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(16),
  ),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'Filter Revenue by Date',
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w700,
          color: AppColors.heading,
        ),
      ),
      const SizedBox(height: 12),
      Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              icon: const Icon(Icons.calendar_today),
              label: Text(
                _startDate == null
                    ? 'From date'
                    : '${_startDate!.day}/${_startDate!.month}/${_startDate!.year}',
              ),
              onPressed: () async {
                final date = await _selectDate(context);
                if (date == null) return;

                if (_endDate != null && date.isAfter(_endDate!)) {
                  setState(() => _endDate = null);
                }

                setState(() => _startDate = date);
              },
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: OutlinedButton.icon(
              icon: const Icon(Icons.calendar_today),
              label: Text(
                _endDate == null
                    ? 'To date'
                    : '${_endDate!.day}/${_endDate!.month}/${_endDate!.year}',
              ),
              onPressed: () async {
                final date = await _selectDate(context);
                if (date == null) return;

                if (_startDate != null && date.isBefore(_startDate!)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'End date must be on or after the start date.',
                      ),
                    ),
                  );
                  return;
                }

                setState(() => _endDate = date);
              },
            ),
          ),
        ],
      ),
      Align(
        alignment: Alignment.centerRight,
        child: TextButton(
          onPressed: () {
            setState(() {
              _startDate = null;
              _endDate = null;
            });
          },
          child: const Text('Clear filter'),
        ),
      ),
    ],
  ),
),


                  // Statistics
                  Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          icon: Icons.payments_rounded,
                          value: '$paidAppointments',
                          label: 'Paid Appointments',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _StatCard(
                          icon: Icons.trending_up_rounded,
                          value: '₹${averageEarnings.toStringAsFixed(0)}',
                          label: 'Average Earnings',
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  // Recent Earnings heading
                  Row(
                    children: [
                      const Text(
                        'Recent Earnings',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: AppColors.heading,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryStart.withOpacity(0.10),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Paid',
                          style: TextStyle(
                            color: AppColors.primaryStart,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // Empty state for now
                  // Container(
                  //   width: double.infinity,
                  //   padding: const EdgeInsets.symmetric(
                  //     horizontal: 20,
                  //     vertical: 35,
                  //   ),
                  //   decoration: BoxDecoration(
                  //     color: Colors.white,
                  //     borderRadius: BorderRadius.circular(20),
                  //     boxShadow: [
                  //       BoxShadow(
                  //         color: Colors.black.withOpacity(0.04),
                  //         blurRadius: 18,
                  //         offset: const Offset(0, 5),
                  //       ),
                  //     ],
                  //   ),
                  //   child: const Column(
                  //     children: [
                  //       Icon(
                  //         Icons.receipt_long_rounded,
                  //         size: 42,
                  //         color: AppColors.subtext,
                  //       ),
                  //       SizedBox(height: 12),
                  //       Text(
                  //         'No earnings yet',
                  //         style: TextStyle(
                  //           fontSize: 15,
                  //           fontWeight: FontWeight.w700,
                  //           color: AppColors.heading,
                  //         ),
                  //       ),
                  //       SizedBox(height: 5),
                  //       Text(
                  //         'Paid appointment earnings will appear here.',
                  //         textAlign: TextAlign.center,
                  //         style: TextStyle(
                  //           fontSize: 12.5,
                  //           color: AppColors.subtext,
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
if (paidRecords.isEmpty)
  Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(
      horizontal: 20,
      vertical: 35,
    ),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.04),
          blurRadius: 18,
          offset: const Offset(0, 5),
        ),
      ],
    ),
    child: const Column(
      children: [
        Icon(
          Icons.receipt_long_rounded,
          size: 42,
          color: AppColors.subtext,
        ),
        SizedBox(height: 12),
        Text(
          'No earnings yet',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: AppColors.heading,
          ),
        ),
        SizedBox(height: 5),
        Text(
          'Paid appointment earnings will appear here.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12.5,
            color: AppColors.subtext,
          ),
        ),
      ],
    ),
  )
else
  Column(
    children: paidRecords.take(5).map((appointment) {
      final fee = (appointment['consultationFee'] as num?)?.toDouble() ?? 0;

      final date = appointment['date']?.toString() ?? '';
      final doctorName =
          appointment['doctorName']?.toString() ?? 'Consultation';

      return Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.primaryStart.withOpacity(0.10),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.payments_rounded,
                color: AppColors.primaryStart,
                size: 21,
              ),
            ),
            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    doctorName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.heading,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    date,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.subtext,
                    ),
                  ),
                ],
              ),
            ),

            Text(
              '₹${fee.toStringAsFixed(0)}',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: AppColors.primaryStart,
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
          ),
        ],
      ),
    );
    },
  );
}

}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppColors.primaryStart.withOpacity(0.10),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: AppColors.primaryStart,
              size: 20,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w800,
              color: AppColors.heading,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 11.5,
              color: AppColors.subtext,
            ),
          ),
        ],
      ),
    );
  }
}
