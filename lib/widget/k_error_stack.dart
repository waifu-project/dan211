import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class KErrorStack extends StatelessWidget {
  const KErrorStack({
    Key? key,
    required this.errorStack,
    this.radiusSize = 20.0,
    this.elevation = 20.0,
    this.padding = const EdgeInsets.all(12.0),
    this.child = const SizedBox.shrink(),
    this.space = 12.0,
    this.crossAxisAlignment = CrossAxisAlignment.center,
  }) : super(key: key);

  final String errorStack;
  final double radiusSize;
  final double elevation;
  final EdgeInsetsGeometry padding;
  final Widget child;
  final double space;
  final CrossAxisAlignment crossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.width * .80,
      height: Get.height * .48,
      child: Column(
        crossAxisAlignment: crossAxisAlignment,
        children: [
          Expanded(
            child: Card(
              child: Padding(
                padding: padding,
                child: CupertinoScrollbar(
                  child: SingleChildScrollView(
                    child: Text(
                      errorStack,
                      style: const TextStyle(
                        fontSize: 12,
                        color: CupertinoColors.systemGrey,
                      ),
                    ),
                  ),
                ),
              ),
              elevation: elevation,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(radiusSize),
                ),
              ),
              clipBehavior: Clip.antiAlias,
              semanticContainer: false,
            ),
          ),
          SizedBox(
            height: space,
          ),
          child,
        ],
      ),
    );
  }
}
