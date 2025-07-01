export 'src/infrastructure/datasources/log_datasource.dart';
export 'src/infrastructure/datasources/log_datasource_impl.dart';
export 'src/infrastructure/repositories/log_repository_impl.dart';
export 'src/infrastructure/models/log_model.dart';
export 'src/infrastructure/mappers/log_mapper.dart';
export 'src/domain/repositories/log_repository.dart';
export 'src/domain/entities/log.dart';
export 'src/domain/entities/log_type.dart';
export 'src/domain/entities/payload_object.dart';
export 'src/domain/entities/payload_type.dart';
export 'src/presentation/pages/logger_list_page.dart';
export 'src/common/core/logger_stream_manager.dart';
import 'package:logger_ui/logger_ui.dart';
import 'package:sqflite/sqflite.dart';

import 'src/common/util/database_util.dart';

class LoggerUi {
  /// Dependency injection
  Database? database;
  LogDatasource? logDatasource;
  LogRepository? logRepository;
  LoggerStreamManager? loggerStreamManager;

  static final LoggerUi _instance = LoggerUi._internal();

  factory LoggerUi() {
    return _instance;
  }

  LoggerUi._internal();

  void initialize() async {
    await DatabaseUtil.initialize();
    await injectDependencies();
  }

  Future<void> injectDependencies() async {
    loggerStreamManager = LoggerStreamManager();
    database = await DatabaseUtil.connect();
    logDatasource = LogDatasourceImpl(database: database!);
    logRepository = LogRepositoryImpl(datasource: logDatasource!);
  }

  Future<bool>? clear() {
    final logRepository = _instance.logRepository;
    return logRepository?.clearLog();
  }

  Future<bool>? createLog(Log payload) {
    final logRepository = _instance.logRepository;
    return logRepository?.createLog(payload).whenComplete(() {
      notifyStream();
    });
  }

  Future<List<Log>?>? retrieveLogs({String? flags}) {
    final logRepository = _instance.logRepository;
    return logRepository?.retrieveLog(flags: flags);
  }

  Future<List<String>?>? retrieveFlags() {
    final logRepository = _instance.logRepository;
    return logRepository?.retrieveFlags();
  }

  Future<int> countLogs() {
    final logRepository = _instance.logRepository;
    return logRepository?.countLogs() ?? Future.value(0);
  }

  Future<bool>? read(List<int> ids) {
    final logRepository = _instance.logRepository;
    return logRepository?.readLog(ids);
  }

  Future<void> notifyStream() async {
    final recordCounts = await countLogs();
    LoggerStreamManager.sendData(recordCounts);
  }
}
