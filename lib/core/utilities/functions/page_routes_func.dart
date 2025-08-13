import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../../../ui/layouts/global_state_widgets/dialog/dialog_button/permission_dialog.dart';
import '../../constant_values/_setting_value/log_app_values.dart';
import '../../state_management/providers/_global_widget/navigator_provider.dart';
import '../../state_management/providers/_settings/preference_provider.dart';
import '../local_storage/isar_local_db/services/_setting_services/log_app_services.dart';
import 'logger_func.dart';

/// Swipe Transition
Future<T?> startScreenSwipe<T>(BuildContext context, Widget pages, {PageTransitionType? transition, Alignment? align, Curve? curve, int? durationMs}) {
  return Navigator.push<T>(
    context,
    Provider.of<PreferenceSettingProvider>(context, listen: false).useAnimation.condition && Provider.of<PreferenceSettingProvider>(context, listen: false).pageTransition.condition 
    ? PageTransition(
      type: transition ?? PageTransitionType.rightToLeftWithFade,
      alignment: align ?? Alignment.bottomCenter,
      curve: curve ?? Curves.easeIn,
      duration: Duration(milliseconds: durationMs ?? 300),
      child: pages,
    ) : MaterialPageRoute(builder: (context) => pages),
  );
}

Future<T?> startScreenSwipeRepl<T>(BuildContext context, Widget pages, {PageTransitionType? transition, Alignment? align, Curve? curve, int? durationMs}) {
  return Navigator.pushReplacement<T,T>(
    context,
    Provider.of<PreferenceSettingProvider>(context, listen: false).useAnimation.condition && Provider.of<PreferenceSettingProvider>(context, listen: false).pageTransition.condition
    ? PageTransition(
      type: transition ?? PageTransitionType.rightToLeftWithFade,
      alignment: align ?? Alignment.bottomCenter,
      curve: curve ?? Curves.easeIn,
      duration: Duration(milliseconds: durationMs ?? 300),
      child: pages,
    ) : MaterialPageRoute(builder: (context) => pages),
  );
}

/// Fade Transition
Future<T?> startScreenFade<T>(BuildContext context, Widget pages, {PageTransitionType? transition, Alignment? align, Curve? curve, int? durationMs}) {
  return Navigator.push<T>(
    context,
    Provider.of<PreferenceSettingProvider>(context, listen: false).useAnimation.condition && Provider.of<PreferenceSettingProvider>(context, listen: false).pageTransition.condition
    ? PageTransition(
      type: transition ?? PageTransitionType.fade,
      alignment: align ?? Alignment.bottomCenter,
      curve: curve ?? Curves.easeIn,
      duration: Duration(milliseconds: durationMs ?? 300),
      child: pages,
    ) : MaterialPageRoute(builder: (context) => pages),
  );
}

Future<T?> startScreenFadeRepl<T>(BuildContext context, Widget pages, {PageTransitionType? transition, Alignment? align, Curve? curve, int? durationMs}) {
  return Navigator.pushReplacement<T,T>(
    context,
    Provider.of<PreferenceSettingProvider>(context, listen: false).useAnimation.condition && Provider.of<PreferenceSettingProvider>(context, listen: false).pageTransition.condition
    ? PageTransition(
      type: transition ?? PageTransitionType.fade,
      alignment: align ?? Alignment.bottomCenter,
      curve: curve ?? Curves.easeIn,
      duration: Duration(milliseconds: durationMs ?? 300),
      child: pages,
    ) : MaterialPageRoute(builder: (context) => pages),
  );
}

/// Fly Transition
Future<T?> startScreenFly<T>(BuildContext context, Widget pages, {PageTransitionType? transition, Alignment? align, Curve? curve, int? durationMs}) {
  return Navigator.push<T>(
    context,
    Provider.of<PreferenceSettingProvider>(context, listen: false).useAnimation.condition && Provider.of<PreferenceSettingProvider>(context, listen: false).pageTransition.condition
    ? PageTransition(
      type: transition ?? PageTransitionType.bottomToTop,
      alignment: align ?? Alignment.bottomCenter,
      curve: curve ?? Curves.easeInCirc,
      duration: Duration(milliseconds: durationMs ?? 250),
      child: pages,
    ) : MaterialPageRoute(builder: (context) => pages),
  );
}

Future<T?> startScreenFlyRepl<T>(BuildContext context, Widget pages, {PageTransitionType? transition, Alignment? align, Curve? curve, int? durationMs}) {
  return Navigator.pushReplacement<T,T>(
    context,
    Provider.of<PreferenceSettingProvider>(context, listen: false).useAnimation.condition && Provider.of<PreferenceSettingProvider>(context, listen: false).pageTransition.condition
    ? PageTransition(
      type: transition ?? PageTransitionType.bottomToTop,
      alignment: align ?? Alignment.bottomCenter,
      curve: curve ?? Curves.easeIn,
      duration: Duration(milliseconds: durationMs ?? 300),
      child: pages,
    ) : MaterialPageRoute(builder: (context) => pages),
  );
}

/// Navigasikan dan hapus semua stack navigasi
void startScreenRemoveAll(BuildContext context, Widget pages, {PageTransitionType? transition, Alignment? align, Curve? curve, int? durationMs}) {
  Navigator.pushAndRemoveUntil(
    context,
    Provider.of<PreferenceSettingProvider>(context, listen: false).useAnimation.condition && Provider.of<PreferenceSettingProvider>(context, listen: false).pageTransition.condition
    ? PageTransition(
      type: transition ?? PageTransitionType.rightToLeftWithFade,
      alignment: align ?? Alignment.bottomCenter,
      curve: curve ?? Curves.easeIn,
      duration: Duration(milliseconds: durationMs ?? 300),
      child: pages,
    ) : MaterialPageRoute(builder: (context) => pages), (route) => false,
  );
}

/// Navigator Push untuk mengarahkan dan membuka halaman baru tanpa context
Future<T?>? startNavigatorPush<T>(Widget pages, {PageTransitionType? transition, Alignment? align, Curve? curve, int? durationMs}) {
  return NavigatorProvider.navigatorState?.push<T>(
    PageTransition(
      type: transition ?? PageTransitionType.rightToLeftWithFade,
      alignment: align ?? Alignment.bottomCenter,
      curve: curve ?? Curves.easeIn,
      duration: Duration(milliseconds: durationMs ?? 330),
      child: pages,
    ),
  );
}

void startNavigatorDialog<T>({
  VoidCallback? declinedOnTap, required VoidCallback acceptedOnTap, String? title, String? description, String? declineText, String? acceptText,
  Widget? dialog, PageTransitionType? transition, Alignment? align, Curve? curve, int? durationMs
}) {
  OverlayEntry? overlayEntry;
  overlayEntry = OverlayEntry(builder: (context) => dialog ?? PermissionDialog(
      header: 'Overlay',
      description: 'Overlay Dialog',
      declinedText: declineText ?? 'Kembali',
      declinedOnTap: () => declinedOnTap != null? declinedOnTap() : overlayEntry?.remove(),
      acceptedText: acceptText ?? 'Konfirmasi',
      acceptedOnTap: () async {
        try {
          acceptedOnTap();
        } catch (e, s) {
          clog('Terjadi masalah saat acceptedOnTap: $e\n$s');
          await addLogApp(level: ListLogAppLevel.critical.level, title: e.toString(), logs: s.toString());
        } finally {
          overlayEntry?.remove();
        }
      }
  ));

  NavigatorProvider.navigatorState?.overlay?.insert(overlayEntry);
}

