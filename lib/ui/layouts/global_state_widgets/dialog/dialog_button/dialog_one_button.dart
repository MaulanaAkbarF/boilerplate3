import 'package:flutter/material.dart';

import '../../../../../core/constant_values/global_values.dart';
import '../../../global_return_widgets/media_widgets_func.dart';
import '../../../styleconfig/textstyle.dart';
import '../../../styleconfig/themecolors.dart';
import '../../button/button_progress/animation_progress.dart';
import '../../divider/custom_divider.dart';

class DialogOneButton extends StatelessWidget {
  final String? lottiePath;
  final String? imagePathPNG;
  final IconData? iconData;
  final double? sizeContentImages;
  final Color? colorContentImages;
  final String header;
  final String description;
  final TextStyle? headerTextStyle;
  final TextStyle? descriptionTextStyle;
  final String? acceptedText;
  final String? loadingAcceptedText;
  final TextStyle? acceptedTextStyle;
  final Function()? acceptedOnTap;

  const DialogOneButton({
    super.key,
    this.lottiePath,
    this.imagePathPNG,
    this.iconData,
    this.sizeContentImages,
    this.colorContentImages,
    required this.header,
    required this.description,
    this.headerTextStyle,
    this.descriptionTextStyle,
    this.acceptedText,
    this.loadingAcceptedText,
    this.acceptedTextStyle,
    this.acceptedOnTap,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      surfaceTintColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      shadowColor: Colors.transparent,
      child: Align(
        alignment: Alignment.center,
        child: Container(
          decoration: BoxDecoration(
            color: ThemeColors.greyLowContrast(context),
            borderRadius: BorderRadius.circular(radiusSquare),
            boxShadow: [
              BoxShadow(
                color: ThemeColors.grey(context).withValues(alpha: shadowOpacityMid),
                spreadRadius: shadowSpreadLow,
                blurRadius: shadowBlueHigh,
                offset: const Offset(0, shadowoffsetMid),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(paddingMid),
            child: IntrinsicHeight(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  lottiePath != null ? loadLottieAsset(path: lottiePath!, width: sizeContentImages, height: sizeContentImages)
                      : imagePathPNG != null ? loadImageAssetPNG(path: imagePathPNG!, width: sizeContentImages, height: sizeContentImages, color: colorContentImages)
                      : iconData != null ? Icon(iconData, size: sizeContentImages, color: colorContentImages) : SizedBox(),
                  cText(context, header, maxLines: 3, align: TextAlign.center, style: headerTextStyle ?? TextStyles.large(context).copyWith(color: ThemeColors.surface(context), fontWeight: FontWeight.w900)),
                  ColumnDivider(),
                  cText(context, description, align: TextAlign.center, style: descriptionTextStyle ?? TextStyles.medium(context).copyWith(color: ThemeColors.surface(context))),
                  ColumnDivider(),
                  AnimateProgressButton(
                    labelButton: acceptedText,
                    labelButtonStyle: acceptedTextStyle ?? TextStyles.medium(context).copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                    labelProgress: loadingAcceptedText,
                    height: heightMid,
                    containerColor: ThemeColors.blueHighContrast(context),
                    containerRadius: radiusSquare,
                    onTap: () async => acceptedOnTap != null ? acceptedOnTap!() : Navigator.pop(context),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}