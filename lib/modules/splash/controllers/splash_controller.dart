import 'package:get/get.dart';
import '../../../core/services/storage_service.dart';
import '../../../routes/app_routes.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(milliseconds: 3200));

    final storage = StorageService.instance;

    if (storage.isFirstLaunch) {
      Get.offAllNamed(AppRoutes.onboarding);
    } else if (storage.isLoggedIn) {
      Get.offAllNamed(AppRoutes.home);
    } else {
      Get.offAllNamed(AppRoutes.login);
    }
  }
}
