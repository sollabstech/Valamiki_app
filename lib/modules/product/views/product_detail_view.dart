import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import '../controllers/product_controller.dart';
import '../../cart/controllers/cart_controller.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/utils/helpers.dart';
import '../../../routes/app_routes.dart';
import '../../../widgets/gradient_button.dart';

class ProductDetailView extends GetView<ProductController> {
  const ProductDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Obx(() {
        final product = controller.product.value;
        if (product == null) {
          return const Center(child: CircularProgressIndicator());
        }
        return CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // App bar with image
            SliverAppBar(
              expandedHeight: 320,
              pinned: true,
              backgroundColor: Colors.white,
              leading: IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.arrow_back_ios_rounded, size: 18, color: AppColors.textPrimary),
                ),
                onPressed: () => Get.back(),
              ),
              actions: [
                IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.share_outlined, size: 18, color: AppColors.textPrimary),
                  ),
                  onPressed: () {},
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: Hero(
                  tag: 'product_${product.id}',
                  child: Container(
                    color: AppColors.surfaceVariant,
                    child: const Center(
                      child: Icon(Icons.image_outlined, size: 80, color: AppColors.textHint),
                    ),
                  ),
                ),
              ),
            ),

            // Product details
            SliverToBoxAdapter(
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          product.categoryName,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Product name
                      Text(
                        product.name,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ).animate().fadeIn(delay: 100.ms),

                      const SizedBox(height: 8),

                      // Unit
                      Text(
                        product.unit,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),

                      const SizedBox(height: 14),

                      // Rating row
                      Row(
                        children: [
                          RatingBarIndicator(
                            rating: product.rating,
                            itemBuilder: (_, __) => const Icon(Icons.star, color: Color(0xFFFFA000)),
                            itemCount: 5,
                            itemSize: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${product.rating} (${product.reviewCount} reviews)',
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 13,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Price section
                      Row(
                        children: [
                          Text(
                            AppHelpers.formatCurrency(product.effectivePrice),
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                          if (product.hasDiscount) ...[
                            const SizedBox(width: 10),
                            Text(
                              AppHelpers.formatCurrency(product.price),
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 16,
                                color: AppColors.textHint,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.discountBadge,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                '${product.discountPercent.toInt()}% OFF',
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Stock status
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: product.stock > 0 ? AppColors.success : AppColors.error,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            product.stock > 10
                                ? 'In Stock'
                                : product.stock > 0
                                    ? 'Only ${product.stock} left!'
                                    : 'Out of Stock',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: product.stock > 0 ? AppColors.success : AppColors.error,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),
                      const Divider(),
                      const SizedBox(height: 16),

                      // Description
                      const Text(
                        'About Product',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        product.description,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          color: AppColors.textSecondary,
                          height: 1.6,
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Quantity selector
                      Row(
                        children: [
                          const Text(
                            'Quantity:',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.border),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                _QtyBtn(
                                  icon: Icons.remove,
                                  onTap: controller.decrement,
                                ),
                                Obx(() => Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 18),
                                      child: Text(
                                        '${controller.quantity.value}',
                                        style: const TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    )),
                                _QtyBtn(
                                  icon: Icons.add,
                                  onTap: controller.increment,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 28),

                      // Action buttons
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                controller.addToCart();
                                Get.toNamed(AppRoutes.cart);
                              },
                              icon: const Icon(Icons.shopping_cart_outlined),
                              label: const Text('Add to Cart'),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: GradientButton(
                              label: 'Buy Now',
                              onPressed: () {
                                controller.addToCart();
                                Get.toNamed(AppRoutes.checkout);
                              },
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}

class _QtyBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _QtyBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 42,
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.08),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 18, color: AppColors.primary),
      ),
    );
  }
}
