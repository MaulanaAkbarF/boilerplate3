// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// import '../../../../core/utilities/services/media_query_func.dart';
// import '../../../../core/utilities/services/global_return_widgets/media_widgets_func.dart';
// import '../../styleconfig/themecolors.dart';
//
// class ImageBackground extends StatelessWidget {
//   const ImageBackground({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//
//     return Stack(
//       children: [
//         // Top Circle Background
//         Positioned(
//           top: -40.0,
//           left: -80.0,
//           child: Container(
//             width: loadDefaultBgSplashHeight() * 2.5,
//             height: loadDefaultBgSplashHeight() * 2.5,
//             decoration: BoxDecoration(
//               border: Border.all(color: ThemeColors.yellowLowContrast(context), width: 2),
//               borderRadius: BorderRadius.circular(1000),
//             ),
//           ),
//         ),
//         Positioned(
//           top: 80.0,
//           left: 100.0,
//           child: Container(
//             width: loadDefaultBgSplashHeight() * 1.2,
//             height: loadDefaultBgSplashHeight() * 1.2,
//             decoration: BoxDecoration(
//               border: Border.all(color: ThemeColors.blueLowContrast(context), width: 2),
//               borderRadius: BorderRadius.circular(500),
//             ),
//           ),
//         ),
//
//         // Bottom Circle Background
//         Positioned(
//           bottom: -40.0,
//           right: -80.0,
//           child: Container(
//             width: loadDefaultBgSplashHeight() * 3,
//             height: loadDefaultBgSplashHeight() * 3,
//             decoration: BoxDecoration(
//               border: Border.all(color: ThemeColors.yellowLowContrast(context), width: 2),
//               borderRadius: BorderRadius.circular(1000),
//             ),
//           ),
//         ),
//         Positioned(
//           bottom: 200.0,
//           right: -20.0,
//           child: Container(
//             width: loadDefaultBgSplashHeight() * 0.8,
//             height: loadDefaultBgSplashHeight() * 0.8,
//             decoration: BoxDecoration(
//               border: Border.all(color: ThemeColors.blueLowContrast(context), width: 2),
//               borderRadius: BorderRadius.circular(500),
//             ),
//           ),
//         ),
//         Positioned(
//           bottom: -40.0,
//           right: 120.0,
//           child: Container(
//             width: loadDefaultBgSplashHeight() * 1.6,
//             height: loadDefaultBgSplashHeight() * 1.6,
//             decoration: BoxDecoration(
//               border: Border.all(color: ThemeColors.blueLowContrast(context), width: 2),
//               borderRadius: BorderRadius.circular(500),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
//
// class ImageBackground2 extends StatelessWidget {
//   const ImageBackground2({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//
//     return Stack(
//       children: [
//         // Top Rectangle Background
//         Positioned(
//           top: -100.0,
//           left: 0.0,
//           right: 0.0,
//           child: Container(
//             width: getMediaQueryWidth(context),
//             height: loadDefaultBgSplashHeight() * 3,
//             decoration: BoxDecoration(
//               color: ThemeColors.blueLowContrast(context).withOpacity(0.1),
//             ),
//           ),
//         ),
//
//         // Bottom Circle Background
//         Positioned(
//           bottom: -20.0,
//           right: -50.0,
//           child: Container(
//             width: loadDefaultBgSplashHeight() * 3,
//             height: loadDefaultBgSplashHeight() * 3,
//             decoration: BoxDecoration(
//               border: Border.all(color: ThemeColors.blueHighContrast(context), width: 2),
//               borderRadius: BorderRadius.circular(500),
//             ),
//           ),
//         ),
//         Positioned(
//           bottom: -50.0,
//           right: 180.0,
//           child: Container(
//             width: loadDefaultBgSplashHeight() * 2,
//             height: loadDefaultBgSplashHeight() * 2,
//             decoration: BoxDecoration(
//               border: Border.all(color: ThemeColors.blueLowContrast(context), width: 2),
//               borderRadius: BorderRadius.circular(500),
//             ),
//           ),
//         ),
//         Positioned(
//           bottom: 240.0,
//           right: -60.0,
//           child: Container(
//             width: loadDefaultBgSplashHeight() * 1.3,
//             height: loadDefaultBgSplashHeight() * 1.3,
//             decoration: BoxDecoration(
//               border: Border.all(color: ThemeColors.blueVeryLowContrast(context), width: 2),
//               borderRadius: BorderRadius.circular(500),
//             ),
//           ),
//         ),
//         Positioned(
//           bottom: -50.0,
//           right: -60.0,
//           child: Container(
//             width: loadDefaultBgSplashHeight() * 1.6,
//             height: loadDefaultBgSplashHeight() * 1.6,
//             decoration: BoxDecoration(
//               border: Border.all(color: ThemeColors.blueLowContrast(context), width: 2),
//               borderRadius: BorderRadius.circular(500),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
