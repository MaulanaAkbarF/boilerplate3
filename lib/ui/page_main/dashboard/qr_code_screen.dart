import 'package:boilerplate_3_firebaseconnect/core/utilities/functions/system_func.dart';
import 'package:boilerplate_3_firebaseconnect/ui/layouts/global_state_widgets/button/button_progress/animation_progress.dart';
import 'package:boilerplate_3_firebaseconnect/ui/layouts/global_state_widgets/divider/custom_divider.dart';
import 'package:boilerplate_3_firebaseconnect/ui/layouts/global_state_widgets/textfield/textfield_form/animate_form.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import 'package:qr_bar_code/code/src/code_generate.dart';

import '../../../core/constant_values/global_values.dart';
import '../../../core/constant_values/list_string_values.dart';
import '../../../core/state_management/providers/_settings/appearance_provider.dart';
import '../../../core/state_management/providers/features/qrcode_provider.dart';
import '../../../core/utilities/functions/media_query_func.dart';
import '../../../core/utilities/functions/page_routes_func.dart';
import '../../../core/utilities/functions/repaint_func.dart';
import '../../layouts/global_return_widgets/helper_widgets_func.dart';
import '../../layouts/global_state_widgets/custom_scaffold/custom_appbar.dart';
import '../../layouts/global_state_widgets/custom_scaffold/custom_scaffold.dart';
import '../../layouts/global_state_widgets/selected_item/expansion_tile.dart';
import '../../layouts/styleconfig/textstyle.dart';
import '../../layouts/styleconfig/themecolors.dart';

class QRCodeScreen extends StatelessWidget {
  const QRCodeScreen({super.key});

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
      appBar: appBarWidget(context: context, title: 'QR-Code', showBackButton: true, showPopupMenuButton: true,
        onPopupMenuSelected: (value) async {
          switch (value) {
            case '0': startScreenSwipe(context, QRCodeGeneratorScreen()); break;
          }
        },
        popupMenuItemBuilder: (context){
          return [
            popupMenuItem(context, '0', 'Buat QR-Code', Icons.qr_code_2_rounded, ThemeColors.green(context)),
          ];
        }
      ),
      body: _bodyWidget(context)
    );
  }

  Widget _setTabletLayout(BuildContext context){
    return CustomScaffold(
      useSafeArea: true,
      padding: EdgeInsets.zero,
      appBar: appBarWidget(context: context, title: 'QR-Code', showBackButton: true),
      body: _bodyWidget(context)
    );
  }

  Widget _bodyWidget(BuildContext context){
    return ChangeNotifierProvider(
      create: (context) => QRCodeProvider(),
      child: Consumer<QRCodeProvider>(
        builder: (context, provider, child) {
        return Stack(
          children: [
            MobileScanner(onDetect: (BarcodeCapture barcodes) => provider.setBarcode(barcodes)),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: paddingMid),
                width: double.infinity,
                height: getMediaQueryHeight(context) * .075,
                color: provider.barcode?.displayValue == null ? ThemeColors.red(context).withValues(alpha: .2) : ThemeColors.green(context).withValues(alpha: .2),
                child: Center(child: cText(context, provider.barcode?.displayValue ?? 'QR-Code tidak ditemukan!', maxLines: 2, align: TextAlign.center)),
              ),
            ),
          ]);
        },
      ),
    );
  }
}

class QRCodeGeneratorScreen extends StatelessWidget {
  final GlobalKey repaintBoundaryKey = GlobalKey();

  QRCodeGeneratorScreen({super.key});

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
        appBar: appBarWidget(context: context, title: 'QR-Code Generator', showBackButton: true),
        body: _bodyWidget(context)
    );
  }

  Widget _setTabletLayout(BuildContext context){
    return CustomScaffold(
        useSafeArea: true,
        padding: EdgeInsets.all(paddingMid),
        appBar: appBarWidget(context: context, title: 'QR-Code Generator', showBackButton: true),
        body: _bodyWidget(context)
    );
  }

  Widget _bodyWidget(BuildContext context){
    return ChangeNotifierProvider(
      create: (context) => QRCodeProvider(),
      child: Consumer<QRCodeProvider>(
        builder: (context, provider, child) {
          provider.setCodeError(false);
          return ListView(
            children: [
              AnimateTextField(
                controller: provider.tecUrl,
                labelText: 'Masukkan URL',
                suffixIcon: Icon(Icons.send_and_archive_rounded, color: ThemeColors.blue(context)),
                suffixOnTap: () => provider.makeBarcode(),
              ),
              ColumnDivider(),
              CustomExpansionTile(
                expansionList: listQRCodeType,
                maxHeight: .3,
                onSelected: (value) => provider.changeCodeType(value)
              ),
              ColumnDivider(),
              Container(
                padding: EdgeInsets.all(paddingMid),
                decoration: BoxDecoration(
                  color: ThemeColors.surface(context),
                  borderRadius: BorderRadius.circular(radiusSquare)
                ),
                child: RepaintBoundary(
                  key: repaintBoundaryKey,
                  child: Code(data: provider.tecUrl.text, codeType: provider.codeType,
                    errorBuilder: (context, error) {
                      provider.setCodeError(true);
                      return Container(padding: EdgeInsets.all(paddingMid),
                        decoration: BoxDecoration(
                          color: ThemeColors.redVeryHighContrast(context),
                          borderRadius: BorderRadius.circular(radiusSquare),
                        ),
                        child: cText(context, 'Error: ${error.toString()}', style: TextStyles.medium(context).copyWith(
                            color: ThemeColors.redLowContrast(context), fontWeight: FontWeight.bold)
                        ),
                      );
                    },
                  ),
                ),
              ),
              ColumnDivider(),
              AnimateProgressButton(
                labelButton: 'Cetak ${provider.codeType}',
                onTap: () async => provider.isCodeError ? showSnackBar(context, 'Tidak dapat mencetak') : await WidgetToImage().captureAndSaveWidget(context, repaintBoundaryKey),
              ),
            ]
          );
        },
      ),
    );
  }
}
