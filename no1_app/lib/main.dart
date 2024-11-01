// lib/main.dart

import 'package:flutter/material.dart';

// Pages
import 'package:no1_app/pages/landing.dart';  
import 'package:no1_app/pages/home.dart';  
import 'package:no1_app/pages/add_data.dart';   
import 'package:no1_app/pages/experiment_log.dart';
import 'package:no1_app/pages/data_lab.dart'; 
import 'package:no1_app/pages/start_experiment.dart'; 

// Data
import 'package:no1_app/database/db_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the database
  await DBHelper().initializeDatabase();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'No1 App',
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
