import 'package:dan211/app/modules/vod_search/views/page_bar.dart';
import 'package:dan211/app/modules/vod_search/views/w_vod_card.dart';
import 'package:dan211/app/routes/app_pages.dart';
import 'package:dan211/widget/k_error_stack.dart';
import 'package:dan211/widget/photo_hero.dart';
import 'package:flutter/cupertino.dart';

import 'package:get/get.dart';

import '../controllers/vod_search_controller.dart';

class VodSearchView extends GetView<VodSearchController> {
  const VodSearchView({Key? key}) : super(key: key);

  String get _placeholder => "搜索";

  // final VodSearchController controller = Get.put(VodSearchController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VodSearchController>(builder: (vodSearch) {
      return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Padding(
            padding: const EdgeInsets.only(
              right: 12.0,
            ),
            child: CupertinoSearchTextField(
              controller: vodSearch.searchController,
              autofocus: true,
              placeholder: _placeholder,
              onSubmitted: vodSearch.handleSearch,
            ),
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Builder(builder: (context) {
                if (!vodSearch.isShowPageBar) return const SizedBox.shrink();
                return CupertinoPageBar(
                  isLoading: vodSearch.isLoading,
                  total: vodSearch.respData.total,
                  totalPage: vodSearch.respData.totalPage,
                  current: vodSearch.respData.current,
                  onTap: vodSearch.handlePrevAndNext,
                );
              }),
              Expanded(
                child: CupertinoScrollbar(
                  child: SingleChildScrollView(
                    child: Builder(builder: (context) {
                      if (vodSearch.firstRun) {
                        return const SizedBox.shrink();
                        // return SizedBox(
                        //   height: Get.height * .66,
                        //   child: const Center(
                        //     child: Text("请搜索"),
                        //   ),
                        // );
                      }
                      var _data = vodSearch.respData.data;
                      if (vodSearch.canShowErrorCase) {
                        return SizedBox(
                          height: Get.height * .66,
                          child: Center(
                            child: KErrorStack(
                              errorStack: vodSearch.errorStack,
                              child: CupertinoButton.filled(
                                child: const Text("重新搜索"),
                                onPressed: () {
                                  vodSearch.handleSearch(
                                    vodSearch.searchController.text,
                                  );
                                },
                              ),
                            ),
                          ),
                        );
                      }
                      if (_data.isEmpty && !vodSearch.isLoading) {
                        return SizedBox(
                          height: Get.height * .66,
                          child: const Center(
                            child: Text("搜索内容为空 :("),
                          ),
                        );
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(
                          _data.length,
                          (index) => Builder(builder: (context) {
                            var curr = _data[index];
                            return PhotoHero(
                              photo: curr.cover,
                              child: VodCardWidget(
                                space: 12.0,
                                imageURL: curr.cover,
                                onTap: () {
                                  Get.toNamed(
                                    Routes.VOD_DETAIL,
                                    arguments: curr.id,
                                  );
                                },
                                title: curr.title,
                                errorBuilder: (context, error, stackTrace) {
                                  return SizedBox(
                                    width: 90,
                                    height: 72,
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                        color: CupertinoColors.inactiveGray,
                                        borderRadius: BorderRadius.circular(12.0),
                                      ),
                                      child: const Center(
                                        child: Text("加载失败 :("),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          }),
                        ).toList(),
                      );
                    }),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
