import 'dart:io';

import 'package:dan211/config/dart_const.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_playout/multiaudio/HLSManifestLanguage.dart';
import 'package:flutter_playout/multiaudio/MultiAudioSupport.dart';
import 'package:flutter_playout/player_observer.dart';
import 'package:flutter_playout/player_state.dart';
import 'package:flutter_playout/video.dart';

import 'hls.dart';

class VideoPlayout extends StatefulWidget {
  final PlayerState desiredState;
  final bool showPlayerControls;

  final String url;

  const VideoPlayout({
    Key? key,
    this.desiredState = PlayerState.PLAYING,
    this.showPlayerControls = true,
    required this.url,
  }) : super(key: key);

  @override
  _VideoPlayoutState createState() => _VideoPlayoutState();
}

class _VideoPlayoutState extends State<VideoPlayout>
    with PlayerObserver, MultiAudioSupport {
  String get _url => widget.url;
  List<HLSManifestLanguage> _hlsLanguages = [];

  // bool _isError = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, _getHLSManifestLanguages);
  }

  Future<void> _getHLSManifestLanguages() async {
    if (!Platform.isIOS && _url.isNotEmpty) {
      _hlsLanguages = await getManifestLanguages(_url);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        previousPageTitle: PREV_BUTTON_TITLE,
      ),
      child: SafeArea(
        child: Column(
          children: <Widget>[
            /* player */
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Video(
                autoPlay: true,
                showControls: widget.showPlayerControls,
                title: "",
                isLiveStream: false,
                position: 0,
                url: _url,
                onViewCreated: _onViewCreated,
                desiredState: widget.desiredState,
                loop: false,
              ),
            ),
            if (_hlsLanguages.length < 2 && !Platform.isIOS)
              Row(
                children: _hlsLanguages
                    .map(
                      (e) => MaterialButton(
                        child: Text(
                          e.name ?? "",
                        ),
                        onPressed: () {
                          setPreferredAudioLanguage(e.code ?? "");
                        },
                      ),
                    )
                    .toList(),
              ),
            // if (_isError)
            //   Text(
            //     "加载失败",
            //     style: TextStyle(
            //       color: CupertinoTheme.of(context).primaryColor,
            //     ),
            //   ),
          ],
        ),
      ),
    );
  }

  void _onViewCreated(int viewId) {
    listenForVideoPlayerEvents(viewId);
    enableMultiAudioSupport(viewId);
  }

  // @override
  // void onError(String? error) {
  //   super.onError(error);
  //   debugPrint(error);
  //   _isError = true;
  //   setState(() {});
  // }

  // @override
  // void onPlay() {
  //   super.onPlay();
  // }

  // @override
  // void onPause() {
  //   super.onPause();
  // }

  // @override
  // void onComplete() {
  //   super.onComplete();
  // }

}
