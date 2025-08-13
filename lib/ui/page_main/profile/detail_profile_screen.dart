import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constant_values/global_values.dart';
import '../../../core/state_management/providers/_settings/appearance_provider.dart';
import '../../../core/state_management/providers/auth/user_provider.dart';
import '../../../core/utilities/functions/media_query_func.dart';
import '../../layouts/global_return_widgets/media_widgets_func.dart';
import '../../layouts/global_state_widgets/custom_scaffold/custom_appbar.dart';
import '../../layouts/global_state_widgets/custom_scaffold/custom_scaffold.dart';
import '../../layouts/global_state_widgets/divider/custom_divider.dart';
import '../../layouts/styleconfig/textstyle.dart';
import '../../layouts/styleconfig/themecolors.dart';

class DetailProfileScreen extends StatelessWidget {
  const DetailProfileScreen({super.key});

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
      padding: EdgeInsets.zero,
      backgroundColor: ThemeColors.onSurface(context),
      appBar: appBarWidget(context: context, title: 'Detail Profil', backgroundColor: ThemeColors.onSurface(context), showBackButton: true),
      body: _bodyWidget(context)
    );
  }

  Widget _setTabletLayout(BuildContext context){
    return CustomScaffold(
      useSafeArea: true,
      padding: EdgeInsets.zero,
      backgroundColor: ThemeColors.onSurface(context),
      appBar: appBarWidget(context: context, title: 'Detail Profil', backgroundColor: ThemeColors.onSurface(context), showBackButton: true),
      body: _bodyWidget(context)
    );
  }

  Widget _bodyWidget(BuildContext context){
    return ListView(
      children: [
        SizedBox(
          width: getMediaQueryWidth(context),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Column(
                children: [
                  Container(
                    height: getMediaQueryHeight(context) * .1,
                    color: Colors.transparent,
                  ),
                  Container(
                    height: getMediaQueryHeight(context) * .12,
                    color: ThemeColors.greyVeryLowContrast(context),
                  ),
                ],
              ),
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: getMediaQueryWidth(context) * .8,
                      padding: const EdgeInsets.all(paddingMid),
                      decoration: BoxDecoration(
                        color: ThemeColors.greyLowContrast(context),
                        borderRadius: BorderRadius.circular(radiusSquare)
                      ),
                      child: Column(
                        children: [
                          loadCircleImage(context: context, radius: 50),
                          ColumnDivider(space: spaceMid),
                          cText(context, UserProvider.read(context).user?.name ?? 'Guest', style: TextStyles.large(context).copyWith(fontWeight: FontWeight.bold)),
                          ColumnDivider(space: paddingMid),
                          cText(context, UserProvider.read(context).user?.email ?? 'guest@mail.com'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 500,
          padding: const EdgeInsets.all(paddingFar),
          color: ThemeColors.greyVeryLowContrast(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(flex: 3, child: cText(context, 'Nomor Telepon', style: TextStyles.medium(context).copyWith(fontWeight: FontWeight.bold))),
                  Expanded(flex: 4, child: Align(alignment: Alignment.centerRight, child: cText(context, '08123456789', align: TextAlign.end))),
                ],
              ),
              ColumnDivider(space: paddingFar),
              Row(
                children: [
                  Expanded(flex: 3, child: cText(context, 'Alamat', style: TextStyles.medium(context).copyWith(fontWeight: FontWeight.bold))),
                  Expanded(flex: 4, child: Align(alignment: Alignment.centerRight, child: cText(context, 'Jl. Perintis Kemerdekaan No. 15, Raijua, Nusa Tenggara Timur, Indonesia', align: TextAlign.end))),
                ],
              ),
              ColumnDivider(space: paddingFar),
              Row(
                children: [
                  Expanded(flex: 3, child: cText(context, 'Tempat/Tanggal Lahir', style: TextStyles.medium(context).copyWith(fontWeight: FontWeight.bold))),
                  Expanded(flex: 4, child: Align(alignment: Alignment.centerRight, child: cText(context, 'Probolinggo, 28 Juni 2002', align: TextAlign.end))),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
