import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../../../../global_values/global_data.dart';
import '../../../functions/logger_func.dart';

class SqfliteDatabaseHelper {
  static Database? database;
  static const String databaseName = 'logapp.db';
  static const int databaseVersion = 1;
  static const String tableName = 'log_app';

  static Future<Database> get databases async {
    database ??= await initializeSqflite();
    return database!;
  }

  static Future<Database> initializeSqflite() async {
    try {
      String path = join(await getDatabasesPath(), databaseName);
      return await openDatabase(
        path,
        version: databaseVersion,
        onCreate: onCreate,
      );
    } catch (e, s) {
      GlobalData.sqfliteFailedMessage = 'Terjadi masalah saat mengisiasi SQLite DB: $e';
      clog('Terjadi masalah saat mengisiasi SQLite DB: $e\n$s');
      rethrow;
    }
  }

  static Future<void> onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        logDate TEXT,
        level TEXT,
        statusCode INTEGER,
        title TEXT,
        subtitle TEXT,
        description TEXT,
        logs TEXT
      )
    ''');
  }

  static Future<void> closeDatabase() async {
    if (database != null) {
      await database!.close();
      database = null;
    }
  }
}