// lib/models/experiment_log.dart

class ExperimentLog {
  int? id;
  String? startDate;
  String? endDate;
  String? indVar;
  String? indSource;
  List<String>? depVars;
  List<String>? depVarSource;

  ExperimentLog({
    this.id,
    this.startDate,
    this.endDate,
    this.indVar,
    this.indSource,
    this.depVars,
    this.depVarSource,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'start_date': startDate,
      'end_date': endDate,
      'ind_var': indVar,
      'ind_source': indSource,
      'dep_vars': depVars?.join(','), // Convert list to comma-separated string
      'dep_var_source': depVarSource?.join(','),
    };
  }

  factory ExperimentLog.fromMap(Map<String, dynamic> map) {
    return ExperimentLog(
      id: map['id'],
      startDate: map['start_date'],
      endDate: map['end_date'],
      indVar: map['ind_var'],
      indSource: map['ind_source'],
      depVars: map['dep_vars']?.split(','),
      depVarSource: map['dep_var_source']?.split(','),
    );
  }
}
