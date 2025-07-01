import 'package:flutter/material.dart';
import 'package:logger_ui/src/infrastructure/datasources/log_datasource.dart';
import 'package:logger_ui/src/infrastructure/models/log_model.dart';
import 'package:sqflite/sqflite.dart';

class LogDatasourceImpl implements LogDatasource {
  final Database database;

  LogDatasourceImpl({required this.database});
  @override
  Future<bool> createLog(LogModel payload) async {
    var id = await database.insert(LogModel.tableName, payload.toJson());
    return (id != 0);
  }

  @override
  Future<List<LogModel>?> retrieveLog({String? flags}) async {
    // Construct the WHERE clause with LIKE statements
    List<String>? searchFlagList = flags?.split(',') ?? [];

    final whereClause = searchFlagList
        .map((flag) => 'flags LIKE ?')
        .join(' OR ');

    // Prepare the where arguments with appropriate wildcards
    List<String> whereArgs = searchFlagList.map((flag) => '%$flag%').toList();

    List<Map<String, Object?>> rows = await database.query(
      LogModel.tableName,
      where: flags != null ? whereClause : null,
      whereArgs: whereArgs, // Correctly pass the where arguments
      orderBy: 'created_at DESC',
    );

    var models = List<LogModel>.from(rows.map((row) => LogModel.fromJson(row)));
    return rows.isNotEmpty ? models : null;
  }

  @override
  Future<bool> clearLog() async {
    var id = await database.delete(LogModel.tableName);
    return (id != 0);
  }

  @override
  Future<int> countLogs() async {
    final List<Map<String, dynamic>> result = await database.rawQuery(
      'SELECT COUNT(*) FROM ${LogModel.tableName} WHERE is_read = 0',
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  @override
  Future<bool> readLog(List<int> ids) {
    if (ids.isEmpty) return Future.value(false);
    final timeStamp = DateTime.now().millisecondsSinceEpoch;
    // Update the isRead field to 1 (true) for the given ids
    return database
        .transaction((txn) async {
          final batch = txn.batch();
          for (var logId in ids) {
            batch.update(
              LogModel.tableName,
              {'is_read': 1, 'readed_at': timeStamp},
              where: 'id = ?',
              whereArgs: [logId],
            );
          }
          await batch.commit(noResult: true);
          return true;
        })
        .catchError((error) {
          debugPrint('Error updating logs: $error');
          return false;
        });
  }

  @override
  Future<List<String>?> retrieveFlags() async {
    final List<Map<String, dynamic>> results = await database.query(
      LogModel.tableName,
      columns: ['flags'],
    );

    Set<String> uniqueFlags = {};

    for (var row in results) {
      // Assuming flags are stored in a column named 'flags'
      String? flagString = row['flags'] as String?;
      if (flagString != null) {
        final flags = flagString.split(',');
        uniqueFlags.addAll(flags.map((flag) => flag.trim()));
      }
    }
    return uniqueFlags.isNotEmpty ? uniqueFlags.toList() : null;
  }
}
