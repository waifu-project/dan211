import 'package:dan211/app/modules/vod_search/views/page_bar.dart';
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

  final int _curr = 4;

  final String _unknowText = "未知";

  @override
  Widget build(BuildContext context) {
    Color _primaryColor = CupertinoTheme.of(context).primaryColor;

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
              DecoratedBox(
                decoration: BoxDecoration(
                  color: CupertinoColors.opaqueSeparator.withOpacity(.2),
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 42,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(
                        12,
                        (index) => Builder(builder: (context) {
                          var isCurr = index == _curr;
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 3.0,
                              vertical: 1.0,
                            ),
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: CupertinoTheme.of(context)
                                    .scaffoldBackgroundColor,
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
                                  "电影",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: isCurr ? _primaryColor : null,
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
              ),
              CupertinoPageBar(
                onTap: (_type) {},
              ),
              Expanded(
                child: CupertinoScrollbar(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 0.0,
                      horizontal: 12.0,
                    ),
                    child: GridView.count(
                        childAspectRatio: 4 / 6,
                        mainAxisSpacing: 12.0,
                        crossAxisSpacing: 24.0,
                        crossAxisCount: 3,
                        children: List.generate(
                          24,
                          (index) => const KMovieCard(
                            radiusSize: 6,
                            imageURL:
                                "http://ljcdn.comtucdncom.com/upload/vod/20220401-1/b9ecac3e27671547de8341ed51eb1f3c.jpg",
                            title: "天狗日记",
                          ),
                        ),
                      ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
