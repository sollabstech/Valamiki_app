import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/constants/app_constants.dart';
import '../../core/services/firebase_service.dart';
import '../models/product_model.dart';

class ProductRepository {
  final _firebase = FirebaseService.instance;

  CollectionReference<Map<String, dynamic>> get _col =>
      _firebase.firestore.collection(AppConstants.colProducts);

  Future<List<ProductModel>> getFeaturedProducts({int limit = 10}) async {
    final snap = await _col
        .where('isFeatured', isEqualTo: true)
        .where('isAvailable', isEqualTo: true)
        .limit(limit)
        .get();
    return snap.docs.map((d) => ProductModel.fromMap(d.data(), d.id)).toList();
  }

  Future<List<ProductModel>> getPopularProducts({int limit = 10}) async {
    final snap = await _col
        .where('isPopular', isEqualTo: true)
        .where('isAvailable', isEqualTo: true)
        .orderBy('rating', descending: true)
        .limit(limit)
        .get();
    return snap.docs.map((d) => ProductModel.fromMap(d.data(), d.id)).toList();
  }

  Future<List<ProductModel>> getFlashDeals({int limit = 6}) async {
    final snap = await _col
        .where('isFlashDeal', isEqualTo: true)
        .where('isAvailable', isEqualTo: true)
        .limit(limit)
        .get();
    return snap.docs.map((d) => ProductModel.fromMap(d.data(), d.id)).toList();
  }

  Future<List<ProductModel>> getProductsByCategory(
    String categoryId, {
    int limit = 20,
    DocumentSnapshot? lastDoc,
  }) async {
    var query = _col
        .where('categoryId', isEqualTo: categoryId)
        .where('isAvailable', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .limit(limit);

    if (lastDoc != null) query = query.startAfterDocument(lastDoc);

    final snap = await query.get();
    return snap.docs.map((d) => ProductModel.fromMap(d.data(), d.id)).toList();
  }

  Future<ProductModel?> getProductById(String productId) async {
    final doc = await _col.doc(productId).get();
    if (!doc.exists) return null;
    return ProductModel.fromMap(doc.data()!, doc.id);
  }

  Future<List<ProductModel>> searchProducts(String query) async {
    // Basic search - for production use Algolia or Typesense
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
