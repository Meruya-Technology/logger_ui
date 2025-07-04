import 'package:flutter/material.dart';
import 'package:logger_ui/src/domain/entities/log.dart';
import 'package:logger_ui/src/domain/repositories/log_repository.dart';
import 'package:logger_ui/src/infrastructure/datasources/log_datasource.dart';
import 'package:logger_ui/src/infrastructure/mappers/log_mapper.dart';

class LogRepositoryImpl implements LogRepository {
  final LogDatasource datasource;
  LogRepositoryImpl({required this.datasource});

  @override
  Future<bool> clearLog() {
    final result = datasource.clearLog();
    return result;
  }

  @override
  Future<bool> createLog(Log payload) {
    final result = datasource.createLog(LogMapper.toModel(payload));
    return result;
  }

  @override
  Future<List<Log>?> retrieveLog({String? flags}) async {
    final models = await datasource.retrieveLog(flags: flags);
    debugPrint('Payloads: ${models?.length}');
    return models != null
        ? List<Log>.from(models.map((model) => LogMapper.toEntity(model)))
        : null;
  }

  @override
  Future<List<String>?> retrieveFlags() {
    final result = datasource.retrieveFlags();
    return result;
  }

  @override
  Future<int> countLogs() {
    final result = datasource.countLogs();
    return result;
  }

  @override
  Future<bool> readLog(List<int> ids) {
    final result = datasource.readLog(ids);
    return result;
  }
}
