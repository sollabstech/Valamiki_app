import 'package:get/get.dart';
import '../controllers/valamiki_search_controller.dart';

class SearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VaSeachController>(() => VaSeachController());
  }
}
