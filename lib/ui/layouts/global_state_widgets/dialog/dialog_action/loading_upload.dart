import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../core/constant_values/_setting_value/log_app_values.dart';
import '../../../../../core/constant_values/assets_values.dart';
import '../../../../../core/constant_values/global_values.dart';
import '../../../../../core/utilities/functions/logger_func.dart';
import '../../../../../core/utilities/local_storage/isar_local_db/services/_setting_services/log_app_services.dart';
import '../../../global_return_widgets/media_widgets_func.dart';
import '../../../styleconfig/textstyle.dart';
import '../../../styleconfig/themecolors.dart';
import '../../divider/custom_divider.dart';
import '../dialog_button/dialog_one_button.dart';

class AdaptiveProgressIndicator extends StatelessWidget {
  const AdaptiveProgressIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoActivityIndicator(color: ThemeColors.surface(context));
    } else {
      return CircularProgressIndicator(color: ThemeColors.surface(context));
    }
  }
}

class DialogProccess extends StatelessWidget {
  final String? lottiePath;
  final String? imagePathPNG;
  final IconData? iconData;
  final double? sizeContentImages;
  final Color? colorContentImages;
  final String header;
  final String description;
  final TextStyle? headerTextStyle;
  final TextStyle? descriptionTextStyle;
  final Function onProcess;
  final String? onSuccessTextHeader;
  final String? onSuccessTextDescription;
  final Function(BuildContext)? onSuccessTap;
  final String? onFailedTextHeader;
  final String? onFailedTextDescription;
  final Function(BuildContext)? onFailedTap;

  const DialogProccess({
    super.key,
    this.lottiePath,
    this.imagePathPNG,
    this.iconData,
    this.sizeContentImages,
    this.colorContentImages,
    required this.header,
    required this.description,
    this.headerTextStyle,
    this.descriptionTextStyle,
    required this.onProcess,
    this.onSuccessTextHeader,
    this.onSuccessTextDescription,
    this.onSuccessTap,
    this.onFailedTextHeader,
    this.onFailedTextDescription,
    this.onFailedTap,
  });

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        /// Kamu bisa menambahkan return false di akhir kode onProcess agar dialog yang ditampilkan selanjutnya adalah dialog gagal dan terdapat tombol untuk mengulangi proses upload
        /// Jika menambahkan return true atau tidak ada return di akhir kode onProcess, maka dialog yang ditampilkan selanjutnya adalah dialog berhasil
        final result = await onProcess();
        Navigator.pop(context);
        if (result == true || result == null) {
          await showDialog(context: context, builder: (context) => DialogOneButton(header: onSuccessTextHeader ?? 'Sukses!', headerTextStyle: TextStyles.large(context).copyWith(color: ThemeColors.green(context), fontWeight: FontWeight.w900),
            description: onSuccessTextDescription ?? 'Proses selesai! Tekan tombol "Konfirmasi" untuk melanjutkan', lottiePath: lottiePath != null ? lottieSuccess : null,
            acceptedOnTap: () async => onSuccessTap != null ? await onSuccessTap!(context) : Navigator.pop(context)));
        } else if (result == false) {
          await showDialog(context: context, builder: (context) => DialogOneButton(header: onFailedTextHeader ?? 'Gagal!', headerTextStyle: TextStyles.large(context).copyWith(color: ThemeColors.red(context), fontWeight: FontWeight.w900),
            description: onFailedTextDescription ?? 'Gagal memproses data! Periksa semua data yang Anda masukkan. Tekan tombol "Konfirmasi" untuk melanjutkan', lottiePath: lottiePath != null ? lottieFailed : null,
            acceptedOnTap: () async => onFailedTap != null ? await onFailedTap!(context) : Navigator.pop(context)));
        }
      } catch (e, s) {
        clog('Terjadi masalah pada onProcess di DialogProccess: $e\n$s');
        await addLogApp(level: ListLogAppLevel.critical.level, title: e.toString(), logs: s.toString());
        Navigator.pop(context);
      }
    });

    return Dialog(
      surfaceTintColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      shadowColor: Colors.transparent,
      child: Align(
        alignment: Alignment.center,
        child: Container(
          decoration: BoxDecoration(
            color: ThemeColors.greyLowContrast(context),
            borderRadius: BorderRadius.circular(radiusSquare),
            boxShadow: [
              BoxShadow(
                color: ThemeColors.grey(context).withValues(alpha: shadowOpacityMid),
                spreadRadius: shadowSpreadLow,
                blurRadius: shadowBlueHigh,
                offset: const Offset(0, shadowoffsetMid),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(paddingMid),
            child: IntrinsicHeight(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  lottiePath != null ? loadLottieAsset(path: lottiePath!, width: sizeContentImages, height: sizeContentImages)
                      : imagePathPNG != null ? loadImageAssetPNG(path: imagePathPNG!, width: sizeContentImages, height: sizeContentImages, color: colorContentImages)
                      : iconData != null ? Icon(iconData, size: sizeContentImages, color: colorContentImages) : SizedBox(),
                  cText(context, header, maxLines: 3, align: TextAlign.center, style: headerTextStyle ?? TextStyles.large(context).copyWith(color: ThemeColors.blue(context), fontWeight: FontWeight.w900)),
                  ColumnDivider(),
                  cText(context, description, align: TextAlign.center, style: descriptionTextStyle ?? TextStyles.medium(context).copyWith(color: ThemeColors.surface(context))),
                  ColumnDivider(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}