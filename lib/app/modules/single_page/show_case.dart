import 'package:dan211/config/dart_const.dart';
import 'package:dan211/utils/helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ShowCasePage extends StatefulWidget {
  const ShowCasePage({Key? key}) : super(key: key);

  @override
  State<ShowCasePage> createState() => _ShowCasePageState();
}

class _ShowCasePageState extends State<ShowCasePage> {
  final List<String> _tabs = const [
    "使用介绍",
    "关于",
  ];

  int _tabsIndex = 0;

  set tabsIndex(int newVal) {
    _tabsIndex = newVal;
    setState(() {});
    // debugPrint(newVal.toString());
    _pageController.animateToPage(
      newVal,
      duration: const Duration(
        microseconds: 4200,
      ),
      curve: Curves.ease,
    );
  }

  final PageController _pageController = PageController(
    initialPage: 0,
  );

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: TextStyle(
        color: CupertinoDynamicColor.resolve(
          CupertinoColors.label,
          context,
        ),
      ),
      child: Column(
        children: [
          const CupertinoNavigationBar(
            previousPageTitle: PREV_BUTTON_TITLE,
          ),
          _buildTabs(),
          Expanded(
            child: PageView(
              controller: _pageController,
              children: [
                _buildUseHelp(),
                _buildAbout(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUseHelp() {
    return const Center(child: Text("使用帮助\n\n你真的需要吗?"));
  }

  Widget get _space => const SizedBox(
        height: 24,
      );

  Widget _buildAbout() {
    var _pC = CupertinoTheme.of(context).primaryColor;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _space,
        Image.asset(
          "assets/empty.png",
          height: Get.height * .32,
        ),
        _space,
        const Text("仅供学习参考"),
        const Text(
          "(只是做了一些微小的工作)",
          style: TextStyle(
            decoration: TextDecoration.lineThrough,
            fontSize: 12,
          ),
        ),
        _space,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              CupertinoIcons.app_badge,
              color: _pC,
            ),
            const SizedBox(
              width: 3,
            ),
            GestureDetector(
              onTap: () {
                launchURL(githubLink);
              },
              child: Text(
                githubLink,
                style: TextStyle(
                  color: _pC,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  String get githubLink => "https://github.com/waifu-project/dan211";

  Widget _buildTabs() {
    return Row(
      children: _tabs
          .map(
            (item) => Builder(
              builder: (context) {
                var _index = _tabs.indexOf(item);
                var _isCurr = _tabsIndex == _index;
                return _showCaseTab(
                  hovered: _isCurr,
                  child: Text(item),
                  onTap: () {
                    if (_isCurr) return;
                    tabsIndex = _index;
                  },
                );
              },
            ),
          )
          .toList(),
    );
  }
}

// ignore: camel_case_types
class _showCaseTab extends StatelessWidget {
  const _showCaseTab(
      {Key? key,
      this.height = 32,
      required this.child,
      this.hovered = false,
      this.onTap})
      : super(key: key);

  final Widget child;
  final double height;
  final VoidCallback? onTap;
  final bool hovered;

  @override
  Widget build(BuildContext context) {
    var barColor = CupertinoTheme.of(context).barBackgroundColor;
    var scaffoldColor = CupertinoTheme.of(context).scaffoldBackgroundColor;

    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;

    var color = barColor;

    /// NOTE:
    ///
    ///  总之就是暗色模式下颜色反了
    ///  然后就取反呗
    ///  这部分逻辑有点混乱, 大佬们轻喷 :(
    ///  2022/04/28 11:26
    if (hovered) {
      color = scaffoldColor;
      if (isDarkMode) color = barColor;
    } else {
      if (isDarkMode) color = scaffoldColor;
    }

    var borderColor = CupertinoDynamicColor.resolve(
      CupertinoColors.opaqueSeparator,
      context,
    ).withOpacity(.8);
    return Expanded(
      flex: 1,
      child: GestureDetector(
        onTap: onTap,
        child: SizedBox(
          height: height,
          child: Row(
            children: [
              Expanded(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: color,
                    border: Border(
                      bottom: BorderSide(
                        width: .6,
                        color: borderColor,
                      ),
                    ),
                  ),
                  child: Center(
                    child: child,
                  ),
                ),
              ),
              const SizedBox(
                width: .2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
