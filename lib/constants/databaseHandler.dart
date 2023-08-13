import 'dart:async';
import 'package:gymapp/models/exercise.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHandler {
  static final DatabaseHandler _databaseHandler = DatabaseHandler._();

  DatabaseHandler._();

  late Database db;

  factory DatabaseHandler() {
    return _databaseHandler;
  }

  Future<void> initDB() async {
    String path = await getDatabasesPath();
    db = await openDatabase(
      join(path, 'exercises.db'),
      onCreate: (database, version) async {
        await database.execute(
          """
            CREATE TABLE exercises (
              id INTEGER PRIMARY KEY AUTOINCREMENT, 
              exerciseText TEXT NOT NULL,
              weights INTEGER ARRAY NOT NULL
            )
          """,
        );
      },
      version: 1,
    );
  }
}
