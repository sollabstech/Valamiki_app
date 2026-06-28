import 'package:get/get.dart';
import '../../../data/models/category_model.dart';
import '../../../data/models/product_model.dart';
import '../../../data/repositories/product_repository.dart';

class CategoriesController extends GetxController {
  final _productRepo = ProductRepository();

  final categories = <CategoryModel>[].obs;
  final products = <ProductModel>[].obs;
  final selectedCategory = Rxn<CategoryModel>();
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    categories.value = CategoryModel.defaultCategories;
    final args = Get.arguments;
    if (args is CategoryModel) {
      selectedCategory.value = args;
      loadCategoryProducts(args.id);
    }
  }

  void selectCategory(CategoryModel category) {
    selectedCategory.value = category;
    loadCategoryProducts(category.id);
  }

  Future<void> loadCategoryProducts(String categoryId) async {
    isLoading.value = true;
    try {
      final result = await _productRepo.getProductsByCategory(categoryId);
      if (result.isEmpty) {
        // Fallback to dummy data filtered by category
        products.value = ProductModel.dummyProducts
            .where((p) => p.categoryId == categoryId)
            .toList();
        if (products.isEmpty) {
          products.value = ProductModel.dummyProducts;
        }
      } else {
        products.value = result;
      }
    } catch (_) {
      products.value = ProductModel.dummyProducts;
    } finally {
      isLoading.value = false;
    }
  }
}
