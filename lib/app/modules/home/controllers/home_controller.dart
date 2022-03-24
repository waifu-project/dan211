import 'package:dan211/api/send.dart';
import 'package:dan211/modules/movie.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  Rx<MovieVodPlayCodeData> data = MovieVodPlayCodeData(
    artDatas: [],
    homeCards: [],
    vodTypes: [],
  ).obs;

  final isLoading = true.obs;

  final errorMsgStack = "".obs;

  /// 是否显示临界
  bool get showCRWidget => isLoading.value || errorMsgStack.value.isNotEmpty;

  fetchHomeData() async {
    isLoading.value = true;
    try {
      // await Future.delayed(const Duration(seconds: 3));
      var _ = await SendHttp.getHome();
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
    fetchHomeData();
  }
}
