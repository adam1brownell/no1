import 'package:flutter/material.dart';
import 'package:no1_app/pages/add_data.dart';  // Import AddDataView

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController _textController = TextEditingController(); // Controller for input

    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
        automaticallyImplyLeading: false,
        actions: [
          // Add a button in the top-right corner that navigates to AddDataView
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Add Data',
            onPressed: () {
              // Navigate to AddDataView when the button is pressed
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddDataView()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome to the Home Page',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _textController,
              decoration: const InputDecoration(
                labelText: "Enter your text",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to the Home Page (self navigation)
                Navigator.pushNamed(context, '/home');
              },
              child: const Text('Start Experiment'),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigate to the Home Page (self navigation)
                Navigator.pushNamed(context, '/home');
              },
              child: const Text('Data Analysis'),
            )
          ],
        ),
      ),
    );
  }
}