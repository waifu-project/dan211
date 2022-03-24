import 'dart:io';

import 'package:dan211/utils/http.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'app/routes/app_pages.dart';

// beforeHook() {

// }

// afterHook() {

// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  await XHttp.init();
  runApp(
    GetCupertinoApp(
      title: "211工程",
      localizationsDelegates: const [
        DefaultMaterialLocalizations.delegate,
        DefaultCupertinoLocalizations.delegate,
        DefaultWidgetsLocalizations.delegate,
      ],
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}

/// https://stackoverflow.com/a/61312927
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
