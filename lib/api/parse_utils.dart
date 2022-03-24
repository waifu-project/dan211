import 'package:dan211/modules/movie.dart';
import 'package:html/dom.dart';

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
