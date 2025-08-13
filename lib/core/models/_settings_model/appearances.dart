import '../../constant_values/_setting_value/appearance_values.dart';

class AppearancesModelSetting {
  final String fontType;
  final ListFontSize fontSize;
  final ListPreferredOrientation preferredOrientation;
  final ListSafeAreaMode isSafeArea;
  final ListTabletMode isTabletMode;
  final ListChangeToTabletMode tabletModePixel;
  final ListThemeApp themeType;

  AppearancesModelSetting({
    required this.fontType,
    required this.fontSize,
    required this.preferredOrientation,
    required this.isSafeArea,
    required this.isTabletMode,
    required this.tabletModePixel,
    required this.themeType,
  });

  Map<String, dynamic> toJson() {
    return {
      'fontType': fontType,
      'fontSize': fontSize.name,
      'preferredOrientation': preferredOrientation.name,
      'isSafeArea': isSafeArea.name,
      'isTabletMode': isTabletMode.name,
      'tabletModePixel': tabletModePixel.name,
      'themeType': themeType.name,
    };
  }

  factory AppearancesModelSetting.fromJson(Map<String, dynamic> json) {
    return AppearancesModelSetting(
      fontType: json['fontType'] ?? '',
      fontSize: ListFontSize.values.firstWhere((e) => e.name == json['fontSize'], orElse: () => ListFontSize.medium),
      preferredOrientation: ListPreferredOrientation.values.firstWhere((e) => e.name == json['preferredOrientation'], orElse: () => ListPreferredOrientation.active),
      isSafeArea: ListSafeAreaMode.values.firstWhere((e) => e.name == json['isSafeArea'], orElse: () => ListSafeAreaMode.active),
      isTabletMode: ListTabletMode.values.firstWhere((e) => e.name == json['isTabletMode'], orElse: () => ListTabletMode.deactive),
      tabletModePixel: ListChangeToTabletMode.values.firstWhere((e) => e.name == json['tabletModePixel'], orElse: () => ListChangeToTabletMode.normal),
      themeType: ListThemeApp.values.firstWhere((e) => e.name == json['themeType'], orElse: () => ListThemeApp.system),
    );
  }
}