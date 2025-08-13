import 'package:boilerplate_3_firebaseconnect/ui/page_main/profile/privacy_policy_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constant_values/_constant_text_values.dart';
import '../../../core/constant_values/global_values.dart';
import '../../../core/state_management/providers/_global_widget/main_navbar_provider.dart';
import '../../../core/state_management/providers/_settings/appearance_provider.dart';
import '../../../core/state_management/providers/auth/user_provider.dart';
import '../../../core/utilities/functions/media_query_func.dart';
import '../../../core/utilities/functions/page_routes_func.dart';
import '../../layouts/global_return_widgets/media_widgets_func.dart';
import '../../layouts/global_state_widgets/button/button_progress/animation_progress.dart';
import '../../layouts/global_state_widgets/custom_scaffold/custom_scaffold.dart';
import '../../layouts/global_state_widgets/dialog/dialog_button/dialog_two_button.dart';
import '../../layouts/global_state_widgets/divider/custom_divider.dart';
import '../../layouts/styleconfig/textstyle.dart';
import '../../layouts/styleconfig/themecolors.dart';
import '../../page_auth/login_screen.dart';
import '../../page_setting/_main_setting_screen.dart';
import 'about_app_screen.dart';
import 'call_us_screen.dart';
import 'detail_profile_screen.dart';
import 'faq_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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
        cText(context, 'Profil', style: TextStyles.giant(context).copyWith(fontWeight: FontWeight.bold)),
        ColumnDivider(space: spaceMid),
        Row(
          children: [
            loadCircleImage(context: context),
            RowDivider(space: spaceMid),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  cText(context, UserProvider.read(context).user?.name ?? 'Guest'),
                  cText(context, UserProvider.read(context).user?.email ?? 'guest@mail.com'),
                ],
              ),
            ),
          ],
        ),
        ColumnDivider(space: spaceFar),
        _button(context: context, label: 'Edit Informasi Akun', icon: Icon(Icons.manage_accounts, size: iconBtnSmall, color: ThemeColors.green(context)),
            onTap: () async => await startScreenSwipe(context, DetailProfileScreen())),
        ColumnDivider(space: spaceNear),
        _button(context: context, label: 'FAQ', icon: Icon(Icons.question_answer, size: iconBtnSmall, color: ThemeColors.surface(context)),
            onTap: () async => await startScreenSwipe(context, FaqScreen())),
        ColumnDivider(space: spaceNear),
        _button(context: context, label: 'Kebijakan Pengguna', icon: Icon(Icons.info, size: iconBtnSmall, color: ThemeColors.yellow(context)),
            onTap: () async => await startScreenSwipe(context, PrivacyPolicyScreen())),
        ColumnDivider(space: spaceNear),
        _button(context: context, label: 'Hubungi Kami', icon: Icon(Icons.call, size: iconBtnSmall, color: ThemeColors.teal(context)),
            onTap: () async => await startScreenSwipe(context, CallUsScreen())),
        ColumnDivider(space: spaceNear),
        _button(context: context, label: 'Tentang Aplikasi', icon: Icon(Icons.device_unknown, size: iconBtnSmall, color: ThemeColors.cyan(context)),
            onTap: () async => await startScreenSwipe(context, AboutAppScreen())),
        ColumnDivider(space: spaceNear),
        _button(context: context, label: 'Pengaturan', icon: Icon(Icons.settings, size: iconBtnSmall, color: ThemeColors.grey(context)),
            onTap: () async => await startScreenSwipe(context, MainSettingScreen())),
        ColumnDivider(space: spaceFar),
        AnimateProgressButton(
            labelButton: 'Keluar',
            labelButtonStyle: TextStyles.semiLarge(context).copyWith(color: ThemeColors.redHighContrast(context)),
            containerColor: ThemeColors.maroonVeryLowContrast(context),
            icon: Icon(Icons.logout, size: iconBtnSmall, color: ThemeColors.redHighContrast(context)),
            useArrow: false,
            onTap: () => showDialog(context: context, builder: (context) => DialogTwoButton(
                header: 'Logout', description: '\nAnda yakin ingin keluar dari sesi Anda saat ini?\n', acceptedOnTap: () async {
              await UserProvider.read(context).logout(context);
              MainNavbarProvider.read(context).changePageIndex(0);
              startScreenRemoveAll(context, LoginScreen());
            }))
        ),
        ColumnDivider(space: spaceNear),
        cText(context, appVersionText, align: TextAlign.center, style: TextStyles.verySmall(context))
      ],
    );
  }

  Widget _button({required BuildContext context, required String label, required Icon icon, required VoidCallback onTap, Function(bool)? onHover}){
    return AnimateProgressButton(
        labelButton: label,
        labelButtonStyle: TextStyles.semiLarge(context).copyWith(color: ThemeColors.surface(context)),
        containerColor: ThemeColors.greyVeryLowContrast(context),
        icon: icon,
        useArrow: true,
        onHover: onHover,
        onTap: onTap
    );
  }
}
