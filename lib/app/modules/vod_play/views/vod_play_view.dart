import 'package:dan211/config/dart_const.dart';
import 'package:dan211/utils/helper.dart';
import 'package:dan211/widget/k_card.dart';
import 'package:dan211/widget/k_transparent_image.dart';
import 'package:dan211/widget/photo_hero.dart';
import 'package:flutter/cupertino.dart';

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
        previousPageTitle: PREV_BUTTON_TITLE,
      ),
      child: SafeArea(
        child: DefaultTextStyle(
          style: TextStyle(
            color: CupertinoDynamicColor.resolve(
              CupertinoColors.label,
              context,
            ),
          ),
          child: CupertinoScrollbar(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  PhotoHero(
                    photo: play.vodDetailCover,
                    child: FadeInImage.memoryNetwork(
                      width: double.infinity,
                      height: Get.height * .42,
                      placeholder: kTransparentImage,
                      image: play.vodDetailCover,
                      fit: BoxFit.cover,
                      imageErrorBuilder: (
                        context,
                        object,
                        stackTrace,
                      ) =>
                          Image.asset(
                        "assets/empty.png",
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: Get.height * .42,
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: double.infinity,
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
                                          width: 150,
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
