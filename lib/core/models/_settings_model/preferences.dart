import '../../constant_values/_setting_value/preferences_values.dart';

class PreferencesModelSetting {
  final ListLanguage language;
  final ListTimeZone timeZone;
  final ListDateFormat dateFormat;
  final ListTimeFormat timeFormat;
  final ListUseAnimation useAnimation;
  final ListUsePageTransition pageTransition;
  final ListUsePageAnimation pageAnimation;

  PreferencesModelSetting({
    required this.language,
    required this.timeZone,
    required this.dateFormat,
    required this.timeFormat,
    required this.useAnimation,
    required this.pageTransition,
    required this.pageAnimation,
  });

  Map<String, dynamic> toJson() {
    return {
      'language': language.name,
      'timeZone': timeZone.name,
      'dateFormat': dateFormat.name,
      'timeFormat': timeFormat.name,
      'useAnimation': useAnimation.name,
      'pageTransition': pageTransition.name,
      'pageAnimation': pageAnimation.name,
    };
  }

  factory PreferencesModelSetting.fromJson(Map<String, dynamic> json) {
    return PreferencesModelSetting(
      language: ListLanguage.values.firstWhere((e) => e.name == json['language'], orElse: () => ListLanguage.indonesia),
      timeZone: ListTimeZone.values.firstWhere((e) => e.name == json['timeZone'], orElse: () => ListTimeZone.jakartaWib),
      dateFormat: ListDateFormat.values.firstWhere((e) => e.name == json['dateFormat'], orElse: () => ListDateFormat.dayMonthYear),
      timeFormat: ListTimeFormat.values.firstWhere((e) => e.name == json['timeFormat'], orElse: () => ListTimeFormat.hourMinute),
      useAnimation: ListUseAnimation.values.firstWhere((e) => e.name == json['useAnimation'], orElse: () => ListUseAnimation.active),
      pageTransition: ListUsePageTransition.values.firstWhere((e) => e.name == json['pageTransition'], orElse: () => ListUsePageTransition.active),
      pageAnimation: ListUsePageAnimation.values.firstWhere((e) => e.name == json['pageAnimation'], orElse: () => ListUsePageAnimation.active),
    );
  }
}