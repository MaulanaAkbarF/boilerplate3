import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constant_values/_setting_value/preferences_values.dart';
import '../../core/constant_values/global_values.dart';
import '../../core/state_management/providers/_settings/appearance_provider.dart';
import '../../core/state_management/providers/_settings/preference_provider.dart';
import '../../core/utilities/functions/media_query_func.dart';
import '../layouts/global_state_widgets/button/button_settings/regular_button.dart';
import '../layouts/global_state_widgets/custom_background/container_background.dart';
import '../layouts/global_state_widgets/custom_page_animation/pa_zoom_out.dart';
import '../layouts/global_state_widgets/custom_scaffold/custom_appbar.dart';
import '../layouts/global_state_widgets/custom_scaffold/custom_scaffold.dart';
import '../layouts/global_state_widgets/divider/custom_divider.dart';
import '../layouts/styleconfig/textstyle.dart';
import '../layouts/styleconfig/themecolors.dart';

class PreferenceSettingScreen extends StatelessWidget {
  const PreferenceSettingScreen({super.key});

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
        appBar: appBarWidget(context: context, title: 'Preferensi', showBackButton: true),
        body: _bodyWidget(context)
    );
  }

  Widget _setTabletLayout(BuildContext context){
    return CustomScaffold(
        useSafeArea: true,
        appBar: appBarWidget(context: context, title: 'Preferensi', showBackButton: true),
        body: _bodyWidget(context)
    );
  }

  Widget _setWebLayout(BuildContext context){
    return CustomScaffold(
        useSafeArea: true,
        appBar: appBarWebWidget(context: context, title: 'Preferensi'),
        body: _bodyWebWidget(context)
    );
  }

  Widget _bodyWidget(BuildContext context){
    return ListView(
      shrinkWrap: true,
      children: [
        cText(context, 'Bahasa', style: TextStyles.semiGiant(context).copyWith(fontWeight: FontWeight.w300)),
        SettingMenuDropdown(
          labelButton: 'Bahasa Sistem',
          containerColor: ThemeColors.greyVeryLowContrast(context),
          value: PreferenceSettingProvider.watch(context).language.text,
          items: ListLanguage.values.map((e) => e.text).toList(),
          onChanged: (String? newValue) => newValue != null ? PreferenceSettingProvider.read(context).setLanguage(newValue) : {},
        ),
        ColumnDivider(space: spaceFar),
        cText(context, 'Waktu dan Tanggal', style: TextStyles.semiGiant(context).copyWith(fontWeight: FontWeight.w300)),
        SettingMenuDropdown(
          labelButton: 'Zona Waktu',
          containerColor: ThemeColors.greyVeryLowContrast(context),
          value: PreferenceSettingProvider.watch(context).timeZone.text,
          items: ListTimeZone.values.map((e) => e.text).toList(),
          onChanged: (String? newValue) => newValue != null ? PreferenceSettingProvider.read(context).setTimeZone(newValue) : {},
        ),
        ColumnDivider(),
        SettingMenuDropdown(
          labelButton: 'Format Tanggal',
          containerColor: ThemeColors.greyVeryLowContrast(context),
          value: PreferenceSettingProvider.watch(context).dateFormat.text,
          items: ListDateFormat.values.map((e) => e.text).toList(),
          onChanged: (String? newValue) => newValue != null ? PreferenceSettingProvider.read(context).setDateFormat(newValue) : {},
        ),
        ColumnDivider(),
        SettingMenuDropdown(
          labelButton: 'Format Waktu',
          containerColor: ThemeColors.greyVeryLowContrast(context),
          value: PreferenceSettingProvider.watch(context).timeFormat.text,
          items: ListTimeFormat.values.map((e) => e.text).toList(),
          onChanged: (String? newValue) => newValue != null ? PreferenceSettingProvider.read(context).setTimeFormat(newValue) : {},
        ),
        ColumnDivider(space: spaceFar),
        cText(context, 'Animasi', style: TextStyles.semiGiant(context).copyWith(fontWeight: FontWeight.w300)),
        SettingMenuDropdown(
          labelButton: 'Aktifkan Animasi',
          containerColor: ThemeColors.greyVeryLowContrast(context),
          useSwitch: true,
          valueSwitch: PreferenceSettingProvider.watch(context).useAnimation.condition,
          onChangedSwitch: (bool? newValue) => newValue != null ? PreferenceSettingProvider.read(context).setUseAnimation(newValue) : {},
        ),
        ColumnDivider(),
        Opacity(
          opacity: PreferenceSettingProvider.read(context).useAnimation.condition ? 1.0 : .3,
          child: SettingMenuDropdown(
            labelButton: 'Transisi Halaman',
            containerColor: ThemeColors.greyVeryLowContrast(context),
            useSwitch: true,
            valueSwitch: PreferenceSettingProvider.watch(context).pageTransition.condition,
            onChangedSwitch: (bool? newValue) => PreferenceSettingProvider.read(context).useAnimation.condition
              ? newValue != null ? PreferenceSettingProvider.read(context).setPageTransition(newValue) : {} : null,
          ),
        ),
        ColumnDivider(),
        Opacity(
          opacity: PreferenceSettingProvider.read(context).useAnimation.condition ? 1.0 : .3,
          child: SettingMenuDropdown(
            labelButton: 'Animasi Halaman',
            containerColor: ThemeColors.greyVeryLowContrast(context),
            useSwitch: true,
            valueSwitch: PreferenceSettingProvider.watch(context).pageAnimation.condition,
            onChangedSwitch: (bool? newValue) => PreferenceSettingProvider.read(context).useAnimation.condition
                ? newValue != null ? PreferenceSettingProvider.read(context).setPageAnimation(newValue) : {} : null,
          ),
        ),
        ColumnDivider(),
      ],
    );
  }

  Widget _bodyWebWidget(BuildContext context){
    String title = 'Preferensi';
    String description = 'Atur preferensi aplikasi seperti Bahasa, Waktu, Tanggal dan Animasi';

    return ListView(
      shrinkWrap: true,
      children: [
        ColumnDivider(),
        StatefulBuilder(
            builder: (context, setState) {
              void setEmpty() => setState((){title = 'Preferensi'; description = 'Atur preferensi aplikasi seperti Bahasa, Waktu, Tanggal dan Animasi';});
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
                          cText(context, 'Bahasa', style: TextStyles.semiGiant(context).copyWith(fontWeight: FontWeight.w300)),
                          SettingMenuDropdown(
                            labelButton: 'Bahasa Sistem',
                            containerColor: ThemeColors.greyVeryLowContrast(context),
                            value: PreferenceSettingProvider.watch(context).language.text,
                            items: ListLanguage.values.map((e) => e.text).toList(),
                            onChanged: (String? newValue) => newValue != null ? PreferenceSettingProvider.read(context).setLanguage(newValue) : {},
                            onHover: (value) => setState((){title = 'Bahasa Sistem'; description = 'Ubah bahasa aplikasi sesuai dengan negara pilihan Anda';}),
                            onExit: (value) => setEmpty(),
                          ),
                          ColumnDivider(space: spaceFar),
                          cText(context, 'Waktu dan Tanggal', style: TextStyles.semiGiant(context).copyWith(fontWeight: FontWeight.w300)),
                          SettingMenuDropdown(
                            labelButton: 'Zona Waktu',
                            containerColor: ThemeColors.greyVeryLowContrast(context),
                            value: PreferenceSettingProvider.watch(context).timeZone.text,
                            items: ListTimeZone.values.map((e) => e.text).toList(),
                            onChanged: (String? newValue) => newValue != null ? PreferenceSettingProvider.read(context).setTimeZone(newValue) : {},
                            onHover: (value) => setState((){title = 'Zona Waktu'; description = 'Ubah jam pada aplikasi sesuai dengan Zona Waktu Anda';}),
                            onExit: (value) => setEmpty(),
                          ),
                          SettingMenuDropdown(
                            labelButton: 'Format Tanggal',
                            containerColor: ThemeColors.greyVeryLowContrast(context),
                            value: PreferenceSettingProvider.watch(context).dateFormat.text,
                            items: ListDateFormat.values.map((e) => e.text).toList(),
                            onChanged: (String? newValue) => newValue != null ? PreferenceSettingProvider.read(context).setDateFormat(newValue) : {},
                            onHover: (value) => setState((){title = 'Format Tanggal'; description = 'Ubah format tanggal pada apliasi yang sesuai dengan preferensi Anda';}),
                            onExit: (value) => setEmpty(),
                          ),
                          SettingMenuDropdown(
                            labelButton: 'Format Waktu',
                            containerColor: ThemeColors.greyVeryLowContrast(context),
                            value: PreferenceSettingProvider.watch(context).timeFormat.text,
                            items: ListTimeFormat.values.map((e) => e.text).toList(),
                            onChanged: (String? newValue) => newValue != null ? PreferenceSettingProvider.read(context).setTimeFormat(newValue) : {},
                            onHover: (value) => setState((){title = 'Format Waktu'; description = 'Ubah format waktu aplikasi sesuai dengan preferensi Anda';}),
                            onExit: (value) => setEmpty(),
                          ),
                          ColumnDivider(space: spaceFar),
                          cText(context, 'Animasi', style: TextStyles.semiGiant(context).copyWith(fontWeight: FontWeight.w300)),
                          SettingMenuDropdown(
                            labelButton: 'Aktifkan Animasi',
                            containerColor: ThemeColors.greyVeryLowContrast(context),
                            useSwitch: true,
                            valueSwitch: PreferenceSettingProvider.watch(context).useAnimation.condition,
                            onChangedSwitch: (bool? newValue) => newValue != null ? PreferenceSettingProvider.read(context).setUseAnimation(newValue) : {},
                            onHover: (value) => setState((){title = 'Aktifkan Animasi'; description = 'Tampilan animasi pada aplikasi\nMatikan opsi ini untuk menonaktifkan semua animasi pada aplikasi untuk membantu meningkatkan performa aplikasi';}),
                            onExit: (value) => setEmpty(),
                          ),
                          Opacity(
                            opacity: PreferenceSettingProvider.read(context).useAnimation.condition ? 1.0 : .3,
                            child: SettingMenuDropdown(
                              labelButton: 'Transisi Halaman',
                              containerColor: ThemeColors.greyVeryLowContrast(context),
                              useSwitch: true,
                              valueSwitch: PreferenceSettingProvider.watch(context).pageTransition.condition,
                              onChangedSwitch: (bool? newValue) => PreferenceSettingProvider.read(context).useAnimation.condition
                                  ? newValue != null ? PreferenceSettingProvider.read(context).setPageTransition(newValue) : {} : null,
                              onHover: (value) => setState((){title = 'Transisi Halaman'; description = 'Tampilan animasi transisi atau perpindahan halaman\nAnda dapat menonaktifkannya untuk meningkatkan performa';}),
                              onExit: (value) => setEmpty(),
                            ),
                          ),
                          Opacity(
                            opacity: PreferenceSettingProvider.read(context).useAnimation.condition ? 1.0 : .3,
                            child: SettingMenuDropdown(
                              labelButton: 'Animasi Halaman',
                              containerColor: ThemeColors.greyVeryLowContrast(context),
                              useSwitch: true,
                              valueSwitch: PreferenceSettingProvider.watch(context).pageAnimation.condition,
                              onChangedSwitch: (bool? newValue) => PreferenceSettingProvider.read(context).useAnimation.condition
                                  ? newValue != null ? PreferenceSettingProvider.read(context).setPageAnimation(newValue) : {} : null,
                              onHover: (value) => setState((){title = 'Animasi Halaman'; description = 'Tampilan animasi pada halaman';}),
                              onExit: (value) => setEmpty(),
                            ),
                          ),
                          ColumnDivider(),
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
}
