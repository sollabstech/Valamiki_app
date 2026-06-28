class CartItemModel {
  final String productId;
  final String name;
  final String imageUrl;
  final double price;
  final double discountPrice;
  final String unit;
  int quantity;

  CartItemModel({
    required this.productId,
    required this.name,
    this.imageUrl = '',
    required this.price,
    this.discountPrice = 0,
    this.unit = 'piece',
    this.quantity = 1,
  });

  double get effectivePrice => discountPrice > 0 ? discountPrice : price;
  double get totalPrice => effectivePrice * quantity;

  factory CartItemModel.fromMap(Map<String, dynamic> map) {
    return CartItemModel(
      productId: map['productId'] ?? '',
      name: map['name'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      discountPrice: (map['discountPrice'] ?? 0).toDouble(),
      unit: map['unit'] ?? 'piece',
      quantity: map['quantity'] ?? 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'name': name,
      'imageUrl': imageUrl,
      'price': price,
      'discountPrice': discountPrice,
      'unit': unit,
      'quantity': quantity,
    };
  }

  CartItemModel copyWith({int? quantity}) {
    return CartItemModel(
      productId: productId,
      name: name,
      imageUrl: imageUrl,
      price: price,
      discountPrice: discountPrice,
      unit: unit,
      quantity: quantity ?? this.quantity,
    );
  }
}
