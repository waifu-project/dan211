import 'package:dan211/app/routes/app_pages.dart';
import 'package:dan211/modules/art_detail.dart';
import 'package:dan211/widget/k_card.dart';
import 'package:dan211/widget/k_error_stack.dart';
import 'package:dan211/widget/k_list_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  // @override
  // HomeController controller = Get.find<HomeController>();

  bool get showCRWidget => controller.showCRWidget;

  @override
  Widget build(BuildContext context) {
    Get.put(HomeController());

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.command),
          onPressed: () {},
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.search),
          onPressed: () {},
        ),
        middle: const Text("榜单"),
      ),
      child: SafeArea(
        child: Obx(() => showCRWidget
            ? _buildCR
            : SingleChildScrollView(
                child: Column(
                  children: [
                    ...controller.data.value.homeCards.map((e) {
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Builder(builder: (BuildContext context) {
                                  var canI1 = controller.data.value.homeCards
                                          .indexOf(e) ==
                                      0;
                                  return Text(
                                    canI1 ? "最新电影" : "最热电影",
                                    style: CupertinoTheme.of(context)
                                        .textTheme
                                        .tabLabelTextStyle,
                                  );
                                })
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
                                    children: e.vodCards
                                        .map(
                                          (sub) => Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: KMovieCard(
                                              imageURL: sub.cover,
                                              title: sub.title,
                                              space: 6.0,
                                              onTap: () {
                                                Get.toNamed(
                                                  Routes.VOD_DETAIL,
                                                  arguments: sub.id,
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
                      );
                    }).toList(),
                    _navTitle("最新影视资讯"),
                    Column(
                      children: controller.data.value.artDatas
                          .map(
                            (e) => CupertinoListTile(
                              leading: const Icon(
                                CupertinoIcons.arrow_down_right_square_fill,
                              ),
                              title: Text(
                                e.title,
                                style: CupertinoTheme.of(context)
                                    .textTheme
                                    .tabLabelTextStyle,
                              ),
                              onTap: () {
                                Get.toNamed(
                                  Routes.ART_DETAIL,
                                  arguments: ArtDetailData.fromArgs(
                                    e.id,
                                    e.title,
                                  ),
                                );
                              },
                            ),
                          )
                          .toList(),
                    )
                  ],
                ),
              )),
      ),
    );
  }

  /// 临界, 世界即将毁灭
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
          controller.fetchHomeData();
        },
      ),
    );
  }

  Widget _navTitle(String title) {
    var ctx = Get.context;
    if (ctx == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: CupertinoTheme.of(ctx).textTheme.tabLabelTextStyle,
          ),
        ],
      ),
    );
  }
}
