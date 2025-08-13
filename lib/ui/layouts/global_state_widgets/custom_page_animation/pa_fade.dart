import 'package:flutter/material.dart';

import '../../styleconfig/themecolors.dart';

/// Gunakan Page Animation di atas ListView/Column atau gunakan di atas Padding dimana Padding membungkus ListView/Column
/// Page Animation juga bisa digunakan pada beberapa widget seperti Button, TextField dan widget lainnya!
class PageAnimationSwipeFade extends StatefulWidget {
  final Widget child;
  final int? duration;
  final double? xStart;
  final double? xEnd;
  final double? yStart;
  final double? yEnd;
  final Color? glowingIndocatorColor;

  const PageAnimationSwipeFade({
    super.key,
    required this.child,
    this.duration ,
    this.xStart,
    this.xEnd,
    this.yStart,
    this.yEnd,
    this.glowingIndocatorColor,
  });

  @override
  State<PageAnimationSwipeFade> createState() => _PageAnimationSwipeFadeState();
}

class _PageAnimationSwipeFadeState extends State<PageAnimationSwipeFade> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _positionAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: widget.duration ?? 500));
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOutQuint));
    _positionAnimation = Tween<Offset>(begin: Offset(widget.xStart ?? -30, widget.yStart ?? 0),
        end: Offset(widget.xEnd ?? 0, widget.yEnd ?? 0)).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOutQuint));
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
      color: widget.glowingIndocatorColor ?? ThemeColors.blue(context).withValues(alpha: .5),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.translate(
            offset: _positionAnimation.value,
            child: Opacity(opacity: _opacityAnimation.value, child: child),
          );
        },
        child: widget.child,
      ),
    );
  }
}

class PageAnimationFlyFade extends StatefulWidget {
  final Widget child;
  final int? duration;
  final double? xStart;
  final double? xEnd;
  final double? yStart;
  final double? yEnd;
  final Color? glowingIndocatorColor;

  const PageAnimationFlyFade({
    super.key,
    required this.child,
    this.duration ,
    this.xStart,
    this.xEnd,
    this.yStart,
    this.yEnd,
    this.glowingIndocatorColor,
  });

  @override
  State<PageAnimationFlyFade> createState() => _PageAnimationFlyFadeState();
}

class _PageAnimationFlyFadeState extends State<PageAnimationFlyFade> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _positionAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: widget.duration ?? 500));
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOutQuint));
    _positionAnimation = Tween<Offset>(begin: Offset(widget.xStart ?? 0, widget.yStart ?? 30),
        end: Offset(widget.xEnd ?? 0, widget.yEnd ?? 0)).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOutQuint));
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
      color: widget.glowingIndocatorColor ?? ThemeColors.blue(context).withValues(alpha: .5),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.translate(
            offset: _positionAnimation.value,
            child: Opacity(opacity: _opacityAnimation.value, child: child),
          );
        },
        child: widget.child,
      ),
    );
  }
}