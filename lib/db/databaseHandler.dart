import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:gymapp/models/exercise.dart';

class ExerciseDatabase {
  static final ExerciseDatabase instance = ExerciseDatabase._init();

  static Database? _database;

  ExerciseDatabase._init();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDB('exercises.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final exerciseTextType = 'STRING';
    final weightsType = 'TEXT';
    final updateDatesType = 'TEXT';
    await db.execute('''
    CREATE TABLE $tableExercise (
      ${ExerciseFields.id} $idType,
      ${ExerciseFields.exerciseText} $exerciseTextType,
      ${ExerciseFields.weights} $weightsType,
      ${ExerciseFields.updateDates} $updateDatesType
    )
''');
  }

  Future<List<Exercise>> readAllExercises() async {
    final db = await instance.database;

    final result = await db.query(tableExercise);

    return result.map((json) => Exercise.fromJson(json)).toList();
  }

  Future<Exercise> addExercise(Exercise exercise) async {
    final db = await instance.database;

    final id = await db.insert(tableExercise, exercise.toJson());
    return exercise.copy(id: id);
  }

  Future<int> updateExercise(Exercise exercise) async {
    final db = await instance.database;

    return db.update(
      tableExercise,
      exercise.toJson(),
      where: '${ExerciseFields.id} = ?',
      whereArgs: [exercise.id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
