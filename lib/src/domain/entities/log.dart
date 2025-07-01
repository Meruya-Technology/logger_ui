import 'package:logger_ui/src/domain/entities/log_type.dart';

class Log {
  final int? id;
  final String title;
  final String? payload;
  final String? flags;
  final LogType type;
  final int createdAt;
  final bool isRead;
  final int? readedAt;

  Log({
    this.id,
    required this.title,
    this.payload,
    this.flags,
    required this.type,
    required this.createdAt,
    this.isRead = false,
    this.readedAt,
  });
}
