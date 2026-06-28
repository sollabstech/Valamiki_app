import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../controllers/valamiki_search_controller.dart';
import '../../../core/constants/color_constants.dart';
import '../../../widgets/product_card.dart';

class SearchView extends GetView<VaSeachController> {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        titleSpacing: 0,
        title: TextField(
          controller: controller.searchController,
          autofocus: true,
          onChanged: controller.search,
          decoration: InputDecoration(
            hintText: 'Search products...',
            hintStyle: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 15,
              color: AppColors.textHint,
            ),
            border: InputBorder.none,
            filled: false,
            suffixIcon: Obx(() => controller.searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.close_rounded, color: AppColors.textSecondary),
                    onPressed: controller.clearSearch,
                  )
                : const SizedBox.shrink()),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        if (!controller.hasSearched.value) {
          return _RecentSearches(controller: controller);
        }

        if (controller.results.isEmpty) {
          return _EmptyResults();
        }

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          physics: const BouncingScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.72,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: controller.results.length,
          itemBuilder: (context, index) => ProductCard(
            product: controller.results[index],
            index: index,
            isGrid: true,
          ),
        );
      }),
    );
  }
}

class _RecentSearches extends StatelessWidget {
  final VaSeachController controller;
  const _RecentSearches({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() => controller.recentSearches.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.search_rounded, size: 64, color: AppColors.textHint),
                const SizedBox(height: 16),
                Text(
                  'Search for products',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(20, 16, 20, 12),
                child: Text(
                  'Recent Searches',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              ...controller.recentSearches.asMap().entries.map(
                    (entry) => ListTile(
                      leading: const Icon(Icons.history_rounded, color: AppColors.textSecondary),
                      title: Text(
                        entry.value,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      onTap: () => controller.useRecent(entry.value),
                    ).animate().fadeIn(delay: Duration(milliseconds: 60 * (entry.key as int))),
                  ),
            ],
          ));
  }
}

class _EmptyResults extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off_rounded, size: 64, color: AppColors.textHint),
          const SizedBox(height: 16),
          const Text(
            'No products found',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try a different search term',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
