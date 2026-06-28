import 'package:get/get.dart';
import '../../../data/models/banner_model.dart';
import '../../../data/models/category_model.dart';
import '../../../data/models/product_model.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/product_repository.dart';
import '../../../data/models/user_model.dart';

class HomeController extends GetxController {
  final _productRepo = ProductRepository();
  final _authRepo = AuthRepository();

  final currentIndex = 0.obs;
  final isLoading = true.obs;

  final user = Rxn<UserModel>();
  final banners = <BannerModel>[].obs;
  final categories = <CategoryModel>[].obs;
  final featuredProducts = <ProductModel>[].obs;
  final popularProducts = <ProductModel>[].obs;
  final flashDeals = <ProductModel>[].obs;

  // Dummy banners for UI
  final dummyBanners = [
    _DummyBanner(
      title: 'Fresh Groceries',
      subtitle: 'Up to 30% off',
      color1: 0xFF1A73E8,
      color2: 0xFF4FC3F7,
      emoji: '🥦',
    ),
    _DummyBanner(
      title: 'Stationery Sale',
      subtitle: 'Buy 2 Get 1 Free',
      color1: 0xFF6C63FF,
      color2: 0xFF9B8FFF,
      emoji: '✏️',
    ),
    _DummyBanner(
      title: 'Flash Deals',
      subtitle: 'Limited time offers',
      color1: 0xFFFF6F00,
      color2: 0xFFFFCA28,
      emoji: '⚡',
    ),
  ];

  @override
  void onInit() {
    super.onInit();
    loadInitialData();
  }

  Future<void> loadInitialData() async {
    isLoading.value = true;
    try {
      categories.value = CategoryModel.defaultCategories;

      // Load user data
      final currentUser = await _authRepo.getCurrentUser();
      user.value = currentUser;

      // Try loading from Firebase, fallback to dummy data
      try {
        final featured = await _productRepo.getFeaturedProducts();
        final popular = await _productRepo.getPopularProducts();
        final flash = await _productRepo.getFlashDeals();

        if (featured.isEmpty) {
          featuredProducts.value = ProductModel.dummyProducts.where((p) => p.isFeatured).toList();
        } else {
          featuredProducts.value = featured;
        }

        if (popular.isEmpty) {
          popularProducts.value = ProductModel.dummyProducts.where((p) => p.isPopular).toList();
        } else {
          popularProducts.value = popular;
        }

        if (flash.isEmpty) {
          flashDeals.value = ProductModel.dummyProducts.where((p) => p.isFlashDeal).toList();
        } else {
          flashDeals.value = flash;
        }
      } catch (_) {
        _loadDummyData();
      }
    } catch (_) {
      _loadDummyData();
    } finally {
      isLoading.value = false;
    }
  }

  void _loadDummyData() {
    final dummy = ProductModel.dummyProducts;
    featuredProducts.value = dummy.where((p) => p.isFeatured).toList();
    popularProducts.value = dummy.where((p) => p.isPopular).toList();
    flashDeals.value = dummy.where((p) => p.isFlashDeal).toList();
  }

  void changeTab(int index) => currentIndex.value = index;

  @override
  Future<void> refresh() => loadInitialData();

  String get greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  String get userName => user.value?.name.split(' ').first ?? 'there';
}

class _DummyBanner {
  final String title;
  final String subtitle;
  final int color1;
  final int color2;
  final String emoji;

  _DummyBanner({
    required this.title,
    required this.subtitle,
    required this.color1,
    required this.color2,
    required this.emoji,
  });
}
