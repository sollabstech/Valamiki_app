import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../core/constants/color_constants.dart';
import '../core/utils/helpers.dart';
import '../data/models/product_model.dart';
import '../modules/cart/controllers/cart_controller.dart';
import '../routes/app_routes.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;
  final int index;
  final bool isGrid;
  final bool isFlashDeal;

  const ProductCard({
    super.key,
    required this.product,
    required this.index,
    this.isGrid = false,
    this.isFlashDeal = false,
  });

  @override
  Widget build(BuildContext context) {
    final cart = Get.find<CartController>();
    final width = isGrid ? double.infinity : 160.0;

    return GestureDetector(
      onTap: () => Get.toNamed(
        AppRoutes.productDetail,
        arguments: product,
      ),
      child: Hero(
        tag: 'product_${product.id}',
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: isGrid ? null : width,
            margin: isGrid ? null : const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image section
                Stack(
                  children: [
                    Container(
                      height: isGrid ? 130 : 120,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceVariant,
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                      ),
                      child: const Center(
                        child: Icon(Icons.image_outlined, size: 40, color: AppColors.textHint),
                      ),
                    ),

                    // Discount badge
                    if (product.hasDiscount)
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.discountBadge,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '${product.discountPercent.toInt()}% OFF',
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),

                    // Flash deal badge
                    if (isFlashDeal)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: AppColors.accentOrange,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.bolt_rounded, color: Colors.white, size: 14),
                        ),
                      ),
                  ],
                ),

                // Details
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        product.unit,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppHelpers.formatCurrency(product.effectivePrice),
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primary,
                                ),
                              ),
                              if (product.hasDiscount)
                                Text(
                                  AppHelpers.formatCurrency(product.price),
                                  style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 10,
                                    color: AppColors.textHint,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                            ],
                          ),

                          // Add to cart button
                          Obx(() {
                            final qty = cart.getQuantity(product.id);
                            if (qty > 0) {
                              return Container(
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.08),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    GestureDetector(
                                      onTap: () => cart.decrementItem(product.id),
                                      child: Container(
                                        width: 26,
                                        height: 26,
                                        decoration: BoxDecoration(
                                          color: AppColors.primary.withOpacity(0.15),
                                          borderRadius: BorderRadius.circular(7),
                                        ),
                                        child: const Icon(Icons.remove, size: 14, color: AppColors.primary),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 6),
                                      child: Text(
                                        '$qty',
                                        style: const TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () => cart.addItem(product),
                                      child: Container(
                                        width: 26,
                                        height: 26,
                                        decoration: BoxDecoration(
                                          color: AppColors.primary,
                                          borderRadius: BorderRadius.circular(7),
                                        ),
                                        child: const Icon(Icons.add, size: 14, color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                            return GestureDetector(
                              onTap: () => cart.addItem(product),
                              child: Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(Icons.add, color: Colors.white, size: 18),
                              ),
                            );
                          }),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(delay: Duration(milliseconds: 60 * index))
        .scale(
          begin: const Offset(0.9, 0.9),
          end: const Offset(1, 1),
          delay: Duration(milliseconds: 60 * index),
          duration: 300.ms,
        );
  }
}
