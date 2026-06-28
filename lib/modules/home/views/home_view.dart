import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../controllers/home_controller.dart';
import '../../cart/controllers/cart_controller.dart';
import '../../categories/views/categories_view.dart';
import '../../orders/views/orders_view.dart';
import '../../profile/views/profile_view.dart';
import '../../../core/constants/color_constants.dart';
import '../../../data/models/category_model.dart';
import '../../../routes/app_routes.dart';
import '../../../widgets/product_card.dart';
import '../../../widgets/shimmer_widget.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final tabs = [
        _HomeTab(controller: controller),
        const CategoriesView(isTab: true),
        const OrdersView(isTab: true),
        const ProfileView(isTab: true),
      ];
      return Scaffold(
        backgroundColor: AppColors.background,
        body: IndexedStack(
          index: controller.currentIndex.value,
          children: tabs,
        ),
        bottomNavigationBar: _BottomNav(controller: controller),
      );
    });
  }
}

class _BottomNav extends StatelessWidget {
  final HomeController controller;
  const _BottomNav({required this.controller});

  @override
  Widget build(BuildContext context) {
    final cartController = Get.find<CartController>();
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Obx(() => BottomNavigationBar(
              currentIndex: controller.currentIndex.value,
              onTap: controller.changeTab,
              elevation: 0,
              backgroundColor: Colors.transparent,
              selectedItemColor: AppColors.primary,
              unselectedItemColor: AppColors.bottomNavInactive,
              type: BottomNavigationBarType.fixed,
              selectedLabelStyle: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 11,
              ),
              items: [
                const BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined),
                  activeIcon: Icon(Icons.home_rounded),
                  label: 'Home',
                ),
                const BottomNavigationBarItem(
                  icon: Icon(Icons.grid_view_outlined),
                  activeIcon: Icon(Icons.grid_view_rounded),
                  label: 'Categories',
                ),
                BottomNavigationBarItem(
                  icon: Stack(
                    children: [
                      const Icon(Icons.shopping_bag_outlined),
                      Obx(() => cartController.itemCount > 0
                          ? Positioned(
                              right: 0,
                              top: 0,
                              child: Container(
                                width: 14,
                                height: 14,
                                decoration: BoxDecoration(
                                  color: AppColors.error,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    '${cartController.itemCount}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 8,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : const SizedBox.shrink()),
                    ],
                  ),
                  activeIcon: const Icon(Icons.shopping_bag_rounded),
                  label: 'Orders',
                ),
                const BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline_rounded),
                  activeIcon: Icon(Icons.person_rounded),
                  label: 'Profile',
                ),
              ],
            )),
      ),
    );
  }
}

