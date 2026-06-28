import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import '../controllers/register_controller.dart';
import '../../../../core/constants/color_constants.dart';
import '../../../../core/utils/validators.dart';
import '../../../../widgets/custom_text_field.dart';
import '../../../../widgets/gradient_button.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              height: 220,
              decoration: const BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: SafeArea(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Create Account',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.3, end: 0),
                      const SizedBox(height: 6),
                      Text(
                        'Join VALAMIKI today',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          color: Colors.white.withValues(alpha: 0.85),
                        ),
                      ).animate().fadeIn(delay: 200.ms),
                    ],
                  ),
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
                        ? _RegisterOtpStep(controller: controller)
                        : _RegisterFormStep(controller: controller),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Step 1: Name + Phone ────────────────────────────────────────────────────

class _RegisterFormStep extends StatelessWidget {
  final RegisterController controller;
  const _RegisterFormStep({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.formKey,
      child: Column(
        key: const ValueKey('register_form'),
        children: [
          const SizedBox(height: 8),

          CustomTextField(
            controller: controller.nameController,
            label: 'Full Name',
            hint: 'John Doe',
            prefixIcon: Icons.person_outline_rounded,
            validator: Validators.name,
          ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2, end: 0, delay: 200.ms),

          const SizedBox(height: 16),

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
          ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.2, end: 0, delay: 300.ms),

          const SizedBox(height: 32),

          Obx(() => GradientButton(
                label: 'Send OTP',
                isLoading: controller.isLoading.value,
                onPressed: controller.sendOTP,
                icon: Icons.send_rounded,
              )).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2, end: 0, delay: 400.ms),

          const SizedBox(height: 24),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Already have an account? ',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              GestureDetector(
                onTap: () => Get.back(),
                child: const Text(
                  'Sign In',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ).animate().fadeIn(delay: 500.ms),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// ─── Step 2: OTP Verification ────────────────────────────────────────────────

class _RegisterOtpStep extends StatelessWidget {
  final RegisterController controller;
  const _RegisterOtpStep({required this.controller});

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
      key: const ValueKey('register_otp'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        const Text(
          'Verify Your Number',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ).animate().fadeIn(duration: 400.ms),

        const SizedBox(height: 8),

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
              label: 'Verify & Create Account',
              isLoading: controller.isLoading.value,
              onPressed: controller.verifyOTP,
              icon: Icons.verified_rounded,
            )).animate().fadeIn(delay: 300.ms),

        const SizedBox(height: 24),

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
