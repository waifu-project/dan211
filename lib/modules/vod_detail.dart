// To parse this JSON data, do
//
//     final vodDetailData = vodDetailDataFromJson(jsonString);

import 'dart:convert';

VodDetailData vodDetailDataFromJson(String str) =>
    VodDetailData.fromJson(json.decode(str));

String vodDetailDataToJson(VodDetailData data) => json.encode(data.toJson());

class VodDetailData {
  VodDetailData({
    required this.title,
    required this.cover,
    required this.vodType,
    required this.category,
    required this.vodPlayer,
    required this.descHtml,
  });

  final String title;
  final String cover;
  final int vodType;
  final String category;
  final List<VodPlayer> vodPlayer;
  final String descHtml;

  factory VodDetailData.fromJson(Map<String, dynamic> json) => VodDetailData(
        title: json["title"],
        cover: json["cover"],
        vodType: json["vod_type"],
        category: json["category"],
        vodPlayer: List<VodPlayer>.from(
            json["vod_player"].map((x) => VodPlayer.fromJson(x))),
        descHtml: json["desc_html"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "cover": cover,
        "vod_type": vodType,
        "category": category,
        "vod_player": List<dynamic>.from(vodPlayer.map((x) => x.toJson())),
        "desc_html": descHtml,
      };
}

class VodPlayer {
  VodPlayer({
    required this.title,
    required this.url,
  });

  final String title;
  final String url;

  factory VodPlayer.fromJson(Map<String, dynamic> json) => VodPlayer(
        title: json["title"],
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "url": url,
      };
}
