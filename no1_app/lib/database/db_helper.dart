// lib/database/db_helper.dart

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;

  static Database? _database;

  DBHelper._internal();

  // Public method to initialize the database
  Future<void> initializeDatabase() async {
    await database;
  }

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
      version: 2, // Incremented version for schema changes
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
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
        age INTEGER,
        activeExp INTEGER,
        ouraPullDate TEXT
      )
    ''');

    // Create oura table
    await db.execute('''
      CREATE TABLE oura (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT,
        data TEXT
      )
    ''');
  }

  // Handle database upgrades
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Add ouraPullDate to user_info table if it doesn't exist
      await db.execute('ALTER TABLE user_info ADD COLUMN ouraPullDate TEXT');

      // Create oura table
      await db.execute('''
        CREATE TABLE IF NOT EXISTS oura (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          date TEXT,
          data TEXT
        )
      ''');
    }
  }
}
