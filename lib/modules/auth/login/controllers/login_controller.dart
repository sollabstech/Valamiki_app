import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/utils/helpers.dart';
import '../../../../data/repositories/auth_repository.dart';
import '../../../../routes/app_routes.dart';

class LoginController extends GetxController {
  final _authRepo = AuthRepository();

  final formKey = GlobalKey<FormState>();
  final phoneController = TextEditingController();
  final otpController = TextEditingController();

  final isLoading = false.obs;
  final otpSent = false.obs;
  final resendSeconds = 0.obs;

  String _verificationId = '';
  Timer? _resendTimer;

  Future<void> sendOTP() async {
    if (!formKey.currentState!.validate()) return;
    isLoading.value = true;
    try {
      await _authRepo.sendOTP(
        phone: phoneController.text.trim(),
        onCodeSent: (verificationId) {
          _verificationId = verificationId;
          otpSent.value = true;
          _startResendTimer();
          AppHelpers.showSuccess('OTP sent to +91 ${phoneController.text.trim()}');
        },
        onError: (error) {
          AppHelpers.showError(_parseError(error));
        },
        onAutoVerified: () {
          Get.offAllNamed(AppRoutes.home);
        },
      );
    } catch (e) {
      AppHelpers.showError(_parseError(e.toString()));
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> verifyOTP() async {
    final otp = otpController.text.trim();
    if (otp.length != 6) {
      AppHelpers.showError('Please enter the complete 6-digit OTP');
      return;
    }
    isLoading.value = true;
    try {
      await _authRepo.verifyOTP(
        verificationId: _verificationId,
        otp: otp,
      );
      Get.offAllNamed(AppRoutes.home);
    } catch (e) {
      AppHelpers.showError(_parseError(e.toString()));
    } finally {
      isLoading.value = false;
    }
  }

  void _startResendTimer() {
    resendSeconds.value = 30;
    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (resendSeconds.value == 0) {
        t.cancel();
      } else {
        resendSeconds.value--;
      }
    });
  }

  void resendOTP() {
    otpController.clear();
    sendOTP();
  }

  void editPhone() {
    otpSent.value = false;
    otpController.clear();
    _resendTimer?.cancel();
    resendSeconds.value = 0;
  }

  String _parseError(String error) {
    if (error.contains('invalid-phone-number')) return 'Invalid phone number. Check and try again.';
    if (error.contains('invalid-verification-code')) return 'Wrong OTP. Please try again.';
    if (error.contains('session-expired')) return 'OTP expired. Please resend.';
    if (error.contains('too-many-requests')) return 'Too many attempts. Try again later.';
    if (error.contains('network-request-failed')) return 'Network error. Check your connection.';
    return 'Something went wrong. Please try again.';
  }

  void goToRegister() => Get.toNamed(AppRoutes.register);

  @override
  void onClose() {
    phoneController.dispose();
    otpController.dispose();
    _resendTimer?.cancel();
    super.onClose();
  }
}
