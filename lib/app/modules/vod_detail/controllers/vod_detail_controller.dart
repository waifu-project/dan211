import 'package:dan211/api/send.dart';
import 'package:dan211/modules/vod_detail.dart';
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

  @override
  void onInit() {
    super.onInit();
    getIDFromArgs();
    fetchVodDetail();
  }

  @override
  void onClose() {}
}
