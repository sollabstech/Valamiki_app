import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/utils/helpers.dart';
import '../../../../data/repositories/auth_repository.dart';
import '../../../../routes/app_routes.dart';

class LoginController extends GetxController {
  final _authRepo = AuthRepository();

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final isLoading = false.obs;
  final isPasswordVisible = false.obs;
  final rememberMe = false.obs;

  void togglePasswordVisibility() => isPasswordVisible.toggle();
  void toggleRememberMe() => rememberMe.toggle();

  Future<void> login() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;
    try {
      await _authRepo.signIn(
        email: emailController.text.trim(),
        password: passwordController.text,
        rememberMe: rememberMe.value,
      );
      Get.offAllNamed(AppRoutes.home);
    } catch (e) {
      AppHelpers.showError(_parseFirebaseError(e.toString()));
    } finally {
      isLoading.value = false;
    }
  }

  String _parseFirebaseError(String error) {
    if (error.contains('user-not-found')) return 'No account found with this email.';
    if (error.contains('wrong-password')) return 'Incorrect password. Please try again.';
    if (error.contains('invalid-email')) return 'Invalid email address.';
    if (error.contains('too-many-requests')) return 'Too many attempts. Please try again later.';
    if (error.contains('network-request-failed')) return 'Network error. Check your connection.';
    return 'Login failed. Please try again.';
  }

  void goToRegister() => Get.toNamed(AppRoutes.register);
  void goToForgotPassword() => Get.toNamed(AppRoutes.forgotPassword);

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
