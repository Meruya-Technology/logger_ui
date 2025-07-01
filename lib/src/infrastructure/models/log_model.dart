import 'dart:convert';

import 'package:flutter/services.dart';

class LogModel {
  final int? id;
  final String title;
  final String? payload;
  final int? payloadType;
  final String? flags;
  final int type;
  final int createdAt;
  final int isRead;
  final int? readedAt;

  LogModel({
    this.id,
    required this.title,
    this.payload,
    this.payloadType,
    this.flags,
    required this.type,
    required this.createdAt,
    this.isRead = 0, // 0 for false, 1 for true
    this.readedAt,
  });

  static String tableName = 'logs';

  factory LogModel.fromJson(Map<String, dynamic> json) => LogModel(
    id: json['id'],
    title: json['title'],
    flags: json['flags'],
    payload: json['payload'],
    payloadType: json['payload_type'],
    type: json['type'],
    createdAt: json['created_at'],
    isRead: json['is_read'],
    readedAt: json['readed_at'],
  );

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json['id'] = id;
    json['title'] = title;
    json['flags'] = flags;
    json['payload'] = payload;
    json['payload_type'] = payloadType;
    json['type'] = type;
    json['created_at'] = createdAt;
    json['is_read'] = isRead;
    json['readed_at'] = readedAt;
    return json;
  }

  static Future<Map<String, dynamic>> get migration async {
    final stringJson = await rootBundle.loadString(
      'packages/logger_ui/assets/log_scheme.json',
    );
    final migrateScript = json.decode(stringJson);
    return migrateScript;
  }
}
