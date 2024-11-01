// lib/database/user_info_helper.dart

import 'package:sqflite/sqflite.dart';
import 'package:no1_app/database/db_helper.dart';
import 'package:no1_app/models/user_info.dart';

class UserInfoHelper {
  final DBHelper _dbHelper = DBHelper();

  // Insert or update user info
  Future<int> saveUserInfo(UserInfo userInfo) async {
    final db = await _dbHelper.database;
    return await db.insert(
      'user_info',
      userInfo.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Retrieve user info
  Future<UserInfo?> getUserInfo() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'user_info',
      where: 'id = ?',
      whereArgs: [1],
    );
    if (maps.isNotEmpty) {
      return UserInfo.fromMap(maps.first);
    } else {
      return null;
    }
  }
}
