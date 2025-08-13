import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../core/state_management/providers/_settings/appearance_provider.dart';
import '../../../core/utilities/functions/media_query_func.dart';
import '../../layouts/global_state_widgets/button/button_progress/animation_progress.dart';
import '../../layouts/global_state_widgets/custom_scaffold/custom_scaffold.dart';
import '../../layouts/global_state_widgets/modal_bottom_sheet/image_picker.dart';
import '../../layouts/global_state_widgets/video_player/adaptive_chewie.dart';
import '../../layouts/styleconfig/themecolors.dart';

class AdaptiveVideoPlayers extends StatelessWidget {
  const AdaptiveVideoPlayers({super.key});

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
      canPop: true,
      useSafeArea: true,
      padding: EdgeInsets.zero,
      body: _bodyWidget(context)
    );
  }

  Widget _setTabletLayout(BuildContext context){
    return CustomScaffold(
      canPop: true,
      useSafeArea: true,
      padding: EdgeInsets.zero,
      body: _bodyWidget(context)
    );
  }

  Widget _bodyWidget(BuildContext context){
    XFile? videoFile;

    return StatefulBuilder(
      builder: (context, setState) {
        return Stack(
          children: [
            SizedBox(width: double.infinity, height: double.infinity, child: AdaptiveChewiePlayer(file: videoFile)),
            Positioned(bottom: 0, left: 0, right: 0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: AnimateProgressButton(
                  labelButton: 'Ambil Video',
                  containerColorStart: ThemeColors.orange(context),
                  containerColorEnd: ThemeColors.redHighContrast(context),
                  shadowColor: ThemeColors.surface(context),
                  onTap: () async {
                    showBottomSheetImagePicker(context: context, requestVideo: true, accessVideoFromGallery: true, onMediaPicked: (data){
                      setState(() {
                        videoFile = data;
                      });
                    });
                  },
                ),
              ),
            ),
          ],
        );
      }
    );
  }
}
