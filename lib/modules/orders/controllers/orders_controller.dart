import 'dart:async';
import 'package:get/get.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/services/firebase_service.dart';
import '../../../data/models/order_model.dart';

class OrdersController extends GetxController {
  final orders = <OrderModel>[].obs;
  final selectedOrder = Rxn<OrderModel>();
  final isLoading = true.obs;

  StreamSubscription? _subscription;

  @override
  void onInit() {
    super.onInit();
    _listenToOrders();
    final args = Get.arguments;
    if (args is OrderModel) selectedOrder.value = args;
  }

  void _listenToOrders() {
    final uid = FirebaseService.instance.currentUserId;
    if (uid == null) {
      isLoading.value = false;
      return;
    }

    isLoading.value = true;
    _subscription = FirebaseService.instance.firestore
        .collection(AppConstants.colOrders)
        .where('userId', isEqualTo: uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen(
          (snapshot) {
            orders.value = snapshot.docs
                .map((doc) => OrderModel.fromMap(
                      doc.data() as Map<String, dynamic>,
                      doc.id,
                    ))
                .toList();
            isLoading.value = false;
          },
          onError: (_) => isLoading.value = false,
        );
  }

  void selectOrder(OrderModel order) => selectedOrder.value = order;

  @override
  Future<void> refresh() async {
    // Stream auto-refreshes; just re-subscribe if needed
    _subscription?.cancel();
    _listenToOrders();
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }
}
