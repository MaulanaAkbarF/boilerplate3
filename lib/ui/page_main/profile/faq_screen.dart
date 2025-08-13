import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constant_values/_constant_text_values.dart';
import '../../../core/constant_values/global_values.dart';
import '../../../core/state_management/providers/_settings/appearance_provider.dart';
import '../../../core/utilities/functions/media_query_func.dart';
import '../../layouts/global_state_widgets/custom_scaffold/custom_appbar.dart';
import '../../layouts/global_state_widgets/custom_scaffold/custom_scaffold.dart';
import '../../layouts/global_state_widgets/selected_item/expansion_tile.dart';
import '../../layouts/styleconfig/textstyle.dart';
import '../../layouts/styleconfig/themecolors.dart';

List<Expansion> listExpansionFAQ = [
  Expansion(text: '$appNameText merupakan aplikasi template yang dikembangkan oleh Maulana Akbar Firdausya pada 11 Januari 2025'),
  Expansion(text: '$appNameText dikembangkan untuk memudahkan developer dalam mengembangkan aplikasi secara cepat, andal dan efisien'),
  Expansion(text: '$appNameText menggunakan state management Provider dalam mengelola state'),
];

class FaqScreen extends StatelessWidget {
  const FaqScreen({super.key});

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
        appBar: appBarWidget(context: context, title: 'Frequently Asked Question', showBackButton: true),
        body: _bodyWidget(context)
    );
  }

  Widget _setTabletLayout(BuildContext context){
    return CustomScaffold(
        useSafeArea: true,
        padding: EdgeInsets.all(paddingMid),
        appBar: appBarWidget(context: context, title: 'Frequently Asked Question', showBackButton: true),
        body: _bodyWidget(context)
    );
  }

  Widget _bodyWidget(BuildContext context){
    return ListView(
      children: [
        cText(context, 'Banyak pertanyaan yang sama masuk ke dalam sistem kami. Frequently Asked Questions (FAQ) mencoba menjawab pertanyaan yang'
            ' sering ditanyakan oleh banyak pengguna kepada kami.'),
        CustomExpansionTile(initialText: 'Apa itu $appNameText', expansionList: listExpansionFAQ.sublist(0, 0 + 1), canItemBeSelected: false,
            textStyle: TextStyles.semiLarge(context).copyWith(fontWeight: FontWeight.bold, color: ThemeColors.blueVeryHighContrast(context)), onSelected: (value) {}),
        CustomExpansionTile(initialText: 'Apa fungsi dari $appNameText', expansionList: listExpansionFAQ.sublist(1, 1 + 1), canItemBeSelected: false,
            textStyle: TextStyles.semiLarge(context).copyWith(fontWeight: FontWeight.bold, color: ThemeColors.blueVeryHighContrast(context)), onSelected: (value) {}),
        CustomExpansionTile(initialText: 'Apa teknologi dari $appNameText', expansionList: listExpansionFAQ.sublist(2, 2 + 1), canItemBeSelected: false,
            textStyle: TextStyles.semiLarge(context).copyWith(fontWeight: FontWeight.bold, color: ThemeColors.blueVeryHighContrast(context)), onSelected: (value) {}),
      ],
    );
  }
}
