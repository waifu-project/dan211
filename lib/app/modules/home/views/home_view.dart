import 'package:dan211/app/modules/single_page/show_case.dart';
import 'package:dan211/app/routes/app_pages.dart';
import 'package:dan211/modules/art_detail.dart';
import 'package:dan211/modules/vod_movie.dart';
import 'package:dan211/widget/k_card.dart';
import 'package:dan211/widget/k_error_stack.dart';
import 'package:dan211/widget/k_list_tile.dart';
import 'package:dan211/widget/photo_hero.dart';
import 'package:flutter/cupertino.dart';

import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  // @override
  // HomeController controller = Get.find<HomeController>();

  bool get showCRWidget => controller.showCRWidget;

  List<HomeCard> get homeCard => controller.data.value.homeCards;

  @override
  Widget build(BuildContext context) {
    Get.put(HomeController());

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: Row(
          children: [
            CupertinoButton(
              padding: EdgeInsets.zero,
              child: const Icon(
                CupertinoIcons.command,
                size: 21,
              ),
              onPressed: () {
                Get.toNamed(
                  Routes.VOD_CASE,
                  arguments: "",
                );
              },
            ),
            CupertinoButton(
              padding: EdgeInsets.zero,
              child: const Icon(
                CupertinoIcons.cloud_moon,
                size: 21,
              ),
              onPressed: () {
                showCupertinoModalBottomSheet(
                  expand: false,
                  duration: const Duration(
                    milliseconds: 420,
                  ),
                  context: context,
                  builder: (context) => const ShowCasePage(),
                );
              },
            ),
          ],
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.search),
          onPressed: () {
            /// TODO ??????????????????????????????
            Get.toNamed(
              Routes.VOD_SEARCH,
              arguments: "",
            );
          },
        ),
        middle: const Text("??????"),
      ),
      child: SafeArea(
        child: Obx(
          () => showCRWidget
              ? _buildCR
              : CupertinoScrollbar(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ...homeCard.map((e) {
                          return Column(
                            children: [
                              Builder(builder: (BuildContext context) {
                                var canI1 = homeCard.indexOf(e) == 0;
                                var _text = canI1 ? "????????????" : "????????????";
                                return _navTitle(_text, context);
                              }),
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
                                              (sub) => PhotoHero(
                                                photo: sub.cover,
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                    8.0,
                                                  ),
                                                  child: KMovieCard(
                                                    width: 120,
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
                        _navTitle("??????????????????", context),
                        Column(
                          children: controller.data.value.artDatas
                              .map(
                                (e) => CupertinoListTile(
                                  leading: const Icon(
                                    CupertinoIcons.arrow_down_right_square_fill,
                                  ),
                                  title: Text(
                                    e.title,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
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
                  ),
                ),
        ),
      ),
    );
  }

  /// ??????, ??????????????????
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
        child: const Text("????????????"),
        onPressed: () {
          controller.fetchHomeData();
        },
      ),
    );
  }

  Widget _navTitle(String title, [BuildContext? context]) {
    var ctx = context ?? Get.context;
    if (ctx == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              color: CupertinoDynamicColor.resolve(
                CupertinoColors.label,
                ctx,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
