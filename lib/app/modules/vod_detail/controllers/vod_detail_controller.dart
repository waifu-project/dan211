import 'package:dan211/api/send.dart';
import 'package:dan211/modules/vod_detail.dart';
import 'package:dan211/modules/vod_play.dart';
import 'package:dan211/share/dan_av_studio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class VodDetailController extends GetxController {
  final data = VodDetailData(
    category: '',
    cover: '',
    descHtml: '',
    title: '',
    vodPlayer: [],
    vodType: 0,
  ).obs;

  final isLoading = true.obs;

  final errorMsgStack = "".obs;

  /// 是否显示临界
  bool get showCRWidget => isLoading.value || errorMsgStack.value.isNotEmpty;

  final tryGroupValue = 0.obs;

  final _cacheID = "".obs;

  setCacheID(String id) {
    _cacheID.value = id;
  }

  /// 首先从缓存中获取 `id`
  ///
  /// 否则从上下文中拿 [Get.arguments]
  String get _id {
    if (_cacheID.value.isNotEmpty) return _cacheID.value;
    var args = Get.arguments;
    if (args == null) return "1dKtYt";
    return args as String;
  }

  getIDFromArgs() {
    var args = Get.arguments;
    if (args != null) {
      _cacheID.value = args;
    }
  }

  Future<MovieVodPlay> getPlayURL(String id) async {
    var data = await SendHttp.getVodPlayURL(id);
    debugPrint("get player url: ${data.player.url}");
    return data;
  }

  fetchVodDetail() async {
    isLoading.value = true;
    try {
      // await Future.delayed(const Duration(seconds: 3));
      var _ = await SendHttp.getVodDetail(_id);
      isLoading.value = false;
      errorMsgStack.value = "";
      data.value = _;
    } catch (e) {
      e.printError();
      errorMsgStack.value = e.toString();
      isLoading.value = false;
    }
  }

  DanAvStudio avStudio = DanAvStudio();

  List<String> get avStudioData => avStudio.data;

  initAvStudio() async {
    await avStudio.init();
  }

  @override
  void onInit() {
    super.onInit();
    getIDFromArgs();
    initAvStudio();
    fetchVodDetail();
  }

  @override
  void onClose() {}
}
