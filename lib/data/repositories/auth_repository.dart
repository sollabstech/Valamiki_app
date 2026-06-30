import 'package:firebase_auth/firebase_auth.dart';
import '../../core/services/firebase_service.dart';
import '../../core/services/storage_service.dart';
import '../../core/constants/app_constants.dart';
import '../models/user_model.dart';

class AuthRepository {
  final _firebase = FirebaseService.instance;
  final _storage = StorageService.instance;

  /// Step 1 — send OTP to the phone number (auto-prepends +91)
  Future<void> sendOTP({
    required String phone,
    required void Function(String verificationId) onCodeSent,
    required void Function(String error) onError,
    required void Function() onAutoVerified,
  }) async {
    // Re-apply before every call so hot-reload sessions stay unblocked.
    await _firebase.auth
        .setSettings(appVerificationDisabledForTesting: true);
    await _firebase.auth.verifyPhoneNumber(
      phoneNumber: '+91$phone',
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Auto-verified on Android (SMS auto-read)
        await _firebase.auth.signInWithCredential(credential);
        onAutoVerified();
      },
      verificationFailed: (FirebaseAuthException e) {
        onError(e.message ?? 'Verification failed');
      },
      codeSent: (String verificationId, int? resendToken) {
        onCodeSent(verificationId);
      },
      codeAutoRetrievalTimeout: (_) {},
    );
  }

  /// Step 2 — verify the 6-digit OTP and return the user
  Future<UserModel> verifyOTP({
    required String verificationId,
    required String otp,
    String name = '',
  }) async {
    final credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: otp,
    );
    final uc = await _firebase.auth.signInWithCredential(credential);
    return _handleUserCredential(uc, name: name);
  }

  Future<UserModel> _handleUserCredential(
    UserCredential uc, {
    String name = '',
  }) async {
    final user = uc.user!;
    final phone = user.phoneNumber?.replaceFirst('+91', '') ?? '';

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
        name: name.isNotEmpty ? name : 'User',
        email: '',
        phone: phone,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      await _firebase.firestore
          .collection(AppConstants.colUsers)
          .doc(user.uid)
          .set(userModel.toMap());
    }

    await _storage.saveLoginSession(user.uid, phone);
    return userModel;
  }

  Future<void> signOut() async {
    await _firebase.auth.signOut();
    await _storage.clearLoginSession();
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
