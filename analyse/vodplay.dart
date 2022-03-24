// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:io';

import 'package:html/parser.dart' as parser;

// To parse this JSON data, do
//
//     final movieVodPlayCodeData = movieVodPlayCodeDataFromMap(jsonString);

import 'dart:convert';

MovieVodPlayCodeData movieVodPlayCodeDataFromMap(String str) =>
    MovieVodPlayCodeData.fromMap(json.decode(str));

String movieVodPlayCodeDataToMap(MovieVodPlayCodeData data) =>
    json.encode(data.toMap());

class MovieVodPlayCodeData {
  MovieVodPlayCodeData({
    required this.flag,
    required this.encrypt,
    required this.trysee,
    required this.points,
    required this.link,
    required this.linkNext,
    required this.linkPre,
    required this.url,
    required this.urlNext,
    required this.from,
    required this.server,
    required this.note,
    required this.id,
    required this.sid,
    required this.nid,
  });

  final String flag;
  final int encrypt;
  final int trysee;
  final int points;
  final String link;
  final String linkNext;
  final String linkPre;
  final String url;
  final String urlNext;
  final String from;
  final String server;
  final String note;
  final String id;
  final int sid;
  final int nid;

  factory MovieVodPlayCodeData.fromMap(Map<String, dynamic> json) =>
      MovieVodPlayCodeData(
        flag: json["flag"],
        encrypt: json["encrypt"],
        trysee: json["trysee"],
        points: json["points"],
        link: json["link"],
        linkNext: json["link_next"],
        linkPre: json["link_pre"],
        url: json["url"],
        urlNext: json["url_next"],
        from: json["from"],
        server: json["server"],
        note: json["note"],
        id: json["id"],
        sid: json["sid"],
        nid: json["nid"],
      );

  Map<String, dynamic> toMap() => {
        "flag": flag,
        "encrypt": encrypt,
        "trysee": trysee,
        "points": points,
        "link": link,
        "link_next": linkNext,
        "link_pre": linkPre,
        "url": url,
        "url_next": urlNext,
        "from": from,
        "server": server,
        "note": note,
        "id": id,
        "sid": sid,
        "nid": nid,
      };
}

Future<String> readFileAsync(String f) async {
  File file = File(f);
  String futureContent = await file.readAsString();
  return futureContent;
}

void main() async {
  var html = await readFileAsync("player.html");
  var document = parser.parseFragment(html);
  var select = document.querySelector("#bofang_box script");
  var text = select!.text.trim();
  var sybId = "var player_aaaa = ";
  var copyData = text.split(sybId);
  if (copyData.length == 2) {
    var parseTarget = copyData[1];
    var face = movieVodPlayCodeDataFromMap(parseTarget);
    print("播放地址: ${ face.url }");
  } else {
    print("查找失败");
  }
}


/// 获取播放地址