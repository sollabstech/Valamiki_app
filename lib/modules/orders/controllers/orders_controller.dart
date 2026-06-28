import 'package:get/get.dart';
import '../../../core/services/firebase_service.dart';
import '../../../data/models/order_model.dart';
import '../../../data/repositories/order_repository.dart';

class OrdersController extends GetxController {
  final _orderRepo = OrderRepository();

  final orders = <OrderModel>[].obs;
  final selectedOrder = Rxn<OrderModel>();
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadOrders();
    final args = Get.arguments;
    if (args is OrderModel) selectedOrder.value = args;
  }

  Future<void> loadOrders() async {
    isLoading.value = true;
    try {
      final uid = FirebaseService.instance.currentUserId;
      if (uid != null) {
        orders.value = await _orderRepo.getUserOrders(uid);
      }
    } catch (_) {
    } finally {
      isLoading.value = false;
    }
  }

  void selectOrder(OrderModel order) {
    selectedOrder.value = order;
  }

  Future<void> refresh() => loadOrders();
}
