import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constant_values/_setting_value/appearance_values.dart';
import '../../core/constant_values/assets_values.dart';
import '../../core/constant_values/global_values.dart';
import '../../core/state_management/providers/_settings/appearance_provider.dart';
import '../../core/utilities/functions/media_query_func.dart';
import '../layouts/global_return_widgets/media_widgets_func.dart';
import '../layouts/global_state_widgets/button/button_settings/regular_button.dart';
import '../layouts/global_state_widgets/custom_background/container_background.dart';
import '../layouts/global_state_widgets/custom_page_animation/pa_zoom_out.dart';
import '../layouts/global_state_widgets/custom_scaffold/custom_appbar.dart';
import '../layouts/global_state_widgets/custom_scaffold/custom_scaffold.dart';
import '../layouts/global_state_widgets/divider/custom_divider.dart';
import '../layouts/styleconfig/textstyle.dart';
import '../layouts/styleconfig/themecolors.dart';

class AppearanceSettingScreen extends StatelessWidget {
  const AppearanceSettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppearanceSettingProvider>(
      builder: (context, provider, child) {
        if (kIsWeb) {
          if (getMediaQueryWidth(context) < minWebLayoutWidth) return _setPhoneLayout(context);
          return _setWebLayout(context);
        }
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
      appBar: appBarWidget(context: context, title: 'Tampilan', showBackButton: true),
      body: _bodyWidget(context)
    );
  }

  Widget _setTabletLayout(BuildContext context){
    return CustomScaffold(
      useSafeArea: true,
      appBar: appBarWidget(context: context, title: 'Tampilan', showBackButton: true),
      body: _bodyWidget(context)
    );
  }

  Widget _setWebLayout(BuildContext context){
    return CustomScaffold(
        useSafeArea: true,
        appBar: appBarWebWidget(context: context, title: 'Tampilan'),
        body: _bodyWebWidget(context)
    );
  }

  Widget _bodyWidget(BuildContext context){
    return ListView(
      shrinkWrap: true,
      children: [
        cText(context, 'Font', style: TextStyles.semiGiant(context).copyWith(fontWeight: FontWeight.w300)),
        SettingMenuDropdown(
          labelButton: 'Jenis Font',
          containerColor: ThemeColors.greyVeryLowContrast(context),
          value: AppearanceSettingProvider.watch(context).fontType,
          items: ListFontType.values.map((e) => e.text).toList(),
          onChanged: (String? newValue) => newValue != null ? AppearanceSettingProvider.read(context).setFontType(newValue, notify: true) : {},
        ),
        ColumnDivider(),
        SettingMenuDropdown(
          labelButton: 'Ukuran Font',
          containerColor: ThemeColors.greyVeryLowContrast(context),
          value: AppearanceSettingProvider.watch(context).fontSizeString.text,
          items: ListFontSize.values.map((e) => e.text).toList(),
          onChanged: (String? newValue) => newValue != null ? AppearanceSettingProvider.read(context).setFontSize(newValue, notify: true) : {},
        ),
        ColumnDivider(space: spaceFar),
        cText(context, 'Tema Aplikasi', style: TextStyles.semiGiant(context).copyWith(fontWeight: FontWeight.w300)),
        _themeButton(context: context, label: ListThemeApp.light.text, desc: ListThemeApp.light.desc,
            imagePath: imgLightMode, onTap: () => AppearanceSettingProvider.read(context).setThemeType(ListThemeApp.light.text, notify: true)),
        _themeButton(context: context, label: ListThemeApp.dark.text, desc: ListThemeApp.dark.desc,
            imagePath: imgDarkMode, onTap: () => AppearanceSettingProvider.read(context).setThemeType(ListThemeApp.dark.text, notify: true)),
        _themeButton(context: context, label: ListThemeApp.system.text, desc: ListThemeApp.system.desc,
            imagePath: imgDarkMode, onTap: () => AppearanceSettingProvider.read(context).setThemeType(ListThemeApp.system.text, notify: true)),
        _themeButton(context: context, label: ListThemeApp.black.text, desc: ListThemeApp.black.desc,
            imagePath: imgBlackMode, onTap: () => AppearanceSettingProvider.read(context).setThemeType(ListThemeApp.black.text, notify: true)),
        ColumnDivider(space: spaceFar),
        cText(context, 'Tampilan Sisi dan Luas', style: TextStyles.semiGiant(context).copyWith(fontWeight: FontWeight.w300)),
        SettingMenuDropdown(
          labelButton: 'Orientasi Vertikal',
          containerColor: ThemeColors.greyVeryLowContrast(context),
          useSwitch: true,
          valueSwitch: AppearanceSettingProvider.watch(context).preferredOrientation.condition,
          onChangedSwitch: (bool? newValue) => newValue != null ? AppearanceSettingProvider.read(context).setPreferredOrientation(newValue, notify: true) : {},
        ),
        ColumnDivider(),
        SettingMenuDropdown(
          labelButton: 'Aktifkan Notch',
          containerColor: ThemeColors.greyVeryLowContrast(context),
          useSwitch: true,
          valueSwitch: AppearanceSettingProvider.watch(context).isSafeArea.condition,
          onChangedSwitch: (bool? newValue) => newValue != null ? AppearanceSettingProvider.read(context).setIsSafeArea(newValue, notify: true) : {},
        ),
        ColumnDivider(),
        SettingMenuDropdown(
          labelButton: 'Aktifkan Mode Tablet',
          containerColor: ThemeColors.greyVeryLowContrast(context),
          useSwitch: true,
          valueSwitch: AppearanceSettingProvider.watch(context).isTabletMode.condition,
          onChangedSwitch: (bool? newValue) => newValue != null ? AppearanceSettingProvider.read(context).setIsTabletMode(newValue, notify: true) : {},
        ),
        ColumnDivider(),
        SettingMenuDropdown(
          labelButton: 'Berubah ke Mode Tablet',
          containerColor: ThemeColors.greyVeryLowContrast(context),
          value: AppearanceSettingProvider.watch(context).tabletModePixel.text,
          items: ListChangeToTabletMode.values.map((e) => e.text).toList(),
          onChanged: (String? newValue) => newValue != null ? AppearanceSettingProvider.read(context).setTabletModePixel(newValue, notify: true) : {},
        ),
        ColumnDivider(),
      ],
    );
  }

