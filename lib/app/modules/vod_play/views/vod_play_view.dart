import 'package:dan211/utils/helper.dart';
import 'package:dan211/widget/k_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/vod_play_controller.dart';

class VodPlayView extends StatelessWidget {
  VodPlayView({Key? key}) : super(key: key);

  final VodPlayController play = Get.put(VodPlayController());

  @override
  Widget build(BuildContext context) {
    var _table = CupertinoTheme.of(context).textTheme.tabLabelTextStyle;

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        previousPageTitle: "返回",
      ),
      child: SafeArea(
        child: CupertinoScrollbar(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CupertinoButton.filled(
                          child: const Text("播放"),
                          onPressed: () {
                            /// TODO 目前仅支持 `ios`
                            if (!GetPlatform.isIOS) {
                              showCupertinoDialog(
                                context: Get.context as BuildContext,
                                builder: (_) => CupertinoAlertDialog(
                                  title: const Text("提示"),
                                  content: const Text("播放仅支持iOS平台"),
                                  actions: [
                                    CupertinoButton(
                                      child: const Text('爷知道了'),
                                      onPressed: () {
                                        Get.back();
                                      },
                                    )
                                  ],
                                ),
                              );
                              return;
                            }
                            var url = play.data.player.url;
                            if (url.isNotEmpty) {
                              launchURL(url);
                            }
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "猜你喜欢",
                              style: _table,
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        width: Get.width,
                        height: 120,
                        child: CupertinoScrollbar(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: IntrinsicHeight(
                              child: Row(
                                children: play.data.recommend
                                    .map(
                                      (sub) => Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: KMovieCard(
                                          imageURL: sub.cover,
                                          title: sub.title,
                                          space: 6.0,
                                          onTap: () {
                                            Get.back(
                                              result: sub.id,
                                            );
                                          },
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
