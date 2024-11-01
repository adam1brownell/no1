import 'package:flutter/material.dart';

class DataLabPage extends StatelessWidget {
  const DataLabPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Data Lab"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous page
          },
        ),
      ),
      body: Center(
        child: const Text(
          "You have no data entries yet.",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}


// """
// TODO: retrieving from datasets

// void getOuraData() async {
//   DatasetsHelper datasetsHelper = DatasetsHelper();

//   List<DatasetEntry> entries = await datasetsHelper.getData('oura');
//   for (var entry in entries) {
//     print(entry.data);
//   }
// }

// """