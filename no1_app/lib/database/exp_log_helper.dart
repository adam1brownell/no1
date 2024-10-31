// lib/database/experiment_log_helper.dart

import 'package:no1_app/models/experiment_log.dart';
import 'package:no1_app/database/db_helper.dart';

class ExperimentLogHelper {
  final DBHelper _dbHelper = DBHelper();

  Future<int> insertExperiment(ExperimentLog experiment) async {
    final db = await _dbHelper.database;
    return await db.insert('experiment_log', experiment.toMap());
  }

  Future<List<ExperimentLog>> getExperiments() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('experiment_log');
    return List.generate(maps.length, (i) {
      return ExperimentLog.fromMap(maps[i]);
    });
  }

  // Add update and delete functions as needed
}
