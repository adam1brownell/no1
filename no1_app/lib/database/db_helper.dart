// lib/database/db_helper.dart

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart'; // Import for accessing file system
import 'dart:async';
import 'dart:io';

class DBHelper {
  // Singleton pattern
  DBHelper._privateConstructor();
  static final DBHelper _instance = DBHelper._privateConstructor();
  factory DBHelper() => _instance;

  static Database? _database;

  // Public method to initialize the database
  Future<void> initializeDatabase() async {
    await deleteDatabaseFile(); // Delete the existing database file if it exists
    await database; // Initialize the database after deleting
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
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
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
        activeExp INTEGER
      )
    ''');
  }

  // Method to delete the existing database file
  Future<void> deleteDatabaseFile() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path, 'app_database.db');
    final file = File(path);

    if (await file.exists()) {
      await file.delete();
      print("Database file deleted.");
    }
  }
}
