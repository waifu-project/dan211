import 'package:dan211/modules/vod_detail.dart';
import 'package:dan211/modules/vod_play.dart';
import 'package:get/get.dart';

class VodPlayController extends GetxController {
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
