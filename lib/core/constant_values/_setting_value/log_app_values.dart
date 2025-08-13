enum ListLogAppLevel {
  negligible("[1] Negligible"),
  low("[2] Low"),
  moderate("[3] Moderate"),
  severe("[4] Severe"),
  critical("[5] Critical");

  final String level;
  const ListLogAppLevel(this.level);
}