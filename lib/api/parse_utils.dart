import 'package:dan211/modules/vod_movie.dart';
import 'package:flutter/foundation.dart';
import 'package:html/dom.dart';

class RespPageData {
  RespPageData({
    this.total = -1,
    this.current = -1,
    this.totalPage = -1,
  });

  int total;
  int current;
  int totalPage;
}

RespPageData getRespPageData(DocumentFragment document) {
  int total = -1;
  int current = -1;
  int totalPage = -1;

  var pageTip = document.querySelector(".page_tip")?.text.trim() ?? "";
  if (pageTip == "共0条数据,当前/页") {
    debugPrint("搜索的内容为空");
  } else {
    // 共1443条数据,当前1/145页
    var _pageCache = pageTip.split("条数据");
    total = int.tryParse(_pageCache[0].substring(1)) ?? 0;
    var _pageNumberCache1 = _pageCache[1].split(",当前")[1];
    var _pageNumberCache = _pageNumberCache1.substring(
      0,
      _pageNumberCache1.length - 1,
    );
    var _pageNumberTarget = _pageNumberCache.split("/");
    current = int.tryParse(_pageNumberTarget[0]) ?? 0;
    totalPage = int.tryParse(_pageNumberTarget[1]) ?? 0;
    debugPrint("total: $total\n");
    debugPrint("current: $current\n");
    debugPrint("total_page: $totalPage\n");
  }
  return RespPageData(
    total: total,
    current: current,
    totalPage: totalPage,
  );
}

/// 获取 `vod-type`
List<VodType> getVodType(DocumentFragment $) {
  var _tags = $.querySelectorAll(".resou a");
  var tags = _tags.map((item) {
    var id = int.parse(item.attributes['href']!.split("/")[2].split(".")[0]);
    var text = item.text;
    return VodType(id: id, title: text);
  }).toList();
  return tags;
}

/// 获取 `vod-card`
List<VodCard> getVodCard(Element? $alias) {
  var _ = _commonParseCard($alias)
      .map(
        (e) => VodCard(
          id: e['id'] ?? "",
          cover: e['image'] ?? "",
          title: e['title'] ?? "",
        ),
      )
      .toList();
  return _;
}

List<Map<String, String?>> _commonParseCard(Element? ele) {
  var data = ele!.querySelectorAll("li").map((item) {
    var ele = item.querySelector("a");
    var eleAttr = ele?.attributes;
    var link = eleAttr?["href"]?.trim();
    var title = eleAttr?["title"]?.trim();
    var id = link?.split("/voddetail/")[1].split(".html")[0];
    var image = ele!.querySelector("img")?.attributes["src"]?.trim();
    return {
      "id": id,
      "image": image,
      "title": title,
    };
  }).toList();
  return data;
}
