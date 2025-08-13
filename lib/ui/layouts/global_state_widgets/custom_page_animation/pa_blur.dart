import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../../core/constant_values/assets_values.dart';
import '../../global_return_widgets/media_widgets_func.dart';

class PageAnimationBlur extends StatefulWidget {
  final Widget child;
  final int? duration;
  final double? opacityStart;
  final double? blurStart;
  final Color? glowingIndicatorColor;

  const PageAnimationBlur({
    super.key,
    required this.child,
    this.duration,
    this.opacityStart,
    this.blurStart,
    this.glowingIndicatorColor,
  });

  @override
  State<PageAnimationBlur> createState() => _PageAnimationBlurState();
}

class _PageAnimationBlurState extends State<PageAnimationBlur> with TickerProviderStateMixin {
  late AnimationController _opacityController;
  late AnimationController _blurController;
  late Animation<double> _opacityAnimation;
  late Animation<double> _blurAnimation;

  @override
  void initState() {
    super.initState();
    _opacityController = AnimationController(vsync: this, duration: Duration(milliseconds: widget.duration ?? 250));
    _blurController = AnimationController(vsync: this, duration: Duration(milliseconds: widget.duration ?? 500));
    _opacityAnimation = Tween<double>(begin: widget.opacityStart ?? 0.0,
        end: 1.0).animate(CurvedAnimation(parent: _opacityController, curve: Curves.easeInOutQuint));
    _blurAnimation = Tween<double>(begin: widget.blurStart ?? 5,
        end: 0.0).animate(CurvedAnimation(parent: _blurController, curve: Curves.easeInOutQuint));
    _opacityController.forward().then((_) => _blurController.forward());
  }

  @override
  void dispose() {
    _opacityController.dispose();
    _blurController.dispose();
    super.dispose();
  }

  // @override
  // Widget build(BuildContext context) {
  //   return GlowingOverscrollIndicator(
  //     axisDirection: AxisDirection.down,
  //     color: widget.glowingIndicatorColor ?? Theme.of(context).primaryColor.withOpacity(0.5),
  //     child: ShaderMask(
  //       shaderCallback: (Rect bounds) {
  //         return const LinearGradient(
  //           begin: Alignment.topCenter,
  //           end: Alignment.bottomCenter,
  //           colors: <Color>[
  //             Colors.transparent,
  //             Colors.black,
  //             Colors.black,
  //             Colors.transparent
  //           ],
  //           stops: [0.0, 0.03, 0.97, 1.0],
  //         ).createShader(bounds);
  //       },
  //       blendMode: BlendMode.dstIn,
  //       child: AnimatedBuilder(
  //         animation: Listenable.merge([_opacityController, _blurController]),
  //         builder: (context, child) {
  //           return Opacity(
  //             opacity: _opacityAnimation.value,
  //             child: ImageFiltered(
  //               imageFilter: ImageFilter.blur(
  //                 sigmaX: _blurAnimation.value,
  //                 sigmaY: _blurAnimation.value,
  //               ),
  //               child: Container(
  //                 decoration: BoxDecoration(
  //                   image: loadDecorationImage(path: iconGooglePNG)),
  //                   child: child,
  //                 ),
  //               ),
  //           );
  //         },
  //         child: widget.child,
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return GlowingOverscrollIndicator(
      axisDirection: AxisDirection.down,
      color: widget.glowingIndicatorColor ?? Theme.of(context).primaryColor.withOpacity(0.5),
      child: AnimatedBuilder(
        animation: Listenable.merge([_opacityController, _blurController]),
        builder: (context, child) {
          return Opacity(
            opacity: _opacityAnimation.value,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(
                sigmaX: _blurAnimation.value,
                sigmaY: _blurAnimation.value,
              ),
              child: Container(
                decoration: BoxDecoration(
                    image: loadDecorationImage(path: iconGooglePNG)),
                child: child,
              ),
            ),
          );
        },
        child: widget.child,
      ),
    );
  }
}

class PageAnimationBlurWithZoom extends StatefulWidget {
  final Widget child;
  final int? duration;
  final double? opacityStart;
  final double? zoomStart;
  final double? blurStart;
  final Color? glowingIndicatorColor;

  const PageAnimationBlurWithZoom({
    super.key,
    required this.child,
    this.duration,
    this.opacityStart,
    this.zoomStart,
    this.blurStart,
    this.glowingIndicatorColor,
  });

  @override
  State<PageAnimationBlurWithZoom> createState() => _PageAnimationBlurWithZoomState();
}

class _PageAnimationBlurWithZoomState extends State<PageAnimationBlurWithZoom> with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _blurController;
  late Animation<double> _opacityAnimation;
  late Animation<double> _blurAnimation;
  late Animation<double> _zoomAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: widget.duration ?? 500));
    _blurController = AnimationController(vsync: this, duration: Duration(milliseconds: widget.duration ?? 200));
    _opacityAnimation = Tween<double>(begin: widget.opacityStart ?? 0.0,
        end: 1.0).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOutQuint));
    _blurAnimation = Tween<double>(begin: widget.blurStart ?? 5,
        end: 0.0).animate(CurvedAnimation(parent: _blurController, curve: Curves.easeInOutQuint));
    _zoomAnimation = Tween<double>(begin: widget.zoomStart ?? 1.2, end: 1.0).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOutQuint));
    _controller.forward().then((_) => _blurController.forward());
  }

  @override
  void dispose() {
    _controller.dispose();
    _blurController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GlowingOverscrollIndicator(
      axisDirection: AxisDirection.down,
      color: widget.glowingIndicatorColor ?? Theme.of(context).primaryColor.withOpacity(0.5),
      child: AnimatedBuilder(
        animation: Listenable.merge([_controller, _blurController]),
        builder: (context, child) {
          return Opacity(
            opacity: _opacityAnimation.value,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(
                sigmaX: _blurAnimation.value,
                sigmaY: _blurAnimation.value,
              ),
              child: Transform.scale(
                scale: _zoomAnimation.value,
                child: child,
              ),
            ),
          );
        },
        child: widget.child,
      ),
    );
  }
}