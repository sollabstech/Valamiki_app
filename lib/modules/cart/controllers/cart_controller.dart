import 'package:get/get.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/helpers.dart';
import '../../../data/models/cart_model.dart';
import '../../../data/models/product_model.dart';

class CartController extends GetxController {
  final items = <CartItemModel>[].obs;

  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  double get subtotal => items.fold(0.0, (sum, item) => sum + item.totalPrice);

  double get deliveryCharge {
    if (subtotal == 0) return 0;
    return subtotal >= AppConstants.freeDeliveryThreshold ? 0 : AppConstants.deliveryCharge;
  }

  double get total => subtotal + deliveryCharge;

  bool get hasItems => items.isNotEmpty;

  bool isInCart(String productId) => items.any((item) => item.productId == productId);

  int getQuantity(String productId) {
    final item = items.firstWhereOrNull((item) => item.productId == productId);
    return item?.quantity ?? 0;
  }

  void addItem(ProductModel product) {
    final existingIndex = items.indexWhere((item) => item.productId == product.id);

    if (existingIndex >= 0) {
      items[existingIndex] = items[existingIndex].copyWith(
        quantity: items[existingIndex].quantity + 1,
      );
    } else {
      items.add(CartItemModel(
        productId: product.id,
        name: product.name,
        imageUrl: product.images.isNotEmpty ? product.images.first : '',
        price: product.price,
        discountPrice: product.discountPrice,
        unit: product.unit,
      ));
    }
    AppHelpers.showSuccess('${product.name} added to cart');
  }

  void removeItem(String productId) {
    items.removeWhere((item) => item.productId == productId);
  }

  void decrementItem(String productId) {
    final index = items.indexWhere((item) => item.productId == productId);
    if (index < 0) return;

    if (items[index].quantity <= 1) {
      removeItem(productId);
    } else {
      items[index] = items[index].copyWith(quantity: items[index].quantity - 1);
    }
  }

  void incrementItem(String productId) {
    final index = items.indexWhere((item) => item.productId == productId);
    if (index < 0) return;
    items[index] = items[index].copyWith(quantity: items[index].quantity + 1);
  }

  void clearCart() => items.clear();
}
