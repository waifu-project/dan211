import 'dart:async';

import 'package:dan211/api/parse_utils.dart';
import 'package:dan211/modules/art_detail.dart';
import 'package:dan211/modules/vod_case.dart';
import 'package:dan211/modules/vod_detail.dart';
import 'package:dan211/modules/vod_play.dart' as vodplay;
import 'package:dan211/modules/vod_search.dart';
import 'package:dan211/share/dan_movie_card.dart';
import 'package:flutter/foundation.dart';
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

  static Future<vodplay.MovieVodPlay> getVodPlayURL(String id) async {
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
    List<VodCard> vodCard = $.querySelectorAll(".img-list li").map((e) {
      var title = e.querySelector("h2")?.text.trim() ?? "";
      var cover = e.querySelector("img")?.attributes["src"]?.trim() ?? "";
      var id = e
          .querySelector("a")
          ?.attributes["href"]
          ?.split("/")[2]
          .split(".html")[0]
          .trim();
      return VodCard(
        id: id ?? "",
        cover: cover,
        title: title,
      );
    }).toList();
    // 网站谜一样的操作
    // `= ` | `=` 操作
    // var sybId = "var player_aaaa = ";
    // var copyData = text.split(sybId);
    // var parseTarget = copyData[1];
    var _data = vodplay.movieVodPlayCodeDataFromMap(parseTarget);
    return vodplay.MovieVodPlay(
      player: VodPlayer(
        url: _data.url,

        /// 暂时写死。。。
        title: '在线播放',
      ),
      recommend: vodCard,
    );
    // if (copyData.length == 2) {
    // } else {
    //   throw Error();
    // }
  }

  static Future<VodSearchRespData> getSearch(PageQueryStringUtils page) async {
    var resp = await XHttp.dio.get(page.toString());
    var document = parser.parseFragment(resp.data);
    var listNode = document.querySelectorAll("#list-focus li");

    List<VodCard> cards = listNode.map((e) {
      var playIMG = e.querySelector(".play-img");
      var img = playIMG?.querySelector("img");
      var title = img?.attributes["alt"]?.trim() ?? "";
      var id =
          playIMG?.attributes["href"]?.split("/")[2].split(".html")[0] ?? "";
      var image = img?.attributes["src"]?.trim() ?? "";
      return VodCard(
        cover: image,
        id: id,
        title: title,
      );
    }).toList();

    RespPageData _pageData = getRespPageData(document);

    return VodSearchRespData(
      data: cards,
      total: _pageData.total,
      current: _pageData.current,
      totalPage: _pageData.totalPage,
    );
  }

  static Future<VodCaseRespData> getDataByVodType({
    required DanMovieCardItem item,
    int page = 1,
    String action = "",
  }) async {
    String send = createVodTypeAndTypeURL(
      vodType: item.id ?? -1,
      page: page,
      action: action,
    );
    var resp = await XHttp.dio.get(send);
    var document = parser.parseFragment(resp.data);
    RespPageData _pageData = getRespPageData(document);
    List<String> tags = document
        .querySelectorAll("#first_list_p a")
        .map(
          (e) => e.text.trim(),
        )
        .toList();

    var listNode = document.querySelectorAll(".img-list li");

    List<VodCard> cards = listNode.map((e) {
      var a = e.querySelector("a");
      var img = a?.querySelector("img");
      var title = img?.attributes["alt"]?.trim() ?? "";
      var id = a?.attributes["href"]?.split("/")[2].split(".html")[0] ?? "";
      var image = img?.attributes["src"]?.trim() ?? "";
      return VodCard(
        cover: image,
        id: id,
        title: title,
      );
    }).toList();

    return VodCaseRespData(
      cards: cards,
      pageData: _pageData,
      tags: tags,
    );
  }
}
