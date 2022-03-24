import 'package:dan211/modules/movie.dart';

String createVodTypeURLAsObj(VodType _type) {
  return createVodTypeURL(_type.id);
}

String createVodTypeURL(int id) {
  return "/vodtype/$id.html";
}

/// [action] 为空则为全部
String createVodTypeAndTypeURL(int vodType, String action) {
  return "/vodshow/$vodType---$action--------.html";
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

/// 查询字段类型
enum PageQueryStringType {
  /// 搜索
  search,
}

extension SelfToString on PageQueryStringType {
  String get action {
    switch (this) {
      case PageQueryStringType.search:
        return "vodsearch";
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

  final int page;
  final String data;
  final PageQueryStringType type;

  /// 根据 [page] 是否 `<=` 1
  bool get isPrev => page <= 1;

  @override
  String toString() {
    return "/${type.action}/$data----------$page---.html";
  }
}
