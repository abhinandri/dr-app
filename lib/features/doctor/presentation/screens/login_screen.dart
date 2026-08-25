import 'package:dr_app/core/theme/app_colors.dart';
import 'package:dr_app/core/utils/validators_login_signup.dart';
import 'package:dr_app/features/doctor/presentation/controllers/notifiers/doctor_auth_controller.dart';
import 'package:dr_app/features/doctor/presentation/controllers/notifiers/splash_controller.dart';
import 'package:dr_app/features/doctor/presentation/screens/dr_main_screen.dart';
import 'package:dr_app/features/doctor/presentation/screens/rejected_screen.dart';
import 'package:dr_app/features/doctor/presentation/screens/signup_screen.dart';
import 'package:dr_app/features/doctor/presentation/screens/waiting_approval_screen.dart';
import 'package:dr_app/features/doctor/presentation/widgets/custome_text_field_signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DoctorLoginScreen extends ConsumerStatefulWidget {
  const DoctorLoginScreen({super.key});

  @override
  ConsumerState<DoctorLoginScreen> createState() => _DoctorLoginScreenState();
}

class _DoctorLoginScreenState extends ConsumerState<DoctorLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController emailController;
  late final TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void handleLogin() async {
    try {
      final route = await ref.read(doctorAuthControllerProvider.notifier).login(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          );

      if (!mounted) return;

      switch (route) {
        case SplashRoute.dashboard:
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const DoctorMainScreen()),
          );
          break;

        case SplashRoute.waiting:
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const WaitingApprovalScreen()),
          );
          break;

        case SplashRoute.rejected:
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const RejectedScreen()),
          );
          break;

        case SplashRoute.login:
          // stay here
          break;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          behavior: SnackBarBehavior.floating,
          backgroundColor: const Color(0xFF1A1F36),
        ),
      );
    }
  }

  void _showForgotPasswordDialog(BuildContext context) {
    final emailResetController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Reset Password'),
        content: TextField(
          controller: emailResetController,
          decoration: const InputDecoration(
            labelText: 'Email',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await ref
                    .read(doctorAuthControllerProvider.notifier)
                    .sendPasswordReset(
                      emailResetController.text.trim(),
                    );

                if (!mounted) return;

                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Password reset email sent'),
                  ),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(e.toString())),
                );
              }
            },
            child: const Text('Send'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(doctorAuthControllerProvider);

    ref.listen<AsyncValue<void>>(
      doctorAuthControllerProvider,
      (previous, next) {
        next.whenOrNull(
          error: (e, _) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(e.toString()),
                behavior: SnackBarBehavior.floating,
                backgroundColor: AppColors.error,
              ),
            );
          },
          data: (_) {
            // Now safe: authStateProvider will trigger rebuild of MyApp
            // No need to navigate manually — root will handle it
          },
        );
      },
    );

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 60),
                // Header Section
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Welcome Back,',
                      style: TextStyle(
                        fontSize: 36, 
                        fontWeight: FontWeight.bold,
                        color: AppColors.heading,
                        letterSpacing: -1,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [AppColors.primaryStart, AppColors.primaryEnd],
                      ).createShader(bounds),
                      child: const Text(
                        'Doctor',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: -1,
                          height: 1.2,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Sign in to continue your practice',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.subtext,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 48),
                // Form Section
                Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    children: [
                      // Email Field
                      AppTextFormField(
                        controller: emailController,
                        label: 'Email Address',
                        icon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        validator: Validators.email,
                      ),
                      // Password Field
                      AppTextFormField(
                        controller: passwordController,
                        label: 'Password',
                        icon: Icons.lock_outline_rounded,
                        obscureText: true,
                        validator: Validators.password,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                            onPressed: () => _showForgotPasswordDialog(context),
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.symmetric(horizontal: 4),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: const Text(
                              'Forgot password?',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.primaryStart),
                            )),
                      ),
                      const SizedBox(height: 32),
                      // Login Button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                AppColors.primaryStart,
                                AppColors.primaryEnd
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primaryStart.withOpacity(0.4),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: state.isLoading
                                ? null
                                : () {
                                    if (_formKey.currentState!.validate()) {
                                      handleLogin();
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: state.isLoading
                                ? const SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                : const Text(
                                    'Login',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Sign Up Link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account? ",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey[600],
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const DoctorSignupScreen(),
                                ),
                              );
                            },
                            style: TextButton.styleFrom(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: const Text(
                              'Sign Up',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primaryStart,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
