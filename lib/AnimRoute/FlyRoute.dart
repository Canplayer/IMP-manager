

import 'dart:math';

import 'package:flutter/widgets.dart';

class FlyRoute extends PageRoute{

  FlyRoute({
    required this.builder,
    this.transitionDuration = const Duration(milliseconds: 500),
    this.barrierColor,
    this.barrierLabel,
    this.maintainState = true,
  });
  final WidgetBuilder builder;

  @override
  // TODO: implement barrierColor
  Color? barrierColor;

  @override
  String? barrierLabel;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    CurvedAnimation curve = CurvedAnimation(parent: animation, curve: Curves.easeInToLinear);
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return ClipPath(
          clipper: CirclePath(curve.value),
          child: child,
        );
      },
      child: builder(context),
    );
  }

  @override
  bool maintainState;

  @override
  Duration transitionDuration;

}


class CirclePath extends CustomClipper<Path> {
  CirclePath(this.value);

  final double value;

  @override
  Path getClip(Size size) {
    var path = Path();
    double radius =
        value * sqrt(size.height * size.height + size.width * size.width);
    path.addOval(Rect.fromLTRB(
        size.width - radius, -radius, size.width + radius, radius));
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}