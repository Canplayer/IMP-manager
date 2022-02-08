

import 'dart:ui';

import 'package:flutter/material.dart';
//import 'package:flutter/widgets.dart';



const Color defaultColor = Color.fromARGB(255, 255, 255, 255);

class PlasticsCard extends StatelessWidget {
  PlasticsCard({
    Key? key,
    this.alignment,
    this.padding,
    this.color = defaultColor,
    this.decoration,
    this.foregroundDecoration,
    double? width,
    double? height,
    BoxConstraints? constraints,
    this.margin,
    this.transform,
    this.transformAlignment,
    this.child,
    this.clipBehavior = Clip.none,
    this.borderRadius = 12,
    this.outPadding = 10,
    this.blurRadius = 10,
}): assert(margin == null || margin.isNonNegative),
        assert(padding == null || padding.isNonNegative),
        assert(decoration == null || decoration.debugAssertIsValid()),
        assert(constraints == null || constraints.debugAssertIsValid()),
        assert(clipBehavior != null),
        assert(decoration != null || clipBehavior == Clip.none),
        assert(color == null || decoration == null,
        'Cannot provide both a color and a decoration\n'
            'To provide both, use "decoration: BoxDecoration(color: color)".',
        ),
        constraints =
        (width != null || height != null)
            ? constraints?.tighten(width: width, height: height)
            ?? BoxConstraints.tightFor(width: width, height: height)
            : constraints,
        super(key: key);



  final Widget? child;
  final AlignmentGeometry? alignment;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final Decoration? decoration;
  final Decoration? foregroundDecoration;
  final BoxConstraints? constraints;
  final EdgeInsetsGeometry? margin;
  final Matrix4? transform;
  final AlignmentGeometry? transformAlignment;
  final Clip clipBehavior;
  final double borderRadius;
  final double outPadding;
  final double blurRadius;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(outPadding),
      child: Container(
        child: ClipRRect(
          //背景过滤器
          borderRadius: BorderRadius.circular(borderRadius),
          child: Container(
            alignment: alignment,
            padding: padding,
            foregroundDecoration: foregroundDecoration,
            constraints: constraints,
            margin: margin,
            transform: transform,
            transformAlignment: transformAlignment,
            clipBehavior: clipBehavior,
            color: color,
            child: child,


          ),
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                  color: Color.fromARGB(10, 0, 0, 0),
                  offset: Offset(0.0, 0.0), //阴影xy轴偏移量
                  blurRadius: borderRadius, //阴影模糊程度
                  spreadRadius: 0.0 //阴影扩散程度
              )
            ]),
      ),
    );
  }


}

