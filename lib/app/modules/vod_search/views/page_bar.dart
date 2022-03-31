import 'package:flutter/cupertino.dart';

class CupertinoPageBar extends StatelessWidget {
  const CupertinoPageBar({
    Key? key,
    this.isInit = false,
    this.total = 1,
    this.current = 1,
  }) : super(key: key);

  /// 是否初始化操作
  ///
  /// [true] => 只显示 `搜索中` 文本
  ///
  /// [false] => 显示操作按钮 `上一页/下一页/跳转`
  final bool isInit;

  final int total;

  final int current;

  bool get _isPrev {
    return current <= 1;
  }

  bool get _isNext {
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            CupertinoButton(
              padding: EdgeInsets.zero,
              child: Row(
                children: [
                  Icon(CupertinoIcons.back),
                  Text("上一页"),
                ],
              ),
              onPressed: () {},
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
              ),
              child: Text("1/24"),
            ),
            CupertinoButton(
              padding: EdgeInsets.zero,
              child: Row(
                children: [
                  Text("下一页"),
                  Icon(CupertinoIcons.right_chevron),
                ],
              ),
              onPressed: () {},
            ),
          ],
        ),
        Row(
          children: [
            CupertinoActivityIndicator(),
            SizedBox(
              width: 6,
            ),
            Text("搜索中"),
          ],
        )
      ],
    );
  }
}
