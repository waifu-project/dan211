import 'package:get/get.dart';

import '../controllers/art_detail_controller.dart';

class ArtDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ArtDetailController>(
      () => ArtDetailController(),
    );
  }
}
