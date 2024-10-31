import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;

  static Database? _database;

  DBHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    // Initialize the database
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'app_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  FutureOr<void> _onCreate(Database db, int version) async {
    // Create experiment_log table
    await db.execute('''
      CREATE TABLE experiment_log (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        start_date TEXT,
        end_date TEXT,
        ind_var TEXT,
        ind_source TEXT,
        dep_vars TEXT,
        dep_var_source TEXT
      )
    ''');

    // Create user_info table
    await db.execute('''
      CREATE TABLE user_info (
        id INTEGER PRIMARY KEY,
        user_name TEXT,
        activeExp INTEGER
      )
    ''');

    // Create datasets tables (e.g., oura, apple)
    await db.execute('''
      CREATE TABLE oura (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT,
        steps INTEGER,
        hrv INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE apple (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT,
        hearbeats INTEGER,
        sleep TEXT
      )
    ''');
  }
}
