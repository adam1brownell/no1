// lib/database/user_info_helper.dart

import 'package:no1_app/models/user_info.dart';
import 'package:no1_app/database/db_helper.dart';

class UserInfoHelper {
  final DBHelper _dbHelper = DBHelper();

  Future<int> insertUserInfo(UserInfo userInfo) async {
    final db = await _dbHelper.database;
    return await db.insert(
      'user_info',
      userInfo.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<UserInfo?> getUserInfo() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps =
        await db.query('user_info', where: 'id = ?', whereArgs: [1]);
    if (maps.isNotEmpty) {
      return UserInfo.fromMap(maps.first);
    }
    return null;
  }

  // Add update and delete functions as needed
}
