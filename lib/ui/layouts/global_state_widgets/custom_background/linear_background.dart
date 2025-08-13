// import 'package:flutter/material.dart';
//
// import '../../styleconfig/themecolors.dart';
//
// class VerticalGradientBackground extends StatelessWidget {
//   final Color? topColor;
//   final Color? transitionTopColor;
//   final Color? transitionBottomColor;
//   final double? transitionTopValue;
//   final double? transitionBottomValue;
//
//   const VerticalGradientBackground({
//     super.key,
//     this.topColor,
//     this.transitionTopColor,
//     this.transitionBottomColor,
//     this.transitionTopValue,
//     this.transitionBottomValue,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//
//     return Container(
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topCenter,
//           end: Alignment.bottomCenter,
//           colors: [
//             topColor != null ? topColor! : Colors.transparent,
//             transitionTopColor != null ? transitionTopColor! : Colors.transparent,
//             transitionBottomColor != null ? transitionBottomColor! : ThemeColors.regularFlipped(context).withOpacity(0.2),
//           ],
//           stops: [
//             0.0,
//             transitionTopValue != null ? transitionTopValue! : 0.4,
//             transitionBottomValue != null ? transitionBottomValue! : 1.0
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class TopBottomGradientBackground extends StatelessWidget {
//   final Color? topColor;
//   final Color? transitionTopColor;
//   final Color? transitionBottomColor;
//   final double? transitionTopValue;
//   final double? transitionBottomValue;
//
//   const TopBottomGradientBackground({
//     super.key,
//     this.topColor,
//     this.transitionTopColor,
//     this.transitionBottomColor,
//     this.transitionTopValue,
//     this.transitionBottomValue,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//
//     return Container(
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topCenter,
//           end: Alignment.bottomCenter,
//           colors: [
//             topColor != null ? topColor! : Colors.transparent,
//             transitionTopColor != null ? transitionTopColor! : Colors.transparent,
//             transitionBottomColor != null ? transitionBottomColor! : ThemeColors.regularFlipped(context).withOpacity(0.2),
//           ],
//           stops: [
//             0.0,
//             transitionTopValue != null ? transitionTopValue! : 0.4,
//             transitionBottomValue != null ? transitionBottomValue! : 1.0
//           ],
//         ),
//       ),
//     );
//   }
// }
