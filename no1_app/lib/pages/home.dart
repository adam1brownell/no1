import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:no1_app/pages/add_data.dart';  // Import AddDataView
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Move the controller to the State class
  TextEditingController _textController = TextEditingController(); // Controller for input
  List<double> x = [1, 2, 3, 4, 5];
  List<double> y = [10, 20, 15, 30, 25];
  final PageController _pageController = PageController();
  bool activeExp = false;

  @override
  void dispose() {
    // Dispose the controller when the widget is removed from the tree
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                      ]
                  )
                ),
                SmoothPageIndicator(
                        controller: _pageController, // Connect the controller
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
            Text(x.join(", "),
            style: TextStyle(fontSize: 10),),
            // TextField(
            //   controller: _textController,
            //   decoration: const InputDecoration(
            //     labelText: "Enter your text",
            //     border: OutlineInputBorder(),
            //   ),
            // ),
            // const SizedBox(height: 20),
            // ElevatedButton(
            //   onPressed: () {
            //     // Do something with the input, like print or pass it to another function
            //     print('User input: ${_textController.text}');
            //   },
            //   child: const Text('Start Experiment'),
            // ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  activeExp = !activeExp;
                  print("Experiment Button Clicked, Active: $activeExp");
                });
              },
              child: Text(activeExp ? 'Stop Experiment' : 'Start Experiment'),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigate to the Data Analysis screen (replace with the actual route)
                Navigator.pushNamed(context, '/data_analysis');
              },
              child: const Text('Data Analysis'),
            ),
          ],
        ),
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


