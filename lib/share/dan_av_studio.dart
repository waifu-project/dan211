import 'dart:convert';

import 'package:flutter/services.dart';

class DanAvStudio {
  DanAvStudio._internal();

  final String _assetFile = "assets/buitln/av_studios.json";

  List<String> data = [];

  /// 只要是初始化过 [data] 就不为空
  bool get isInit => data.isEmpty;

  Future<void> init() async {
    if (data.isNotEmpty) return;
    String fileBuf = await rootBundle.loadString(_assetFile);
    List<dynamic> _data = jsonDecode(fileBuf);
    data = _data.map((e) {
      return e as String;
    }).toList();
  }

  factory DanAvStudio() => _instance;

  static late final DanAvStudio _instance = DanAvStudio._internal();
}
