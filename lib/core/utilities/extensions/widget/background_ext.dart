import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

import '../../../../ui/layouts/global_return_widgets/media_widgets_func.dart';
import '../../../constant_values/assets_values.dart';

extension WidgetHelperExtensions on Widget {
  /// KeyboardVisibilityBuilder digunakan untuk kontol
  Widget dismissKeyboardOnTap(BuildContext context) {
    return KeyboardVisibilityBuilder(
      builder: (p0, isKeyboardVisible) => GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        behavior: HitTestBehavior.translucent,
        child: this,
      ),
    );
  }

  Widget gradientBackground({required BuildContext context, double? opacity}) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned(
          top: 0,
          bottom: 0,
          left: 0,
          right: 0,
          child: Opacity(opacity: opacity ?? 0.1, child: loadImageAssetPNG(path: iconLogoPNG)),
        ),
        this,
      ],
    );
  }
}