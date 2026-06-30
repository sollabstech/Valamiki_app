import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/constants/app_constants.dart';
import '../../core/services/firebase_service.dart';
import '../models/product_model.dart';

class ProductRepository {
  final _firebase = FirebaseService.instance;

  CollectionReference<Map<String, dynamic>> get _col =>
      _firebase.firestore.collection(AppConstants.colProducts);

  Stream<List<ProductModel>> watchFeaturedProducts({int limit = 10}) {
    return _col
        .where('isFeatured', isEqualTo: true)
        .where('isAvailable', isEqualTo: true)
        .limit(limit)
        .snapshots()
        .map((snap) =>
            snap.docs.map((d) => ProductModel.fromMap(d.data(), d.id)).toList());
  }

  Stream<List<ProductModel>> watchPopularProducts({int limit = 10}) {
    return _col
        .where('isPopular', isEqualTo: true)
        .where('isAvailable', isEqualTo: true)
        .limit(limit)
        .snapshots()
        .map((snap) =>
            snap.docs.map((d) => ProductModel.fromMap(d.data(), d.id)).toList());
  }

  Stream<List<ProductModel>> watchFlashDeals({int limit = 6}) {
    return _col
        .where('isFlashDeal', isEqualTo: true)
        .where('isAvailable', isEqualTo: true)
        .limit(limit)
        .snapshots()
        .map((snap) =>
            snap.docs.map((d) => ProductModel.fromMap(d.data(), d.id)).toList());
  }

  Future<List<ProductModel>> getProductsByCategory(
    String categoryId, {
    int limit = 20,
    DocumentSnapshot? lastDoc,
  }) async {
    var q = _col
        .where('categoryId', isEqualTo: categoryId)
        .where('isAvailable', isEqualTo: true)
        .limit(limit);

    if (lastDoc != null) q = q.startAfterDocument(lastDoc);

    final snap = await q.get();
    return snap.docs.map((d) => ProductModel.fromMap(d.data(), d.id)).toList();
  }

  Future<ProductModel?> getProductById(String productId) async {
    final d = await _col.doc(productId).get();
    if (!d.exists) return null;
    return ProductModel.fromMap(d.data()!, d.id);
  }

  Future<List<ProductModel>> searchProducts(String query) async {
    final snap = await _col
        .where('isAvailable', isEqualTo: true)
        .orderBy('name')
        .startAt([query])
        .endAt(['$query'])
        .limit(20)
        .get();
    return snap.docs.map((d) => ProductModel.fromMap(d.data(), d.id)).toList();
  }

  Future<List<ProductModel>> getAllProducts({int limit = 20}) async {
    final snap = await _col
        .where('isAvailable', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .get();
    return snap.docs.map((d) => ProductModel.fromMap(d.data(), d.id)).toList();
  }
}
