import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/utils/helpers.dart';
import '../../../../data/repositories/auth_repository.dart';
import '../../../../routes/app_routes.dart';

class RegisterController extends GetxController {
  final _authRepo = AuthRepository();

  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final isLoading = false.obs;
  final isPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;

  void togglePassword() => isPasswordVisible.toggle();
  void toggleConfirmPassword() => isConfirmPasswordVisible.toggle();

  Future<void> register() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;
    try {
      await _authRepo.signUp(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text,
      );
      AppHelpers.showSuccess('Account created successfully!');
      Get.offAllNamed(AppRoutes.home);
    } catch (e) {
      AppHelpers.showError(_parseError(e.toString()));
    } finally {
      isLoading.value = false;
    }
  }

  String _parseError(String error) {
    if (error.contains('email-already-in-use')) return 'An account with this email already exists.';
    if (error.contains('weak-password')) return 'Password is too weak. Use at least 6 characters.';
    if (error.contains('invalid-email')) return 'Invalid email address.';
    if (error.contains('network-request-failed')) return 'Network error. Check your connection.';
    return 'Registration failed. Please try again.';
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
