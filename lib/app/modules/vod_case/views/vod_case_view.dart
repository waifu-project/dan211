import 'package:dan211/app/modules/vod_search/views/page_bar.dart';
import 'package:dan211/app/routes/app_pages.dart';
import 'package:dan211/share/dan_movie_card.dart';
import 'package:dan211/widget/k_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../controllers/vod_case_controller.dart';
import 'case_view.dart';

class VodCaseView extends StatelessWidget {
  const VodCaseView({Key? key}) : super(key: key);

  final String _unknowText = "未知";

  @override
  Widget build(BuildContext context) {
    Color _primaryColor = CupertinoTheme.of(context).primaryColor;

    Color _label =
        CupertinoDynamicColor.resolve(CupertinoColors.label, context);

    return GetBuilder<VodCaseController>(
      builder: (vodCase) => CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: GestureDetector(
            onTap: () async {
              DanMovieCardItem? futureID = await showCupertinoModalBottomSheet(
                context: context,
                builder: (context) => const DoMovieCaseView(),
              );
              debugPrint(futureID!.text ?? _unknowText);
              vodCase.changeCaseIndex(futureID);
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  vodCase.currCaseItem.text ?? _unknowText,
                  style: TextStyle(
                    color: _primaryColor,
                  ),
                ),
                const SizedBox(
                  width: 3,
                ),
                const Icon(
                  CupertinoIcons.chevron_down,
                  size: 16,
                )
              ],
            ),
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              AnimatedContainer(
                decoration: BoxDecoration(
                  color: CupertinoColors.opaqueSeparator.withOpacity(.2),
                ),
                duration: const Duration(
                  milliseconds: 420,
                ),
                width: double.infinity,
                height: vodCase.pageBarHeigth,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(
                      vodCase.data.tags.length,
                      (index) => Builder(builder: (context) {
                        var curr = vodCase.data.tags[index];
                        var isCurr = curr == vodCase.currentTag;
                        var _color =
                            CupertinoTheme.of(context).scaffoldBackgroundColor;
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 3.0,
                            vertical: 1.0,
                          ),
                          child: GestureDetector(
                            onTap: () {
                              vodCase.changeCurrentTag(curr);
                            },
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: _color,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isCurr
                                      ? _primaryColor
                                      : Colors.transparent,
                                  width: 2,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12.0,
                                  vertical: 6.0,
                                ),
                                child: Text(
                                  curr,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: isCurr ? _primaryColor : _label,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ),
              Builder(builder: (context) {
                var _pageData = vodCase.data.pageData;
                return CupertinoPageBar(
                  isLoading: vodCase.isLoading,
                  total: _pageData.total,
                  current: _pageData.current,
                  totalPage: _pageData.totalPage,
                  onTap: vodCase.handlePrevAndNext,
                );
              }),
              Builder(builder: (context) {
                if (vodCase.data.pageData.total == -1 && !vodCase.isLoading) {
                  return const Center(
                    child: Text("内容为空或未知错误"),
                  );
                }
                return Expanded(
                  child: CupertinoScrollbar(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 0.0,
                        horizontal: 12.0,
                      ),
                      child: Builder(builder: (context) {
                        var cards = vodCase.data.cards;
                        return GridView.count(
                          childAspectRatio: 4 / 6,
                          mainAxisSpacing: 12.0,
                          crossAxisSpacing: 24.0,
                          crossAxisCount: 3,
                          children: List.generate(
                            cards.length,
                            (index) => KMovieCard(
                              radiusSize: 6,
                              imageURL: cards[index].cover,
                              title: cards[index].title,
                              onTap: () {
                                Get.toNamed(
                                  Routes.VOD_DETAIL,
                                  arguments: cards[index].id,
                                );
                              },
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
