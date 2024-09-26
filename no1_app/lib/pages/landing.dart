import 'package:flutter/material.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Landing Page"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Navigate to the Home Page
            Navigator.pushNamed(context, '/home');
          },
          child: const Text('Go to Home Page'),
        ),
      ),
    );
  }
}