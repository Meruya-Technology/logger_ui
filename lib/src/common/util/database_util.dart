import 'package:flutter/material.dart';
import 'package:logger_ui/src/infrastructure/models/log_model.dart';
import 'package:sqflite/sqflite.dart';

import '../model/map_to_table.dart';

class DatabaseUtil {
  static const String databaseName = 'logger_ui.db';
  static const int databaseVersion = 1;

  static Future<Database> initialize() async {
    var database = openDatabase(
      databaseName,
      version: databaseVersion,
      onCreate: (Database db, int version) async {
        debugPrint('Database Created');
        await initializeTable(database: db, version: version);
      },
      onConfigure: (Database db) {
        debugPrint('Configuring Database..');
      },
      onOpen: (Database db) {
        debugPrint('Database Open & Connected');
      },
    );
    return database;
  }

  static Future<void> initializeTable({
    required Database database,
    required int version,
  }) async {
    await createTable(
      migrationScript: await LogModel.migration,
      database: database,
    );
  }

  static Future<void> createTable({
    required Database database,
    required Map<String, dynamic> migrationScript,
  }) async {
    /// Initialize query
    debugPrint('Initialize Table');
    var migrationObject = MapToTable.fromJson(migrationScript);
    var definitions = migrationObject.definition;
    var definitionLength = definitions?.length ?? 0;
    var query = '';

    /// DDL Building
    for (var i = 0; i < definitionLength; i++) {
      var definition = definitions?[i];
      if (definition?.fields != null) query += '${definition?.fields}';
      if (definition?.type != null) query += ' ${definition?.type}';
      if (definition?.attribute != null) query += ' ${definition?.attribute}';
      if ((definitionLength - 1) != i) query += ", ";
    }
    var ddl = '''create table ${migrationObject.tableName} ($query)''';

    /// Execute ddl
    await database
        .execute(ddl)
        .then((_) {
          debugPrint('DDL Executed DDL : $ddl');
        })
        .onError((error, stackTrace) {
          debugPrint('Error when execute DDL : ${stackTrace.toString()}');
        })
        .whenComplete(() => close(database));
  }

  static Future<Database> connect() async {
    var database = openDatabase(databaseName);
    return database;
  }

  static Future<void> close(Database database) async {
    await database.close();
  }
}
