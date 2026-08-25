import 'package:dr_app/features/doctor/presentation/controllers/providers/dr_nav_provider.dart';
import 'package:dr_app/features/doctor/presentation/screens/appointment/doctor_appointments_screen.dart';
import 'package:dr_app/features/doctor/presentation/screens/doctor_profile_screen.dart';
import 'package:dr_app/features/doctor/presentation/screens/dr_slot_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'dashboard_screen.dart';

class DoctorMainScreen extends ConsumerWidget {
  const DoctorMainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(doctorNavIndexProvider);

    final pages = [
      const DashboardScreen(),
      const DoctorAppointmentsScreen(),
      const DoctorSlotScreen(),
      const DoctorProfileScreen(),
    ];

    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          ref.read(doctorNavIndexProvider.notifier).state = index;
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
             BottomNavigationBarItem(
    icon: Icon(Icons.calendar_month),
    label: "Appointments",
  ),
          BottomNavigationBarItem(
            icon: Icon(Icons.access_time),
            label: "Slots",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
         

        ],
      ),
    );
  }
}
