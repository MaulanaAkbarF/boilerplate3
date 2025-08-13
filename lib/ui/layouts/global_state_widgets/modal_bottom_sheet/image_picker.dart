import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/constant_values/global_values.dart';
import '../../../../core/utilities/functions/media_func.dart';
import '../../../../core/utilities/functions/media_query_func.dart';
import '../../styleconfig/textstyle.dart';
import '../../styleconfig/themecolors.dart';

void showBottomSheetImagePicker({required BuildContext context, required Function(XFile) onMediaPicked, bool? requestVideo, bool? accessVideoFromGallery}){
  showModalBottomSheet(context: context, constraints: BoxConstraints(minWidth: double.infinity, maxHeight: getMediaQueryHeight(context, size: .25)),
    builder: (BuildContext context) => BottomSheetImagePicker(onMediaPicked: onMediaPicked, requestVideo: requestVideo, accessVideoFromGallery: accessVideoFromGallery));
}

class BottomSheetImagePicker extends StatelessWidget {
  final bool? requestVideo;
  final bool? accessVideoFromGallery;
  final Function(XFile) onMediaPicked;

  const BottomSheetImagePicker({
    super.key,
    this.requestVideo,
    this.accessVideoFromGallery,
    required this.onMediaPicked
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ThemeColors.greyVeryLowContrast(context),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(radiusTriangle),
          topRight: Radius.circular(radiusTriangle)
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: paddingMid),
        child: ListView(
          shrinkWrap: true,
          children: [
            ListTile(leading: Icon(Icons.camera, size: iconBtnMid, color: ThemeColors.purple(context)), title: cText(context, (requestVideo != null) && true ? 'Ambil Video' : 'Ambil Foto'), onTap: () async {
              XFile? photo = await getMediaFromCamera(requestVideo: requestVideo);
              if (photo != null) onMediaPicked(photo);
            }),
            ListTile(leading: Icon(Icons.photo_library, size: iconBtnMid, color: ThemeColors.blue(context)), title: cText(context, (accessVideoFromGallery != null) && true ? 'Buka Galeri Video' : 'Buka Galeri Foto'), onTap: () async {
              XFile? photo = await getMediaFromGallery(accessVideoFromGallery: accessVideoFromGallery);
              if (photo != null) onMediaPicked(photo);
            }),
          ],
        ),
      ),
    );
  }
}
