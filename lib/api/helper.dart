import 'package:dan211/modules/vod_movie.dart';

String createVodTypeURLAsObj(VodType _type) {
  return createVodTypeURL(_type.id);
}

String createVodTypeURL(int id) {
  return "/vodtype/$id.html";
}

/// [vodType] 为类型 `id`
/// [action] 为空则为全部
/// [page] 页数
///
/// 不要🙅🏻‍♀️使用 [createVodTypeURL] 函数来生成线路操作
String createVodTypeAndTypeURL({
  required int vodType,
  String action = "",
  int page = 1,
}) {
  return "/vodshow/$vodType---$action-----$page---.html";
}

String createVodDetailURL(String detailID) {
  return "/voddetail/$detailID.html";
}

String createArtDetailURL(String id) {
  return "/artdetail-$id.html";
}

String createSearchURL(String keyword) {
  return "/vodsearch/----$keyword---------.html";
}

String createVodPlayURL(String id) {
  return "/vodplay/$id.html";
}

/// 查询字段类型
enum PageQueryStringType {
  /// 搜索
  search,

  /// 线路
  vodtype,
}

extension SelfToString on PageQueryStringType {
  String get action {
    switch (this) {
      case PageQueryStringType.search:
        return "vodsearch";
      case PageQueryStringType.vodtype:
        return "vodtype";
      default:
        return "";
    }
  }
}

class PageQueryStringUtils {
  PageQueryStringUtils({
    required this.data,
    this.page = 1,
    this.type = PageQueryStringType.search,
  });

  int page;
  String data;
  final PageQueryStringType type;

  /// 根据 [page] 是否 `<=` 1
  bool get isPrev => page <= 1;

  @override
  String toString() {
    return "/${type.action}/$data----------$page---.html";
  }
}
