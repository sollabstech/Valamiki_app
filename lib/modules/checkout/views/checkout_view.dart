import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../controllers/checkout_controller.dart';
import '../../cart/controllers/cart_controller.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/utils/helpers.dart';
import '../../../data/models/address_model.dart';
import '../../../widgets/gradient_button.dart';

class CheckoutView extends GetView<CheckoutController> {
  const CheckoutView({super.key});

  @override
  Widget build(BuildContext context) {
    final cartController = Get.find<CartController>();
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Checkout'),
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
            // Delivery address section
            _SectionTitle(title: 'Delivery Address', icon: Icons.location_on_rounded),
            const SizedBox(height: 12),
            Obx(() => controller.isLoading.value
                ? const Center(child: CircularProgressIndicator())
                : controller.addresses.isEmpty
                    ? _NoAddressCard(onAdd: controller.addNewAddress)
                    : Column(
                        children: [
                          ...controller.addresses.map((addr) => _AddressTile(
                                address: addr,
                                isSelected: controller.selectedAddress.value?.id == addr.id,
                                onSelect: () => controller.selectAddress(addr),
                              )),
                          const SizedBox(height: 8),
                          TextButton.icon(
                            onPressed: controller.addNewAddress,
                            icon: const Icon(Icons.add_circle_outline_rounded, size: 18),
                            label: const Text('Add New Address'),
                          ),
                        ],
                      )).animate().fadeIn(delay: 100.ms),

            const SizedBox(height: 24),

            // Order summary
            _SectionTitle(title: 'Order Summary', icon: Icons.receipt_long_rounded),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
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
              child: Obx(() => Column(
                    children: [
                      ...cartController.items.map((item) => Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    '${item.name} × ${item.quantity}',
                                    style: const TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 13,
                                      color: AppColors.textPrimary,
                                    ),
                                    overflow: TextOverflow.ellipsis,
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
                      _PriceLine(label: 'Subtotal', amount: cartController.subtotal),
                      const SizedBox(height: 6),
                      _PriceLine(
                        label: 'Delivery',
                        amount: cartController.deliveryCharge,
                        isGreen: cartController.deliveryCharge == 0,
                        freeText: cartController.deliveryCharge == 0 ? 'FREE' : null,
                      ),
                      const Divider(),
                      _PriceLine(
                        label: 'Total',
                        amount: cartController.total,
                        isBold: true,
                      ),
                    ],
                  )),
            ).animate().fadeIn(delay: 200.ms),

            const SizedBox(height: 24),

            // Payment method
            _SectionTitle(title: 'Payment Method', icon: Icons.payment_rounded),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
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
              child: Column(
                children: [
                  // COD option (selected)
                  _PaymentOption(
                    icon: Icons.money_rounded,
                    label: 'Cash on Delivery',
                    isSelected: true,
                    onTap: () {},
                  ),
                  const SizedBox(height: 10),
                  // Online payment (disabled)
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.credit_card_rounded, color: AppColors.textHint, size: 22),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Online Payment',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textHint,
                                ),
                              ),
                              Text(
                                'Coming Soon',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 11,
                                  color: AppColors.accentOrange,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.accentOrange.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'Soon',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppColors.accentOrange,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 300.ms),

            const SizedBox(height: 32),

            // Place order button
            Obx(() => GradientButton(
                  label: 'Place Order',
                  isLoading: controller.isPlacingOrder.value,
                  onPressed: controller.placeOrder,
                  icon: Icons.check_circle_rounded,
                )).animate().fadeIn(delay: 400.ms),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final IconData icon;
  const _SectionTitle({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 20),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

class _NoAddressCard extends StatelessWidget {
  final VoidCallback onAdd;
  const _NoAddressCard({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onAdd,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.primary.withOpacity(0.3), style: BorderStyle.solid),
        ),
        child: Column(
          children: [
            Icon(Icons.add_location_alt_rounded, color: AppColors.primary, size: 36),
            const SizedBox(height: 8),
            const Text(
              'Add Delivery Address',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddressTile extends StatelessWidget {
  final AddressModel address;
  final bool isSelected;
  final VoidCallback onSelect;

  const _AddressTile({
    required this.address,
    required this.isSelected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelect,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.05) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Radio<String>(
              value: address.id,
              groupValue: isSelected ? address.id : '',
              onChanged: (_) => onSelect(),
              activeColor: AppColors.primary,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        address.name,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          address.type.toUpperCase(),
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    address.fullAddress,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 13,
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    address.phone,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PaymentOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _PaymentOption({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.05) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? AppColors.primary : AppColors.textSecondary, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? AppColors.primary : AppColors.textPrimary,
                ),
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle_rounded, color: AppColors.primary, size: 20),
          ],
        ),
      ),
    );
  }
}

class _PriceLine extends StatelessWidget {
  final String label;
  final double amount;
  final bool isBold;
  final bool isGreen;
  final String? freeText;

  const _PriceLine({
    required this.label,
    required this.amount,
    this.isBold = false,
    this.isGreen = false,
    this.freeText,
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
            fontSize: isBold ? 15 : 13,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w400,
            color: isBold ? AppColors.textPrimary : AppColors.textSecondary,
          ),
        ),
        Text(
          freeText ?? AppHelpers.formatCurrency(amount),
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: isBold ? 16 : 13,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w600,
            color: isGreen
                ? AppColors.success
                : isBold
                    ? AppColors.primary
                    : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
