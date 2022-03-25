import 'package:dan211/modules/vod_detail.dart';
import 'package:dan211/utils/helper.dart';
import 'package:dan211/widget/k_error_stack.dart';
import 'package:dan211/widget/k_transparent_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import 'package:get/get.dart';

import '../controllers/vod_detail_controller.dart';

class VodDetailView extends GetView<VodDetailController> {
  VodDetailView({Key? key}) : super(key: key);

  bool get showCRWidget => controller.showCRWidget;

  VodDetailData get data => controller.data.value;

  final PageController _page = PageController(initialPage: 0);

  handlePlay(VodPlayer ctx) async {
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

    try {
      var id = ctx.url;
      debugPrint("player id: $id");
      Get.dialog(
        Expanded(
          child: Center(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Get.isDarkMode
                    ? CupertinoColors.darkBackgroundGray.withOpacity(.72)
                    : CupertinoColors.white.withOpacity(.72),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const SizedBox(
                child: CupertinoActivityIndicator(),
                width: 90,
                height: 90,
              ),
            ),
          ),
        ),
      );
      var url = await controller.getPlayURL(id);
      if (Get.isDialogOpen as bool) Get.back();
      launchURL(url);
    } catch (e) {
      showCupertinoDialog(
        context: Get.context as BuildContext,
        builder: (_) => CupertinoAlertDialog(
          title: const Text("提示"),
          content: const Text("获取播放链接失败 :("),
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
    }
  }

  final List<String> _tabData = [
    "播放",
    "简介",
    "猜你喜欢",
    "评论",
  ];

  @override
  Widget build(BuildContext context) {
    TextStyle? _caption = Theme.of(context).textTheme.caption;

    Map<int, Widget> _tabs =
        _tabData.map((e) => Text(e, style: _caption)).toList().asMap();

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        previousPageTitle: "返回",
      ),
      child: SafeArea(
        child: Obx(
          () => showCRWidget
              ? _buildCR
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FadeInImage.memoryNetwork(
                          width: double.infinity,
                          height: Get.height * .33,
                          placeholder: kTransparentImage,
                          image: data.cover,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(data.title),
                        )
                      ],
                    ),
                    Container(
                      width: double.infinity,
                      // height: 42,
                      margin: const EdgeInsets.only(top: 12),
                      child: CupertinoSlidingSegmentedControl(
                        children: _tabs,
                        groupValue: controller.tryGroupValue.value,
                        onValueChanged: (int? value) {
                          if (value == null) return;
                          controller.tryGroupValue.value = value;
                          // _page.jumpToPage(value);
                          _page.animateToPage(
                            value,
                            duration: const Duration(
                              milliseconds: 240,
                            ),
                            curve: Curves.ease,
                          );
                        },
                      ),
                    ),
                    Expanded(
                      child: PageView(
                        controller: _page,
                        pageSnapping: true,
                        dragStartBehavior: DragStartBehavior.down,
                        physics: const NeverScrollableScrollPhysics(),
                        children: <Widget>[
                          CupertinoScrollbar(
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: List.generate(
                                  data.vodPlayer.length,
                                  (index) {
                                    var curr = data.vodPlayer[index];
                                    return Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: CupertinoButton(
                                        minSize: 27,
                                        onPressed: () {
                                          handlePlay(curr);
                                        },
                                        child: Text(
                                          curr.title,
                                          style: Theme.of(context)
                                              .textTheme
                                              .button,
                                        ),
                                        color: Theme.of(context).dividerColor,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                          CupertinoScrollbar(
                            child: SingleChildScrollView(
                              child: Html(
                                data: data.descHtml,
                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Center(
                              child: Text("猜你喜欢"),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Center(
                              child: Text("啥也没有"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget get _buildCR {
    Widget child = _buildLoading();
    var isErrorFlag = controller.errorMsgStack.value.isNotEmpty;
    if (!controller.isLoading.value && isErrorFlag) {
      child = _buildError();
    }
    return Center(child: child);
  }

  Widget _buildLoading() {
    return const CupertinoActivityIndicator();
  }

  Widget _buildError() {
    return KErrorStack(
      errorStack: controller.errorMsgStack.value,
      child: CupertinoButton.filled(
        child: const Text("重新加载"),
        onPressed: () {
          controller.fetchVodDetail();
        },
      ),
    );
  }
}
