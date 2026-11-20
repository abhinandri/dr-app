import 'package:dr_app/features/doctor/domain/usecases/get_doctor_revenue.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class RevenueNotifier
    extends StateNotifier<AsyncValue<List<Map<String, dynamic>>>> {
  final GetDoctorRevenue getDoctorRevenue;

  RevenueNotifier(this.getDoctorRevenue)
      : super(const AsyncLoading());

  Future<void> loadRevenue(String doctorId) async {
    try {
      state = const AsyncLoading();

      final appointments = await getDoctorRevenue(doctorId);
 print('REVENUE DOCTOR ID: $doctorId');
    print('TOTAL APPOINTMENTS: ${appointments.length}');
    print('APPOINTMENTS: $appointments');
      final paidAppointments = appointments.where((appointment) {
           print(
        'PAYMENT STATUS: ${appointment['paymentStatus']} | '
        'FEE: ${appointment['consultationFee']}',
      );

        return appointment['paymentStatus'] == 'paid';
      }).toList();

          print('PAID APPOINTMENTS: ${paidAppointments.length}');


      state = AsyncData(paidAppointments);
    } catch (e, st) {
          print('REVENUE ERROR: $e');

      state = AsyncError(e, st);
    }
  }
}