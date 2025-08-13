import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../styleconfig/textstyle.dart';
import '../../styleconfig/themecolors.dart';

class WarningText extends StatefulWidget {
  final bool visible;
  final bool snackBarVisible;
  final String text;
  final String? textSnackBar;
  final Duration? snackBarDuration;
  final TextStyle? textStyle;
  final Icon icon;
  final Color? iconColor;
  final double iconSize;

  const WarningText({
    super.key,
    required this.visible,
    this.snackBarVisible = false,
    required this.text,
    this.textSnackBar,
    this.snackBarDuration,
    this.textStyle,
    this.icon = const Icon(Icons.error),
    this.iconColor,
    this.iconSize = 16,
  });

  @override
  State<WarningText> createState() => _WarningTextState();
}

class _WarningTextState extends State<WarningText> {
  void showSnackBar(BuildContext context, String message, Duration duration) {
    final snackBar = SnackBar(content: Text(message), duration: duration);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    
    if (widget.snackBarVisible) {
      if (widget.visible == true) {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          showSnackBar(context, widget.textSnackBar ?? widget.text, widget.snackBarDuration ?? const Duration(seconds: 2));
        });
      }
    }
    return Visibility(
      visible: widget.visible,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child:Icon(
                widget.icon.icon,
                color: ThemeColors.red(context),
                size: widget.iconSize,
              ),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: cText(context, widget.text, maxLines: 2, style: widget.textStyle ?? TextStyles.small(context).copyWith(color: ThemeColors.red(context))),
              ),
            ),
          ],
        ),
      ),
    );
  }
}