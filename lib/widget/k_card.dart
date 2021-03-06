import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class KMovieCard extends StatelessWidget {
  const KMovieCard({
    Key? key,
    required this.imageURL,
    required this.title,
    this.radiusSize = 8.0,
    this.space = 0,
    this.width = double.infinity,
    this.height = double.infinity,
    this.onTap,
  }) : super(key: key);

  final String imageURL;
  final String title;
  final double radiusSize;
  final double space;
  final double width;
  final double height;
  final VoidCallback? onTap;

  Widget get _spaceWidget {
    if (space <= 0) {
      return const SizedBox.shrink();
    }
    return SizedBox(height: space);
  }

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
        child: SizedBox(
          width: width,
          height: height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Image.network(
                  imageURL,
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
                          color:
                              CupertinoColors.opaqueSeparator.withOpacity(.2),
                        ),
                        child: SizedBox(
                          width: width,
                          height: height,
                          child: const Center(
                            child: CupertinoActivityIndicator(),
                          ),
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) => ClipRRect(
                    borderRadius: BorderRadius.circular(radiusSize),
                    child: const Center(
                      child: Text("????????????"),
                    ),
                  ),
                ),
              ),
              _spaceWidget,
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
