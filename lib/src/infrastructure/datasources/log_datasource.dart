import 'package:logger_ui/src/infrastructure/models/log_model.dart';

abstract class LogDatasource {
  Future<bool> createLog(LogModel payload);

  Future<List<LogModel>?> retrieveLog({String? flags});

  Future<List<String>?> retrieveFlags();

  Future<bool> readLog(List<int> ids);

  Future<bool> clearLog();

  Future<int> countLogs();
}
