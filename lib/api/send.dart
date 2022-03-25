import 'dart:async';

import 'package:dan211/api/parse_utils.dart';
import 'package:dan211/modules/art_detail.dart';
import 'package:dan211/modules/vod_detail.dart';
import 'package:dan211/modules/vod_play.dart' as vodplay;
import 'package:html/parser.dart' as parser;
import 'package:dan211/modules/vod_movie.dart';
import 'package:dan211/utils/http.dart';

import 'helper.dart';

class SendHttp {
  static Future<MovieVodPlayCodeData> getHome() async {
    var resp = await XHttp.dio.get("/");
    var data = resp.data;
    var $ = parser.parseFragment(data);
    var cards = $
        .querySelectorAll(".box")
        .sublist(0, 2)
        .map((e) => HomeCard(vodCards: getVodCard(e)))
        .toList();
    var arts = $.querySelectorAll(".box_news li").map((e) {
      var id = e
          .querySelector("a")!
          .attributes["href"]!
          .split("artdetail-")[1]
          .split(".html")[0];
      var title = e.text;
      return ArtData(id: id, title: title);
    }).toList();
    var render = MovieVodPlayCodeData(
      vodTypes: getVodType($),
      artDatas: arts,
      homeCards: cards,
    );
    return render;
  }

  static Future<ArtDetailData> getArtDetail(String id) async {
    var resp = await XHttp.dio.get(createArtDetailURL(id));
    var data = resp.data;
    var $ = parser.parseFragment(data);
    var newsEle = $.querySelector(".news");
    var title = newsEle!.querySelector("h1")?.text.trim() ?? "";
    var desc = newsEle.querySelector(".source")?.text.trim() ?? "";
    List<String> imgs = newsEle
        .querySelectorAll("img")
        .map((e) => e.attributes["src"] ?? "")
        .toList();
    return ArtDetailData(
      desc: desc,
      title: title,
      images: imgs,
      id: id,
    );
  }

  static Future<VodDetailData> getVodDetail(String id) async {
    var resp = await XHttp.dio.get(createVodDetailURL(id));
    var data = resp.data;
    var $ = parser.parseFragment(data);
    var cover = $.querySelector(".detail-pic img")!.attributes["src"] ?? "";
    var title = $.querySelector(".detail-title")!.text.trim();
    var tmpCol = $.querySelector(".info")!.querySelectorAll("dl");
    var category = tmpCol.last.text.trim();
    tmpCol.removeLast();
    var vodType = 0;
    var vodHref = tmpCol.last.querySelector("a")!.attributes["href"];
    vodType = int.parse(vodHref!.split("/")[2].split(".html")[0]);
    var descHtml = $.getElementById("juqing")?.innerHtml.trim() ?? "";
    List<VodPlayer> player = $.querySelectorAll(".video_list a").map((e) {
      var title = e.text.trim();
      var url = e.attributes["href"]!.split("/")[2].split(".html")[0].trim();
      return VodPlayer(title: title, url: url);
    }).toList();
    return VodDetailData(
      category: category,
      cover: cover,
      descHtml: descHtml,
      title: title,
      vodPlayer: player,
      vodType: vodType,
    );
  }

  static Future<String> getVodPlayURL(String id) async {
    var resp = await XHttp.dio.get(createVodPlayURL(id));
    var data = resp.data;
    var $ = parser.parseFragment(data);
    var select = $.querySelector("#bofang_box script");
    var text = select!.text.trim();
    var fristIndex = text.indexOf("{");
    var parseTarget = "";
    if (fristIndex >= 0) {
      var _idl = text[fristIndex - 1];
      if (_idl == " " || _idl == "=") {
        parseTarget = text.substring(fristIndex);
      }
    }
    if (parseTarget.isEmpty) {
      throw AsyncError(
        "parse error",
        StackTrace.fromString("解析失败"),
      );
    }
    // 网站谜一样的操作
    // `= ` | `=` 操作
    // var sybId = "var player_aaaa = ";
    // var copyData = text.split(sybId);
    // var parseTarget = copyData[1];
    var _data = vodplay.movieVodPlayCodeDataFromMap(parseTarget);
    return _data.url;
    // if (copyData.length == 2) {
    // } else {
    //   throw Error();
    // }
  }
}
