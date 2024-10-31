import 'package:flutter/material.dart';
import 'package:no1_app/pages/landing.dart';  
import 'package:no1_app/pages/home.dart';  
import 'package:no1_app/pages/add_data.dart';   
import 'package:no1_app/pages/experiment_log.dart';
import 'package:no1_app/pages/data_lab.dart'; 
import 'package:no1_app/pages/start_experiment.dart'; 


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LandingPage(), // Set LandingPage as the initial page
      routes: {
        '/home': (context) => const HomePage(),
        '/add_data': (context) => const AddDataView(),
        '/experiment_log': (context) => const ExperimentLogPage(),
        '/data_lab': (context) => const DataLabPage(),
        '/start_experiment': (context) => const StartExperimentPage(),
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: Center(
        child: Text(
          "Hello World",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}


"""

TODO: update main for database management

// lib/main.dart

import 'package:flutter/material.dart';
import 'package:your_app_name/database/datasets_helper.dart';
import 'package:your_app_name/database/experiment_log_helper.dart';
import 'package:your_app_name/database/user_info_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Setup dataset tables
  await setupDatasetTables();

  // Insert sample data
  await insertOuraData();
  await insertAppleData();
  await insertExperimentLog();
  await insertUserInfo();

  // Retrieve and print data
  await getOuraData();
  await getExperimentLogs();
  await getUserInfo();

  runApp(MyApp());
}

// Rest of your Flutter app code

class MyApp extends StatelessWidget {
  // Build your app here
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SQLite Example',
      home: Scaffold(
        appBar: AppBar(
          title: Text('SQLite Example'),
        ),
        body: Center(
          child: Text('Check console for output'),
        ),
      ),
    );
  }
}
"""