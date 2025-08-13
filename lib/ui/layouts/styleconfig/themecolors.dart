import 'package:flutter/material.dart';

class ThemeColors {
  // General Colors
  static Color surface(BuildContext context) => Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white;
  static Color onSurface(BuildContext context) => Theme.of(context).brightness == Brightness.light ? Colors.white : Colors.black;

  // Grey Colors
  static Color greyVeryLowContrast(BuildContext context) => Theme.of(context).brightness == Brightness.light ? Colors.grey.shade200 : Colors.grey.shade900;
  static Color greyLowContrast(BuildContext context) => Theme.of(context).brightness == Brightness.light ? Colors.grey.shade300 : Colors.grey.shade800;
  static Color grey(BuildContext context) => Colors.grey;
  static Color greyHighContrast(BuildContext context) => Theme.of(context).brightness == Brightness.light ? Colors.grey.shade800 : Colors.grey.shade300;
  static Color greyVeryHighContrast(BuildContext context) => Theme.of(context).brightness == Brightness.light ? Colors.grey.shade900 : Colors.grey.shade200;
  // Maroon (Merah Tua) Colors
  static Color maroonVeryLowContrast(BuildContext context) => Theme.of(context).brightness == Brightness.light ? Color(0xFFE8D5D5) : Color(0xFF4A0E0E);
  static Color maroonLowContrast(BuildContext context) => Theme.of(context).brightness == Brightness.light ? Color(0xFFB87A7A) : Color(0xFF8B2635);
  static Color maroon(BuildContext context) => Color(0xFF800000);
  static Color maroonHighContrast(BuildContext context) => Theme.of(context).brightness == Brightness.light ? Color(0xFF5D1A1A) : Color(0xFFB87A7A);
  static Color maroonVeryHighContrast(BuildContext context) => Theme.of(context).brightness == Brightness.light ? Color(0xFF2D0A0A) : Color(0xFFE8D5D5);
  // Red Colors
  static Color redVeryLowContrast(BuildContext context) => Theme.of(context).brightness == Brightness.light ? Colors.red.shade100 : Colors.red.shade900;
  static Color redLowContrast(BuildContext context) => Theme.of(context).brightness == Brightness.light ? Colors.red.shade300 : Colors.red.shade700;
  static Color red(BuildContext context) => Colors.red;
  static Color redHighContrast(BuildContext context) => Theme.of(context).brightness == Brightness.light ? Colors.red.shade700 : Colors.red.shade300;
  static Color redVeryHighContrast(BuildContext context) => Theme.of(context).brightness == Brightness.light ? Colors.red.shade900 : Colors.red.shade100;
  // Pink Colors
  static Color pinkVeryLowContrast(BuildContext context) => Theme.of(context).brightness == Brightness.light ? Colors.pink.shade100 : Colors.pink.shade900;
  static Color pinkLowContrast(BuildContext context) => Theme.of(context).brightness == Brightness.light ? Colors.pink.shade300 : Colors.pink.shade700;
  static Color pink(BuildContext context) => Colors.pink;
  static Color pinkHighContrast(BuildContext context) => Theme.of(context).brightness == Brightness.light ? Colors.pink.shade700 : Colors.pink.shade300;
  static Color pinkVeryHighContrast(BuildContext context) => Theme.of(context).brightness == Brightness.light ? Colors.pink.shade900 : Colors.pink.shade100;
  // Green Colors
  static Color greenVeryLowContrast(BuildContext context) => Theme.of(context).brightness == Brightness.light ? Colors.green.shade100 : Colors.green.shade900;
  static Color greenLowContrast(BuildContext context) => Theme.of(context).brightness == Brightness.light ? Colors.green.shade300 : Colors.green.shade700;
  static Color green(BuildContext context) => Colors.green;
  static Color greenHighContrast(BuildContext context) => Theme.of(context).brightness == Brightness.light ? Colors.green.shade700 : Colors.green.shade300;
  static Color greenVeryHighContrast(BuildContext context) => Theme.of(context).brightness == Brightness.light ? Colors.green.shade900 : Colors.green.shade100;
  // Teal (Biru Hijau Muda) Colors
  static Color tealVeryLowContrast(BuildContext context) => Theme.of(context).brightness == Brightness.light ? Colors.teal.shade100 : Colors.teal.shade900;
  static Color tealLowContrast(BuildContext context) => Theme.of(context).brightness == Brightness.light ? Colors.teal.shade300 : Colors.teal.shade700;
  static Color teal(BuildContext context) => Colors.teal;
  static Color tealHighContrast(BuildContext context) => Theme.of(context).brightness == Brightness.light ? Colors.teal.shade700 : Colors.teal.shade300;
  static Color tealVeryHighContrast(BuildContext context) => Theme.of(context).brightness == Brightness.light ? Colors.teal.shade900 : Colors.teal.shade100;
  // Lime (Hijau Muda) Colors
  static Color limeVeryLowContrast(BuildContext context) => Theme.of(context).brightness == Brightness.light ? Colors.lime.shade100 : Colors.lime.shade900;
  static Color limeLowContrast(BuildContext context) => Theme.of(context).brightness == Brightness.light ? Colors.lime.shade300 : Colors.lime.shade700;
  static Color lime(BuildContext context) => Colors.lime;
  static Color limeHighContrast(BuildContext context) => Theme.of(context).brightness == Brightness.light ? Colors.lime.shade700 : Colors.lime.shade300;
  static Color limeVeryHighContrast(BuildContext context) => Theme.of(context).brightness == Brightness.light ? Colors.lime.shade900 : Colors.lime.shade100;
  // Blue Colors
  static Color blueVeryLowContrast(BuildContext context) => Theme.of(context).brightness == Brightness.light ? Colors.blue.shade100 : Colors.blue.shade900;
  static Color blueLowContrast(BuildContext context) => Theme.of(context).brightness == Brightness.light ? Colors.blue.shade300 : Colors.blue.shade700;
  static Color blue(BuildContext context) => Colors.blue;
  static Color blueHighContrast(BuildContext context) => Theme.of(context).brightness == Brightness.light ? Colors.blue.shade700 : Colors.blue.shade300;
  static Color blueVeryHighContrast(BuildContext context) => Theme.of(context).brightness == Brightness.light ? Colors.blue.shade900 : Colors.blue.shade100;
  // Cyan (Biru Muda) Colors
  static Color cyanVeryLowContrast(BuildContext context) => Theme.of(context).brightness == Brightness.light ? Colors.cyan.shade100 : Colors.cyan.shade900;
  static Color cyanLowContrast(BuildContext context) => Theme.of(context).brightness == Brightness.light ? Colors.cyan.shade300 : Colors.cyan.shade700;
  static Color cyan(BuildContext context) => Colors.cyan;
  static Color cyanHighContrast(BuildContext context) => Theme.of(context).brightness == Brightness.light ? Colors.cyan.shade700 : Colors.cyan.shade300;
  static Color cyanVeryHighContrast(BuildContext context) => Theme.of(context).brightness == Brightness.light ? Colors.cyan.shade900 : Colors.cyan.shade100;
  // Yellow Colors
  static Color yellowVeryLowContrast(BuildContext context) => Theme.of(context).brightness == Brightness.light ? Colors.yellow.shade100 : Colors.yellow.shade900;
  static Color yellowLowContrast(BuildContext context) => Theme.of(context).brightness == Brightness.light ? Colors.yellow.shade300 : Colors.yellow.shade700;
  static Color yellow(BuildContext context) => Colors.yellow;
  static Color yellowHighContrast(BuildContext context) => Theme.of(context).brightness == Brightness.light ? Colors.yellow.shade700 : Colors.yellow.shade300;
  static Color yellowVeryHighContrast(BuildContext context) => Theme.of(context).brightness == Brightness.light ? Colors.yellow.shade900 : Colors.yellow.shade100;
  // Orange Colors
  static Color orangeVeryLowContrast(BuildContext context) => Theme.of(context).brightness == Brightness.light ? Colors.orange.shade100 : Colors.orange.shade900;
  static Color orangeLowContrast(BuildContext context) => Theme.of(context).brightness == Brightness.light ? Colors.orange.shade300 : Colors.orange.shade700;
  static Color orange(BuildContext context) => Colors.orange;
  static Color orangeHighContrast(BuildContext context) => Theme.of(context).brightness == Brightness.light ? Colors.orange.shade700 : Colors.orange.shade300;
  static Color orangeVeryHighContrast(BuildContext context) => Theme.of(context).brightness == Brightness.light ? Colors.orange.shade900 : Colors.orange.shade100;
  // Purple Colors
  static Color purpleVeryLowContrast(BuildContext context) => Theme.of(context).brightness == Brightness.light ? Colors.purple.shade100 : Colors.purple.shade900;
  static Color purpleLowContrast(BuildContext context) => Theme.of(context).brightness == Brightness.light ? Colors.purple.shade300 : Colors.purple.shade700;
  static Color purple(BuildContext context) => Theme.of(context).brightness == Brightness.light ? Colors.purple : Colors.purple.shade300;
  static Color purpleHighContrast(BuildContext context) => Theme.of(context).brightness == Brightness.light ? Colors.purple.shade700 : Colors.purple.shade300;
  static Color purpleVeryHighContrast(BuildContext context) => Theme.of(context).brightness == Brightness.light ? Colors.purple.shade900 : Colors.purple.shade100;

  /// App Colors
  /// Imlementasi warna khusus untuk aplikasi
}