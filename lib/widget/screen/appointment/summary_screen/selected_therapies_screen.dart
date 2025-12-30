import 'dart:convert';

import 'package:flutter/material.dart';

class SelectedTherapiesScreen extends StatefulWidget {
  const SelectedTherapiesScreen({super.key});

  @override
  State<SelectedTherapiesScreen> createState() => _SelectedTherapiesState();
}

class _SelectedTherapiesState extends State<SelectedTherapiesScreen> {
  @override
  Widget build(BuildContext context) {
    // final Map argument = ModalRoute.of(context)?.settings.arguments as Map;
    // List<Therapies> selectedTherapies;
    // List<dynamic> dynamicList;

    // var data = argument['selectedTherapies'];

    // dynamicList = jsonDecode(data);
    // print(dynamicList);
    // String clean = data.replaceAll('[]', '').replaceAll(']', '');
    // selectedTherapies = dynamicList
    //     .map((therapies) => Therapies.fromMap(therapies))
    //     .toList();

    // print('ST ${selectedTherapies}');
    // return Scaffold(
    //   backgroundColor: Colors.white,
    //   appBar: AppBar(
    //     iconTheme: IconThemeData(
    //       color: Colors
    //           .white, // Changes the back button, menu icon, and all other icons' color
    //     ),
    //     automaticallyImplyLeading: true,
    //     backgroundColor: Colors.blueAccent.shade700,
    //     title: Text(
    //       'Selected Therapies',
    //       style: TextStyle(
    //         fontSize: 22,
    //         color: Colors.white,
    //         fontWeight: FontWeight.bold,
    //       ),
    //     ),
    //     centerTitle: true,
    //   ),
    //   body: Container(
    //     alignment: Alignment.topLeft,
    //     child: medicationSummary([]),
    //   ),
    // );
    final dynamic args = ModalRoute.of(context)?.settings.arguments;

    List<String> therapyTitles = [];

    if (args != null && args is Map) {
      var data = args['selectedTherapies'];

      if (data is List) {
        // CASE A: It is already a Dart List (Best practice)
        therapyTitles = List<String>.from(data);
      } else if (data is String) {
        // CASE B: It is a String
        try {
          // Attempt to decode as JSON
          var decoded = jsonDecode(data);
          therapyTitles = List<String>.from(decoded);
        } catch (e) {
          // If jsonDecode fails (Unexpected character error),
          // it means the string is "[A, B]" instead of '["A", "B"]'
          debugPrint("JSON Error: $e. Attempting manual cleanup.");

          // Cleanup logic for non-JSON strings like "[Ayurveda, Reflexology]"
          String clean = data.replaceAll('[', '').replaceAll(']', '');
          therapyTitles = clean.split(',').map((e) => e.trim()).toList();
        }
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors
              .white, // Changes the back button, menu icon, and all other icons' color
        ),
        automaticallyImplyLeading: true,
        backgroundColor: Colors.blueAccent.shade700,
        title: Text(
          'Selected Therapies',
          style: TextStyle(
            fontSize: 22,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        alignment: Alignment.topLeft,
        child: therapyTitles.isEmpty
            ? const Center(child: Text("No data found"))
            : ListView.builder(
                itemCount: therapyTitles.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Icon(
                      Icons.check_circle_rounded,
                      color: Colors.blueAccent.shade400,
                    ),
                    title: Text(therapyTitles[index]),
                  );
                },
              ),
      ),
    );
  }
}
