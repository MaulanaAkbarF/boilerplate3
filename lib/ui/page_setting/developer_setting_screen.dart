import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constant_values/global_values.dart';
import '../../../core/state_management/providers/_settings/appearance_provider.dart';
import '../../../core/utilities/functions/media_query_func.dart';
import '../../core/constant_values/_constant_text_values.dart';
import '../../core/state_management/providers/_settings/dev_mode_provider.dart';
import '../layouts/global_state_widgets/button/button_progress/animation_progress.dart';
import '../layouts/global_state_widgets/custom_scaffold/custom_appbar.dart';
import '../layouts/global_state_widgets/custom_scaffold/custom_scaffold.dart';
import '../layouts/global_state_widgets/divider/custom_divider.dart';
import '../layouts/global_state_widgets/textfield/textfield_form/animate_form.dart';
import '../layouts/styleconfig/textstyle.dart';
import '../layouts/styleconfig/themecolors.dart';

class DevSettingScreen extends StatelessWidget {
  const DevSettingScreen({super.key});

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
      appBar: appBarWidget(context: context, title: 'Pengaturan Dev', showBackButton: true),
      body: _bodyWidget(context)
    );
  }

  Widget _setTabletLayout(BuildContext context){
    return CustomScaffold(
      useSafeArea: true,
      appBar: appBarWidget(context: context, title: 'Pengaturan Dev', showBackButton: true),
      body: _bodyWidget(context)
    );
  }

  Widget _bodyWidget(BuildContext context){
    return Consumer<DevModeProvider>(
      builder: (context, provider, child) {
      return ListView(
        shrinkWrap: true,
        children: [
          cText(context, 'Endpoint Aktif', style: TextStyles.semiGiant(context).copyWith(fontWeight: FontWeight.w300)),
          ColumnDivider(),
          AnimateTextField(
            labelText: 'Endpoint Aktif Saat Ini',
            controller: provider.tecActiveEndpoint,
            shadowColor: ThemeColors.surface(context),
            borderAnimationColor: ThemeColors.blueHighContrast(context),
          ),
          ColumnDivider(),
          SizedBox(
            height: 60,
            child: ListView(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              children: [
                !provider.isConfig ? AnimateProgressButton(
                  labelButton: 'Terapkan',
                  labelButtonStyle: TextStyles.medium(context).copyWith(color: ThemeColors.surface(context), fontWeight: FontWeight.bold),
                  labelProgress: loadingButtonText,
                  fitButton: true,
                  width: getMediaQueryWidth(context) - 80,
                  height: heightMid,
                  containerColor: ThemeColors.red(context),
                  containerRadius: radiusSquare,
                  onTap: () async {
                    DevModeProvider.read(context).setNewEndpoint();
                  },
                ) : const SizedBox(),
                RowDivider(),
                if (!provider.isConfig) IconButton(icon: Icon(Icons.settings, size: iconBtnMid),
                  color: ThemeColors.surface(context), onPressed: () => DevModeProvider.read(context).toggleConfig()),
                if (provider.isConfig) TextButton(
                  child: Row(
                    children: [
                      Icon(Icons.arrow_back, size: iconBtnSmall, color: ThemeColors.green(context)),
                      RowDivider(),
                      cText(context, 'Selesai', style: TextStyles.medium(context).copyWith(fontWeight: FontWeight.bold)),
                  ]
                ), onPressed: () => DevModeProvider.read(context).toggleConfig()),
                if (provider.isConfig) TextButton(
                  child: Row(
                    children: [
                      Icon(Icons.lock_reset_outlined, size: iconBtnSmall, color: ThemeColors.blue(context)),
                      RowDivider(),
                      cText(context, 'Atur Ulang ke Main', style: TextStyles.medium(context).copyWith(fontWeight: FontWeight.bold)),
                    ]
                ), onPressed: () => DevModeProvider.read(context).restoreMainEndpoint()),
                if (provider.isConfig) TextButton(
                  child: Row(
                    children: [
                      Icon(Icons.lock_reset_outlined, size: iconBtnSmall, color: ThemeColors.red(context)),
                      RowDivider(),
                      cText(context, 'Atur Ulang ke Dev', style: TextStyles.medium(context).copyWith(fontWeight: FontWeight.bold)),
                    ]
                  ), onPressed: () => DevModeProvider.read(context).restoreDevEndpoint()),
                if (provider.isConfig) TextButton(
                  child: Row(
                    children: [
                      Icon(Icons.developer_mode, size: iconBtnSmall, color: ThemeColors.purple(context)),
                      RowDivider(),
                      cText(context, 'Ubah Endpoint Lain', style: TextStyles.medium(context).copyWith(fontWeight: FontWeight.bold)),
                    ]
                  ), onPressed: () => DevModeProvider.read(context).restoreMainEndpoint()),
              ],
            ),
          )
        ]);
      },
    );
  }
}
