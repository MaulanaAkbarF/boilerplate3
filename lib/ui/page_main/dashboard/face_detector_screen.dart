import 'package:boilerplate_3_firebaseconnect/ui/layouts/styleconfig/textstyle.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constant_values/global_values.dart';
import '../../../core/state_management/providers/_settings/appearance_provider.dart';
import '../../../core/state_management/providers/features/face_detector_provider.dart';
import '../../../core/utilities/functions/media_query_func.dart';
import '../../layouts/global_return_widgets/future_state_func.dart';
import '../../layouts/global_state_widgets/_other_custom_widgets/face_detector/overlay_widget.dart';
import '../../layouts/global_state_widgets/custom_scaffold/custom_appbar.dart';
import '../../layouts/global_state_widgets/custom_scaffold/custom_scaffold.dart';
import '../../layouts/styleconfig/themecolors.dart';

class FaceDetectorScreen extends StatelessWidget {
  const FaceDetectorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppearanceSettingProvider>(
      builder: (context, provider, child) {
        if (provider.isTabletMode.condition) {
          if (getMediaQueryWidth(context) > provider.tabletModePixel.value) return _setTabletLayout(context);
          if (getMediaQueryWidth(context) < provider.tabletModePixel.value) return _setPhoneLayout(context);
        }
        return _setPhoneLayout(context);
      }
    );
  }

  Widget _setPhoneLayout(BuildContext context) {
    return CustomScaffold(
        useSafeArea: true,
        useExtension: true,
        padding: EdgeInsets.zero,
        appBar: appBarWidget(
        context: context, title: 'Face Detector', showBackButton: true),
        body: _bodyWidget(context)
    );
  }

  Widget _setTabletLayout(BuildContext context) {
    return CustomScaffold(
        useSafeArea: true,
        useExtension: true,
        padding: EdgeInsets.zero,
        appBar: appBarWidget(
        context: context, title: 'Face Detector', showBackButton: true),
        body: _bodyWidget(context)
    );
  }

  Widget _bodyWidget(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        var provider = FaceDetectorProvider(context, enableFaceComparison: true);
        provider.initializeCamera();
        provider.loadReferenceImage();
        return provider;
      },
      child: Consumer<FaceDetectorProvider>(
        builder: (context, provider, child) {
        return Column(
            children: [
              Expanded(flex: 5, child: _cameraPreview(context, provider.cameraController)),
              Expanded(flex: 5,
                child: Container(
                  decoration: BoxDecoration(
                    color: ThemeColors.onSurface(context),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(radiusTriangle),
                      topRight: Radius.circular(radiusTriangle),
                    )
                  ),
                  child: ListView(
                    padding: EdgeInsets.all(paddingMid),
                    children: [
                      cText(context, provider.detectorPrompt, align: TextAlign.center, style: TextStyles.large(context).copyWith(fontWeight: FontWeight.bold)),
                      cText(context, 'Wajah ditemukan: ${provider.faceValid}'),
                      cText(context, 'Kecerahan: ${provider.brightness.toStringAsFixed(1)}'),
                      cText(context, 'Kecocokan Wajah Manusia: ${provider.faceMatched}'),
                      cText(context, 'Similarity: ${(provider.comparisonScore * 100).toStringAsFixed(1)}%', style: TextStyles.medium(context)),
                      cText(context, 'Mata Kiri Terbuka: ${provider.leftEyeOpen}'),
                      cText(context, 'Mata Kanan Terbuka: ${provider.rightEyeOpen}'),
                      cText(context, 'Senyuman: ${provider.isSmiling ? "Ya" : "Tidak"}'),
                      cText(context, 'Menghadap Tengah: ${provider.isLookingCenter  ? "Ya" : "Tidak"}'),
                      cText(context, 'Arah Pandangan: ${provider.headDirection}'),
                      cText(context, 'Menggeleng (X): ${provider.headYaw.toStringAsFixed(2)}'),
                      cText(context, 'Mengangguk (Y): ${provider.headPitch.toStringAsFixed(2)}'),
                      cText(context, 'Miring kepala: ${provider.headRoll.toStringAsFixed(2)}'),
                    ],
                  ),
                )
              )
            ],
          );
        },
      ),
    );
  }

  Widget _cameraPreview(BuildContext context, CameraController? cameraController) {
    if (cameraController == null) return onLoadingState(context: context);
    return Stack(
      fit: StackFit.expand,
      children: [
        FittedBox(
          fit: BoxFit.cover,
          alignment: Alignment.center,
          child: SizedBox(
            width: cameraController.value.previewSize?.height ?? 1,
            height: cameraController.value.previewSize?.width ?? 1,
            child: CameraPreview(cameraController),
          ),
        ),
        Consumer<FaceDetectorProvider>(builder: (context, value, child) => CameraOverlayWidget(provider: value)),
      ],
    );
  }
}