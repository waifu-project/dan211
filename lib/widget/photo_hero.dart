import 'package:flutter/cupertino.dart';

class PhotoHero extends StatelessWidget {
  const PhotoHero({
    Key? key,
    required this.photo,
    required this.child,
  }) : super(key: key);

  final String photo;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: photo,
      child: child,
    );
  }
}
