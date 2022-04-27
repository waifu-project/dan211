import 'package:dan211/app/modules/vod_detail/controllers/vod_detail_controller.dart';
import 'package:dan211/modules/vod_detail.dart';
import 'package:dan211/modules/vod_play.dart';
import 'package:get/get.dart';

class VodPlayController extends GetxController {
  VodDetailController vodDetailController = Get.find<VodDetailController>();

  /// 从上一个栈拿到数据
  /// [vodDetailController.data]
  String get vodDetailCover {
    return vodDetailController.data.value.cover;
  }

  MovieVodPlay get data {
    var _arg = Get.arguments;
    if (_arg == null || _arg is String) {
      return MovieVodPlay(
        player: VodPlayer(
          title: '',
          url: '',
        ),
        recommend: [],
      );
    }
    return _arg as MovieVodPlay;
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {}
}
