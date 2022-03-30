// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:io';

import 'package:html/parser.dart' as parser;

Future<String> readFileAsync(String f) async {
  File file = File(f);
  String futureContent = await file.readAsString();
  return futureContent;
}

/// 空内容解析的格式:
/// `共0条数据,当前/页`
///
/// `共1443条数据,当前1/145页`
///
/// 解析成:
///
/// ``` json
/// {
///   "total": 1443,
///   "current": 1,
///   "total_page": 145
/// }
///
/// ```
parseSearchPage() {}

void main() async {
  var data = await readFileAsync("search.html");
  var document = parser.parseFragment(data);
  var listNode = document.querySelectorAll("#list-focus li");

  List<Map<String, String>> cards = listNode.map((e) {
    var playIMG = e.querySelector(".play-img");
    var img = playIMG?.querySelector("img");
    var title = img?.attributes["alt"]?.trim() ?? "";
    var id = playIMG?.attributes["href"]?.split("/")[2].split(".html")[0] ?? "";
    var image = img?.attributes["src"]?.trim() ?? "";
    return {
      "id": id,
      "image": image,
      "title": title,
    };
  }).toList();

  var pageTip = document.querySelector(".page_tip")?.text.trim() ?? "";
  if (pageTip == "共0条数据,当前/页") {
    print("搜索的内容为空");
    return;
  } else {
    // 共1443条数据,当前1/145页
    var _pageCache = pageTip.split("条数据");
    var total = _pageCache[0].substring(1);
    var _pageNumberCache1 = _pageCache[1].split(",当前")[1];
    var _pageNumberCache = _pageNumberCache1.substring(
      0,
      _pageNumberCache1.length - 1,
    );
    var _pageNumberTarget = _pageNumberCache.split("/");
    var current = _pageNumberTarget[0];
    var totalPage = _pageNumberTarget[1];
    print("total: $total\n");
    print("current: $current\n");
    print("total_page: $totalPage\n");
  }

  print(cards);
}
