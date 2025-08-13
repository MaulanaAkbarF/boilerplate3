import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constant_values/_constant_text_values.dart';
import '../../core/constant_values/global_values.dart';
import '../../core/state_management/providers/_settings/appearance_provider.dart';
import '../../core/utilities/functions/media_query_func.dart';
import '../layouts/global_return_widgets/media_widgets_func.dart';
import '../layouts/global_state_widgets/custom_scaffold/custom_scaffold.dart';
import '../layouts/global_state_widgets/divider/custom_divider.dart';
import '../layouts/styleconfig/textstyle.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

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
      useExtension: true,
      showBackgroundLogo: true,
      padding: EdgeInsets.zero,
      body: _bodyWidget(context)
    );
  }

  Widget _setTabletLayout(BuildContext context){
    return CustomScaffold(
      canPop: false,
      useSafeArea: true,
      useExtension: true,
      showBackgroundLogo: true,
      padding: EdgeInsets.zero,
      body: _bodyWidget(context)
    );
  }

  Widget _bodyWidget(BuildContext context){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        cText(context, appNameText, style: TextStyles.giant(context).copyWith(fontWeight: FontWeight.bold)),
        ColumnDivider(space: spaceMid),
        loadDefaultAppLogoPNG(sizeLogo: 100),
        ColumnDivider(space: spaceMid),
        cText(context, 'Memuat Data...', style: TextStyles.semiLarge(context).copyWith(fontWeight: FontWeight.bold))
      ],
    );
  }
}
