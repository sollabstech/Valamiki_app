import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import '../controllers/login_controller.dart';
import '../../../../core/constants/color_constants.dart';
import '../../../../core/utils/validators.dart';
import '../../../../widgets/gradient_button.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Gradient header
            Container(
              width: double.infinity,
              height: 280,
              decoration: const BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Image.asset(
                        'assets/images/logo.png',
                        fit: BoxFit.contain,
                      ),
                    )
                        .animate()
                        .scale(duration: 600.ms, curve: Curves.elasticOut)
                        .fadeIn(duration: 400.ms),
                    const SizedBox(height: 16),
                    const Text(
                      'VALAMIKI',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 3,
                      ),
                    ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.3, end: 0, delay: 300.ms),
                    const SizedBox(height: 6),
                    Text(
                      'Groceries & Stationery Delivered Fast',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 13,
                        color: Colors.white.withValues(alpha: 0.85),
                      ),
                    ).animate().fadeIn(delay: 500.ms),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(24),
              child: Obx(() => AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    transitionBuilder: (child, animation) => SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0.15, 0),
                        end: Offset.zero,
                      ).animate(animation),
                      child: FadeTransition(opacity: animation, child: child),
                    ),
                    child: controller.otpSent.value
                        ? _OtpStep(controller: controller)
                        : _PhoneStep(controller: controller),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Step 1: Phone Number ────────────────────────────────────────────────────

class _PhoneStep extends StatelessWidget {
  final LoginController controller;
  const _PhoneStep({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.formKey,
      child: Column(
        key: const ValueKey('phone'),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          const Text(
            'Sign In',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ).animate().fadeIn(delay: 200.ms).slideX(begin: -0.2, end: 0, delay: 200.ms),
          const SizedBox(height: 4),
          const Text(
            'Enter your mobile number to receive an OTP',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ).animate().fadeIn(delay: 300.ms),
          const SizedBox(height: 32),

          // Phone field with +91 prefix
          TextFormField(
            controller: controller.phoneController,
            keyboardType: TextInputType.phone,
            maxLength: 10,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            validator: Validators.phone,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
            ),
            decoration: InputDecoration(
              labelText: 'Mobile Number',
              hintText: '9XXXXXXXXX',
              counterText: '',
              prefixIcon: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('🇮🇳', style: TextStyle(fontSize: 18)),
                    const SizedBox(width: 6),
                    const Text(
                      '+91',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(width: 1, height: 20, color: Colors.grey.shade300),
                  ],
                ),
              ),
              labelStyle: const TextStyle(fontFamily: 'Poppins', color: AppColors.textSecondary),
              hintStyle: TextStyle(fontFamily: 'Poppins', color: AppColors.textSecondary.withValues(alpha: 0.5)),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: AppColors.primary, width: 2),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: Colors.red),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: Colors.red, width: 2),
              ),
            ),
          ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2, end: 0, delay: 400.ms),

          const SizedBox(height: 32),

          Obx(() => GradientButton(
                label: 'Send OTP',
                isLoading: controller.isLoading.value,
                onPressed: controller.sendOTP,
                icon: Icons.send_rounded,
              )).animate().fadeIn(delay: 500.ms).slideY(begin: 0.2, end: 0, delay: 500.ms),

          const SizedBox(height: 32),

          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Don't have an account? ",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
                GestureDetector(
                  onTap: controller.goToRegister,
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(delay: 600.ms),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// ─── Step 2: OTP Verification ────────────────────────────────────────────────

class _OtpStep extends StatelessWidget {
  final LoginController controller;
  const _OtpStep({required this.controller});

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 52,
      height: 56,
      textStyle: const TextStyle(
        fontFamily: 'Poppins',
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200, width: 1.5),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
    );

    return Column(
      key: const ValueKey('otp'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        const Text(
          'Verify OTP',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ).animate().fadeIn(duration: 400.ms).slideX(begin: -0.2, end: 0),

        const SizedBox(height: 8),

        // Shows which number OTP was sent to
        Obx(() => RichText(
              text: TextSpan(
                style: const TextStyle(fontFamily: 'Poppins', fontSize: 13, color: AppColors.textSecondary),
                children: [
                  const TextSpan(text: 'OTP sent to '),
                  TextSpan(
                    text: '+91 ${controller.phoneController.text.trim()}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                  const TextSpan(text: '  '),
                  WidgetSpan(
                    child: GestureDetector(
                      onTap: controller.editPhone,
                      child: const Text(
                        'Edit',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )).animate().fadeIn(delay: 100.ms),

        const SizedBox(height: 36),

        // Pinput OTP boxes
        Center(
          child: Pinput(
            controller: controller.otpController,
            length: 6,
            defaultPinTheme: defaultPinTheme,
            focusedPinTheme: defaultPinTheme.copyWith(
              decoration: defaultPinTheme.decoration!.copyWith(
                border: Border.all(color: AppColors.primary, width: 2),
              ),
            ),
            submittedPinTheme: defaultPinTheme.copyWith(
              decoration: defaultPinTheme.decoration!.copyWith(
                color: AppColors.primary.withValues(alpha: 0.08),
                border: Border.all(color: AppColors.primary, width: 1.5),
              ),
            ),
            onCompleted: (_) => controller.verifyOTP(),
          ),
        ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.3, end: 0, delay: 200.ms),

        const SizedBox(height: 36),

        Obx(() => GradientButton(
              label: 'Verify & Sign In',
              isLoading: controller.isLoading.value,
              onPressed: controller.verifyOTP,
              icon: Icons.verified_rounded,
            )).animate().fadeIn(delay: 300.ms),

        const SizedBox(height: 24),

        // Resend timer
        Center(
          child: Obx(() {
            if (controller.resendSeconds.value > 0) {
              return Text(
                'Resend OTP in ${controller.resendSeconds.value}s',
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              );
            }
            return GestureDetector(
              onTap: controller.resendOTP,
              child: const Text(
                'Resend OTP',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                  decoration: TextDecoration.underline,
                ),
              ),
            );
          }),
        ).animate().fadeIn(delay: 400.ms),

        const SizedBox(height: 24),
      ],
    );
  }
}
