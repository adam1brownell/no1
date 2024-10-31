import 'package:flutter/material.dart';
import 'package:no1_app/pages/landing.dart';  
import 'package:no1_app/pages/home.dart';  
import 'package:no1_app/pages/add_data.dart';   


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
        '/home': (context) => const HomePage(), // Define route for Home Page
        '/add_data': (context) => const AddDataView(), // Define route for AddDataView
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