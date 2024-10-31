import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<double> x = [1, 2, 3, 4, 5];
  List<double> y = [10, 20, 15, 30, 25];
  final PageController _pageController = PageController();
  bool activeExp = false;

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
              // Navigate to AddDataPage
              Navigator.pushNamed(context, '/add_data');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          activeExp
              ? SizedBox(
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
                )
              : Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'N of 1',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
          const SizedBox(height: 20),
          Column(
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    if (activeExp) {
                      {
                        // Show confirmation dialog to end experiment
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("End Experiment"),
                              content: const Text("Are you sure you want to end your experiment early?"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    // End the experiment
                                    setState(() {
                                      activeExp = false; // or any additional logic if needed
                                    });
                                    Navigator.of(context).pop(); // Close the dialog
                                  },
                                  child: const Text("Yes"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(); // Close the dialog without ending the experiment
                                  },
                                  child: const Text("No"),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    } else {
                      Navigator.pushNamed(context, '/start_experiment');
                      activeExp = true;
                    }
                    print("Experiment Button Clicked, Active: $activeExp");
                  });
                },
                child: Text(activeExp ? 'Stop Experiment' : 'Start Experiment'),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/data_lab');
                    },
                    child: const Text('Data Lab'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/experiment_log');
                    },
                    child: const Text('Experiment Log'),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // Function to build the Line Chart
  Widget buildLineChart(List<double> x, List<double> y) {
    return LineChart(
      LineChartData(
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                return Text(value.toInt().toString());
              },
            ),
          ),
          bottomTitles: AxisTitles(
            axisNameWidget: const Padding(
              padding: EdgeInsets.only(top: 16.0),
              child: Text('Days', style: TextStyle(fontSize: 16)),
            ),
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                return Text(value.toInt().toString());
              },
            ),
          ),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border(
            top: BorderSide.none,
            right: BorderSide.none,
            left: const BorderSide(width: 1),
            bottom: const BorderSide(width: 1),
          ),
        ),
        clipData: FlClipData(
          top: false,
          bottom: false,
          left: false,
          right: false,
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

"""
TODO: pulling from User Info

void insertUserInfo() async {
  UserInfoHelper userInfoHelper = UserInfoHelper();

  UserInfo userInfo = UserInfo(
    userName: 'Adam',
    activeExp: true,
  );

  await userInfoHelper.insertUserInfo(userInfo);
}

void getUserInfo() async {
  UserInfoHelper userInfoHelper = UserInfoHelper();

  UserInfo? userInfo = await userInfoHelper.getUserInfo();
  if (userInfo != null) {
    print(userInfo.toMap());
  }
}
"""