import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../controllers/login_controller.dart';
import '../../../../core/constants/color_constants.dart';
import '../../../../core/utils/validators.dart';
import '../../../../widgets/custom_text_field.dart';
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
            // Header
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
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          'V',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 38,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
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
                      'Welcome back!',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.85),
                      ),
                    ).animate().fadeIn(delay: 500.ms),
                  ],
                ),
              ),
            ),

            // Form
            Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: controller.formKey,
                child: Column(
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
                    Text(
                      'Enter your credentials to continue',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ).animate().fadeIn(delay: 300.ms),
                    const SizedBox(height: 28),

                    // Email field
                    CustomTextField(
                      controller: controller.emailController,
                      label: 'Email Address',
                      hint: 'your@email.com',
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: Icons.email_outlined,
                      validator: Validators.email,
                    ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2, end: 0, delay: 400.ms),

                    const SizedBox(height: 16),

                    // Password field
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
                            onPressed: controller.togglePasswordVisibility,
                          ),
                        )).animate().fadeIn(delay: 500.ms).slideY(begin: 0.2, end: 0, delay: 500.ms),

                    const SizedBox(height: 12),

                    // Remember me & Forgot password row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Obx(() => Row(
                              children: [
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: Checkbox(
                                    value: controller.rememberMe.value,
                                    onChanged: (_) => controller.toggleRememberMe(),
                                    activeColor: AppColors.primary,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'Remember me',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 13,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            )),
                        TextButton(
                          onPressed: controller.goToForgotPassword,
                          child: const Text(
                            'Forgot Password?',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ).animate().fadeIn(delay: 600.ms),

                    const SizedBox(height: 28),

                    // Login button
                    Obx(() => GradientButton(
                          label: 'Sign In',
                          isLoading: controller.isLoading.value,
                          onPressed: controller.login,
                        )).animate().fadeIn(delay: 700.ms).slideY(begin: 0.2, end: 0, delay: 700.ms),

                    const SizedBox(height: 28),

                    // Register link
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
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
                    ).animate().fadeIn(delay: 800.ms),

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
