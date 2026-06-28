import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../constants/color_constants.dart';

class AppHelpers {
  // Currency formatting
  static String formatCurrency(double amount) {
    final formatter = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);
    return formatter.format(amount);
  }

  // Date formatting
  static String formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }

  static String formatDateTime(DateTime date) {
    return DateFormat('dd MMM yyyy, hh:mm a').format(date);
  }

  // Discount calculation
  static double calculateDiscount(double originalPrice, double discountedPrice) {
    if (originalPrice <= 0) return 0;
    return ((originalPrice - discountedPrice) / originalPrice * 100).roundToDouble();
  }

  // Show snackbar
  static void showSuccess(String message) {
    Get.snackbar(
      'Success',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.success,
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: const Duration(seconds: 3),
      icon: const Icon(Icons.check_circle_rounded, color: Colors.white),
    );
  }

  static void showError(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.error,
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: const Duration(seconds: 3),
      icon: const Icon(Icons.error_rounded, color: Colors.white),
    );
  }

  static void showInfo(String message) {
    Get.snackbar(
      'Info',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.primary,
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: const Duration(seconds: 3),
      icon: const Icon(Icons.info_rounded, color: Colors.white),
    );
  }

  static void showWarning(String message) {
    Get.snackbar(
      'Warning',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.warning,
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: const Duration(seconds: 3),
      icon: const Icon(Icons.warning_rounded, color: Colors.white),
    );
  }

  // Loading dialog
  static void showLoading([String message = 'Please wait...']) {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(color: AppColors.primary),
              const SizedBox(height: 16),
              Text(
                message,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  static void hideLoading() {
    if (Get.isDialogOpen == true) Get.back();
  }

  // Capitalize first letter
  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }
}
