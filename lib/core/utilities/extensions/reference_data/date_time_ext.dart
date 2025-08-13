import 'package:intl/intl.dart';

extension DateTimeExtensions on DateTime {
  /// Formats the date as a day of the month (1-31).
  String d({locale}) => DateFormat.d(locale).format(this);

  /// Formats the date as an abbreviated day of the week (Mon, Tue, etc.).
  String E({locale}) => DateFormat.E(locale).format(this);

  /// Formats the date as a full day of the week (Monday, Tuesday, etc.).
  String EEEE({locale}) => DateFormat.EEEE(locale).format(this);

  /// Formats the date as a narrow day of the week (M, T, etc.).
  String EEEEE({locale}) => DateFormat.EEEEE(locale).format(this);

  /// Formats the date as an abbreviated month (Jan, Feb, etc.).
  String LLL({locale}) => DateFormat.LLL(locale).format(this);

  /// Formats the date as a full month (January, February, etc.).
  String LLLL({locale}) => DateFormat.LLLL(locale).format(this);

  /// Formats the date as a numeric month (1-12).
  String M({locale}) => DateFormat.M(locale).format(this);

  /// Formats the date as a numeric month and day (MM/dd).
  String Md({locale}) => DateFormat.Md(locale).format(this);

  /// Formats the date as an abbreviated day of the week, numeric month, and day (EEE, MM/dd).
  String MEd({locale}) => DateFormat.MEd(locale).format(this);

  /// Formats the date as an abbreviated month and day (MMM dd).
  String MMM({locale}) => DateFormat.MMM(locale).format(this);

  /// Formats the date as an abbreviated month, day, and year (MMM dd, yyyy).
  String MMMd({locale}) => DateFormat.MMMd(locale).format(this);

  /// Formats the date as an abbreviated day of the week, month, and day (EEE, MMM dd).
  String MMMEd({locale}) => DateFormat.MMMEd(locale).format(this);

  /// Formats the date as a full month (MMMM).
  String MMMM({locale}) => DateFormat.MMMM(locale).format(this);

  /// Formats the date as a full month and day (MMMM dd).
  String MMMMd({locale}) => DateFormat.MMMMd(locale).format(this);

  /// Formats the date as a full day of the week, month, and day (EEEE, MMMM dd).
  String MMMMEEEEd({locale}) => DateFormat.MMMMEEEEd(locale).format(this);

  /// Formats the date as an abbreviated quarter (Q1, Q2, etc.).
  String QQQ({locale}) => DateFormat.QQQ(locale).format(this);

  /// Formats the date as a full quarter (1st quarter, 2nd quarter, etc.).
  String QQQQ({locale}) => DateFormat.QQQQ(locale).format(this);

  /// Formats the date as a numeric year (yyyy).
  String y({locale}) => DateFormat.y(locale).format(this);

  /// Formats the date as a numeric year and month (yyyy-MM).
  String yM({locale}) => DateFormat.yM(locale).format(this);

  /// Formats the date as a numeric year, month, and day (yyyy-MM-dd).
  String yMd({locale}) => DateFormat.yMd(locale).format(this);

  /// Formats the date as an abbreviated day of the week, numeric year, month, and day (EEE, yyyy-MM-dd).
  String yMEd({locale}) => DateFormat.yMEd(locale).format(this);

  /// Formats the date as an abbreviated year, month, and day (MMM yyyy).
  String yMMM({locale}) => DateFormat.yMMM(locale).format(this);

  /// Formats the date as an abbreviated year, month, and day (MMM dd, yyyy).
  String yMMMd({locale}) => DateFormat.yMMMd(locale).format(this);

  /// Formats the date as an abbreviated day of the week, year, month, and day (EEE, MMM dd, yyyy).
  String yMMMEd({locale}) => DateFormat.yMMMEd(locale).format(this);

  /// Formats the date as a full year and month (MMMM yyyy).
  String yMMMM({locale}) => DateFormat.yMMMM(locale).format(this);

  /// Formats the date as a full year, month, and day (MMMM dd, yyyy).
  String yMMMMd({locale}) => DateFormat.yMMMMd(locale).format(this);

  /// Formats the date as a full day of the week, year, month, and day (EEEE, MMMM dd, yyyy).
  String yMMMMEEEEd({locale}) => DateFormat.yMMMMEEEEd(locale).format(this);

  /// Formats the date as an abbreviated year and quarter (Q1 yyyy).
  String yQQQ({locale}) => DateFormat.yQQQ(locale).format(this);

  /// Formats the date as a full year and quarter (1st quarter yyyy).
  String yQQQQ({locale}) => DateFormat.yQQQQ(locale).format(this);

  /// Formats the time as a 24-hour clock hour (0-23).
  String H({locale}) => DateFormat.H(locale).format(this);

  /// Formats the time as a 24-hour clock hour and minute (HH:mm).
  String Hm({locale}) => DateFormat.Hm(locale).format(this);

  /// Formats the time as a 24-hour clock hour, minute, and second (HH:mm:ss).
  String Hms({locale}) => DateFormat.Hms(locale).format(this);

  /// Formats the time as a 12-hour clock hour (1-12).
  String j({locale}) => DateFormat.j(locale).format(this);

  /// Formats the time as a 12-hour clock hour and minute (h:mm a).
  String jm({locale}) => DateFormat.jm(locale).format(this);

  /// Formats the time as a 12-hour clock hour, minute, and second (h:mm:ss a).
  String jms([locale]) => DateFormat.jms([locale]).format(this);

  DateTime get startOfDay => DateTime(year, month, day);
  DateTime get endOfDay => DateTime(year, month, day, 23, 59, 59, 999, 999);
}