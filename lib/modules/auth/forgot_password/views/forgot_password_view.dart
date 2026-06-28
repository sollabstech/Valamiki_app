import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../../../core/constants/color_constants.dart';
import '../../../../core/utils/helpers.dart';
import '../../../../core/utils/validators.dart';
import '../../../../data/repositories/auth_repository.dart';
import '../../../../widgets/custom_text_field.dart';
import '../../../../widgets/gradient_button.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _authRepo = AuthRepository();
  bool _isLoading = false;
  bool _emailSent = false;

  Future<void> _resetPassword() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      await _authRepo.resetPassword(_emailController.text.trim());
      setState(() => _emailSent = true);
    } catch (e) {
      AppHelpers.showError('Failed to send reset email. Check your email address.');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: AppColors.textPrimary),
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: _emailSent ? _buildSuccessView() : _buildFormView(),
      ),
    );
  }

  Widget _buildFormView() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(Icons.lock_reset_rounded, color: AppColors.primary, size: 32),
          ).animate().scale(duration: 500.ms, curve: Curves.elasticOut),
          const SizedBox(height: 24),
          const Text(
            'Forgot Password?',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ).animate().fadeIn(delay: 200.ms).slideX(begin: -0.2, end: 0, delay: 200.ms),
          const SizedBox(height: 8),
          Text(
            "Don't worry! Enter your email and we'll send you a reset link.",
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ).animate().fadeIn(delay: 300.ms),
          const SizedBox(height: 36),
          CustomTextField(
            controller: _emailController,
            label: 'Email Address',
            hint: 'your@email.com',
            keyboardType: TextInputType.emailAddress,
            prefixIcon: Icons.email_outlined,
            validator: Validators.email,
          ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2, end: 0, delay: 400.ms),
          const SizedBox(height: 32),
          GradientButton(
            label: 'Send Reset Link',
            isLoading: _isLoading,
            onPressed: _resetPassword,
          ).animate().fadeIn(delay: 500.ms),
        ],
      ),
    );
  }

  Widget _buildSuccessView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: AppColors.success.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 52),
          ).animate().scale(duration: 600.ms, curve: Curves.elasticOut),
          const SizedBox(height: 28),
          const Text(
            'Email Sent!',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ).animate().fadeIn(delay: 300.ms),
          const SizedBox(height: 12),
          Text(
            'We\'ve sent a password reset link to\n${_emailController.text}',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              color: AppColors.textSecondary,
              height: 1.6,
            ),
          ).animate().fadeIn(delay: 400.ms),
          const SizedBox(height: 36),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Get.back(),
              child: const Text('Back to Sign In'),
            ),
          ).animate().fadeIn(delay: 500.ms),
        ],
      ),
    );
  }
}
