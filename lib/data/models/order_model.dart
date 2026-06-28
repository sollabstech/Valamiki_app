import 'package:cloud_firestore/cloud_firestore.dart';
import 'cart_model.dart';
import 'address_model.dart';

class OrderModel {
  final String id;
  final String userId;
  final List<CartItemModel> products;
  final double subtotal;
  final double deliveryCharge;
  final double totalPrice;
  final AddressModel deliveryAddress;
  final String paymentMethod;
  final String orderStatus;
  final DateTime createdAt;
  final DateTime? updatedAt;

  OrderModel({
    required this.id,
    required this.userId,
    required this.products,
    required this.subtotal,
    this.deliveryCharge = 0,
    required this.totalPrice,
    required this.deliveryAddress,
    required this.paymentMethod,
    this.orderStatus = 'pending',
    required this.createdAt,
    this.updatedAt,
  });

  factory OrderModel.fromMap(Map<String, dynamic> map, String id) {
    return OrderModel(
      id: id,
      userId: map['userId'] ?? '',
      products: (map['products'] as List? ?? [])
          .map((p) => CartItemModel.fromMap(p as Map<String, dynamic>))
          .toList(),
      subtotal: (map['subtotal'] ?? 0).toDouble(),
      deliveryCharge: (map['deliveryCharge'] ?? 0).toDouble(),
      totalPrice: (map['totalPrice'] ?? 0).toDouble(),
      deliveryAddress: AddressModel.fromMap(
        (map['deliveryAddress'] as Map<String, dynamic>?) ?? {},
        '',
      ),
      paymentMethod: map['paymentMethod'] ?? 'Cash on Delivery',
      orderStatus: map['orderStatus'] ?? 'pending',
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (map['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'products': products.map((p) => p.toMap()).toList(),
      'subtotal': subtotal,
      'deliveryCharge': deliveryCharge,
      'totalPrice': totalPrice,
      'deliveryAddress': deliveryAddress.toMap(),
      'paymentMethod': paymentMethod,
      'orderStatus': orderStatus,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
    };
  }

  String get statusLabel {
    switch (orderStatus) {
      case 'pending': return 'Order Placed';
      case 'confirmed': return 'Confirmed';
      case 'shipped': return 'On the Way';
      case 'delivered': return 'Delivered';
      case 'cancelled': return 'Cancelled';
      default: return 'Unknown';
    }
  }

  int get statusIndex {
    switch (orderStatus) {
      case 'pending': return 0;
      case 'confirmed': return 1;
      case 'shipped': return 2;
      case 'delivered': return 3;
      default: return 0;
    }
  }
}
