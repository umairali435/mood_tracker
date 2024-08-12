import 'package:mood_tracker/models/moods_model.dart';
import 'package:mood_tracker/utils/keys.dart';
import 'package:mood_tracker/utils/mood_keys.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class MoodDataSource {
  static final MoodDataSource _instance = MoodDataSource._();

  factory MoodDataSource() => _instance;

  MoodDataSource._() {
    _initDb();
  }

  static Database? _database;

  Future<Database> get database async {
    _database ??= await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'moods.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  void _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE ${AppKeys.dbTable} (
        ${MoodKeys.id} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${MoodKeys.note} TEXT,
        ${MoodKeys.date} TEXT,
        ${MoodKeys.moodValue} TEXT
      )
    ''');
  }

  Future<int> addTask(MoodModel moodModel) async {
    final db = await database;
    return db.transaction((txn) async {
      return await txn.insert(
        AppKeys.dbTable,
        moodModel.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    });
  }

  Future<List<MoodModel>> getAllTasks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      AppKeys.dbTable,
      orderBy: "id DESC",
    );
    return List.generate(
      maps.length,
      (index) {
        return MoodModel.fromJson(maps[index]);
      },
    );
  }

  Future<int> updateTask(MoodModel moods) async {
    final db = await database;
    return db.transaction((txn) async {
      return await txn.update(
        AppKeys.dbTable,
        moods.toJson(),
        where: 'id = ?',
        whereArgs: [moods.id],
      );
    });
  }

  Future<int> deleteTask(MoodModel moods) async {
    final db = await database;
    return db.transaction(
      (txn) async {
        return await txn.delete(
          AppKeys.dbTable,
          where: 'id = ?',
          whereArgs: [moods.id],
        );
      },
    );
  }
}
