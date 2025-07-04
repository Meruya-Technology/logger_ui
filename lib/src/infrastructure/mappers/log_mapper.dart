import 'dart:convert';

import 'package:logger_ui/logger_ui.dart';
import 'package:logger_ui/src/infrastructure/mappers/payload_item_mapper.dart';

class LogMapper {
  static Log toEntity(LogModel model) {
    return Log(
      id: model.id,
      title: model.title,
      type: LogType.fromInt(model.type),
      flags: model.flags,
      payloads: model.payloads != null
          ? PayloadItemMapper.toListEntity(jsonDecode(model.payloads!))
          : null,
      createdAt: model.createdAt,
      isRead: model.isRead == 1 ? true : false,
      readedAt: model.readedAt,
    );
  }

  static LogModel toModel(Log model) {
    return LogModel(
      id: model.id,
      title: model.title,
      type: model.type.toInt,
      flags: model.flags,
      payloads: (model.payloads != null)
          ? PayloadItemMapper.toStringJson(model.payloads!)
          : null,
      createdAt: model.createdAt,
      isRead: model.isRead ? 1 : 0,
      readedAt: model.readedAt,
    );
  }
}
