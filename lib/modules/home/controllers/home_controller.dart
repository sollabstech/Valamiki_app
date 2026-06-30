import 'dart:async';
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

  StreamSubscription? _featuredSub;
  StreamSubscription? _popularSub;
  StreamSubscription? _flashSub;

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
    _loadUser();
    categories.value = CategoryModel.defaultCategories;
    _subscribeToProducts();
  }

  Future<void> _loadUser() async {
    try {
      user.value = await _authRepo.getCurrentUser();
    } catch (_) {}
  }

  void _subscribeToProducts() {
    isLoading.value = true;
    _pendingStreams = 3;

    _featuredSub = _productRepo.watchFeaturedProducts().listen(
      (products) {
        if (products.isEmpty) {
          featuredProducts.value =
              ProductModel.dummyProducts.where((p) => p.isFeatured).toList();
        } else {
          featuredProducts.value = products;
        }
        _checkDoneLoading();
      },
      onError: (_) {
        featuredProducts.value =
            ProductModel.dummyProducts.where((p) => p.isFeatured).toList();
        _checkDoneLoading();
      },
    );

    _popularSub = _productRepo.watchPopularProducts().listen(
      (products) {
        if (products.isEmpty) {
          popularProducts.value =
              ProductModel.dummyProducts.where((p) => p.isPopular).toList();
        } else {
          popularProducts.value = products;
        }
        _checkDoneLoading();
      },
      onError: (_) {
        popularProducts.value =
            ProductModel.dummyProducts.where((p) => p.isPopular).toList();
        _checkDoneLoading();
      },
    );

    _flashSub = _productRepo.watchFlashDeals().listen(
      (products) {
        if (products.isEmpty) {
          flashDeals.value =
              ProductModel.dummyProducts.where((p) => p.isFlashDeal).toList();
        } else {
          flashDeals.value = products;
        }
        _checkDoneLoading();
      },
      onError: (_) {
        flashDeals.value =
            ProductModel.dummyProducts.where((p) => p.isFlashDeal).toList();
        _checkDoneLoading();
      },
    );
  }

  int _pendingStreams = 3;

  void _checkDoneLoading() {
    _pendingStreams--;
    if (_pendingStreams <= 0) isLoading.value = false;
  }

  void changeTab(int index) => currentIndex.value = index;

  @override
  Future<void> refresh() async {
    _featuredSub?.cancel();
    _popularSub?.cancel();
    _flashSub?.cancel();
    _subscribeToProducts();
  }

  @override
  void onClose() {
    _featuredSub?.cancel();
    _popularSub?.cancel();
    _flashSub?.cancel();
    super.onClose();
  }

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
