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
  }) : super(key: key);

  final VoidCallback onTap;
  final String imageURL;
  final String title;
  final double imgWidth;
  final EdgeInsets padding;
  final double space;

  double get radiusSize => 12;

  String get _title {
    if (title.isEmpty) return "暂无";
    return title;
  }

  String get _loadImageError => "加载失败";

  @override
  Widget build(BuildContext context) {
    return Padding(
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
              return const Center(
                child: CupertinoActivityIndicator(),
              );
            },
            errorBuilder: (context, error, stackTrace) => ClipRRect(
              borderRadius: BorderRadius.circular(radiusSize),
              child: Center(
                child: Text(_loadImageError),
              ),
            ),
          ),
          SizedBox(width: space,),
          Text(_title),
        ],
      ),
    );
  }
}
