import 'package:flutter/cupertino.dart';

class VodCardWidget extends StatelessWidget {
  const VodCardWidget({
    Key? key,
    required this.onTap,
    required this.imageURL,
    required this.title,
    this.padding = const EdgeInsets.all(8.0),
    this.imgWidth = 90,
    this.space = 0,
    this.errorBuilder,
  }) : super(key: key);

  final VoidCallback onTap;
  final String imageURL;
  final String title;
  final double imgWidth;
  final EdgeInsets padding;
  final double space;
  final ImageErrorWidgetBuilder? errorBuilder;

  double get radiusSize => 12;

  String get _title {
    if (title.isEmpty) return "暂无";
    return title;
  }

  String get _loadImageError => "加载失败";

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: TextStyle(
        color: CupertinoDynamicColor.resolve(
          CupertinoColors.label,
          context,
        ),
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Image.network(
                imageURL,
                width: imgWidth,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(radiusSize),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                          radiusSize,
                        ),
                        child: child,
                      ),
                    );
                  }
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(radiusSize),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: CupertinoColors.opaqueSeparator.withOpacity(.2),
                      ),
                      child: SizedBox(
                        width: imgWidth,
                        height: imgWidth * .72,
                        child: const Center(
                          child: CupertinoActivityIndicator(),
                        ),
                      ),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) =>
                    Builder(builder: (context) {
                  if (errorBuilder != null) return errorBuilder!(context, error, stackTrace);
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(radiusSize),
                    child: Center(
                      child: Text(_loadImageError),
                    ),
                  );
                }),
              ),
              SizedBox(
                width: space,
              ),
              Expanded(
                child: Text(
                  _title,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
