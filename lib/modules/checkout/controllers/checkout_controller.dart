import 'package:get/get.dart';
import '../../../core/services/firebase_service.dart';
import '../../../core/utils/helpers.dart';
import '../../../data/models/address_model.dart';
import '../../../data/models/order_model.dart';
import '../../../data/repositories/address_repository.dart';
import '../../../data/repositories/order_repository.dart';
import '../../cart/controllers/cart_controller.dart';
import '../../../routes/app_routes.dart';

class CheckoutController extends GetxController {
  final _addressRepo = AddressRepository();
  final _orderRepo = OrderRepository();
  final _cartController = Get.find<CartController>();

  final addresses = <AddressModel>[].obs;
  final selectedAddress = Rxn<AddressModel>();
  final selectedPaymentMethod = 'Cash on Delivery'.obs;
  final isLoading = false.obs;
  final isPlacingOrder = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadAddresses();
  }

  Future<void> loadAddresses() async {
    isLoading.value = true;
    try {
      final uid = FirebaseService.instance.currentUserId;
      if (uid != null) {
        addresses.value = await _addressRepo.getUserAddresses(uid);
        final defaultAddr = addresses.firstWhereOrNull((a) => a.isDefault);
        selectedAddress.value = defaultAddr ?? (addresses.isNotEmpty ? addresses.first : null);
      }
    } catch (_) {
    } finally {
      isLoading.value = false;
    }
  }

  void selectAddress(AddressModel address) {
    selectedAddress.value = address;
  }

  Future<void> placeOrder() async {
    if (selectedAddress.value == null) {
      AppHelpers.showError('Please add a delivery address');
      return;
    }

    if (_cartController.items.isEmpty) {
      AppHelpers.showError('Your cart is empty');
      return;
    }

    isPlacingOrder.value = true;
    try {
      final uid = FirebaseService.instance.currentUserId ?? '';
      final order = OrderModel(
        id: '',
        userId: uid,
        products: List.from(_cartController.items),
        subtotal: _cartController.subtotal,
        deliveryCharge: _cartController.deliveryCharge,
        totalPrice: _cartController.total,
        deliveryAddress: selectedAddress.value!,
        paymentMethod: selectedPaymentMethod.value,
        orderStatus: 'pending',
        createdAt: DateTime.now(),
      );

      final orderId = await _orderRepo.placeOrder(order);
      _cartController.clearCart();

      Get.offAllNamed(
        AppRoutes.orderConfirmation,
        arguments: {'orderId': orderId, 'total': order.totalPrice},
      );
    } catch (e) {
      AppHelpers.showError('Failed to place order. Please try again.');
    } finally {
      isPlacingOrder.value = false;
    }
  }

  void addNewAddress() => Get.toNamed(AppRoutes.addAddress)?.then((_) => loadAddresses());
}
