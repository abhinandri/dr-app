
import 'package:dr_app/core/theme/app_colors.dart';
import 'package:dr_app/features/doctor/presentation/controllers/notifiers/doctor_auth_controller.dart';
import 'package:dr_app/features/doctor/presentation/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DoctorSettingsScreen extends ConsumerWidget {
  const DoctorSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        title: const Text('Settings'),
        foregroundColor: Colors.white,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primaryStart,
                AppColors.primaryEnd,
              ],
            ),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _sectionTitle('Preferences'),
          const SizedBox(height: 12),
          _settingsCard([
            _SettingsItem(
              icon: Icons.notifications_none_rounded,
              title: 'Notifications',
              subtitle: 'Appointment reminders and updates',
              onTap: () => _showMessage(
                context,
                'Notification preferences will be added later.',
              ),
            ),
            _SettingsItem(
              icon: Icons.lock_outline_rounded,
              title: 'Privacy & Security',
              subtitle: 'Account security information',
              onTap: () => _showPrivacyDialog(context),
              showDivider: false,
            ),
          ]),
          const SizedBox(height: 28),
          _sectionTitle('About'),
          const SizedBox(height: 12),
          _settingsCard([
            _SettingsItem(
              icon: Icons.info_outline_rounded,
              title: 'About Medivo',
              subtitle: 'App information',
              onTap: () {
                showAboutDialog(
                  context: context,
                  applicationName: 'Medivo',
                  applicationVersion: '1.0.0',
                  applicationLegalese: 'Healthcare appointment app',
                );
              },
              showDivider: false,
            ),
          ]),
          const SizedBox(height: 28),
          _settingsCard([
            _SettingsItem(
              icon: Icons.logout_rounded,
              title: 'Logout',
              subtitle: 'Sign out of your account',
              isDestructive: true,
              showDivider: false,
              onTap: () => _confirmLogout(context, ref),
            ),
          ]),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        color: AppColors.heading,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _settingsCard(List<_SettingsItem> items) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: items.map((item) {
          return Column(
            children: [
              ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 5,
                ),
                leading: Icon(
                  item.icon,
                  color: item.isDestructive
                      ? Colors.red
                      : AppColors.primaryStart,
                  size: 26,
                ),
                title: Text(
                  item.title,
                  style: TextStyle(
                    color: item.isDestructive
                        ? Colors.red
                        : AppColors.heading,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(item.subtitle),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: item.onTap,
              ),
              if (item.showDivider)
                const Divider(height: 1, indent: 56, endIndent: 16),
            ],
          );
        }).toList(),
      ),
    );
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _showPrivacyDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Privacy & Security'),
        content: const Text(
          'Keep your login credentials private. '
          'If you need to reset your password, use the '
          'password-reset option on the Doctor Login screen.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmLogout(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (shouldLogout != true || !context.mounted) return;

    await ref.read(doctorAuthControllerProvider.notifier).logout();

    if (!context.mounted) return;

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => const DoctorLoginScreen(),
      ),
      (_) => false,
    );
  }
}

class _SettingsItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool showDivider;
  final bool isDestructive;

  const _SettingsItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.showDivider = true,
    this.isDestructive = false,
  });
}
