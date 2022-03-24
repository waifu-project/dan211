import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/vod_detail_controller.dart';

class VodDetailView extends GetView<VodDetailController> {
  const VodDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        leading: CupertinoNavigationBarBackButton(),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.network(
                      "https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/dc57954905594554801c791319a18055~tplv-k3u1fbpfcp-zoom-crop-mark:1304:1304:1304:734.awebp?",
                      width: 72,
                      height: 120,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("你好世界"),
                      const SizedBox(
                        height: 6,
                      ),
                      Text(
                        "主演: 不详",
                        style: Theme.of(context).textTheme.caption,
                      ),
                      Text(
                        "状态：",
                        style: Theme.of(context).textTheme.caption,
                      ),
                      Text(
                        "语言：英语",
                        style: Theme.of(context).textTheme.caption,
                      ),
                      Text(
                        "时间：2021-09-11",
                        style: Theme.of(context).textTheme.caption,
                      ),
                      Text(
                        "分类：乐播",
                        style: Theme.of(context).textTheme.caption,
                      ),
                      Text(
                        "类型：NMSL",
                        style: Theme.of(context).textTheme.caption,
                      )
                    ],
                  )
                ],
              ),
            ),
            Container(
              width: double.infinity,
              // height: 42,
              margin: const EdgeInsets.only(top: 12),
              child: CupertinoSlidingSegmentedControl(
                children: <int, Widget>{
                  0: Text(
                    "播放",
                    style: Theme.of(context).textTheme.button,
                  ),
                  1: Text(
                    "简介",
                    style: Theme.of(context).textTheme.caption,
                  ),
                  2: Text(
                    "评论",
                    style: Theme.of(context).textTheme.caption,
                  ),
                },
                //当前选中的索引
                groupValue: 0, onValueChanged: (int? value) {},
              ),
            ),
            Expanded(
              child: PageView(
                dragStartBehavior: DragStartBehavior.down,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: CupertinoButton(
                          minSize: 27,
                          onPressed: () {},
                          child: Text("Click Me", style: Theme.of(context).textTheme.subtitle2),
                          color: CupertinoColors.activeBlue,
                          padding: const EdgeInsets.symmetric(horizontal: 12,),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: const [
                      Text("简介"),
                    ],
                  ),
                  Column(
                    children: const [
                      Text("啥也没有"),
                    ]
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
