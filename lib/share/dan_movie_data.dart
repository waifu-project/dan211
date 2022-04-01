import 'dart:convert';

import 'package:flutter/services.dart';

import 'dan_movie_card.dart';

class DanMovieShareData {
  DanMovieShareData._internal();

  final String _assetFile = "assets/buitln/tags.json";

  late List<DanMovieCardItem> data;

  Future<List<DanMovieCardItem>> loadDataFromBuitlnAssets() async {
    String fileBuf = await rootBundle.loadString(_assetFile);
    List<dynamic> data = jsonDecode(fileBuf);
    return data.map((e) {
      var asWrapper = e as Map<String, dynamic>;
      return DanMovieCardItem.fromJson(asWrapper);
    }).toList();
  }

  Future<void> init() async {
    data = await loadDataFromBuitlnAssets();
  }

  factory DanMovieShareData() => _instance;

  static late final DanMovieShareData _instance = DanMovieShareData._internal();
}

var danMovieShareConstData = DanMovieShareData();