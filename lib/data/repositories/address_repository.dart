import '../../core/constants/app_constants.dart';
import '../../core/services/firebase_service.dart';
import '../models/address_model.dart';

class AddressRepository {
  final _firebase = FirebaseService.instance;

  Future<List<AddressModel>> getUserAddresses(String userId) async {
    final snap = await _firebase.firestore
        .collection(AppConstants.colUsers)
        .doc(userId)
        .collection(AppConstants.colAddresses)
        .get();
    return snap.docs.map((d) => AddressModel.fromMap(d.data(), d.id)).toList();
  }

  Future<String> addAddress(String userId, AddressModel address) async {
    final docRef = await _firebase.firestore
        .collection(AppConstants.colUsers)
        .doc(userId)
        .collection(AppConstants.colAddresses)
        .add(address.toMap());
    return docRef.id;
  }

  Future<void> updateAddress(String userId, AddressModel address) async {
    await _firebase.firestore
        .collection(AppConstants.colUsers)
        .doc(userId)
        .collection(AppConstants.colAddresses)
        .doc(address.id)
        .update(address.toMap());
  }

  Future<void> deleteAddress(String userId, String addressId) async {
    await _firebase.firestore
        .collection(AppConstants.colUsers)
        .doc(userId)
        .collection(AppConstants.colAddresses)
        .doc(addressId)
        .delete();
  }

  Future<void> setDefaultAddress(String userId, String addressId) async {
    // Unset all defaults
    final addresses = await getUserAddresses(userId);
    final batch = _firebase.firestore.batch();

    for (final addr in addresses) {
      final ref = _firebase.firestore
          .collection(AppConstants.colUsers)
          .doc(userId)
          .collection(AppConstants.colAddresses)
          .doc(addr.id);
      batch.update(ref, {'isDefault': addr.id == addressId});
    }
    await batch.commit();
  }
}
