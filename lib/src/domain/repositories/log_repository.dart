import '../entities/log.dart';

abstract class LogRepository {
  Future<bool> createLog(Log payload);

  Future<List<Log>?> retrieveLog({String? flags});

  Future<List<String>?> retrieveFlags();

  Future<bool> clearLog();

  Future<int> countLogs();

  Future<bool> readLog(List<int> ids);
}
