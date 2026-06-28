import 'package:flutter/material.dart';
import '../../core/constants/color_constants.dart';

class CategoryModel {
  final String id;
  final String name;
  final String imageUrl;
  final String icon;
  final Color color;
  final int productCount;
  final bool isActive;

  CategoryModel({
    required this.id,
    required this.name,
    this.imageUrl = '',
    this.icon = '',
    this.color = AppColors.primary,
    this.productCount = 0,
    this.isActive = true,
  });

  factory CategoryModel.fromMap(Map<String, dynamic> map, String id) {
    return CategoryModel(
      id: id,
      name: map['name'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      icon: map['icon'] ?? '',
      color: Color(map['color'] ?? 0xFF1A73E8),
      productCount: map['productCount'] ?? 0,
      isActive: map['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'imageUrl': imageUrl,
      'icon': icon,
      'color': color.toARGB32(),
      'productCount': productCount,
      'isActive': isActive,
    };
  }

  static List<CategoryModel> get defaultCategories => [
    CategoryModel(id: 'grocery', name: 'Grocery', icon: '🥦', color: AppColors.grocery),
    CategoryModel(id: 'stationery', name: 'Stationery', icon: '✏️', color: AppColors.stationery),
    CategoryModel(id: 'snacks', name: 'Snacks', icon: '🍟', color: AppColors.snacks),
    CategoryModel(id: 'household', name: 'Household', icon: '🏠', color: AppColors.household),
    CategoryModel(id: 'daily_essentials', name: 'Essentials', icon: '🧴', color: AppColors.dailyEssentials),
  ];
}
