import 'package:isar/isar.dart';

part 'log_app.g.dart';

@Collection()
class LogAppCollection {
  Id id = Isar.autoIncrement;

  DateTime? logDate;
  String? level;
  int? statusCode;
  String? title;
  String? subtitle;
  String? description;
  String? logs;
}