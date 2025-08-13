enum ListLanguage {
  indonesia("Indonesia", "id", "id_ID", "Rp");

  final String text;
  final String countryId;
  final String countryFormat;
  final String currency;
  const ListLanguage(this.text, this.countryId, this.countryFormat, this.currency);
}

enum ListTimeZone {
  jakartaWib("Asia/Jakarta"),
  makassarWita("Asia/Makassar"),
  jayapuraWit("Asia/Jayapura");

  final String text;
  const ListTimeZone(this.text);
}

enum ListDateFormat {
  dayMonthYear("31 Desember 2000", "d MMMM yyyy"),
  monthDayYear("Desember 31, 2000", "MMMM d, yyyy"),
  dayMonthYearHyphen("31-12-2000", "dd-MM-yyyy"),
  dayMonthYearSlash("31/12/2000", "dd/MM/yyyy"),
  monthDayYearHyphen("12-31-2000", "MM-dd-yyyy"),
  monthDayYearSlash("12/31/2000", "MM/dd/yyyy"),
  yearDayMonthHyphen("2000-31-12", "yyyy-dd-MM"),
  yearDayMonthSlash("2000/31/12", "yyyy/dd/MM"),
  yearMonthDayHyphen("2000-12-31", "yyyy-MM-dd"),
  yearMonthDaySlash("2000/12/31", "yyyy/MM/dd");

  final String text;
  final String pattern;
  const ListDateFormat(this.text, this.pattern);
}

enum ListTimeFormat {
  hourMinute("23:59", "HH:mm"),
  hourMinuteSecond("23:59:59", "HH:mm:ss"),
  hourMinuteMeridiem("11:59 PM", "hh:mm a"),
  hourMinuteSecondMeridiem("11:59:59 PM", "hh:mm:ss a");

  final String text;
  final String pattern;
  const ListTimeFormat(this.text, this.pattern);
}

enum ListUseAnimation {
  active("Aktif", true),
  deactive("Non-Aktif", false);

  final String text;
  final bool condition;
  const ListUseAnimation(this.text, this.condition);
}

enum ListUsePageTransition {
  active("Aktif", true),
  deactive("Non-Aktif", false);

  final String text;
  final bool condition;
  const ListUsePageTransition(this.text, this.condition);
}

enum ListUsePageAnimation {
  active("Aktif", true),
  deactive("Non-Aktif", false);

  final String text;
  final bool condition;
  const ListUsePageAnimation(this.text, this.condition);
}