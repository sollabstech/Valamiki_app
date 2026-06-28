import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
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
                          color: Colors.white.withOpacity(0.85),
                        ),
                      ).animate().fadeIn(delay: 200.ms),
                    ],
                  ),
                ),
              ),
            ),

            // Form
            Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: controller.formKey,
                child: Column(
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

                    CustomTextField(
                      controller: controller.emailController,
                      label: 'Email Address',
                      hint: 'your@email.com',
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: Icons.email_outlined,
                      validator: Validators.email,
                    ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.2, end: 0, delay: 300.ms),

                    const SizedBox(height: 16),

                    Obx(() => CustomTextField(
                          controller: controller.passwordController,
                          label: 'Password',
                          hint: '••••••••',
                          obscureText: !controller.isPasswordVisible.value,
                          prefixIcon: Icons.lock_outline_rounded,
                          validator: Validators.password,
                          suffixIcon: IconButton(
                            icon: Icon(
                              controller.isPasswordVisible.value
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: AppColors.textSecondary,
                            ),
                            onPressed: controller.togglePassword,
                          ),
                        )).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2, end: 0, delay: 400.ms),

                    const SizedBox(height: 16),

                    Obx(() => CustomTextField(
                          controller: controller.confirmPasswordController,
                          label: 'Confirm Password',
                          hint: '••••••••',
                          obscureText: !controller.isConfirmPasswordVisible.value,
                          prefixIcon: Icons.lock_outline_rounded,
                          validator: (v) => Validators.confirmPassword(
                              v, controller.passwordController.text),
                          suffixIcon: IconButton(
                            icon: Icon(
                              controller.isConfirmPasswordVisible.value
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: AppColors.textSecondary,
                            ),
                            onPressed: controller.toggleConfirmPassword,
                          ),
                        )).animate().fadeIn(delay: 500.ms).slideY(begin: 0.2, end: 0, delay: 500.ms),

                    const SizedBox(height: 32),

                    Obx(() => GradientButton(
                          label: 'Create Account',
                          isLoading: controller.isLoading.value,
                          onPressed: controller.register,
                        )).animate().fadeIn(delay: 600.ms).slideY(begin: 0.2, end: 0, delay: 600.ms),

                    const SizedBox(height: 24),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
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
                    ).animate().fadeIn(delay: 700.ms),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
