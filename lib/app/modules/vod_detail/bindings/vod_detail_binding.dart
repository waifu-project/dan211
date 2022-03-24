import 'package:get/get.dart';

import '../controllers/vod_detail_controller.dart';

class VodDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VodDetailController>(
      () => VodDetailController(),
    );
  }
}
