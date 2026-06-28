import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/product_model.dart';
import '../../../data/repositories/product_repository.dart';

class VaSeachController extends GetxController {
  final _productRepo = ProductRepository();

  final searchController = TextEditingController();
  final results = <ProductModel>[].obs;
  final recentSearches = <String>[].obs;
  final isLoading = false.obs;
  final hasSearched = false.obs;

  Future<void> search(String query) async {
    if (query.trim().isEmpty) {
      results.clear();
      hasSearched.value = false;
      return;
    }

    isLoading.value = true;
    hasSearched.value = true;

    if (!recentSearches.contains(query) && query.length > 1) {
      recentSearches.insert(0, query);
      if (recentSearches.length > 5) recentSearches.removeLast();
    }

    try {
      final firebaseResults = await _productRepo.searchProducts(query);
      if (firebaseResults.isEmpty) {
        // Filter dummy products for offline/dev mode
        results.value = ProductModel.dummyProducts
            .where((p) => p.name.toLowerCase().contains(query.toLowerCase()) ||
                p.categoryName.toLowerCase().contains(query.toLowerCase()))
            .toList();
      } else {
        results.value = firebaseResults;
      }
    } catch (_) {
      results.value = ProductModel.dummyProducts
          .where((p) => p.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    } finally {
      isLoading.value = false;
    }
  }

  void clearSearch() {
    searchController.clear();
    results.clear();
    hasSearched.value = false;
  }

  void useRecent(String query) {
    searchController.text = query;
    search(query);
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
