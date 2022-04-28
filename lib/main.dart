import 'dart:io';

import 'package:dan211/share/dan_movie_data.dart';
import 'package:dan211/share/first_run.dart';
import 'package:dan211/utils/http.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'app/routes/app_pages.dart';

// beforeHook() {

// }

// afterHook() {

// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  await GetStorage.init();
  await danMovieShareConstData.init();
  await isFirstRun.init();
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
      defaultTransition: Transition.cupertino,
      // theme: CupertinoThemeData(brightness: Brightness.dark,),
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
