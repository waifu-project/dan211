import 'package:dan211/api/parse_utils.dart';
import 'package:dan211/api/send.dart';
import 'package:dan211/app/modules/vod_search/views/page_bar.dart';
import 'package:dan211/modules/vod_case.dart';
import 'package:dan211/share/dan_movie_card.dart';
import 'package:dan211/share/dan_movie_data.dart';
import 'package:get/get.dart';

class VodCaseController extends GetxController {
  int _caseIndex = 0;

  int get caseIndex => _caseIndex;

  set caseIndex(int newVal) {
    _caseIndex = newVal;
    update();
    fetchData();
  }

  VodCaseRespData data = VodCaseRespData(
    cards: [],
    pageData: RespPageData(),
    tags: [],
  );

  List<DanMovieCardItem> get shareData => danMovieShareConstData.data;

  DanMovieCardItem get currCaseItem => shareData[caseIndex];

  String currentTag = "全部";

  bool isLoading = false;
  String errorStack = "";
  int page = 1;

  String get _currentTagText {
    /// 事实上如果是 `全部` 则为传递 ` ` 内容
    if (currentTag == "全部") return "";
    return currentTag;
  }

  changeCurrentTag(String item) {
    currentTag = item;
    page = 1;
    update();
    fetchData();
  }

  changeCaseIndex(DanMovieCardItem? item) {
    if (item == null) return;
    var _index = shareData.indexOf(item);
    if (_index <= -1) return;
    currentTag = "全部";
    update();
    caseIndex = _index;
    update();
  }

  fetchData() async {
    isLoading = true;
    update();
    try {
      data = await SendHttp.getDataByVodType(
        item: currCaseItem,
        action: _currentTagText,
        page: page,
      );
      isLoading = false;
      errorStack = "";
      update();
    } on Exception catch (e) {
      isLoading = false;
      errorStack = e.toString();
      update();
    }
  }

  handlePrevAndNext(CupertinoPageBarActionType _type) async {
    var _p = page;
    if (_type == CupertinoPageBarActionType.prev) {
      page--;
    } else {
      page++;
    }
    await fetchData();

    /// 错误栈有内容回退操作
    if (errorStack.isNotEmpty) {
      page = _p;
    }
  }

  beforeHook() {
    caseIndex = 0;
  }

  @override
  void onInit() {
    super.onInit();
    beforeHook();
  }

  @override
  void onClose() {}
}
