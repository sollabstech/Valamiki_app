import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../controllers/cart_controller.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/utils/helpers.dart';
import '../../../data/models/cart_model.dart';
import '../../../routes/app_routes.dart';
import '../../../widgets/gradient_button.dart';

class CartView extends GetView<CartController> {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Obx(() => Text(
              'Cart (${controller.itemCount})',
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            )),
        actions: [
          Obx(() => controller.hasItems
              ? TextButton(
                  onPressed: () {
                    Get.defaultDialog(
                      title: 'Clear Cart',
                      middleText: 'Remove all items from cart?',
                      textConfirm: 'Clear',
                      textCancel: 'Cancel',
                      confirmTextColor: Colors.white,
                      buttonColor: AppColors.error,
                      onConfirm: () {
                        controller.clearCart();
                        Get.back();
                      },
                    );
                  },
                  child: const Text('Clear', style: TextStyle(color: AppColors.error)),
                )
              : const SizedBox.shrink()),
        ],
      ),
      body: Obx(() => controller.hasItems ? _buildCartItems() : _buildEmptyCart()),
      bottomNavigationBar: Obx(() => controller.hasItems ? _buildCheckoutBar() : const SizedBox.shrink()),
    );
  }

  Widget _buildCartItems() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      physics: const BouncingScrollPhysics(),
      itemCount: controller.items.length,
      itemBuilder: (context, index) {
        return _CartItemTile(item: controller.items[index], index: index)
            .animate()
            .fadeIn(delay: Duration(milliseconds: 50 * index))
            .slideX(begin: 0.2, end: 0, delay: Duration(milliseconds: 50 * index));
      },
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.shopping_cart_outlined, size: 56, color: AppColors.primary),
          ).animate().scale(duration: 500.ms, curve: Curves.elasticOut),
          const SizedBox(height: 24),
          const Text(
            'Your cart is empty',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ).animate().fadeIn(delay: 200.ms),
          const SizedBox(height: 8),
          Text(
            'Add items to get started',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ).animate().fadeIn(delay: 300.ms),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () => Get.back(),
            child: const Text('Browse Products'),
          ).animate().fadeIn(delay: 400.ms),
        ],
      ),
    );
  }

  Widget _buildCheckoutBar() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Price summary
            _PriceRow(label: 'Subtotal', value: controller.subtotal),
            const SizedBox(height: 8),
            Obx(() => _PriceRow(
                  label: 'Delivery',
                  value: controller.deliveryCharge,
                  valueColor: controller.deliveryCharge == 0 ? AppColors.success : null,
                  valueText: controller.deliveryCharge == 0 ? 'FREE' : null,
                )),
            if (controller.subtotal < AppConstants.freeDeliveryThreshold &&
                controller.subtotal > 0)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  'Add ${AppHelpers.formatCurrency(AppConstants.freeDeliveryThreshold - controller.subtotal)} more for free delivery',
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 11,
                    color: AppColors.accentOrange,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Divider(),
            ),
            _PriceRow(
              label: 'Total',
              value: controller.total,
              isBold: true,
            ),
            const SizedBox(height: 16),
            GradientButton(
              label: 'Proceed to Checkout',
              onPressed: () => Get.toNamed(AppRoutes.checkout),
              icon: Icons.arrow_forward_rounded,
            ),
          ],
        ),
      ),
    );
  }
}

class _CartItemTile extends StatelessWidget {
  final CartItemModel item;
  final int index;

  const _CartItemTile({required this.item, required this.index});

  @override
  Widget build(BuildContext context) {
    final cart = Get.find<CartController>();
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // Product image placeholder
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.image_outlined, color: AppColors.textHint, size: 28),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  item.unit,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppHelpers.formatCurrency(item.effectivePrice),
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                    // Quantity control
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.surfaceVariant,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          _QtyButton(
                            icon: Icons.remove,
                            onTap: () => cart.decrementItem(item.productId),
                          ),
                          Obx(() {
                            final qty = cart.getQuantity(item.productId);
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: Text(
                                '$qty',
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            );
                          }),
                          _QtyButton(
                            icon: Icons.add,
                            onTap: () => cart.incrementItem(item.productId),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _QtyButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 16, color: AppColors.primary),
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String label;
  final double value;
  final bool isBold;
  final Color? valueColor;
  final String? valueText;

  const _PriceRow({
    required this.label,
    required this.value,
    this.isBold = false,
    this.valueColor,
    this.valueText,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: isBold ? 16 : 14,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w400,
            color: isBold ? AppColors.textPrimary : AppColors.textSecondary,
          ),
        ),
        Text(
          valueText ?? AppHelpers.formatCurrency(value),
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: isBold ? 18 : 14,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w600,
            color: valueColor ?? (isBold ? AppColors.primary : AppColors.textPrimary),
          ),
        ),
      ],
    );
  }
}
