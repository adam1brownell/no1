// lib/database/experiment_log_helper.dart

import 'package:sqflite/sqflite.dart';
import 'package:no1_app/database/db_helper.dart';
import 'package:no1_app/models/experiment_log.dart';

class ExperimentLogHelper {
  final DBHelper _dbHelper = DBHelper();

  // Insert a new experiment log
  Future<int> insertExperiment(ExperimentLog experiment) async {
    final db = await _dbHelper.database;
    return await db.insert('experiment_log', experiment.toMap());
  }

  // Retrieve all experiment logs
  Future<List<ExperimentLog>> getExperiments() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('experiment_log');
    return List.generate(maps.length, (i) {
      return ExperimentLog.fromMap(maps[i]);
    });
  }

  // Retrieve active experiments (where end_date is NULL)
  Future<List<ExperimentLog>> getActiveExperiments() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'experiment_log',
      where: 'end_date IS NULL',
    );
    return List.generate(maps.length, (i) {
      return ExperimentLog.fromMap(maps[i]);
    });
  }
  // Additional methods (update, delete) can be added as needed
}
