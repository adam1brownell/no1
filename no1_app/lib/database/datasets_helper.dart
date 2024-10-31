// lib/database/datasets_helper.dart

import 'package:no1_app/models/dataset_entry.dart';
import 'package:no1_app/database/db_helper.dart';

class DatasetsHelper {
  final DBHelper _dbHelper = DBHelper();

  // Insert data into a dataset table
  Future<int> insertData(String tableName, DatasetEntry entry) async {
    final db = await _dbHelper.database;
    return await db.insert(tableName, entry.toMap());
  }

  // Retrieve data from a dataset table
  Future<List<DatasetEntry>> getData(String tableName) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(tableName);
    return List.generate(maps.length, (i) {
      return DatasetEntry.fromMap(maps[i]);
    });
  }

  // Create a dataset table dynamically
  Future<void> createDatasetTable(String tableName, Map<String, String> columns) async {
    final db = await _dbHelper.database;
    String columnsSQL =
        columns.entries.map((e) => '${e.key} ${e.value}').join(', ');
    await db.execute('CREATE TABLE IF NOT EXISTS $tableName ($columnsSQL);');
  }
}
