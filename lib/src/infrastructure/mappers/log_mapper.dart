import 'package:logger_ui/src/domain/entities/log_type.dart';
import 'package:logger_ui/src/infrastructure/mappers/payload_object_mapper.dart';
import 'package:logger_ui/src/infrastructure/models/log_model.dart';

import '../../domain/entities/log.dart';
import '../../domain/entities/payload_type.dart';

class LogMapper {
  static Log toEntity(LogModel model) {
    final payloadType = model.payloadType != null
        ? PayloadType.fromInt(model.payloadType!)
        : null;
    return Log(
      id: model.id,
      title: model.title,
      type: LogType.fromInt(model.type),
      flags: model.flags,
      payload: payloadType == PayloadType.list
          ? PayloadObjectMapper.toEntity(model.payload!)
          : model.payload,
      payloadType: payloadType,
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
      payload: model.payloadType == PayloadType.list
          ? PayloadObjectMapper.toStringJson(model.payload!)
          : model.payload,
      payloadType: model.payloadType?.toInt(),
      createdAt: model.createdAt,
      isRead: model.isRead ? 1 : 0,
      readedAt: model.readedAt,
    );
  }
}
