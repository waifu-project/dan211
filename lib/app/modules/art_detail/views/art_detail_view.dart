import 'package:dan211/widget/k_error_stack.dart';
import 'package:dan211/widget/k_transparent_image.dart';
import 'package:dan211/widget/lazy_load_scrollview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/art_detail_controller.dart';

class ArtDetailView extends GetView<ArtDetailController> {
  const ArtDetailView({Key? key}) : super(key: key);

  bool get showCRWidget => controller.showCRWidget;

  @override
  Widget build(BuildContext context) {
    Get.put(ArtDetailController());

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
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Builder(builder: (context) {
                            return AnimatedOpacity(
                              duration: const Duration(
                                microseconds: 420,
                              ),
                              opacity: controller.artDesc.isEmpty ? .0 : 1,
                              child: Text(
                                controller.artTitle,
                                style: CupertinoTheme.of(context)
                                    .textTheme
                                    .actionTextStyle,
                              ),
                            );
                          }),
                          const SizedBox(
                            height: 6,
                          ),
                          Builder(builder: (BuildContext _) {
                            return AnimatedOpacity(
                              duration: const Duration(
                                microseconds: 420,
                              ),
                              opacity: controller.artDesc.isEmpty ? .0 : 1,
                              child: Text(
                                controller.artDesc,
                                style: CupertinoTheme.of(context)
                                    .textTheme
                                    .tabLabelTextStyle,
                              ),
                            );
                          })
                        ],
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 0,
                        ),
                        child: LazyLoadScrollView(
                          scrollOffset: 66,
                          onEndOfPage: () {
                            // print("trigger action");
                          },
                          child: CupertinoScrollbar(
                            child: ListView(
                              children: List.generate(
                                controller.data.value.images.length,
                                // controller.data.value.images.isNotEmpty ? 4 : 0,
                                (index) {
                                  return FadeInImage.memoryNetwork(
                                    placeholder: kTransparentImage,
                                    image: controller.data.value.images[index],
                                  );
                                },
                              ).toList(),
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
          controller.fetchArtDetailData();
        },
      ),
    );
  }
}
