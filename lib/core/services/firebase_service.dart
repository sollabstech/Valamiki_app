import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';

class FirebaseService extends GetxService {
  static FirebaseService get instance => Get.find<FirebaseService>();

  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;

  User? get currentUser => auth.currentUser;
  String? get currentUserId => auth.currentUser?.uid;
  bool get isLoggedIn => auth.currentUser != null;

  Stream<User?> get authStateChanges => auth.authStateChanges();

  // Firestore helpers
  CollectionReference<Map<String, dynamic>> collection(String path) {
    return firestore.collection(path);
  }

  DocumentReference<Map<String, dynamic>> document(String collectionPath, String docId) {
    return firestore.collection(collectionPath).doc(docId);
  }

  // Timestamp
  static Timestamp get now => Timestamp.now();

  @override
  void onInit() {
    super.onInit();
    // Enable Firestore offline persistence
    firestore.settings = const Settings(
      persistenceEnabled: true,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );
  }
}
