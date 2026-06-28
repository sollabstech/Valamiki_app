import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/utils/helpers.dart';
import '../../../routes/app_routes.dart';

class OrderConfirmationView extends StatelessWidget {
  const OrderConfirmationView({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>?;
    final orderId = args?['orderId'] as String? ?? '';
    final total = args?['total'] as double? ?? 0;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Success animation
              Container(
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                  gradient: AppColors.greenGradient,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.success.withOpacity(0.4),
                      blurRadius: 30,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: Colors.white,
                  size: 64,
                ),
              )
                  .animate()
                  .scale(
                    begin: const Offset(0, 0),
                    duration: 700.ms,
                    curve: Curves.elasticOut,
                  )
                  .fadeIn(duration: 400.ms),

              const SizedBox(height: 32),

              const Text(
                'Order Placed!',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.3, end: 0, delay: 400.ms),

              const SizedBox(height: 12),

              Text(
                'Your order has been placed successfully.\nWe\'ll deliver it to your door!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  height: 1.6,
                ),
              ).animate().fadeIn(delay: 500.ms),

              const SizedBox(height: 32),

              // Order details card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _InfoRow(label: 'Order ID', value: '#${orderId.substring(0, 8).toUpperCase()}'),
                    const Divider(height: 20),
                    _InfoRow(label: 'Total Amount', value: AppHelpers.formatCurrency(total)),
                    const Divider(height: 20),
                    _InfoRow(label: 'Payment', value: 'Cash on Delivery'),
                    const Divider(height: 20),
                    _InfoRow(label: 'Status', value: 'Confirmed', valueColor: AppColors.success),
                  ],
                ),
              ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.3, end: 0, delay: 600.ms),

              const SizedBox(height: 40),

              // Buttons
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: () => Get.offAllNamed(AppRoutes.orders),
                  child: const Text('Track Order'),
                ),
              ).animate().fadeIn(delay: 700.ms),

              const SizedBox(height: 14),

              SizedBox(
                width: double.infinity,
                height: 54,
                child: OutlinedButton(
                  onPressed: () => Get.offAllNamed(AppRoutes.home),
                  child: const Text('Continue Shopping'),
                ),
              ).animate().fadeIn(delay: 800.ms),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoRow({required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 13,
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: valueColor ?? AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
