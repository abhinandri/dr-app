import 'package:dr_app/features/doctor/presentation/controllers/notifiers/revenue_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/usecases/get_doctor_revenue.dart';
import 'doctor_repository_provider.dart';

final getDoctorRevenueProvider = Provider<GetDoctorRevenue>((ref) {
  final repository = ref.read(doctorRepositoryProvider);

  return GetDoctorRevenue(repository);
});

final revenueProvider = StateNotifierProvider<
    RevenueNotifier,
    AsyncValue<List<Map<String, dynamic>>>>((ref) {
  final getDoctorRevenue = ref.read(getDoctorRevenueProvider);

  return RevenueNotifier(getDoctorRevenue);
});