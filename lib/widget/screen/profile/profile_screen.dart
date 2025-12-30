import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileState();
}

class _ProfileState extends State<ProfileScreen> {
  double? _deviceWidth, _deviceHeight;

  @override
  Widget build(BuildContext context) {
    _deviceWidth = MediaQuery.of(context).size.width;
    _deviceHeight = MediaQuery.of(context).size.height;

    final Map argument = ModalRoute.of(context)?.settings.arguments as Map;
    String currentMedication = argument['current_medication'];
    String patientName = argument['patientName'];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors
              .white, // Changes the back button, menu icon, and all other icons' color
        ),
        automaticallyImplyLeading: true,
        backgroundColor: Colors.blueAccent.shade400,
        title: Text(
          'Profile',
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          width: _deviceWidth!,
          height: _deviceHeight!,
          margin: EdgeInsets.symmetric(horizontal: 16),
          padding: EdgeInsets.fromLTRB(12, 12, 0, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              textHeading('Patient Name', Colors.blueAccent.shade200),
              Text(
                patientName,
                softWrap: true,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 20),
              textHeading(
                'Patient Current Medication',
                Colors.blueAccent.shade200,
              ),
              Text(
                currentMedication,
                textAlign: TextAlign.justify,
                softWrap: true,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget textHeading(String label, Color color) {
    return Text(
      label,
      style: TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.w400),
    );
  }
}
