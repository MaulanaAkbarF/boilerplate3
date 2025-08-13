class LogAppSqflite {
  int? id;
  DateTime? logDate;
  String? level;
  int? statusCode;
  String? title;
  String? subtitle;
  String? description;
  String? logs;

  LogAppSqflite({
    this.id,
    this.logDate,
    this.level,
    this.statusCode,
    this.title,
    this.subtitle,
    this.description,
    this.logs,
  });

  // Convert dari Map ke LogAppSqflite
  factory LogAppSqflite.fromMap(Map<String, dynamic> map) {
    return LogAppSqflite(
      id: map['id'],
      logDate: map['logDate'] != null ? DateTime.parse(map['logDate']) : null,
      level: map['level'],
      statusCode: map['statusCode'],
      title: map['title'],
      subtitle: map['subtitle'],
      description: map['description'],
      logs: map['logs'],
    );
  }

  // Convert dari LogAppSqflite ke Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'logDate': logDate?.toIso8601String(),
      'level': level,
      'statusCode': statusCode,
      'title': title,
      'subtitle': subtitle,
      'description': description,
      'logs': logs,
    };
  }
}