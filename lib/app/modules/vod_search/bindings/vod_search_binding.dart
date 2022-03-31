import 'package:get/get.dart';

import '../controllers/vod_search_controller.dart';

class VodSearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VodSearchController>(
      () => VodSearchController(),
    );
  }
}
