import 'package:flutter/material.dart';

class StartExperimentPage extends StatefulWidget {
  const StartExperimentPage({Key? key}) : super(key: key);

  @override
  _StartExperimentPageState createState() => _StartExperimentPageState();
}

class _StartExperimentPageState extends State<StartExperimentPage> {
  String? selectedVariable;
  final List<String> variableOptions = ["A", "B", "C"];
  final List<String> dependentVariableOptions = ["X", "Y", "Z"];
  final List<String> selectedDependentVariables = [];
  double experimentLength = 7;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Start Experiment"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous page
          },
        ),
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
              min: 3,
              max: 60,
              divisions: 57,
              label: experimentLength.toInt().toString(),
              onChanged: (value) {
                setState(() {
                  experimentLength = value;
                });
              },
            ),
            Text(
              "${experimentLength.toInt()} days",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),

            const Spacer(),

            // Start Experiment Button
            Center(
              child: ElevatedButton(
                onPressed: (selectedVariable != null && selectedDependentVariables.isNotEmpty)
                    ? () {
                        // Logic to start experiment goes here
                        print("Experiment Started with $selectedVariable and $selectedDependentVariables for ${experimentLength.toInt()} weeks.");
                        Navigator.pop(context);
                      }
                    : null, // Disable button if conditions are not met
                child: const Text("Start Experiment"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCustomVariableDialog(BuildContext context) {
    final TextEditingController variableNameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Custom Variable"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: variableNameController,
                decoration: const InputDecoration(
                  labelText: "Name of variable",
                ),
              ),
              const SizedBox(height: 20),
              const Text("Are you going to track this manually?"),
            ],
          ),
          actions: [
            TextButton(
              child: const Text("Yes"),
              onPressed: () {
                _addCustomVariable(variableNameController.text);
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: const Text("No"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog without adding
              },
            ),
          ],
        );
      },
    );
  }

  void _addCustomVariable(String variableName) {
    setState(() {
      if (!variableOptions.contains(variableName) && variableName.isNotEmpty) {
        variableOptions.add(variableName);
        selectedVariable = variableName; // Automatically select the new variable
      }
    });
  }

  void _showUnsupportedFeatureDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("srry"),
          content: const Text("Currently, we cannot support this."),
          actions: [
            TextButton(
              child: const Text("k."),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }
}
