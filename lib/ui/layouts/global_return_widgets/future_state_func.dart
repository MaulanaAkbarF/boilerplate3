import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../../ui/layouts/styleconfig/textstyle.dart';
import '../../../../ui/layouts/styleconfig/themecolors.dart';
import '../../../core/constant_values/global_values.dart';
import '../../../core/utilities/functions/media_query_func.dart';
import '../global_state_widgets/button/button_progress/animation_progress.dart';
import '../global_state_widgets/divider/custom_divider.dart';

/// Global Future State Widget

/// Widget yang dipanggil ketika fungsi Future Builder atau State berada pada kondisi default/initial
Widget onInitialState(BuildContext context) {
  return SizedBox(
    width: double.infinity,
    child: Center(
      child: Padding(
        padding: const EdgeInsets.all(paddingMid),
        child: cText(context, 'Mengisiasi', align: TextAlign.center, style: TextStyles.semiLarge(context).copyWith(fontWeight: FontWeight.bold)),
      ),
    ),
  );
}

/// Widget yang dipanggil ketika fungsi Future Builder atau State berada pada kondisi memuat data/loading
Widget onLoadingState({required BuildContext context, String? response}) {
  return SizedBox(
    width: double.infinity,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        cText(context, response ?? 'Memuat Data', align: TextAlign.center, style: TextStyles.semiLarge(context).copyWith(fontWeight: FontWeight.bold)),
        const ColumnDivider(space: spaceNear),
        LoadingAnimationWidget.hexagonDots(color: ThemeColors.surface(context), size: iconBtnMid)
      ],
    ),
  );
}

/// Widget yang dipanggil ketika fungsi Future Builder atau State menghasilkan data kosong/null
Widget onEmptyState({required BuildContext context, String? response, String? description, String? buttonLabel, VoidCallback? onTap}) {
  return SizedBox(
    width: double.infinity,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        cText(context, response ?? 'Data Kosong', align: TextAlign.center, style: TextStyles.semiLarge(context).copyWith(fontWeight: FontWeight.bold)),
        if (description != null)...[
          const ColumnDivider(space: spaceNear),
          cText(context, description, align: TextAlign.center, style: TextStyles.medium(context).copyWith(color: ThemeColors.grey(context))),
        ],
        if (onTap != null)...[
          const ColumnDivider(space: paddingFar),
          AnimateProgressButton(
            labelButton: buttonLabel ?? 'Segarkan',
            containerColor: ThemeColors.blueHighContrast(context),
            shadowColor: ThemeColors.surface(context),
            fitButton: true,
            width: getMediaQueryWidth(context) * .5,
            containerRadius: radiusCircle,
            onTap: () => onTap(),
          ),
        ]
      ],
    ),
  );
}

/// Widget yang dipanggil ketika fungsi Future Builder atau State gagal memuat data atau terjadi suatu masalah
Widget onFailedState({required BuildContext context, String? response, String? description, String? buttonLabel, VoidCallback? onTap}) {
  return SizedBox(
    width: double.infinity,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        cText(context, response ?? 'Gagal Memuat Data', align: TextAlign.center, style: TextStyles.semiLarge(context).copyWith(color: ThemeColors.red(context), fontWeight: FontWeight.bold)),
        if (description != null)...[
          const ColumnDivider(space: 2),
          cText(context, description, align: TextAlign.center, style: TextStyles.medium(context).copyWith(color: ThemeColors.grey(context))),
        ],
        if (onTap != null)...[
          const ColumnDivider(space: paddingFar),
          AnimateProgressButton(
            labelButton: buttonLabel ?? 'Muat Ulang',
            containerColor: ThemeColors.blueHighContrast(context),
            shadowColor: ThemeColors.surface(context),
            fitButton: true,
            width: getMediaQueryWidth(context) * .5,
            containerRadius: radiusCircle,
            onTap: () => onTap(),
          ),
        ]
      ],
    ),
  );
}