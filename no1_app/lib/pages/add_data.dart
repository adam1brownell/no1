import 'package:flutter/material.dart';

class AddDataView extends StatefulWidget {  // Converted AddDataView to StatefulWidget
  const AddDataView({Key? key}) : super(key: key); // Add const here

  @override
  _AddDataViewState createState() => _AddDataViewState();
}

class _AddDataViewState extends State<AddDataView> {
  List<Device> devices = [
    Device(name: "Garmin", logo: "lib/assets/garmin-logo.jpg", isConnected: false, hasView: true),
    Device(name: "Oura", logo: "lib/assets/oura-logo.jpg", isConnected: true, hasView: true),
    Device(name: "Apple HealthKit", logo: "lib/assets/apple-logo.jpg", isConnected: true, hasView: false),
    Device(name: "Whoop", logo: "lib/assets/whoop-logo.jpg", isConnected: false, hasView: false),
  ];

  int idx = -1;
  String selectedDevice = "";
  bool showAlert = false;
  bool showSheet = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Data"),
      ),
      body: Column(
        children: [
          Text(
            "Connect a Device",
            style: TextStyle(fontSize: 32),
          ),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
              ),
              itemCount: devices.length,
              itemBuilder: (context, index) {
                return DeviceView(
                  device: devices[index],
                  onTap: () => handleDeviceTap(index),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: showAlert ? buildDeviceAlert(context) : null,
    );
  }

  void handleDeviceTap(int index) {
    setState(() {
      selectedDevice = devices[index].name;
      devices[index].hasView ? showSheet = true : showAlert = true;
      idx = index;
    });

    // Debugging equivalent in Flutter
    print("Selected Device: $selectedDevice");
    print("Select by Index: ${devices[index].name}");
    print("Is Connected: ${devices[index].isConnected}");

    // Commenting out APIManager calls and assuming true
    print("!= nil result: true"); // Always true
    print("Is Connected #2: ${devices[index].isConnected}");

    if (showSheet) {
      if (selectedDevice == "Garmin") {
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return GarminView(isConnected: devices[idx].isConnected);
          },
        );
      } else if (selectedDevice == "Oura") {
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return OuraView(device: devices[idx]);
          },
        );
      }
    }
  }

  Widget buildDeviceAlert(BuildContext context) {
    return AlertDialog(
      title: Text(selectedDevice == "Apple HealthKit" ? "Connect to Apple HealthKit" : "Device Selected"),
      content: Text(selectedDevice == "Apple HealthKit"
          ? "Do you want to connect to Apple HealthKit?"
          : "Please visit Whoop"),
      actions: [
        if (selectedDevice == "Apple HealthKit")
          TextButton(
            child: Text("Connect"),
            onPressed: () {
              setState(() {
                devices[idx].isConnected = true;
              });
            },
          ),
        TextButton(
          child: Text("Cancel"),
          onPressed: () {
            setState(() {
              showAlert = false;
            });
          },
        ),
      ],
    );
  }
}

class DeviceView extends StatelessWidget {
  final Device device;
  final VoidCallback onTap;

  DeviceView({required this.device, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: device.isConnected ? Colors.green : Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: device.isConnected ? Colors.green : Colors.grey,
            width: 2,
          ),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(device.logo, width: 50, height: 50),
            Text(device.name, style: TextStyle(fontSize: 16, color: device.isConnected ? Colors.white : Colors.grey)),
            Divider(color: Colors.grey),
          ],
        ),
      ),
    );
  }
}

class Device {
  final String name;
  final String logo;
  bool isConnected;
  final bool hasView;

  Device({
    required this.name,
    required this.logo,
    required this.isConnected,
    required this.hasView,
  });
}

class GarminView extends StatelessWidget {
  final bool isConnected;

  GarminView({required this.isConnected});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset("lib/assets/garmin-logo.jpg", width: 50, height: 50),
          Text("Please visit Garmin"),
          TextField(decoration: InputDecoration(labelText: "Input 1")),
          TextField(decoration: InputDecoration(labelText: "Input 2")),
          ElevatedButton(
            onPressed: () {
              print("Done with Garmin");
              Navigator.pop(context);
            },
            child: Text("Done"),
          ),
        ],
      ),
    );
  }
}

class OuraView extends StatefulWidget {
  final Device device;

  OuraView({required this.device});

  @override
  _OuraViewState createState() => _OuraViewState();
}

class _OuraViewState extends State<OuraView> {
  String accessToken = "";

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Login & Create a Personal Token"),
          TextField(
            decoration: InputDecoration(labelText: "Enter Oura Access Token"),
            onChanged: (value) {
              setState(() {
                accessToken = value;
              });
            },
          ),
          ElevatedButton(
            onPressed: () {
              print("Submitted Oura Token: $accessToken");
              setState(() {
                widget.device.isConnected = true;
              });
            },
            child: Text("Submit"),
          ),
        ],
      ),
    );
  }
}
