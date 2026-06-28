import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/categories_controller.dart';
import '../../../core/constants/color_constants.dart';
import '../../../data/models/category_model.dart';
import '../../../widgets/product_card.dart';
import '../../../widgets/shimmer_widget.dart';

class CategoryProductsView extends GetView<CategoriesController> {
  const CategoryProductsView({super.key});

  @override
  Widget build(BuildContext context) {
    final category = Get.arguments as CategoryModel?;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 140,
            backgroundColor: category?.color ?? AppColors.primary,
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
              title: Text(
                category?.name ?? 'Products',
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      category?.color ?? AppColors.primary,
                      (category?.color ?? AppColors.primary).withOpacity(0.7),
                    ],
                  ),
                ),
                child: Center(
                  child: Text(
                    category?.icon ?? '',
                    style: const TextStyle(fontSize: 60),
                  ),
                ),
              ),
            ),
          ),
          Obx(() => controller.isLoading.value
              ? SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                      (_, __) => ShimmerWidget.rectangular(
                        height: 200,
                        borderRadius: 16,
                      ),
                      childCount: 6,
                    ),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.72,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                  ),
                )
              : SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => ProductCard(
                        product: controller.products[index],
                        index: index,
                        isGrid: true,
                      ),
                      childCount: controller.products.length,
                    ),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.72,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                  ),
                )),
        ],
      ),
    );
  }
}
