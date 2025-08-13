import 'package:boilerplate_3_firebaseconnect/ui/layouts/global_return_widgets/media_widgets_func.dart';
import 'package:boilerplate_3_firebaseconnect/ui/layouts/global_state_widgets/divider/custom_divider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constant_values/_constant_text_values.dart';
import '../../../core/constant_values/global_values.dart';
import '../../../core/state_management/providers/_settings/appearance_provider.dart';
import '../../../core/utilities/functions/logger_func.dart';
import '../../../core/utilities/functions/media_query_func.dart';
import '../../../core/utilities/functions/webview_func.dart';
import '../../layouts/global_state_widgets/button/button_progress/animation_progress.dart';
import '../../layouts/global_state_widgets/custom_scaffold/custom_appbar.dart';
import '../../layouts/global_state_widgets/custom_scaffold/custom_scaffold.dart';
import '../../layouts/styleconfig/textstyle.dart';
import '../../layouts/styleconfig/themecolors.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

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
        useSafeArea: true,
        padding: EdgeInsets.all(paddingMid),
        appBar: appBarWidget(context: context, title: 'Tentang Aplikasi', showBackButton: true),
        body: _bodyWidget(context)
    );
  }

  Widget _setTabletLayout(BuildContext context){
    return CustomScaffold(
        useSafeArea: true,
        padding: EdgeInsets.all(paddingMid),
        appBar: appBarWidget(context: context, title: 'Tentang Aplikas', showBackButton: true),
        body: _bodyWidget(context)
    );
  }

  Widget _bodyWidget(BuildContext context){
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: paddingVeryFar),
          child: Column(
            children: [
              loadDefaultAppLogoPNG(sizeLogo: iconBtnBig * 2),
              ColumnDivider(space: spaceFar),
              cText(context, appNameText, align: TextAlign.center, style: TextStyles.giant(context)),
              ColumnDivider(space: spaceFar),
              cText(context, '$appNameText adalah aplikasi yang dikembangkan oleh $appCopyrightText pada tanggal 11 Januari 2025. '
                'Aplikasi ini dikembangkan untuk memudahkan pada developer dalam membangun aplikasi dengan cepat, andal, dan efisien.'
                'Aplikasi ini dibuat menggunakan Framework Flutter 3 yang canggih', align: TextAlign.center),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.all(paddingMid),
          decoration: BoxDecoration(
            color: ThemeColors.greyVeryLowContrast(context),
            borderRadius: BorderRadius.circular(radiusSquare)
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              cText(context, 'Pengembang', align: TextAlign.start, style: TextStyles.semiLarge(context).copyWith(fontWeight: FontWeight.bold)),
              Align(alignment: Alignment.centerRight, child: cText(context, appCopyrightText, align: TextAlign.end)),
              ColumnDivider(space: spaceNear),
              cText(context, 'Versi Aplikasi', align: TextAlign.start, style: TextStyles.semiLarge(context).copyWith(fontWeight: FontWeight.bold)),
              Align(alignment: Alignment.centerRight, child: cText(context, appVersionText, align: TextAlign.end)),
              ColumnDivider(space: spaceNear),
              cText(context, 'Minimal Versi Perangkat', align: TextAlign.start, style: TextStyles.semiLarge(context).copyWith(fontWeight: FontWeight.bold)),
              Align(alignment: Alignment.centerRight, child: cText(context, 'Android 6 (Marshmallow)', align: TextAlign.end)),
            ],
          ),
        ),
        ColumnDivider(space: spaceFar),
        _button(context: context, label: 'Cek Pembaharuan', icon: Icon(Icons.settings, size: iconBtnSmall, color: ThemeColors.grey(context)),
            color: ThemeColors.blueVeryLowContrast(context), onTap: () async => clog('Cek Pembaharuan')),
        ColumnDivider(space: spaceNear),
        _button(context: context, label: 'Bagikan Aplikasi', icon: Icon(Icons.share, size: iconBtnSmall, color: ThemeColors.grey(context)),
            color: ThemeColors.tealVeryLowContrast(context), onTap: () async => await launchURL('https://play.google.com/store/apps/details?id=com.serkolinas.ceklist.tb_project')),
      ],
    );
  }

  Widget _button({required BuildContext context, required String label, required Icon icon, required Color color, required VoidCallback onTap, Function(bool)? onHover}){
    return AnimateProgressButton(
        labelButton: label,
        labelButtonStyle: TextStyles.semiLarge(context).copyWith(color: ThemeColors.surface(context)),
        containerColor: color,
        icon: icon,
        useArrow: true,
        onHover: onHover,
        onTap: onTap
    );
  }
}
