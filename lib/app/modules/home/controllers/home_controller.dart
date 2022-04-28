import 'package:dan211/api/send.dart';
import 'package:dan211/app/modules/single_page/show_case.dart';
import 'package:dan211/modules/vod_movie.dart';
import 'package:dan211/share/first_run.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

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

  /// 检测是否是第一次运行
  checkFirstRun() async {
    await Future.delayed(
      const Duration(
        seconds: 2,
      ),
    );
    var flag = isFirstRun.value;
    if (flag) {
      await Future.delayed(const Duration(seconds: 1));
      await showCupertinoModalBottomSheet(
        expand: false,
        duration: const Duration(
          milliseconds: 420,
        ),
        context: Get.context as BuildContext,
        builder: (context) => const ShowCasePage(),
      );
      isFirstRun.save(false);
    }
  }

  @override
  void onInit() {
    super.onInit();
    checkFirstRun();
    fetchHomeData();
  }
}
