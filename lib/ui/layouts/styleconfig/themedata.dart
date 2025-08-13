import 'package:boilerplate_3_firebaseconnect/ui/layouts/styleconfig/textstyle.dart';
import 'package:boilerplate_3_firebaseconnect/ui/layouts/styleconfig/themecolors.dart';
import 'package:flutter/material.dart';

import '../../../core/constant_values/global_values.dart';
import '../../../core/state_management/providers/_settings/appearance_provider.dart';

ThemeData theme(BuildContext context) => Theme.of(context);
TextTheme textTheme(BuildContext context) => Theme.of(context).textTheme;

ThemeData globalThemeData(BuildContext context, AppearanceSettingProvider provider){
  Color divideColor = provider.brightnessTheme == Brightness.light ? ThemeColors.greyHighContrast(context) : ThemeColors.greyLowContrast(context);

  return ThemeData(
    useMaterial3: false,
    brightness: provider.brightnessTheme,
    dividerColor: divideColor,
    textTheme: TextTheme(
      displayLarge: ThemeData().textTheme.displayLarge,
      displayMedium: ThemeData().textTheme.displayMedium,
      displaySmall: ThemeData().textTheme.displaySmall,
      headlineLarge: ThemeData().textTheme.headlineLarge,
      headlineMedium: ThemeData().textTheme.headlineMedium,
      headlineSmall: ThemeData().textTheme.headlineSmall,
      titleLarge: ThemeData().textTheme.titleLarge,
      titleMedium: ThemeData().textTheme.titleMedium,
      titleSmall: ThemeData().textTheme.titleSmall,
      bodyLarge: ThemeData().textTheme.bodyLarge,
      bodyMedium: ThemeData().textTheme.bodyMedium,
      bodySmall: ThemeData().textTheme.bodySmall,
      labelLarge: ThemeData().textTheme.labelLarge,
      labelMedium: ThemeData().textTheme.labelMedium,
      labelSmall: ThemeData().textTheme.labelSmall,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: ThemeColors.surface(context),
      centerTitle: true,
      titleTextStyle: TextStyles.medium(context).copyWith(fontWeight: FontWeight.bold),
      elevation: 0,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: ThemeColors.surface(context),
      selectedItemColor: ThemeColors.onSurface(context),
      unselectedItemColor: ThemeColors.greyLowContrast(context),
      selectedLabelStyle: TextStyles.medium(context),
      elevation: 5,
    ),
    tabBarTheme: TabBarThemeData(
      labelColor: ThemeColors.blueHighContrast(context),
      unselectedLabelColor: ThemeColors.greyLowContrast(context),
      labelStyle: TextStyles.medium(context),
      indicatorColor: ThemeColors.green(context),
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(width: 2.0, color: ThemeColors.red(context)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.symmetric(horizontal: paddingFar),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(radiusSquare), borderSide: BorderSide(color: divideColor)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(radiusSquare), borderSide: BorderSide(color:divideColor)),
      suffixIconColor: divideColor,
      filled: true,
      fillColor: ThemeColors.surface(context),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(0, heightTall),
        backgroundColor: ThemeColors.cyan(context),
        foregroundColor: ThemeColors.blue(context),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radiusSquare)),
      ),
    ),
    buttonTheme: ButtonThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radiusSquare)), 
        buttonColor: ThemeColors.blue(context),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: ThemeColors.blueHighContrast(context),
        side: BorderSide(color: ThemeColors.blueHighContrast(context)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radiusSquare)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        shape: const RoundedRectangleBorder(),
        foregroundColor: ThemeColors.surface(context),
      ),
    ),
    timePickerTheme: TimePickerThemeData(
      confirmButtonStyle: TextButton.styleFrom(foregroundColor: ThemeColors.blue(context)),
      cancelButtonStyle: TextButton.styleFrom(foregroundColor: ThemeColors.red(context)),
    ),
    datePickerTheme: DatePickerThemeData(
      confirmButtonStyle: TextButton.styleFrom(foregroundColor: ThemeColors.blue(context)),
      cancelButtonStyle: TextButton.styleFrom(foregroundColor: ThemeColors.red(context)),
    ),
  );
}