  Widget _bodyWebWidget(BuildContext context){
    String title = 'Tampilan';
    String description = 'Edit dan sesuaikan tampilan aplikasi Anda!\nAtur Font, Ukuran Font, Tema, dan ukuran sisi';

    return ListView(
      shrinkWrap: true,
      children: [
        ColumnDivider(),
        StatefulBuilder(
          builder: (context, setState) {
            void setEmpty() => setState((){title = 'Tampilan'; description = 'Edit dan sesuaikan tampilan aplikasi Anda!\nAtur Font, Ukuran Font, Tema, dan ukuran sisi';});
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomContainer(
                  isExpanded: true,
                  containerColor: ThemeColors.greyVeryLowContrast(context),
                  padding: EdgeInsets.all(paddingMid),
                  child: PageAnimationSwipeZoomOut(
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        cText(context, 'Font', style: TextStyles.semiGiant(context).copyWith(fontWeight: FontWeight.w300)),
                        SettingMenuDropdown(
                          labelButton: 'Jenis Font',
                          containerColor: ThemeColors.greyVeryLowContrast(context),
                          value: AppearanceSettingProvider.watch(context).fontType,
                          items: ListFontType.values.map((e) => e.text).toList(),
                          onChanged: (String? newValue) => newValue != null ? AppearanceSettingProvider.read(context).setFontType(newValue, notify: true) : {},
                          onHover: (value) => setState((){title = 'Jenis Font'; description = 'Ubah jenis font atau teks aplikasi sesuai dengan keinginan Anda';}),
                          onExit: (value) => setEmpty(),
                        ),
                        SettingMenuDropdown(
                          labelButton: 'Ukuran Font',
                          containerColor: ThemeColors.greyVeryLowContrast(context),
                          value: AppearanceSettingProvider.watch(context).fontSizeString.text,
                          items: ListFontSize.values.map((e) => e.text).toList(),
                          onChanged: (String? newValue) => newValue != null ? AppearanceSettingProvider.read(context).setFontSize(newValue, notify: true) : {},
                          onHover: (value) => setState((){title = 'Ukuran Font'; description = 'Ubah ukuran font atau teks aplikasi sesuai dengan kenyamanan Anda';}),
                          onExit: (value) => setEmpty(),
                        ),
                        ColumnDivider(space: spaceFar),
                        cText(context, 'Tema Aplikasi', style: TextStyles.semiGiant(context).copyWith(fontWeight: FontWeight.w300)),
                        _themeButton(context: context, label: ListThemeApp.light.text, desc: ListThemeApp.light.desc,
                            imagePath: imgLightMode, onTap: () => AppearanceSettingProvider.read(context).setThemeType(ListThemeApp.light.text, notify: true)),
                        _themeButton(context: context, label: ListThemeApp.dark.text, desc: ListThemeApp.dark.desc,
                            imagePath: imgDarkMode, onTap: () => AppearanceSettingProvider.read(context).setThemeType(ListThemeApp.dark.text, notify: true)),
                        _themeButton(context: context, label: ListThemeApp.system.text, desc: ListThemeApp.system.desc,
                            imagePath: imgDarkMode, onTap: () => AppearanceSettingProvider.read(context).setThemeType(ListThemeApp.system.text, notify: true)),
                        _themeButton(context: context, label: ListThemeApp.black.text, desc: ListThemeApp.black.desc,
                            imagePath: imgBlackMode, onTap: () => AppearanceSettingProvider.read(context).setThemeType(ListThemeApp.black.text, notify: true)),
                        ColumnDivider(space: spaceFar),
                        cText(context, 'Tampilan Sisi dan Luas', style: TextStyles.semiGiant(context).copyWith(fontWeight: FontWeight.w300)),
                        SettingMenuDropdown(
                          labelButton: 'Orientasi Vertikal',
                          containerColor: ThemeColors.greyVeryLowContrast(context),
                          useSwitch: true,
                          valueSwitch: AppearanceSettingProvider.watch(context).preferredOrientation.condition,
                          onChangedSwitch: (bool? newValue) => newValue != null ? AppearanceSettingProvider.read(context).setPreferredOrientation(newValue, notify: true) : {},
                          onHover: (value) => setState((){title = 'Orientasi Vertikal'; description = 'Pilih apakah aplikasi Anda tetap pada tampilan vertikal atau dapat diputar pada orientasi Anda saat ini';}),
                          onExit: (value) => setEmpty(),
                        ),
                      ],
                    ),
                  ),
                ),
                RowDivider(),
                CustomContainer(
                  isExpanded: true,
                  padding: EdgeInsets.all(paddingVeryFar),
                  containerColor: ThemeColors.greyVeryLowContrast(context),
                  child: Column(
                    children: [
                      cText(context, title, align: TextAlign.center, style: TextStyles.giant(context).copyWith(fontWeight: FontWeight.bold)),
                      ColumnDivider(),
                      cText(context, description, align: TextAlign.center, style: TextStyles.large(context)),
                    ],
                  ),
                ),
              ],
            );
          }
        ),
      ],
    );
  }

  Widget _themeButton({required BuildContext context, required String label, required String desc, required String imagePath, required VoidCallback onTap}){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: paddingNear),
      child: GestureDetector(
        onTap: () => onTap(),
        child: SizedBox(
          height: AppearanceSettingProvider.read(context).fontSizeString.value * 6,
          child: Stack(
            children: [
              ClipRRect(borderRadius: BorderRadius.circular(radiusSquare),
                child: Opacity(opacity: .9, child: loadImageAssetPNG(path: imagePath, width: getMediaQueryWidth(context),
                  height: AppearanceSettingProvider.read(context).fontSizeString.value * 6))),
              Padding(
                padding: const EdgeInsets.all(paddingMid),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        cText(context, label, maxLines: 1, style: TextStyles.semiGiant(context).copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                        RowDivider(),
                        if (AppearanceSettingProvider.read(context).themeType.text == label) Icon(Icons.star, size: iconBtnSmall, color: ThemeColors.yellow(context))
                      ],
                    ),
                    cText(context, desc, maxLines: 2, style: TextStyles.medium(context).copyWith(color: Colors.white)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
