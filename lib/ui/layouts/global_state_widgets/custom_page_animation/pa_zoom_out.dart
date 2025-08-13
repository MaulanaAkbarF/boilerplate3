import 'package:flutter/material.dart';

import '../../styleconfig/themecolors.dart';

/// Gunakan Page Animation di atas ListView/Column atau gunakan di atas Padding dimana Padding membungkus ListView/Column
/// Page Animation juga bisa digunakan pada beberapa widget seperti Button, TextField dan widget lainnya!
class PageAnimationZoomOut extends StatefulWidget {
  final Widget child;
  final int? duration;
  final double? zoomStart;
  final Color? glowingIndicatorColor;

  const PageAnimationZoomOut({
    super.key,
    required this.child,
    this.duration,
    this.zoomStart,
    this.glowingIndicatorColor,
  });

  @override
  State<PageAnimationZoomOut> createState() => _PageAnimationZoomOutState();
}

class _PageAnimationZoomOutState extends State<PageAnimationZoomOut> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _zoomAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: widget.duration ?? 600));
    _zoomAnimation = Tween<double>(begin: widget.zoomStart ?? 0.8, end: 1.0).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOutQuint));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GlowingOverscrollIndicator(
      axisDirection: AxisDirection.down,
      color: widget.glowingIndicatorColor ?? ThemeColors.blue(context).withValues(alpha: .5),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _zoomAnimation.value,
            child: child,
          );
        },
        child: widget.child,
      ),
    );
  }
}

class PageAnimationSwipeZoomOut extends StatefulWidget {
  final Widget child;
  final int? duration;
  final double? xStart;
  final double? xEnd;
  final double? yStart;
  final double? yEnd;
  final double? zoomStart;
  final Color? glowingIndicatorColor;

  const PageAnimationSwipeZoomOut({
    super.key,
    required this.child,
    this.duration,
    this.xStart,
    this.xEnd,
    this.yStart,
    this.yEnd,
    this.zoomStart,
    this.glowingIndicatorColor,
  });

  @override
  State<PageAnimationSwipeZoomOut> createState() => _PageAnimationSwipeZoomOutState();
}

class _PageAnimationSwipeZoomOutState extends State<PageAnimationSwipeZoomOut> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _zoomAnimation;
  late Animation<Offset> _positionAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: widget.duration ?? 600));
    _zoomAnimation = Tween<double>(begin: widget.zoomStart ?? 0.8, end: 1.0).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutQuint));
    _positionAnimation = Tween<Offset>(begin: Offset(widget.xStart ?? -60, widget.yStart ?? 0),
        end: Offset(widget.xEnd ?? 0, widget.yEnd ?? 0)).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutQuint));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GlowingOverscrollIndicator(
      axisDirection: AxisDirection.down,
      color: widget.glowingIndicatorColor ?? ThemeColors.blue(context).withValues(alpha: .5),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.translate(
            offset: _positionAnimation.value,
            child: Transform.scale(
              scale: _zoomAnimation.value,
              child: child,
            ),
          );
        },
        child: widget.child,
      ),
    );
  }
}

class PageAnimationFlyZoomOut extends StatefulWidget {
  final Widget child;
  final int? duration;
  final double? xStart;
  final double? xEnd;
  final double? yStart;
  final double? yEnd;
  final Color? glowingIndicatorColor;

  const PageAnimationFlyZoomOut({
    super.key,
    required this.child,
    this.duration,
    this.xStart,
    this.xEnd,
    this.yStart,
    this.yEnd,
    this.glowingIndicatorColor,
  });

  @override
  State<PageAnimationFlyZoomOut> createState() => _PageAnimationFlyZoomOutState();
}

class _PageAnimationFlyZoomOutState extends State<PageAnimationFlyZoomOut> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _zoomAnimation;
  late Animation<Offset> _positionAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: widget.duration ?? 750));
    _zoomAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutQuint));
    _positionAnimation = Tween<Offset>(begin: Offset(widget.xStart ?? 0, widget.yStart ?? 60),
        end: Offset(widget.xEnd ?? 0, widget.yEnd ?? 0)).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutQuint));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GlowingOverscrollIndicator(
      axisDirection: AxisDirection.down,
      color: widget.glowingIndicatorColor ?? ThemeColors.blue(context).withValues(alpha: .5),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.translate(
            offset: _positionAnimation.value,
            child: Transform.scale(
              scale: _zoomAnimation.value,
              child: child,
            ),
          );
        },
        child: widget.child,
      ),
    );
  }
}