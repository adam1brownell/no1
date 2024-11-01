// lib/pages/start_experiment.dart

import 'package:flutter/material.dart';
import 'package:no1_app/models/experiment_log.dart';
import 'package:no1_app/database/experiment_log_helper.dart';
import 'package:no1_app/database/user_info_helper.dart';
import 'package:no1_app/models/user_info.dart';

class StartExperimentPage extends StatefulWidget {
  const StartExperimentPage({Key? key}) : super(key: key);

  @override
  _StartExperimentPageState createState() => _StartExperimentPageState();
}

class _StartExperimentPageState extends State<StartExperimentPage> {
  final ExperimentLogHelper _experimentLogHelper = ExperimentLogHelper();
  final UserInfoHelper _userInfoHelper = UserInfoHelper();

  // Variables for the older UX
  String? selectedVariable;
  List<String> selectedDependentVariables = [];
  double experimentLength = 4; // Default length in weeks

  // Options for variables
  List<String> variableOptions = ['Variable X', 'Variable Y', 'Variable Z'];
  List<String> dependentVariableOptions = ['Outcome A', 'Outcome B', 'Outcome C'];

  // Function to show custom variable dialog (currently unsupported)
  void _showCustomVariableDialog(BuildContext context) {
    // Implement custom variable addition if needed
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Custom variables are not supported yet.')),
    );
  }

  // Function to show unsupported feature dialog
  void _showUnsupportedFeatureDialog(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('This feature is not supported yet.')),
    );
  }

  // Function to save the experiment
  Future<void> _saveExperiment() async {
    if (selectedVariable == null || selectedDependentVariables.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select variables.')),
      );
      return;
    }

    // Create ExperimentLog object
    ExperimentLog newExperiment = ExperimentLog(
      startDate: DateTime.now().toIso8601String(),
      endDate: null, // Experiment is ongoing
      indVar: selectedVariable,
      indSource: 'App', // Assuming the source is the app
      depVars: selectedDependentVariables,
      depVarSource: List.filled(selectedDependentVariables.length, 'App'),
    );

    // Insert into database
    try {
      int insertedId = await _experimentLogHelper.insertExperiment(newExperiment);
      print('Inserted experiment log with ID: $insertedId');

      // Update user_info to set activeExp to true
      UserInfo? userInfo = await _userInfoHelper.getUserInfo();
      if (userInfo != null) {
        userInfo.activeExp = true;
        await _userInfoHelper.saveUserInfo(userInfo);
      } else {
        // Initialize user_info if it doesn't exist
        userInfo = UserInfo(
          userName: 'User', // Default username, you can prompt the user for this
          age: 30, // Default age, you can prompt the user for this
          activeExp: true,
        );
        await _userInfoHelper.saveUserInfo(userInfo);
      }

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Experiment started successfully!')),
      );

      // Navigate back
      Navigator.pop(context);
    } catch (e) {
      // Handle errors
      print('Error inserting experiment log: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to start experiment.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Start Experiment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Independent Variable Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Independent Variable",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  tooltip: "Add Custom Variable",
                  onPressed: () {
                    _showCustomVariableDialog(context);
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
            DropdownButton<String>(
              hint: const Text("Select Variable"),
              value: selectedVariable,
              items: variableOptions.map((variable) {
                return DropdownMenuItem(
                  value: variable,
                  child: Text(variable),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedVariable = value;
                });
              },
            ),
            const SizedBox(height: 20),
            if (selectedVariable != null)
              Text(
                "Selected Independent Variable: $selectedVariable",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),

            const SizedBox(height: 40),

            // Dependent Variable Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Dependent Variable",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  tooltip: "Add Custom Dependent Variable",
                  onPressed: () {
                    _showUnsupportedFeatureDialog(context);
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10.0,
              children: dependentVariableOptions.map((variable) {
                return ChoiceChip(
                  label: Text(variable),
                  selected: selectedDependentVariables.contains(variable),
                  onSelected: (isSelected) {
                    setState(() {
                      isSelected
                          ? selectedDependentVariables.add(variable)
                          : selectedDependentVariables.remove(variable);
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            if (selectedDependentVariables.isNotEmpty)
              Text(
                "Selected Dependent Variables: ${selectedDependentVariables.join(', ')}",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),

            const SizedBox(height: 40),

            // Experiment Length Slider
            const Text(
              "Experiment Length",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Slider(
              value: experimentLength,
              min: 1,
              max: 12,
              divisions: 11,
              label: experimentLength.toInt().toString(),
              onChanged: (value) {
                setState(() {
                  experimentLength = value;
                });
              },
            ),
            Text(
              "${experimentLength.toInt()} weeks",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),

            Spacer(),

            // Start Experiment Button
            ElevatedButton(
              onPressed: _saveExperiment,
              child: Text('Start Experiment'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50), // Make button full-width
              ),
            ),
          ],
        ),
      ),
    );
  }
}