class _HomeTab extends StatelessWidget {
  final HomeController controller;
  const _HomeTab({required this.controller});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: controller.refresh,
      color: AppColors.primary,
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // App bar
          SliverToBoxAdapter(child: _buildHeader()),
          // Search bar
          SliverToBoxAdapter(child: _buildSearchBar()),
          // Banner slider
          SliverToBoxAdapter(child: _buildBannerSlider()),
          // Categories
          SliverToBoxAdapter(child: _buildCategoriesSection()),
          // Flash deals
          SliverToBoxAdapter(child: _buildFlashDeals()),
          // Featured products
          SliverToBoxAdapter(child: _buildFeaturedSection()),
          // Popular products
          SliverToBoxAdapter(child: _buildPopularSection()),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(Get.context!).padding.top + 16,
        left: 20,
        right: 20,
        bottom: 16,
      ),
      decoration: const BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Obx(() => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      controller.greeting,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 13,
                        color: Colors.white.withOpacity(0.85),
                      ),
                    ),
                    Text(
                      controller.userName,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.location_on_rounded, color: Colors.white70, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          'Delivering to your location',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 12,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ],
                )),
          ),
          // Cart icon
          Obx(() {
            final cart = Get.find<CartController>();
            return GestureDetector(
              onTap: () => Get.toNamed(AppRoutes.cart),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.shopping_cart_outlined, color: Colors.white, size: 22),
                  ),
                  if (cart.itemCount > 0)
                    Positioned(
                      right: -6,
                      top: -6,
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: const BoxDecoration(
                          color: AppColors.accentOrange,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '${cart.itemCount}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            );
          }),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms);
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: GestureDetector(
        onTap: () => Get.toNamed(AppRoutes.search),
        child: Container(
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              const Icon(Icons.search_rounded, color: AppColors.textSecondary, size: 22),
              const SizedBox(width: 12),
              Text(
                'Search groceries, stationery...',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  color: AppColors.textHint,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Filter',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.2, end: 0, delay: 100.ms);
  }

  Widget _buildBannerSlider() {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: CarouselSlider.builder(
        itemCount: controller.dummyBanners.length,
        options: CarouselOptions(
          height: 160,
          autoPlay: true,
          autoPlayInterval: const Duration(seconds: 3),
          autoPlayAnimationDuration: const Duration(milliseconds: 800),
          autoPlayCurve: Curves.easeInOut,
          enlargeCenterPage: true,
          enlargeFactor: 0.1,
          viewportFraction: 0.88,
        ),
        itemBuilder: (context, index, realIndex) {
          final banner = controller.dummyBanners[index];
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(banner.color1), Color(banner.color2)],
              ),
              boxShadow: [
                BoxShadow(
                  color: Color(banner.color1).withOpacity(0.4),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Stack(
              children: [
                // Background pattern circles
                Positioned(
                  right: -20,
                  top: -20,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.1),
                    ),
                  ),
                ),
                Positioned(
                  right: 20,
                  bottom: -30,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.08),
                    ),
                  ),
                ),
                // Content
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              banner.subtitle,
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 12,
                                color: Colors.white.withOpacity(0.85),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              banner.title,
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                'Shop Now',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Color(banner.color1),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        banner.emoji,
                        style: const TextStyle(fontSize: 60),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    ).animate().fadeIn(delay: 200.ms);
  }

  Widget _buildCategoriesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(title: 'Shop by Category', onSeeAll: () => Get.toNamed(AppRoutes.categories)),
        SizedBox(
          height: 100,
          child: Obx(() => ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                physics: const BouncingScrollPhysics(),
                itemCount: controller.categories.length,
                itemBuilder: (context, index) {
                  final cat = controller.categories[index];
                  return _CategoryChip(category: cat, index: index);
                },
              )),
        ),
      ],
    );
  }

  Widget _buildFlashDeals() {
    return Obx(() {
      if (controller.flashDeals.isEmpty) return const SizedBox.shrink();
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(
            title: '⚡ Flash Deals',
            subtitle: 'Limited time offers',
            onSeeAll: () {},
            titleColor: AppColors.accentOrange,
          ),
          SizedBox(
            height: 220,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              physics: const BouncingScrollPhysics(),
              itemCount: controller.flashDeals.length,
              itemBuilder: (context, index) {
                return ProductCard(
                  product: controller.flashDeals[index],
                  index: index,
                  isFlashDeal: true,
                );
              },
            ),
          ),
        ],
      );
    });
  }

  Widget _buildFeaturedSection() {
    return Obx(() => controller.isLoading.value
        ? _buildProductShimmer('Featured Products')
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SectionHeader(title: 'Featured Products', onSeeAll: () {}),
              SizedBox(
                height: 220,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  physics: const BouncingScrollPhysics(),
                  itemCount: controller.featuredProducts.length,
                  itemBuilder: (context, index) {
                    return ProductCard(
                      product: controller.featuredProducts[index],
                      index: index,
                    );
                  },
                ),
              ),
            ],
          ));
  }

  Widget _buildPopularSection() {
    return Obx(() => controller.isLoading.value
        ? const SizedBox.shrink()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SectionHeader(title: 'Popular Products', onSeeAll: () {}),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.72,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: controller.popularProducts.length,
                itemBuilder: (context, index) {
                  return ProductCard(
                    product: controller.popularProducts[index],
                    index: index,
                    isGrid: true,
                  );
                },
              ),
            ],
          ));
  }

  Widget _buildProductShimmer(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
          child: ShimmerWidget.rectangular(height: 20, width: 160),
        ),
        SizedBox(
          height: 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: 4,
            itemBuilder: (_, __) => Padding(
              padding: const EdgeInsets.only(right: 12),
              child: ShimmerWidget.rectangular(
                height: 210,
                width: 160,
                borderRadius: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final VoidCallback? onSeeAll;
  final Color? titleColor;

  const _SectionHeader({
    required this.title,
    this.subtitle,
    this.onSeeAll,
    this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: titleColor ?? AppColors.textPrimary,
                ),
              ),
              if (subtitle != null)
                Text(
                  subtitle!,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
            ],
          ),
          if (onSeeAll != null)
            GestureDetector(
              onTap: onSeeAll,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'See All',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final CategoryModel category;
  final int index;

  const _CategoryChip({required this.category, required this.index});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(
        AppRoutes.categoryProducts,
        arguments: category,
      ),
      child: Padding(
        padding: const EdgeInsets.only(right: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: category.color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: category.color.withOpacity(0.3),
                  width: 1.5,
                ),
              ),
              child: Center(
                child: Text(category.icon, style: const TextStyle(fontSize: 28)),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              category.name,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      )
          .animate()
          .fadeIn(delay: Duration(milliseconds: 100 * index))
          .slideX(begin: 0.3, end: 0, delay: Duration(milliseconds: 100 * index)),
    );
  }
}
