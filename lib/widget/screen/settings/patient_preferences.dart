import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PatientPreferences extends StatelessWidget {
  const PatientPreferences({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(209, 18, 97, 233),
        title: Text(
          'Setting',
          style: TextStyle(fontSize: 22, color: Colors.white),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24.0, 4, 4, 0),
            child: GestureDetector(
              onTap: () => _showDialog(context),
              child: ListTile(title: Text('Version'), subtitle: Text('1.0')),
            ),
          ),
          Divider(color: Colors.blueAccent.shade100),
          Padding(
            padding: const EdgeInsets.fromLTRB(24.0, 4, 4, 0),
            child: GestureDetector(
              onTap: () => _showDialog(context),
              child: ListTile(
                title: Text(
                  'Logout',
                  selectionColor: Color.fromARGB(209, 18, 97, 233),
                ),
              ),
            ),
          ),
          Divider(color: Colors.blueAccent.shade100),
        ],
      ),
    );
  }

  void _showDialog(BuildContext context) {
    if (Platform.isIOS) {
      showCupertinoDialog(
        context: context,
        builder: (ctx) => CupertinoAlertDialog(
          title: const Text("Logout"),
          content: const Text("Are you sure you want to logout !"),
          actions: [
            TextButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pushNamedAndRemoveUntil(
                  'login',
                  (Route<dynamic> route) => false,
                );
              },
              child: const Text(
                "Okay",
                style: TextStyle(fontSize: 14, color: Colors.blueAccent),
              ),
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (cts) => AlertDialog(
          title: const Text("Invalid Input"),
          content: const Text(
            "Please enter a valid amount, date and title for the expense.",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                "Okay",
                style: TextStyle(fontSize: 14, color: Colors.blueAccent),
              ),
            ),
          ],
        ),
      );
    }
  }
}
