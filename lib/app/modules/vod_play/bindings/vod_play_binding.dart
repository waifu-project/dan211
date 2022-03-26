import 'package:get/get.dart';

import '../controllers/vod_play_controller.dart';

class VodPlayBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VodPlayController>(
      () => VodPlayController(),
    );
  }
}
