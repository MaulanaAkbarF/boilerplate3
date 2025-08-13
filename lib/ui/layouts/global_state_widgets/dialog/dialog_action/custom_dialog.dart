import 'package:flutter/material.dart';

import '../../../../../core/constant_values/global_values.dart';
import '../../../styleconfig/textstyle.dart';
import '../../../styleconfig/themecolors.dart';
import '../../button/button_progress/animation_progress.dart';
import '../../divider/custom_divider.dart';

class DialogCustom extends StatelessWidget {
  final String? header;
  final String? description;
  final TextStyle? headerTextStyle;
  final TextStyle? descriptionTextStyle;
  final Widget child;
  final String? acceptedText;
  final String? loadingAcceptedText;
  final TextStyle? acceptedTextStyle;
  final Function() acceptedOnTap;
  final String? declinedText;
  final String? loadingDeclinedText;
  final TextStyle? declinedTextStyle;
  final Function()? declinedOnTap;

  const DialogCustom({
    super.key,
    this.header,
    this.description,
    this.headerTextStyle,
    this.descriptionTextStyle,
    required this.child,
    this.acceptedText,
    this.loadingAcceptedText,
    this.acceptedTextStyle,
    required this.acceptedOnTap,
    this.declinedText,
    this.loadingDeclinedText,
    this.declinedTextStyle,
    this.declinedOnTap,
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
                  if (header != null)...[
                    cText(context, header!, maxLines: 3, align: TextAlign.center, style: headerTextStyle ?? TextStyles.large(context).copyWith(color: ThemeColors.surface(context), fontWeight: FontWeight.w900)),
                    ColumnDivider(),
                  ],
                  if (description != null)...[
                    cText(context, description!, align: TextAlign.center, style: descriptionTextStyle ?? TextStyles.medium(context).copyWith(color: ThemeColors.surface(context))),
                    ColumnDivider(),
                  ],
                  child,
                  ColumnDivider(),
                  if (declinedOnTap != null)...[
                    Row(
                      children: [
                        Expanded(
                          child: AnimateProgressButton(
                            labelButton: declinedText ?? 'Kembali',
                            labelButtonStyle: declinedTextStyle ?? TextStyles.medium(context).copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                            labelProgress: loadingDeclinedText,
                            height: heightMid,
                            containerColor: ThemeColors.redHighContrast(context),
                            containerRadius: radiusSquare,
                            onTap: () async => declinedOnTap != null ? declinedOnTap!() : Navigator.pop(context),
                          ),
                        ),
                        RowDivider(),
                        Expanded(
                          child: AnimateProgressButton(
                            labelButton: acceptedText,
                            labelButtonStyle: acceptedTextStyle ?? TextStyles.medium(context).copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                            labelProgress: loadingAcceptedText,
                            height: heightMid,
                            containerColor: ThemeColors.blueHighContrast(context),
                            containerRadius: radiusSquare,
                            onTap: () async => acceptedOnTap(),
                          ),
                        ),
                      ],
                    )
                  ],
                  if (declinedOnTap == null)...[
                    AnimateProgressButton(
                      labelButton: acceptedText,
                      labelButtonStyle: acceptedTextStyle ?? TextStyles.medium(context).copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                      labelProgress: loadingAcceptedText,
                      height: heightMid,
                      containerColor: ThemeColors.blueHighContrast(context),
                      containerRadius: radiusSquare,
                      onTap: () async => acceptedOnTap(),
                    )
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}