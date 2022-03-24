import 'dart:io';

import 'package:html/dom.dart';
import 'package:html/parser.dart' as parser;

Future<String> readFileAsync(String f) async {
  File file = File(f);
  String futureContent = await file.readAsString();
  return futureContent;
}

/// 镜像实现: https://www.huaigongzi.com/
void main() async {
  var data = await readFileAsync("home.html");
  var $ = parser.parseFragment(data);

  /// 参考 `vodtype.dart` 实现
  // var _tags = $.querySelectorAll(".resou a");
  // var tags = _tags.map((item) {
  //   var id = item.attributes['href']!.split("/")[2].split(".")[0];
  //   var text = item.text;
  //   return {
  //     "id": id,
  //     "text": text,
  //   };
  // }).toList();
  // print(tags[1]);

  // /// 第一个板块
  // var cardOnce = $.querySelector("section.box");
  // String? cardOnceTitle = cardOnce!.querySelector("section.title")?.text.trim();
  // print(cardOnceTitle);
  // var lists = commonParseCard(cardOnce);
  // print(lists[0]);
  // /// =========

  $.querySelectorAll(".box").forEach((element) {
    commonParseGetTitle(element);
    var data = commonParseCard(element);
    print(data[0]);
  });
}

commonParseGetTitle(dynamic data) {
  String? cardOnceTitle = data!.querySelector("section.title")?.text.trim();
  print(cardOnceTitle);
}

List<Map<String, String?>> commonParseCard(Element? ele) {
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
