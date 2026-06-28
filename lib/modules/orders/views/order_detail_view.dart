import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:timeline_tile/timeline_tile.dart';
import '../controllers/orders_controller.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/utils/helpers.dart';
import '../../../data/models/order_model.dart';

class OrderDetailView extends GetView<OrdersController> {
  const OrderDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final order = Get.arguments as OrderModel;

    final statuses = ['Order Placed', 'Confirmed', 'On the Way', 'Delivered'];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Order #${order.id.substring(0, 8).toUpperCase()}'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order tracking timeline
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Order Status',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...List.generate(statuses.length, (index) {
                    final isDone = index <= order.statusIndex;
                    final isCurrent = index == order.statusIndex;
                    return TimelineTile(
                      isFirst: index == 0,
                      isLast: index == statuses.length - 1,
                      indicatorStyle: IndicatorStyle(
                        width: 22,
                        height: 22,
                        indicator: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isDone ? AppColors.primary : AppColors.border,
                            border: isCurrent
                                ? Border.all(color: AppColors.primary, width: 3)
                                : null,
                          ),
                          child: isDone
                              ? const Icon(Icons.check, color: Colors.white, size: 12)
                              : null,
                        ),
                      ),
                      beforeLineStyle: LineStyle(
                        color: index <= order.statusIndex ? AppColors.primary : AppColors.border,
                        thickness: 2,
                      ),
                      afterLineStyle: LineStyle(
                        color: index < order.statusIndex ? AppColors.primary : AppColors.border,
                        thickness: 2,
                      ),
                      endChild: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: Text(
                          statuses[index],
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 13,
                            fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w400,
                            color: isDone ? AppColors.textPrimary : AppColors.textHint,
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ).animate().fadeIn().slideY(begin: 0.2, end: 0),

            const SizedBox(height: 20),

            // Order items
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Order Items',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 14),
                  ...order.products.map((item) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                '${item.name} (${item.unit}) × ${item.quantity}',
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 13,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ),
                            Text(
                              AppHelpers.formatCurrency(item.totalPrice),
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      )),
                  const Divider(),
                  _SummaryRow(label: 'Subtotal', value: AppHelpers.formatCurrency(order.subtotal)),
                  _SummaryRow(
                    label: 'Delivery',
                    value: order.deliveryCharge == 0
                        ? 'FREE'
                        : AppHelpers.formatCurrency(order.deliveryCharge),
                    valueColor: order.deliveryCharge == 0 ? AppColors.success : null,
                  ),
                  const Divider(),
                  _SummaryRow(
                    label: 'Total',
                    value: AppHelpers.formatCurrency(order.totalPrice),
                    isBold: true,
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.2, end: 0, delay: 100.ms),

            const SizedBox(height: 20),

            // Delivery address
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Delivery Address',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.location_on_rounded, color: AppColors.primary, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              order.deliveryAddress.name,
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            Text(
                              order.deliveryAddress.fullAddress,
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 13,
                                color: AppColors.textSecondary,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2, end: 0, delay: 200.ms),

            const SizedBox(height: 20),

            // Payment info
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                children: [
                  const Icon(Icons.payment_rounded, color: AppColors.primary, size: 22),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Payment Method',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Text(
                        order.paymentMethod,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.2, end: 0, delay: 300.ms),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;
  final Color? valueColor;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.isBold = false,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: isBold ? 15 : 13,
              fontWeight: isBold ? FontWeight.w700 : FontWeight.w400,
              color: isBold ? AppColors.textPrimary : AppColors.textSecondary,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: isBold ? 16 : 13,
              fontWeight: isBold ? FontWeight.w700 : FontWeight.w600,
              color: valueColor ?? (isBold ? AppColors.primary : AppColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }
}
