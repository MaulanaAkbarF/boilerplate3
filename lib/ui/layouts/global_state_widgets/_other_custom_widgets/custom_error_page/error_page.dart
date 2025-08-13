import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constant_values/assets_values.dart';
import '../../../../../core/constant_values/global_values.dart';
import '../../../../../core/state_management/providers/_global_widget/main_navbar_provider.dart';
import '../../../../../core/state_management/providers/_settings/appearance_provider.dart';
import '../../../../../core/utilities/functions/media_query_func.dart';
import '../../../../../core/utilities/functions/page_routes_func.dart';
import '../../../../page_main/_bottom_navbar/main_navbar_floating.dart';
import '../../../global_return_widgets/media_widgets_func.dart';
import '../../../styleconfig/textstyle.dart';
import '../../../styleconfig/themecolors.dart';
import '../../button/button_progress/animation_progress.dart';
import '../../custom_scaffold/custom_scaffold.dart';
import '../../divider/custom_divider.dart';

class ErrorPage extends StatelessWidget {
  final FlutterErrorDetails details;

  const ErrorPage({super.key, required this.details});

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
        canPop: false,
        useSafeArea: true,
        padding: EdgeInsets.zero,
        body: _bodyWidget(context)
    );
  }

  Widget _setTabletLayout(BuildContext context){
    return CustomScaffold(
        canPop: false,
        useSafeArea: true,
        padding: EdgeInsets.zero,
        body: _bodyWidget(context)
    );
  }

  Widget _setWebLayout(BuildContext context){
    return CustomScaffold(
        canPop: false,
        useSafeArea: true,
        padding: EdgeInsets.zero,
        body: _bodyWebWidget(context)
    );
  }

  Widget _bodyWidget(BuildContext context){
    return Padding(
      padding: const EdgeInsets.all(paddingFar),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          loadLottieAsset(path: lottieFailed, width: iconBtnBig * 3, height: iconBtnBig * 3),
          cText(context, 'Oops, terjadi masalah nih di aplikasi :(', align: TextAlign.center, style: TextStyles.large(context).copyWith(fontWeight: FontWeight.bold)),
          ColumnDivider(space: spaceNear),
          cText(context, details.exception.toString(), align: TextAlign.center),
          ColumnDivider(space: spaceFar),
          Row(
            children: [
              Expanded(
                child: AnimateProgressButton(
                  labelButton: 'Kembali',
                  containerColor: ThemeColors.blueHighContrast(context),
                  shadowColor: ThemeColors.surface(context),
                  onTap: () async {
                    Navigator.pop(context);
                  },
                ),
              ),
              RowDivider(space: spaceMid),
              Expanded(
                child: AnimateProgressButton(
                  labelButton: 'Beranda',
                  containerColor: ThemeColors.greyLowContrast(context),
                  shadowColor: ThemeColors.surface(context),
                  onTap: () async {
                    MainNavbarProvider.read(context).changePageIndex(1);
                    startScreenRemoveAll(context, MainFloatingNavbar());
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _bodyWebWidget(BuildContext context){
    return Padding(
      padding: const EdgeInsets.all(paddingFar),
      child: ListView(
        shrinkWrap: true,
        children: [
          cText(context, 'Oops, terjadi masalah nih di aplikasi :)', align: TextAlign.center),
        ],
      ),
    );
  }
}