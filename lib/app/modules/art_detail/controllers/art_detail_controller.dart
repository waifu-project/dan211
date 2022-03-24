import 'package:dan211/api/send.dart';
import 'package:dan211/modules/art_detail.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class ArtDetailController extends GetxController {
  final data = ArtDetailData.fromArgs("", "").obs;

  final isLoading = true.obs;
  final errorMsgStack = "".obs;

  /// 是否显示临界
  bool get showCRWidget => isLoading.value || errorMsgStack.value.isNotEmpty;

  ArtDetailData get _args {
    // if (kDebugMode || Get.arguments == null) return ArtDetailData.fromArgs("12VtYt", "");
    return Get.arguments as ArtDetailData;
  }

  String get artTitle {
    return showCRWidget ? "" : data.value.title;
  }

  String get artDesc {
    return showCRWidget ? "" : data.value.desc;
  }

  String get _id => _args.id;

  fetchArtDetailData() async {
    isLoading.value = true;
    try {
      // await Future.delayed(const Duration(seconds: 3));
      var _ = await SendHttp.getArtDetail(_id);
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
    fetchArtDetailData();
  }

  @override
  void onClose() {}
}
