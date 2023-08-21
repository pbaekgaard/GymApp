// ignore_for_file: file_names

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:gymapp/models/exercise.dart';
import 'package:gymapp/models/gym.dart';

class AppDatabase {
  static final AppDatabase instance = AppDatabase._init();

  static Database? _database;

  AppDatabase._init();

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
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const exerciseTextType = 'TEXT NOT NULL';
    const weightsType = 'TEXT NOT NULL';
    const exerciseRepsType = 'TEXT NOT NULL';
    const exercisePartType = 'TEXT NOT NULL';
    const updateDatesType = 'TEXT NOT NULL';
    const gymNameType = 'TEXT NOT NULL';
    const gymColorType = 'INTEGER NOT NULL';
    const exerciseGymColorType = 'INTEGER';
    const exerciseGymType = 'TEXT';
    await db.execute('''
    CREATE TABLE $tableExercise (
      ${ExerciseFields.id} $idType,
      ${ExerciseFields.exerciseText} $exerciseTextType,
      ${ExerciseFields.weights} $weightsType,
      ${ExerciseFields.updateDates} $updateDatesType,
      ${ExerciseFields.gym} $exerciseGymType,
      ${ExerciseFields.gymColor} $exerciseGymColorType,
      ${ExerciseFields.reps} $exerciseRepsType,
      ${ExerciseFields.bodyPart} $exercisePartType
    )''');
    await db.execute('''
      CREATE TABLE $tableGym (
        ${GymFields.id} $idType,
        ${GymFields.gymName} $gymNameType,
        ${GymFields.color} $gymColorType
      )
''');
  }

  Future<List<Exercise>> readAllExercises() async {
    final db = await instance.database;

    final result = await db.query(tableExercise);

    return result.map((json) => Exercise.fromJson(json)).toList();
  }

  Future<List<Gym>> getGyms() async {
    final db = await instance.database;

    final result = await db.query(tableGym);

    return result.map((json) => Gym.fromJson(json)).toList();
  }

  Future<Gym> addGym(Gym gym) async {
    final db = await instance.database;

    final id = await db.insert(tableGym, gym.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return gym.copy(id: id);
  }

  Future<int> updateGym(Gym gym) async {
    final db = await instance.database;

    return db.update(
      tableGym,
      gym.toJson(),
      where: '${GymFields.id} = ?',
      whereArgs: [gym.id],
    );
  }

  Future<int> removeGym(Gym gym) async {
    final db = await instance.database;

    return db.delete(tableGym, where: '${GymFields.id}=?', whereArgs: [gym.id]);
  }

  Future<Exercise> addExercise(Exercise exercise) async {
    final db = await instance.database;

    final id = await db.insert(tableExercise, exercise.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
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

  Future<int> removeExercise(Exercise exercise) async {
    final db = await instance.database;

    return db.delete(tableExercise,
        where: '${ExerciseFields.id}=?', whereArgs: [exercise.id]);
  }
}
