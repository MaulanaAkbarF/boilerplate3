import 'package:boilerplate_3_firebaseconnect/ui/layouts/global_return_widgets/media_widgets_func.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constant_values/_constant_text_values.dart';
import '../../../core/constant_values/assets_values.dart';
import '../../../core/constant_values/global_values.dart';
import '../../../core/state_management/providers/_settings/appearance_provider.dart';
import '../../../core/utilities/functions/media_query_func.dart';
import '../../../core/utilities/functions/page_routes_func.dart';
import '../../../core/utilities/functions/webview_func.dart';
import '../../layouts/global_state_widgets/button/button_progress/animation_progress.dart';
import '../../layouts/global_state_widgets/custom_scaffold/custom_appbar.dart';
import '../../layouts/global_state_widgets/custom_scaffold/custom_scaffold.dart';
import '../../layouts/global_state_widgets/custom_text/custom_line_text.dart';
import '../../layouts/global_state_widgets/divider/custom_divider.dart';
import '../../layouts/styleconfig/textstyle.dart';
import '../../layouts/styleconfig/themecolors.dart';
import '../../page_setting/_main_setting_screen.dart';

class CallUsScreen extends StatelessWidget {
  const CallUsScreen({super.key});

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
      appBar: appBarWidget(context: context, title: 'Hubungi Kami', showBackButton: true),
      body: _bodyWidget(context)
    );
  }

  Widget _setTabletLayout(BuildContext context){
    return CustomScaffold(
      useSafeArea: true,
      padding: EdgeInsets.all(paddingMid),
      appBar: appBarWidget(context: context, title: 'Hubungi Kami', showBackButton: true),
      body: _bodyWidget(context)
    );
  }

  Widget _bodyWidget(BuildContext context){
    return ListView(
      children: [
        cText(context, 'Jika Anda memiliki pertanyaan atau masalah ketika menggunakan aplikasi, jangan sungkan untuk menghubungi kami!\n'
          'Kami dengan senang hati melayani Anda untuk memberikan pengalaman terbaik dalam menggunakan aplikasi $appNameText!'),
        ColumnDivider(space: spaceNear),
        ColumnDivider(space: spaceNear),
        _button(context: context, label: 'WhatsApp', image: loadImageAssetPNG(path: iconWhatsAppPNG, width: iconBtnBig, height: iconBtnBig),
            onTap: () async => await launchURL("https://api.whatsapp.com/send?phone=6289504990855&text=${Uri.encodeComponent('Halo, saya ingin bertanya')}")),
        LineText(text: 'atau hubungi melalui'),
        ColumnDivider(space: spaceNear),
        _button(context: context, label: '  G-Mail   ', image: loadImageAssetPNG(path: iconGmailPNG, width: iconBtnBig, height: iconBtnBig),
          onTap: () async => await sendEmail(
            toEmail: 'variousra@email.com',
            subject: 'Meeting Reminder',
            body: 'Jangan lupa meeting hari ini jam 14:00',
            ccEmails: ['altixspherd@email.com', 'mavindv1@email.com'],
            bccEmails: ['mavindv1@email.com'],
          )),
        ColumnDivider(space: spaceNear),
        _button(context: context, label: 'Instagram', image: loadImageAssetPNG(path: iconInstagramPNG, width: iconBtnBig, height: iconBtnBig),
            onTap: () async => await launchURL("https://www.instagram.com/listriksentral_idn?utm_source=ig_web_button_share_sheet&igsh=ZDNlZDc0MzIxNw==")),
        ColumnDivider(space: spaceNear),
        _button(context: context, label: 'Facebook', image: loadImageAssetPNG(path: iconFacebookPNG, width: iconBtnBig, height: iconBtnBig),
            onTap: () async => await startScreenSwipe(context, MainSettingScreen())),
      ],
    );
  }

  Widget _button({required BuildContext context, required String label, Icon? icon, Image? image, required VoidCallback onTap, Function(bool)? onHover}){
    return AnimateProgressButton(
        labelButton: label,
        labelButtonStyle: TextStyles.semiGiant(context).copyWith(color: ThemeColors.surface(context)),
        containerColor: ThemeColors.greyVeryLowContrast(context),
        height: heightTowering,
        icon: icon,
        image: image,
        onHover: onHover,
        onTap: onTap
    );
  }
}
