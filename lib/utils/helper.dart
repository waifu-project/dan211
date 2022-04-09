import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';

void launchURL(String _url) async {
  if (!await launch(_url)) throw 'Could not launch $_url';
}

Future<void> setClipboardText(String text) async {
  return Clipboard.setData(
    ClipboardData(
      text: text,
    ),
  );
}
