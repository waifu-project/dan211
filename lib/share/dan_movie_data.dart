// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';

import 'dan_movie_card.dart';

class DanMovieShareData {
  DanMovieShareData._internal();

  final String _assetFile = "assets/buitln/tags.json";

  late List<DanMovieCardItem> data;

  int current = 0;

  final _box = GetStorage();

  final String _KEY = "";

  int getCurrentFromCache() {
    return _box.read<int>(_KEY) ?? 0;
  }

  Future<void> setCurrent(int newVal) async {
    current = newVal;
    return _box.write(_KEY, newVal);
  }

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
    current = getCurrentFromCache();
  }

  factory DanMovieShareData() => _instance;

  static late final DanMovieShareData _instance = DanMovieShareData._internal();
}

var danMovieShareConstData = DanMovieShareData();
