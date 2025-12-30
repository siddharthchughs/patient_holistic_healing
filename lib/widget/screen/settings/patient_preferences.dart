import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:patient_holistic_healing/widget/services/firebase_services.dart';

class PatientPreferencesScreen extends StatefulWidget {
  const PatientPreferencesScreen({super.key});
  @override
  State<PatientPreferencesScreen> createState() => _PatientPreferencesState();
}

class _PatientPreferencesState extends State<PatientPreferencesScreen> {
  FirebaseServices? firebaseStore;
  late Future<Map<String, dynamic>?> _userFuture;
  final String patientID = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    //    firebaseStore = GetIt.instance.get<FirebaseServices>();
    _userFuture = FirebaseServices().getPatientInfo(patientID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors
              .white, // Changes the back button, menu icon, and all other icons' color
        ),
        automaticallyImplyLeading: true,
        backgroundColor: Colors.blueAccent.shade700,
        centerTitle: true,
        title: Text(
          'Setting',
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
        child: patientInfo(),
      ),
    );
  }

  Widget patientInfo() {
    return FutureBuilder<Map<String, dynamic>?>(
      future: _userFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError &&
            FirebaseAuth.instance.currentUser!.uid.isEmpty) {
          return const Center(child: Text("Error loading profile"));
        }

        final data = snapshot.data;
        print(data);

        return Column(
          children: [
            customLayoutSubListTile(title: 'Logged In', subTitle: ''),
            Divider(color: Colors.blueAccent.shade100),
            customLayoutSubListTile(title: 'Version', subTitle: '1.0'),
            Divider(color: Colors.blueAccent.shade100),
            customLayoutListTile(
              title: 'Logout',
              onTap: () => _showDialog(context),
            ),
          ],
        );
        return const Text('Loading...');
      },
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
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                "Cancel",
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

  Widget customLayoutSubListTile({
    required String title,
    required String subTitle,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.fromLTRB(8, 2, 0, 2),
      dense: true,
      visualDensity: VisualDensity(horizontal: -4, vertical: -4),
      tileColor: Colors.white,
      title: Text(title, style: TextStyle(fontSize: 16)),
      subtitle: Text(subTitle, style: TextStyle(fontSize: 14)),
    );
  }

  Widget customLayoutListTile({
    required String title,
    required Function() onTap,
  }) {
    return ListTile(
      onTap: () => onTap(),
      contentPadding: EdgeInsets.fromLTRB(8, 2, 8, 2),
      dense: true,
      visualDensity: VisualDensity(horizontal: -4, vertical: -4),
      title: Text(title, style: TextStyle(fontSize: 16)),
    );
  }
}
