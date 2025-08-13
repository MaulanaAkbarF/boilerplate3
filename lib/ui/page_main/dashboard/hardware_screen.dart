import 'package:boilerplate_3_firebaseconnect/core/utilities/functions/page_routes_func.dart';
import 'package:boilerplate_3_firebaseconnect/core/utilities/functions/permission/security_permission.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constant_values/global_values.dart';
import '../../../core/state_management/providers/_settings/appearance_provider.dart';
import '../../../core/utilities/functions/media_query_func.dart';
import '../../../core/utilities/functions/system_func.dart';
import '../../layouts/global_state_widgets/button/button_progress/animation_progress.dart';
import '../../layouts/global_state_widgets/custom_scaffold/custom_appbar.dart';
import '../../layouts/global_state_widgets/custom_scaffold/custom_scaffold.dart';
import '../../layouts/global_state_widgets/divider/custom_divider.dart';
import '../../layouts/styleconfig/textstyle.dart';
import '../../layouts/styleconfig/themecolors.dart';
import 'hardware_screens/bluetooth_control_screen.dart';
import 'hardware_screens/wifi_control_screen.dart';

class HardwareScreen extends StatelessWidget {
  const HardwareScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppearanceSettingProvider>(
      builder: (context, provider, child) {
        if (provider.isTabletMode.condition) {
          if (getMediaQueryWidth(context) > provider.tabletModePixel.value) return _setTabletLayout(context);
          if (getMediaQueryWidth(context) < provider.tabletModePixel.value) return _setPhoneLayout(context);
        }
        return _setPhoneLayout(context);
      }
    );
  }

  Widget _setPhoneLayout(BuildContext context) {
    return CustomScaffold(
      useSafeArea: true,
      useExtension: true,
      padding: EdgeInsets.all(paddingMid),
      appBar: appBarWidget(context: context, title: 'Hardware', showBackButton: true),
      body: _bodyWidget(context)
    );
  }

  Widget _setTabletLayout(BuildContext context) {
    return CustomScaffold(
      useSafeArea: true,
      useExtension: true,
      padding: EdgeInsets.all(paddingMid),
      appBar: appBarWidget(context: context, title: 'Hardware', showBackButton: true),
      body: _bodyWidget(context)
    );
  }

  Widget _bodyWidget(BuildContext context) {
    return ListView(
      children: [
        _button(context: context, label: 'Bluetooth Control', color: ThemeColors.blue(context), onTap: () => startScreenSwipe(context, BluetoothControlScreen())),
        ColumnDivider(),
        _button(context: context, label: 'Wi-Fi Control', color: ThemeColors.orangeLowContrast(context), onTap: () => startScreenSwipe(context, WifiControlScreen())),
        ColumnDivider(),
        _button(context: context, label: 'Local Auth', onTap: () async => await checkBiometrics(useOnlyBiometricAuth: false).then((value) => showSnackBar(context, 'Status Autentikasi: $value'))),
      ],
    );
  }

  Widget _button({required BuildContext context, required String label, Color? color, required VoidCallback onTap, Function(bool)? onHover}){
    return AnimateProgressButton(
      labelButton: label,
      labelButtonStyle: TextStyles.semiGiant(context).copyWith(color: ThemeColors.surface(context)),
      containerColor: color ?? ThemeColors.greenVeryLowContrast(context),
      height: heightTowering,
      onHover: onHover,
      onTap: onTap
    );
  }
}