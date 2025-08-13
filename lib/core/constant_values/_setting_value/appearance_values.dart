import 'dart:ui';

enum ListFontType {
  segoe("Segoe UI"),
  apple("AppleSans"),
  google("GoogleSans"),
  arial("Arial Narrow"),
  cinzel("Cinzel"),
  nunito("Nunito");

  final String text;
  const ListFontType(this.text);
}

enum ListFontSize {
  verySmall("Sangat Kecil", 14.0),
  small("Kecil", 16.0),
  medium("Sedang", 18.0),
  large("Besar", 20.0),
  veryLarge("Sangat Besar", 24.0);

  final String text;
  final double value;
  const ListFontSize(this.text, this.value);
}

enum ListPreferredOrientation {
  active("Aktif", true),
  deactive("Non-Aktif", false);

  final String text;
  final bool condition;
  const ListPreferredOrientation(this.text, this.condition);
}

enum ListSafeAreaMode {
  active("Aktif", true),
  deactive("Non-Aktif", false);

  final String text;
  final bool condition;
  const ListSafeAreaMode(this.text, this.condition);
}

enum ListTabletMode {
  active("Aktif", true),
  deactive("Non-Aktif", false);

  final String text;
  final bool condition;
  const ListTabletMode(this.text, this.condition);
}

enum ListChangeToTabletMode {
  narrow("500 Pixel", 500),
  normal("600 Pixel", 600),
  wide("800 Pixel", 800),
  veryWide("1000 Pixel", 1000);

  final String text;
  final int value;
  const ListChangeToTabletMode(this.text, this.value);
}

enum ListThemeApp {
  light("Tema Terang", "Tampilan aplikasi secerah mentari di siang hari!", Brightness.light, 0),
  dark("Tema Gelap", "Malam hari dengan cahaya bintang yang gemerlap nan indah", Brightness.dark, 1),
  system("Tema Sistem", "Berganti terang dan gelap secara dinamis yang menakjubkan!", Brightness.light, 2),
  black("Tema Hitam", "Hitam dengan pantulan langit malam dan sinar rembulan", Brightness.light, 3);

  final String text;
  final String desc;
  final Brightness brightness;
  final int value;
  const ListThemeApp(this.text, this.desc, this.brightness, this.value);
}