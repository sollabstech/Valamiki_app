import 'package:get/get.dart';
import '../../../data/models/product_model.dart';
import '../../../data/repositories/product_repository.dart';
import '../../cart/controllers/cart_controller.dart';

class ProductController extends GetxController {
  final _productRepo = ProductRepository();
  final _cartController = Get.find<CartController>();

  final product = Rxn<ProductModel>();
  final isLoading = false.obs;
  final selectedImageIndex = 0.obs;
  final quantity = 1.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is ProductModel) {
      product.value = args;
    } else if (args is String) {
      loadProduct(args);
    }
  }

  Future<void> loadProduct(String productId) async {
    isLoading.value = true;
    try {
      product.value = await _productRepo.getProductById(productId);
    } catch (_) {
    } finally {
      isLoading.value = false;
    }
  }

  void selectImage(int index) => selectedImageIndex.value = index;

  void increment() => quantity.value++;
  void decrement() {
    if (quantity.value > 1) quantity.value--;
  }

  void addToCart() {
    if (product.value == null) return;
    for (var i = 0; i < quantity.value; i++) {
      _cartController.addItem(product.value!);
    }
  }

  bool get isInCart {
    if (product.value == null) return false;
    return _cartController.isInCart(product.value!.id);
  }
}
