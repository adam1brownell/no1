import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _textController = TextEditingController(); // Controller for input
  List<double> x = [1, 2, 3, 4, 5];
  List<double> y = [10, 20, 15, 30, 25];
  final PageController _pageController = PageController();
  bool activeExp = false;

  String fullText = "Hello! How are you?"; // First message from the app
  String userInput = "";
  String serverResponse = "";

  List<Map<String, dynamic>> conversationHistory = []; // Stores conversation history with role info

  @override
  void initState() {
    super.initState();
    // Add the first app message as soon as the app starts
    addMessage(fullText, isUser: false);
  }

  // Function to add messages to the conversation history
  void addMessage(String message, {required bool isUser}) {
    setState(() {
      conversationHistory.add({
        'message': message,
        'isUser': isUser,
      });
    });
  }

  Future<void> pingNgrokServer(String inputText) async {
    try {
      // Replace with your ngrok URL
      var url = Uri.parse('https://6742-34-74-29-202.ngrok-free.app/chat');
      var response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"text": inputText}),
      );

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        setState(() {
          serverResponse = responseData['response'];
          // Add the bot's response to the conversation
          addMessage(serverResponse, isUser: false);
        });
      } else {
        setState(() {
          serverResponse = "Failed to get a response from the server.";
        });
      }
    } catch (e) {
      setState(() {
        serverResponse = "Error: $e";
      });
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Add Data',
            onPressed: () {
              // Add your navigation logic here
            },
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 300,
            child: Column(
              children: [
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    children: [
                      buildLineChart(x, y), // First chart
                      buildLineChart(x, x), // Second chart
                    ],
                  ),
                ),
                SmoothPageIndicator(
                  controller: _pageController,
                  count: 2, // Number of pages
                  effect: ExpandingDotsEffect(
                    activeDotColor: Colors.blue, // Active dot color
                    dotColor: Colors.grey, // Inactive dot color
                    dotHeight: 8.0,
                    dotWidth: 8.0,
                    spacing: 8.0,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    activeExp = !activeExp;
                    print("Experiment Button Clicked, Active: $activeExp");
                  });
                },
                child: Text(activeExp ? 'Stop Experiment' : 'Start Experiment'),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  // Navigate to the Data Analysis screen (replace with the actual route)
                  Navigator.pushNamed(context, '/data_analysis');
                },
                child: const Text('Data Analysis'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: conversationHistory.length,
              itemBuilder: (context, index) {
                bool isUser = conversationHistory[index]['isUser'];
                String message = conversationHistory[index]['message'];
                return Row(
                  mainAxisAlignment:
                      isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 14,
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
                      decoration: BoxDecoration(
                        color: isUser ? Colors.blue[100] : Colors.grey[300],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        message,
                        style: TextStyle(
                          fontSize: 16,
                          color: isUser ? Colors.black : Colors.black,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      decoration: const InputDecoration(
                        labelText: "Enter text",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () {
                      setState(() {
                        userInput = _textController.text; // Capture user input
                        addMessage(userInput, isUser: true); // Add user message to conversation
                        pingNgrokServer(userInput); // Ping the server with input
                        _textController.clear(); // Clear the input field
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Function to build the Line Chart
  Widget buildLineChart(List<double> x, List<double> y) {
    return LineChart(
      LineChartData(
        gridData: FlGridData(show: false), // Disable grid/tick marks
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true, getTitlesWidget: (value, meta) {
              return Text(value.toInt().toString()); // Y-axis values
            }),
          ),
          bottomTitles: AxisTitles(
            axisNameWidget: const Padding(
              padding: EdgeInsets.only(top: 16.0), // Space for axis label
              child: Text('Days', style: TextStyle(fontSize: 16)), // X-axis label
            ),
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                return Text(value.toInt().toString()); // X-axis values
              },
            ),
          ),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false), // Hide right side numbers
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false), // Hide top numbers
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border(
            top: BorderSide.none, // Hide top border
            right: BorderSide.none, // Hide right border
            left: const BorderSide(width: 1), // Keep left border
            bottom: const BorderSide(width: 1), // Keep bottom border
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: List.generate(x.length, (index) => FlSpot(x[index], y[index])),
            isCurved: true,
            color: Colors.blue,
            barWidth: 4,
            isStrokeCapRound: true,
            belowBarData: BarAreaData(show: false),
            dotData: FlDotData(show: true),
          ),
        ],
      ),
    );
  }
}
