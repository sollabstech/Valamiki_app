import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';

class StorageService extends GetxService {
  static StorageService get instance => Get.find<StorageService>();

  late SharedPreferences _prefs;

  Future<StorageService> init() async {
    _prefs = await SharedPreferences.getInstance();
    return this;
  }

  // Bool
  Future<bool> setBool(String key, bool value) => _prefs.setBool(key, value);
  bool getBool(String key, {bool defaultValue = false}) => _prefs.getBool(key) ?? defaultValue;

  // String
  Future<bool> setString(String key, String value) => _prefs.setString(key, value);
  String getString(String key, {String defaultValue = ''}) => _prefs.getString(key) ?? defaultValue;

  // Int
  Future<bool> setInt(String key, int value) => _prefs.setInt(key, value);
  int getInt(String key, {int defaultValue = 0}) => _prefs.getInt(key) ?? defaultValue;

  // Remove
  Future<bool> remove(String key) => _prefs.remove(key);

  // Clear all
  Future<bool> clearAll() => _prefs.clear();

  // Auth specific
  bool get isLoggedIn => getBool(AppConstants.keyIsLoggedIn);
  bool get isFirstLaunch => getBool(AppConstants.keyIsFirstLaunch, defaultValue: true);
  bool get rememberMe => getBool(AppConstants.keyRememberMe);
  String get userId => getString(AppConstants.keyUserId);
  String get userEmail => getString(AppConstants.keyUserEmail);

  Future<void> saveLoginSession(String userId, String email) async {
    await setBool(AppConstants.keyIsLoggedIn, true);
    await setString(AppConstants.keyUserId, userId);
    await setString(AppConstants.keyUserEmail, email);
  }

  Future<void> clearLoginSession() async {
    await setBool(AppConstants.keyIsLoggedIn, false);
    await remove(AppConstants.keyUserId);
    await remove(AppConstants.keyUserEmail);
  }

  Future<void> setFirstLaunchComplete() async {
    await setBool(AppConstants.keyIsFirstLaunch, false);
  }
}
