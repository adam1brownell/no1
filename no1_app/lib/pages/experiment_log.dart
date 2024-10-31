import 'package:flutter/material.dart';

class ExperimentLogPage extends StatelessWidget {
  const ExperimentLogPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Experiment Log"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous page
          },
        ),
      ),
      body: Center(
        child: const Text(
          "You have no experiments yet.",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

"""
Pulling from Experiment Log

void insertExperimentLog() async {
  ExperimentLogHelper experimentLogHelper = ExperimentLogHelper();

  ExperimentLog experiment = ExperimentLog(
    startDate: '2024-10-03',
    endDate: null,
    indVar: 'X',
    indSource: 'garmin',
    depVars: ['A', 'B', 'C'],
    depVarSource: ['garmin', 'garmin', 'apple'],
  );

  await experimentLogHelper.insertExperiment(experiment);
}

void getExperimentLogs() async {
  ExperimentLogHelper experimentLogHelper = ExperimentLogHelper();

  List<ExperimentLog> experiments =
      await experimentLogHelper.getExperiments();
  for (var experiment in experiments) {
    print(experiment.toMap());
  }
}

"""
