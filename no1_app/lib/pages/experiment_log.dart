// lib/pages/experiment_log.dart

import 'package:flutter/material.dart';
import 'package:no1_app/models/experiment_log.dart';
import 'package:no1_app/database/experiment_log_helper.dart';

class ExperimentLogPage extends StatefulWidget {
  const ExperimentLogPage({Key? key}) : super(key: key);

  @override
  _ExperimentLogPageState createState() => _ExperimentLogPageState();
}

class _ExperimentLogPageState extends State<ExperimentLogPage> {
  final ExperimentLogHelper _experimentLogHelper = ExperimentLogHelper();
  List<ExperimentLog> _experiments = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadExperiments();
  }

  // Load experiments from the database
  Future<void> _loadExperiments() async {
    List<ExperimentLog> experiments =
        await _experimentLogHelper.getExperiments();
    setState(() {
      _experiments = experiments;
      _isLoading = false;
    });
  }

  // Build the experiment list
  Widget _buildExperimentList() {
    if (_experiments.isEmpty) {
      return Center(
        child: Text(
          "You have no experiments yet.",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      );
    } else {
      return ListView.builder(
        itemCount: _experiments.length,
        itemBuilder: (context, index) {
          ExperimentLog experiment = _experiments[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              title: Text('Experiment ${experiment.id}'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Start Date: ${experiment.startDate}'),
                  Text('End Date: ${experiment.endDate ?? "Ongoing"}'),
                  Text('Independent Variable: ${experiment.indVar}'),
                  Text('Independent Source: ${experiment.indSource}'),
                  Text('Dependent Variables: ${experiment.depVars?.join(", ")}'),
                  Text(
                      'Dependent Variable Sources: ${experiment.depVarSource?.join(", ")}'),
                ],
              ),
              isThreeLine: true,
            ),
          );
        },
      );
    }
  }

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
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _buildExperimentList(),
    );
  }
}
