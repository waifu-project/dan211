import 'package:dan211/app/routes/app_pages.dart';
import 'package:dan211/modules/vod_detail.dart';
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
    try {
      var id = ctx.url;
      debugPrint("player id: $id");
      Get.defaultDialog(
        title: "",
        backgroundColor: Colors.transparent,
        content: Center(
          child: Builder(
            builder: (context) {
              var _primaryColor = CupertinoTheme.of(context).primaryColor;
              return DecoratedBox(
                decoration: BoxDecoration(
                  color: CupertinoColors.darkBackgroundGray.withOpacity(.72),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SizedBox(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 12,),
                      Text(
                        "加载中",
                        style: TextStyle(
                          color: _primaryColor,
                        ),
                      ),
                    ],
                  ),
                  width: 120,
                  height: 120,
                ),
              );
            }
          ),
        ),
      );
      var data = await controller.getPlayURL(id);
      if (Get.isDialogOpen as bool) Get.back();
      var recommendID = await Get.toNamed(
        Routes.VOD_PLAY,
        arguments: data,
      );
      if (recommendID != null && recommendID is String) {
        controller.setCacheID(recommendID);
        controller.fetchVodDetail();
      }
    } catch (e) {
      e.printError();
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
    Map<int, Widget> _tabs = _tabData.map((e) => Text(e)).toList().asMap();

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        previousPageTitle: "返回",
      ),
      child: DefaultTextStyle(
        style: TextStyle(
          color: CupertinoDynamicColor.resolve(
            CupertinoColors.label,
            context,
          ),
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
                                          ),
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
                            DecoratedBox(
                              decoration: const BoxDecoration(
                                color: CupertinoColors.white,
                              ),
                              child: CupertinoScrollbar(
                                child: SingleChildScrollView(
                                  child: Html(
                                    data: data.descHtml,
                                  ),
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
