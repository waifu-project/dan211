import 'package:dan211/config/dart_const.dart';
import 'package:dan211/share/dan_movie_card.dart';
import 'package:dan211/share/dan_movie_data.dart';
import 'package:dan211/widget/k_list_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DoMovieCaseView extends StatefulWidget {
  const DoMovieCaseView({
    Key? key,
  }) : super(key: key);

  @override
  State<DoMovieCaseView> createState() => _DoMovieCaseViewState();
}

class _DoMovieCaseViewState extends State<DoMovieCaseView> {
  String get _title => "选择线路";

  List<DanMovieCardItem> get _data => danMovieShareConstData.data;

  int get _curr => danMovieShareConstData.current;

  final ScrollController _controller = ScrollController(
    initialScrollOffset: 0,
  );

  @override
  void initState() {
    super.initState();
    beforeHook();
  }

  double get _height => 55.0;

  beforeHook() {
    // _controller.addListener(() {
    //   /// TODO 走缓存
    //   debugPrint("offset: ${_controller.offset}");
    // });
    var time = const Duration(
      milliseconds: 420,
    );
    Future.delayed(time, () {
      double offset = _curr * _height;
      debugPrint("before go to current index offset: $offset");
      if (_controller.hasClients) {
        double maxScroll = _controller.position.maxScrollExtent;
        if (offset >= maxScroll) {
          offset = maxScroll;
        }
        _controller.animateTo(
          offset,
          duration: time,
          curve: Curves.easeIn,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        previousPageTitle: PREV_BUTTON_TITLE,
        middle: Text(_title),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            showCupertinoDialog<void>(
              context: context,
              builder: (BuildContext context) => CupertinoAlertDialog(
                title: const Text('声明'),
                content: const Text(CASE_TIPS),
                actions: <CupertinoDialogAction>[
                  CupertinoDialogAction(
                    child: const Text('爷知道了'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            );
          },
          child: const Icon(
            CupertinoIcons.zzz,
          ),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: CupertinoScrollbar(
            isAlwaysShown: true,
            controller: _controller,
            child: SingleChildScrollView(
              controller: _controller,
              child: Column(
                children: List.generate(
                  _data.length,
                  (index) => Builder(builder: (context) {
                    var curr = _data[index];
                    var isCurrent = index == _curr;
                    return SizedBox(
                      height: _height,
                      child: CupertinoListTile(
                        selected: isCurrent,
                        trailing: Builder(builder: (context) {
                          var currWidget = const Icon(
                            CupertinoIcons.checkmark,
                          );
                          var _default = const SizedBox.shrink();
                          return isCurrent ? currWidget : _default;
                        }),
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(
                          CupertinoIcons.videocam_circle,
                        ),
                        title: Text(
                          curr.text ?? "",
                        ),
                        onTap: () {
                          Get.back<DanMovieCardItem>(
                            result: curr,
                          );
                        },
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
