import 'package:dan211/api/helper.dart';
import 'package:dan211/api/send.dart';
import 'package:dan211/app/modules/vod_search/views/page_bar.dart';
import 'package:dan211/modules/vod_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class VodSearchController extends GetxController {
  /// 搜索内容
  VodSearchRespData respData = VodSearchRespData(
    current: -1,
    total: -1,
    totalPage: -1,
    data: [],
  );

  /// 是否加载
  bool isLoading = false;

  /// 错误栈
  String errorStack = "";

  /// 一个 `flag`
  /// 用来判断是否是第一次操作
  bool firstRun = true;

  TextEditingController searchController = TextEditingController();

  handleSearch(String keyword) {
    debugPrint("keyword: $keyword");
    pageQuery.data = keyword;
    pageQuery.page = 1;
    fetchData();
  }

  PageQueryStringUtils pageQuery = PageQueryStringUtils(
    data: '',
  );

  bool isShowPageBar = false;

  /// 是否显示错误页面
  ///
  /// 判断条件
  ///
  /// [respData.data] 内容为空, 并且 [errorStack] 不为空
  bool get canShowErrorCase {
    return respData.data.isEmpty && errorStack.isNotEmpty;
  }

  fetchData() async {
    if (pageQuery.data.isEmpty) return;
    isShowPageBar = true;
    isLoading = true;
    update();
    try {
      var data = await SendHttp.getSearch(pageQuery);
      if (firstRun) {
        firstRun = false;
      }
      isLoading = false;
      respData = data;
      errorStack = "";
      update();
    } catch (e) {
      isLoading = false;
      errorStack = e.toString();
      if (respData.data.isEmpty) {
        isShowPageBar = false;
      }
      update();
    }
  }

  handlePrevAndNext(CupertinoPageBarActionType _type) async {
    var _p = pageQuery.page;
    if (_type == CupertinoPageBarActionType.prev) {
      pageQuery.page--;
    } else {
      pageQuery.page++;
    }
    await fetchData();

    /// 从缓存中判断若失败了, 则回退操作的 [pageQuery.page]
    if (errorStack.isNotEmpty) {
      pageQuery.page = _p;
    }
  }

  @override
  void onInit() {
    super.onInit();
    // fetchData();
  }

  @override
  void onClose() {}
}
