import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constant_values/_constant_text_values.dart';
import '../../../core/constant_values/global_values.dart';
import '../../../core/state_management/providers/_settings/appearance_provider.dart';
import '../../../core/utilities/functions/media_query_func.dart';
import '../../../core/utilities/functions/page_routes_func.dart';
import '../../layouts/global_state_widgets/button/button_progress/animation_progress.dart';
import '../../layouts/global_state_widgets/custom_scaffold/custom_appbar.dart';
import '../../layouts/global_state_widgets/custom_scaffold/custom_scaffold.dart';
import '../../layouts/global_state_widgets/custom_text/markdown_text.dart';
import '../../layouts/global_state_widgets/divider/custom_divider.dart';
import '../../layouts/styleconfig/textstyle.dart';
import '../../layouts/styleconfig/themecolors.dart';
import 'call_us_screen.dart';

List<String> listKebijakanPrivasi = [
  '''$appNameText mengumpulkan data pribadi yang bertujuan untuk memproses pendaftaran donor darah dan tujuan lainnya **sesuai dengan peraturan perundang-undangan yang berlaku**.''',
  '''$appNameText menggunakan data pribadi yang diperoleh dan dikumpulkan dari data pengguna untuk digunakan dalam proses **pelayanan pesanan**, meliputi:
  * Nama Pengguna
  * Email Pengguna''',
  '''$appNameText menyimpan data Anda pada database kami yang dienkripsi berlapis-lapis untuk memastikan data Anda aman dari serangan''',
];

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

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
        appBar: appBarWidget(context: context, title: 'Kebijakan Privasi', showBackButton: true),
        body: _bodyWidget(context)
    );
  }

  Widget _setTabletLayout(BuildContext context){
    return CustomScaffold(
        useSafeArea: true,
        padding: EdgeInsets.all(paddingMid),
        appBar: appBarWidget(context: context, title: 'Kebijakan Privasi', showBackButton: true),
        body: _bodyWidget(context)
    );
  }

  Widget _bodyWidget(BuildContext context){
    return ListView(
      children: [
        cText(context, 'Kami menghargai privasi Anda dan berkomitmen untuk melindungi data pribadi Anda. '
          'Kebijakan privasi ini menjelaskan cara kami mengumpulkan, menggunakan, mengolah, dan mengamankan data pribadi Anda saat menggunakan aplikasi'),
        ColumnDivider(space: spaceFar),
        cText(context, 'Pengumpulan Data', style: TextStyles.large(context).copyWith(fontWeight: FontWeight.bold)),
        ColumnDivider(space: spaceNear),
        RegularMarkdown(text: listKebijakanPrivasi[0]),
        ColumnDivider(space: spaceFar),
        cText(context, 'Penggunaan Data', style: TextStyles.large(context).copyWith(fontWeight: FontWeight.bold)),
        ColumnDivider(space: spaceNear),
        RegularMarkdown(text: listKebijakanPrivasi[1]),
        ColumnDivider(space: spaceFar),
        cText(context, 'Keamanan Data', style: TextStyles.large(context).copyWith(fontWeight: FontWeight.bold)),
        ColumnDivider(space: spaceNear),
        RegularMarkdown(text: listKebijakanPrivasi[2]),
        ColumnDivider(space: spaceFar),
        cText(context, 'Kami berkomitmen untuk melindungi privasi dan data pribadi Anda sesuai dengan peraturan yang berlaku. '
          'Jika Anda memiliki pertanyaan atau kekhawatiran terkait kebijakan privasi ini, silakan hubungi kami melalui tombol di bawah ini.'),
        ColumnDivider(space: spaceNear),
        AnimateProgressButton(
          labelButton: 'Hubungi Kami',
          labelButtonStyle: TextStyles.semiLarge(context).copyWith(color: ThemeColors.surface(context)),
          containerColor: ThemeColors.greyVeryLowContrast(context),
          icon: Icon(Icons.call, size: iconBtnSmall, color: ThemeColors.teal(context)),
          useArrow: true,
          onTap: () async => await startScreenSwipe(context, CallUsScreen())
        ),
      ],
    );
  }
}
