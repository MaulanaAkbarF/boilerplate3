import 'package:boilerplate_3_firebaseconnect/ui/layouts/styleconfig/themecolors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constant_values/global_values.dart';
import '../../../core/state_management/providers/_settings/appearance_provider.dart';
import '../../../core/state_management/providers/_settings/preference_provider.dart';

class TextStyles {
  static TextStyle getStyle(BuildContext context, double multiplier) {
    return TextStyle(
      color: ThemeColors.surface(context),
      fontFamily: Provider.of<AppearanceSettingProvider>(context, listen: false).fontType,
      fontSize: Provider.of<AppearanceSettingProvider>(context, listen: false).fontSizeString.value * multiplier,
      fontWeight: FontWeight.normal,
      overflow: TextOverflow.ellipsis,
    );
  }

  static TextStyle nano(BuildContext context) => getStyle(context, 0.35);
  static TextStyle micro(BuildContext context) => getStyle(context, 0.45);
  static TextStyle verySmall(BuildContext context) => getStyle(context, 0.55);
  static TextStyle small(BuildContext context) => getStyle(context, 0.68);
  static TextStyle semiMedium(BuildContext context) => getStyle(context, 0.73);
  static TextStyle medium(BuildContext context) => getStyle(context, 0.78);
  static TextStyle semiLarge(BuildContext context) => getStyle(context, 0.9);
  static TextStyle large(BuildContext context) => getStyle(context, 1);
  static TextStyle semiGiant(BuildContext context) => getStyle(context, 1.2);
  static TextStyle giant(BuildContext context) => getStyle(context, 1.4);
  static TextStyle semiMega(BuildContext context) => getStyle(context, 1.75);
  static TextStyle mega(BuildContext context) => getStyle(context, 2.10);
  static TextStyle semiGiga(BuildContext context) => getStyle(context, 2.6);
  static TextStyle giga(BuildContext context) => getStyle(context, 3);
  static TextStyle colossal(BuildContext context) => getStyle(context, 4);
}

Widget cText(BuildContext context, String text, {int? maxLines,  TextAlign? align, TextStyle? style, Function()? onTap}){
  return onTap != null ? GestureDetector(
    onTap: () async => onTap(),
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: paddingMid),
      child: Text(
        text,
        maxLines: maxLines ?? 10,
        textAlign: align ?? TextAlign.left,
        semanticsLabel: text,
        locale: Locale(Provider.of<PreferenceSettingProvider>(context, listen: false).language.countryId),
        style: style ?? TextStyles.medium(context).copyWith(color: ThemeColors.blue(context)),
      ),
    ),
  ) : Text(
    text,
    maxLines: maxLines ?? 10,
    textAlign: align ?? TextAlign.left,
    semanticsLabel: text,
    locale: Locale(Provider.of<PreferenceSettingProvider>(context, listen: false).language.countryId),
    style: style ?? TextStyles.medium(context),
  );
}