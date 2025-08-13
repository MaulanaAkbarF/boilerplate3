import 'package:boilerplate_3_firebaseconnect/ui/page_main/dashboard/counter_screen.dart';
import 'package:boilerplate_3_firebaseconnect/ui/page_main/dashboard/qr_code_screen.dart';
import 'package:boilerplate_3_firebaseconnect/ui/page_main/dashboard/webview_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constant_values/global_values.dart';
import '../../../core/state_management/providers/_settings/appearance_provider.dart';
import '../../../core/state_management/providers/features/firebase_ai_provider.dart';
import '../../../core/utilities/functions/media_query_func.dart';
import '../../../core/utilities/functions/page_routes_func.dart';
import '../../layouts/global_state_widgets/button/button_progress/animation_progress.dart';
import '../../layouts/global_state_widgets/custom_scaffold/custom_scaffold.dart';
import '../../layouts/global_state_widgets/divider/custom_divider.dart';
import '../../layouts/styleconfig/textstyle.dart';
import '../../layouts/styleconfig/themecolors.dart';
import 'adaptive_video_players.dart';
import 'charts_screen.dart';
import 'document_scanner_screen.dart';
import 'face_detector_screen.dart';
import 'firebase_ai_main_screen.dart';
import 'hardware_screen.dart';
import 'input_form_screen.dart';
import 'maps_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppearanceSettingProvider>(
      builder: (context, provider, child) {
        if (provider.isTabletMode.condition){
          if (getMediaQueryWidth(context) > provider.tabletModePixel.value) return _setTabletLayout(context);
          if (getMediaQueryWidth(context) < provider.tabletModePixel.value) return _setPhoneLayout(context);
        }
        return _setPhoneLayout(context);
      }
    );
  }

  Widget _setPhoneLayout(BuildContext context){
    return CustomScaffold(
      canPop: false,
      useSafeArea: true,
      padding: EdgeInsets.all(paddingMid),
      body: _bodyWidget(context)
    );
  }

  Widget _setTabletLayout(BuildContext context){
    return CustomScaffold(
      canPop: false,
      useSafeArea: true,
      padding: EdgeInsets.all(paddingMid),
      body: _bodyWidget(context)
    );
  }

  Widget _bodyWidget(BuildContext context){
    return ListView(
      children: [
        cText(context, 'Beranda', style: TextStyles.giant(context).copyWith(fontWeight: FontWeight.bold)),
        ColumnDivider(),
        _button(context: context, label: 'Chatbot AI', icon: Icon(Icons.chat, size: iconBtnSmall, color: ThemeColors.purpleVeryHighContrast(context)),
          onTap: () async {
            FirebaseAIProvider.read(context).init(context);
            startScreenSwipe(context, FirebaseAIMainScreen());
          }),
        ColumnDivider(),
        _button(context: context, label: 'Face Detector', icon: Icon(Icons.face_retouching_natural_rounded, size: iconBtnSmall, color: ThemeColors.purple(context)),
            onTap: () async => startScreenSwipe(context, FaceDetectorScreen())),
        ColumnDivider(),
        _button(context: context, label: 'Document Scanner', icon: Icon(Icons.document_scanner, size: iconBtnSmall, color: ThemeColors.yellowVeryHighContrast(context)),
            onTap: () async => startScreenSwipe(context, DocumentScannerScreen())),
        ColumnDivider(),
        _button(context: context, label: 'QR-Code', icon: Icon(Icons.qr_code_scanner_rounded, size: iconBtnSmall, color: ThemeColors.surface(context)),
            onTap: () async => startScreenSwipe(context, QRCodeScreen())),
        ColumnDivider(),
        _button(context: context, label: 'Google Maps', icon: Icon(Icons.location_pin, size: iconBtnSmall, color: ThemeColors.redHighContrast(context)),
            onTap: () async => startScreenSwipe(context, MapsScreen())),
        ColumnDivider(),
        _button(context: context, label: 'Hardware Features', icon: Icon(Icons.settings_applications, size: iconBtnSmall, color: ThemeColors.yellowLowContrast(context)),
            onTap: () async => startScreenSwipe(context, HardwareScreen())),
        ColumnDivider(),
        _button(context: context, label: 'Charts', icon: Icon(Icons.pie_chart_sharp, size: iconBtnSmall, color: ThemeColors.blue(context)),
            onTap: () async => startScreenSwipe(context, ChartsScreen())),
        ColumnDivider(),
        _button(context: context, label: 'Input Form', icon: Icon(Icons.input, size: iconBtnSmall, color: ThemeColors.pink(context)),
            onTap: () async => startScreenSwipe(context, InputFormScreen())),
        ColumnDivider(),
        _button(context: context, label: 'Chewie Player', icon: Icon(Icons.video_camera_back_outlined, size: iconBtnSmall, color: ThemeColors.orangeLowContrast(context)),
            onTap: () async => startScreenSwipe(context, AdaptiveVideoPlayers())),
        ColumnDivider(),
        _button(context: context, label: 'WebView', icon: Icon(Icons.web, size: iconBtnSmall, color: ThemeColors.green(context)),
            onTap: () async => startScreenSwipe(context, WebViewScreen())),
        ColumnDivider(),
        _button(context: context, label: 'Counter', icon: Icon(Icons.countertops, size: iconBtnSmall, color: ThemeColors.green(context)),
            onTap: () async => startScreenSwipe(context, CounterScreen())),
        ColumnDivider(),
        _button(context: context, label: 'Error Page', icon: Icon(Icons.error, size: iconBtnSmall, color: ThemeColors.redVeryLowContrast(context)),
            onTap: () async => startScreenSwipe(context, MakeErrorPage())),
      ],
    );
  }

  Widget _button({required BuildContext context, required String label, required Icon icon, required VoidCallback onTap}){
    return AnimateProgressButton(
        labelButton: label,
        labelButtonStyle: TextStyles.semiLarge(context).copyWith(color: ThemeColors.surface(context)),
        containerColor: Colors.transparent,
        icon: icon,
        useArrow: true,
        onTap: onTap
    );
  }
}

class MakeErrorPage extends StatelessWidget {
  const MakeErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      decoration: BoxDecoration(
        color: Colors.green
      ),
    );
  }
}

