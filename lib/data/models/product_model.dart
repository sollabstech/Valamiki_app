import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  final String id;
  final String name;
  final String description;
  final String categoryId;
  final String categoryName;
  final double price;
  final double discountPrice;
  final double discountPercent;
  final List<String> images;
  final String unit;
  final int stock;
  final bool isAvailable;
  final bool isFeatured;
  final bool isPopular;
  final bool isFlashDeal;
  final double rating;
  final int reviewCount;
  final List<String> tags;
  final DateTime createdAt;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.categoryId,
    required this.categoryName,
    required this.price,
    this.discountPrice = 0,
    this.discountPercent = 0,
    this.images = const [],
    this.unit = 'piece',
    this.stock = 0,
    this.isAvailable = true,
    this.isFeatured = false,
    this.isPopular = false,
    this.isFlashDeal = false,
    this.rating = 0,
    this.reviewCount = 0,
    this.tags = const [],
    required this.createdAt,
  });

  double get effectivePrice => discountPrice > 0 ? discountPrice : price;
  bool get hasDiscount => discountPrice > 0 && discountPrice < price;

  factory ProductModel.fromMap(Map<String, dynamic> map, String id) {
    return ProductModel(
      id: id,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      categoryId: map['categoryId'] ?? '',
      categoryName: map['categoryName'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      discountPrice: (map['discountPrice'] ?? 0).toDouble(),
      discountPercent: (map['discountPercent'] ?? 0).toDouble(),
      images: List<String>.from(map['images'] ?? []),
      unit: map['unit'] ?? 'piece',
      stock: map['stock'] ?? 0,
      isAvailable: map['isAvailable'] ?? true,
      isFeatured: map['isFeatured'] ?? false,
      isPopular: map['isPopular'] ?? false,
      isFlashDeal: map['isFlashDeal'] ?? false,
      rating: (map['rating'] ?? 0).toDouble(),
      reviewCount: map['reviewCount'] ?? 0,
      tags: List<String>.from(map['tags'] ?? []),
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'categoryId': categoryId,
      'categoryName': categoryName,
      'price': price,
      'discountPrice': discountPrice,
      'discountPercent': discountPercent,
      'images': images,
      'unit': unit,
      'stock': stock,
      'isAvailable': isAvailable,
      'isFeatured': isFeatured,
      'isPopular': isPopular,
      'isFlashDeal': isFlashDeal,
      'rating': rating,
      'reviewCount': reviewCount,
      'tags': tags,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  // Dummy products for development/UI testing
  static List<ProductModel> get dummyProducts => [
    ProductModel(
      id: 'p1', name: 'Fresh Tomatoes', description: 'Farm fresh red tomatoes, rich in antioxidants.',
      categoryId: 'grocery', categoryName: 'Grocery', price: 60, discountPrice: 49,
      discountPercent: 18, images: [], unit: '500g', stock: 100,
      isFeatured: true, isPopular: true, rating: 4.5, reviewCount: 128, createdAt: DateTime.now(),
    ),
    ProductModel(
      id: 'p2', name: 'Classmate Notebook', description: '200 pages ruled notebook, premium quality.',
      categoryId: 'stationery', categoryName: 'Stationery', price: 85, discountPrice: 70,
      discountPercent: 18, images: [], unit: '1 piece', stock: 50,
      isFeatured: true, rating: 4.3, reviewCount: 56, createdAt: DateTime.now(),
    ),
    ProductModel(
      id: 'p3', name: 'Lays Classic Chips', description: 'Crispy salted potato chips.',
      categoryId: 'snacks', categoryName: 'Snacks', price: 20, discountPrice: 18,
      discountPercent: 10, images: [], unit: '26g', stock: 200,
      isFlashDeal: true, isPopular: true, rating: 4.7, reviewCount: 312, createdAt: DateTime.now(),
    ),
    ProductModel(
      id: 'p4', name: 'Tata Salt', description: 'Iodized salt for healthy cooking.',
      categoryId: 'grocery', categoryName: 'Grocery', price: 28, discountPrice: 25,
      discountPercent: 11, images: [], unit: '1 kg', stock: 300,
      isPopular: true, rating: 4.8, reviewCount: 890, createdAt: DateTime.now(),
    ),
    ProductModel(
      id: 'p5', name: 'Geometry Box', description: 'Complete geometry set with compass, protractor.',
      categoryId: 'stationery', categoryName: 'Stationery', price: 120, discountPrice: 99,
      discountPercent: 17, images: [], unit: '1 set', stock: 40,
      isFeatured: true, rating: 4.2, reviewCount: 34, createdAt: DateTime.now(),
    ),
    ProductModel(
      id: 'p6', name: 'Amul Butter', description: 'Pasteurized butter, made from fresh cream.',
      categoryId: 'grocery', categoryName: 'Grocery', price: 58, discountPrice: 55,
      discountPercent: 5, images: [], unit: '100g', stock: 80,
      isPopular: true, rating: 4.6, reviewCount: 445, createdAt: DateTime.now(),
    ),
  ];
}
