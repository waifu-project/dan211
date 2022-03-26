import 'package:get/get.dart';

import '../modules/art_detail/bindings/art_detail_binding.dart';
import '../modules/art_detail/views/art_detail_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/vod_detail/bindings/vod_detail_binding.dart';
import '../modules/vod_detail/views/vod_detail_view.dart';
import '../modules/vod_play/bindings/vod_play_binding.dart';
import '../modules/vod_play/views/vod_play_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.VOD_DETAIL,
      page: () => VodDetailView(),
      binding: VodDetailBinding(),
    ),
    GetPage(
      name: _Paths.ART_DETAIL,
      page: () => ArtDetailView(),
      binding: ArtDetailBinding(),
    ),
    GetPage(
      name: _Paths.VOD_PLAY,
      page: () => VodPlayView(),
      binding: VodPlayBinding(),
    ),
  ];
}
