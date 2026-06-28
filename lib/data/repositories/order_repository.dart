import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/constants/app_constants.dart';
import '../../core/services/firebase_service.dart';
import '../models/order_model.dart';

class OrderRepository {
  final _firebase = FirebaseService.instance;

  CollectionReference<Map<String, dynamic>> get _col =>
      _firebase.firestore.collection(AppConstants.colOrders);

  Future<String> placeOrder(OrderModel order) async {
    final doc = await _col.add(order.toMap());
    return doc.id;
  }

  Future<List<OrderModel>> getUserOrders(String userId) async {
    final snap = await _col
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .get();
    return snap.docs.map((d) => OrderModel.fromMap(d.data(), d.id)).toList();
  }

  Future<OrderModel?> getOrderById(String orderId) async {
    final doc = await _col.doc(orderId).get();
    if (!doc.exists) return null;
    return OrderModel.fromMap(doc.data()!, doc.id);
  }

  Stream<List<OrderModel>> getUserOrdersStream(String userId) {
    return _col
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((d) => OrderModel.fromMap(d.data(), d.id)).toList());
  }

  Future<void> updateOrderStatus(String orderId, String status) async {
    await _col.doc(orderId).update({
      'orderStatus': status,
      'updatedAt': Timestamp.now(),
    });
  }
}
