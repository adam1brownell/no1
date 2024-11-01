// lib/helpers/data_retrieval_helper.dart

import 'package:no1_app/database/db_helper.dart';
import 'package:no1_app/models/experiment_log.dart';
import 'package:no1_app/database/experiment_log_helper.dart';

Future<void> getActiveExperimentData() async {
  ExperimentLogHelper experimentLogHelper = ExperimentLogHelper();

  // Get the active experiment(s) where end_date is NULL
  List<ExperimentLog> activeExperiments = await experimentLogHelper.getActiveExperiments();

  if (activeExperiments.isEmpty) {
    print('No active experiments found.');
    return;
  }

  // Assuming only one active experiment
  ExperimentLog activeExperiment = activeExperiments.first;

  String? startDate = activeExperiment.startDate;
  String endDate = activeExperiment.endDate ?? DateTime.now().toIso8601String();
  String? indVar = activeExperiment.indVar;
  String? indSource = activeExperiment.indSource;
  List<String>? depVars = activeExperiment.depVars;
  List<String>? depVarSources = activeExperiment.depVarSource;

  if (startDate == null || indVar == null || indSource == null || depVars == null || depVarSources == null) {
    print('Active experiment has incomplete data.');
    return;
  }

  // Get indVar data from indSource table between startDate and endDate
  print('\nIndependent Variable Data:');
  await getVariableData(indSource, indVar, startDate, endDate);

  // For each depVar and depVarSource, get data
  print('\nDependent Variables Data:');
  for (int i = 0; i < depVars.length; i++) {
    String depVar = depVars[i];
    String depVarSource = depVarSources[i];
    await getVariableData(depVarSource, depVar, startDate, endDate);
  }
}

Future<void> getVariableData(String tableName, String columnName, String startDate, String endDate) async {
  final db = await DBHelper().database;

  // Check if the table and column exist
  bool columnExists = await checkTableColumnExists(tableName, columnName);

  if (!columnExists) {
    print('Column $columnName does not exist in table $tableName.');
    return;
  }

  // Prepare the query
  String query = '''
    SELECT date, $columnName FROM $tableName
    WHERE date BETWEEN ? AND ?
    ORDER BY date ASC
  ''';

  List<Map<String, dynamic>> results = await db.rawQuery(query, [startDate, endDate]);

  // Print the data
  print('Data from table $tableName for column $columnName between $startDate and $endDate:');
  for (var row in results) {
    print('Date: ${row['date']}, $columnName: ${row[columnName]}');
  }
}

Future<bool> checkTableColumnExists(String tableName, String columnName) async {
  final db = await DBHelper().database;

  String query = '''
    PRAGMA table_info($tableName)
  ''';

  List<Map<String, dynamic>> tableInfo = await db.rawQuery(query);

  for (var columnInfo in tableInfo) {
    if (columnInfo['name'] == columnName) {
      return true;
    }
  }
  return false;
}
