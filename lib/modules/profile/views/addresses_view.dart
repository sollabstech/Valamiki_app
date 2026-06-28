import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';
import '../../../core/constants/color_constants.dart';
import '../../../data/models/address_model.dart';
import '../../../routes/app_routes.dart';

class AddressesView extends GetView<ProfileController> {
  const AddressesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Saved Addresses'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            onPressed: () => Get.toNamed(AppRoutes.addAddress)?.then((_) => controller.loadAddresses()),
          ),
        ],
      ),
      body: Obx(() => controller.addresses.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.08),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.location_off_outlined, size: 48, color: AppColors.primary),
                  ).animate().scale(duration: 500.ms, curve: Curves.elasticOut),
                  const SizedBox(height: 20),
                  const Text(
                    'No addresses saved',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => Get.toNamed(AppRoutes.addAddress)?.then((_) => controller.loadAddresses()),
                    icon: const Icon(Icons.add_rounded),
                    label: const Text('Add Address'),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: controller.addresses.length,
              itemBuilder: (context, index) {
                final addr = controller.addresses[index];
                return _AddressCard(address: addr, index: index, controller: controller);
              },
            )),
      floatingActionButton: Obx(() => controller.addresses.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: () => Get.toNamed(AppRoutes.addAddress)?.then((_) => controller.loadAddresses()),
              icon: const Icon(Icons.add_rounded),
              label: const Text('Add Address'),
              backgroundColor: AppColors.primary,
            )
          : const SizedBox.shrink()),
    );
  }
}

class _AddressCard extends StatelessWidget {
  final AddressModel address;
  final int index;
  final ProfileController controller;

  const _AddressCard({
    required this.address,
    required this.index,
    required this.controller,
  });

  IconData get _typeIcon {
    switch (address.type) {
      case 'work': return Icons.work_outline_rounded;
      case 'other': return Icons.location_on_outlined;
      default: return Icons.home_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: address.isDefault
            ? Border.all(color: AppColors.primary, width: 1.5)
            : null,
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
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(_typeIcon, color: AppColors.primary, size: 22),
          ),
          const SizedBox(width: 14),
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
                    if (address.isDefault) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Default',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  address.fullAddress,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded, color: AppColors.error, size: 20),
            onPressed: () => controller.deleteAddress(address.id),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(delay: Duration(milliseconds: 80 * index))
        .slideX(begin: 0.2, end: 0, delay: Duration(milliseconds: 80 * index));
  }
}
