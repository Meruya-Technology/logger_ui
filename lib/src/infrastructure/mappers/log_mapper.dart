import 'package:logger_ui/src/domain/entities/log_type.dart';
import 'package:logger_ui/src/infrastructure/models/log_model.dart';

import '../../domain/entities/log.dart';

class LogMapper {
  static Log toEntity(LogModel model) => Log(
    id: model.id,
    title: model.title,
    type: LogType.fromInt(model.type),
    flags: model.flags,
    payload: model.payload,
    createdAt: model.createdAt,
    isRead: model.isRead == 1 ? true : false,
    readedAt: model.readedAt,
  );

  static LogModel toModel(Log model) => LogModel(
    id: model.id,
    title: model.title,
    type: model.type.toInt,
    flags: model.flags,
    payload: model.payload,
    createdAt: model.createdAt,
    isRead: model.isRead ? 1 : 0,
    readedAt: model.readedAt,
  );
}
