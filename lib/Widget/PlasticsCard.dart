

import 'dart:ui';

import 'package:flutter/material.dart';
//import 'package:flutter/widgets.dart';



const Color defaultCardColor = Colors.white;
const Color defaultShadowColor = Color.fromARGB(40, 0, 0, 0);//Color.fromARGB(70, 96, 200, 232);
const Offset defaultShadowOffset = Offset(0.0, 20.0);

class PlasticsCard extends StatelessWidget {
  PlasticsCard({
    Key? key,
    this.alignment,
    this.padding,
    this.cardColor = defaultCardColor,
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
    this.borderRadius = 20,
    this.outPadding = 10,

    this.shadowBlurRadius = 20,
    this.shadowOffset = defaultShadowOffset,
    this.shadowSpreadRadius = -10,
    this.shadowColor = defaultShadowColor,

}): assert(margin == null || margin.isNonNegative),
        assert(padding == null || padding.isNonNegative),
        assert(decoration == null || decoration.debugAssertIsValid()),
        assert(constraints == null || constraints.debugAssertIsValid()),
        assert(clipBehavior != null),
        assert(decoration != null || clipBehavior == Clip.none),
        assert(cardColor == null || decoration == null,
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
  final Color? cardColor;
  final Decoration? decoration;
  final Decoration? foregroundDecoration;
  final BoxConstraints? constraints;
  final EdgeInsetsGeometry? margin;
  final Matrix4? transform;
  final AlignmentGeometry? transformAlignment;
  final Clip clipBehavior;
  final double borderRadius;

  final Offset shadowOffset;
  final double shadowSpreadRadius;
  final Color shadowColor;

  final double outPadding;
  final double shadowBlurRadius;

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
            child: Material(
              color: cardColor,
              //type: MaterialType.card,
              child: Semantics(
                child: child,
              ),
            ),


          ),
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            boxShadow: [
              BoxShadow(
                  color: shadowColor,
                  offset: shadowOffset, //阴影xy轴偏移量
                  blurRadius: shadowBlurRadius, //阴影模糊程度
                  spreadRadius: shadowSpreadRadius //阴影扩散程度
              )
            ]),
      ),
    );
  }


}

