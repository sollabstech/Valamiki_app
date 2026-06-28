import '../../core/services/firebase_service.dart';
import '../../core/services/storage_service.dart';
import '../../core/constants/app_constants.dart';
import '../models/user_model.dart';

class AuthRepository {
  final _firebase = FirebaseService.instance;
  final _storage = StorageService.instance;

  Future<UserModel> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    final credential = await _firebase.auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = credential.user!;
    await user.updateDisplayName(name);

    final userModel = UserModel(
      uid: user.uid,
      name: name,
      email: email,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await _firebase.firestore
        .collection(AppConstants.colUsers)
        .doc(user.uid)
        .set(userModel.toMap());

    await _storage.saveLoginSession(user.uid, email);
    return userModel;
  }

  Future<UserModel> signIn({
    required String email,
    required String password,
    bool rememberMe = false,
  }) async {
    final credential = await _firebase.auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = credential.user!;
    final doc = await _firebase.firestore
        .collection(AppConstants.colUsers)
        .doc(user.uid)
        .get();

    late UserModel userModel;
    if (doc.exists) {
      userModel = UserModel.fromMap(doc.data()!, user.uid);
    } else {
      userModel = UserModel(
        uid: user.uid,
        name: user.displayName ?? '',
        email: email,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      await _firebase.firestore
          .collection(AppConstants.colUsers)
          .doc(user.uid)
          .set(userModel.toMap());
    }

    await _storage.saveLoginSession(user.uid, email);
    if (rememberMe) await _storage.setBool(AppConstants.keyRememberMe, true);

    return userModel;
  }

  Future<void> signOut() async {
    await _firebase.auth.signOut();
    await _storage.clearLoginSession();
  }

  Future<void> resetPassword(String email) async {
    await _firebase.auth.sendPasswordResetEmail(email: email);
  }

  Future<UserModel?> getCurrentUser() async {
    final user = _firebase.currentUser;
    if (user == null) return null;

    final doc = await _firebase.firestore
        .collection(AppConstants.colUsers)
        .doc(user.uid)
        .get();

    if (!doc.exists) return null;
    return UserModel.fromMap(doc.data()!, user.uid);
  }

  Future<void> updateProfile(String uid, Map<String, dynamic> data) async {
    await _firebase.firestore
        .collection(AppConstants.colUsers)
        .doc(uid)
        .update({...data, 'updatedAt': DateTime.now()});
  }

  bool get isLoggedIn => _firebase.isLoggedIn;
}
