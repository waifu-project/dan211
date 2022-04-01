import 'package:get/get.dart';

import '../controllers/vod_case_controller.dart';

class VodCaseBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VodCaseController>(
      () => VodCaseController(),
    );
  }
}
