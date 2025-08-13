import 'dart:convert';

class NotificationModel {
  final int? id;
  final String? title;
  final String? description;
  final String? type;
  final Map<String, dynamic>? raw;

  NotificationModel({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.raw,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: 1,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      type: json['type'] ?? '',
      raw: json['raw'] ?? {},
    );
  }

  factory NotificationModel.fromPayloadJson(dynamic json) {
    return NotificationModel.fromJson(jsonDecode(json.payload ?? '{}'));
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type,
      'raw': raw,
    };
  }
}