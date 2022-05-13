import 'package:dan211/utils/helper.dart';

// enum PlaySource { iina }

/// 调用 `iina` 播放
/// 用户需自行安装 :)
void easyPlayToIINA(String url) {
  return launchURL('iina://weblink?url=$url&new_window=1');
}
