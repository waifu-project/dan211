import 'package:flutter/cupertino.dart';

enum CupertinoPageBarActionType {
  prev,
  next,
}

class CupertinoPageBar extends StatelessWidget {
  const CupertinoPageBar({
    Key? key,
    this.total = 1,
    this.current = 1,
    this.totalPage = 1,
    required this.onTap,
    this.isLoading = true,
    this.loadingText = "搜索中",
    this.prevText = "上一页",
    this.nextText = "下一页",
  }) : super(key: key);

  final bool isLoading;

  final String loadingText;

  final String prevText;

  final String nextText;

  final int total;

  final int current;

  final int totalPage;

  final ValueChanged<CupertinoPageBarActionType> onTap;

  bool get _isPrev {
    return current > 1;
  }

  bool get _isNext {
    return current < totalPage;
  }

  bool get _canShowToolBar => total == -1;

  MainAxisAlignment get _mainAxisAlignment {
    if (_canShowToolBar) return MainAxisAlignment.center;
    return MainAxisAlignment.spaceBetween;
  }

  double get _opacity {
    return isLoading ? 1.0 : 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: _mainAxisAlignment,
        children: [
          Builder(builder: (context) {
            if (_canShowToolBar) return const SizedBox.shrink();
            return Row(
              children: [
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: Row(
                    children: [
                      const Icon(CupertinoIcons.back),
                      Text(prevText),
                    ],
                  ),
                  onPressed: !_isPrev ? null : () {
                    onTap(CupertinoPageBarActionType.prev);
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                  ),
                  child: Text("$current/$totalPage"),
                ),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: Row(
                    children: [
                      Text(nextText),
                      const Icon(CupertinoIcons.right_chevron),
                    ],
                  ),
                  onPressed: !_isNext ? null : () {
                    onTap(CupertinoPageBarActionType.next);
                  },
                ),
              ],
            );
          }),
          AnimatedOpacity(
            opacity: _opacity,
            duration: const Duration(
              milliseconds: 420,
            ),
            child: Row(
              children: [
                const CupertinoActivityIndicator(),
                const SizedBox(
                  width: 6,
                ),
                Text(loadingText),
                const SizedBox(
                  width: 3,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
