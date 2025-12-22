import 'package:flutter/material.dart';
import 'package:patient_holistic_healing/widget/screen/appointment/summary_screen/selectedtherapies_expandable_menu.dart';
import 'package:patient_holistic_healing/widget/screen/appointment/summary_screen/symptom_detail_screen.dart';

class PatientDetailScreen extends StatelessWidget {
  const PatientDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors
              .white, // Changes the back button, menu icon, and all other icons' color
        ),
        automaticallyImplyLeading: true,
        backgroundColor: Colors.blueAccent.shade700,
        title: Text(
          'Detail',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: buildAppointmentSummary(context),
          ),
        ),
      ),
    );
  }

  Widget buildAppointmentSummary(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        appointmentStatus(),
        SizedBox(height: 16),
        textHeading('Appointment Created By'),
        appointmentCreatedBy(),
        SizedBox(height: 16),
        textHeading('Patient Appointment Sumary'),
        patientAppointmentSummary(),
        SizedBox(height: 16),
        textHeading('Patient Area Of Concern'),
        patientAreaOfConcernSummary(context),
        SizedBox(height: 16),
        textHeading('Patient Vaccination'),
        patientVaccination(),
        SizedBox(height: 16),
        textHeading('Patient Lifestyle'),
        patientLifestyleSummary(),
        SizedBox(height: 16),
      ],
    );
  }

  Widget appointmentStatus() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      color: Colors.white,
      elevation: 0.4,
      borderOnForeground: true,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Text(
                'Appointment Status',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            // Text('Appointment Status'),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Pending',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget appointmentCreatedBy() {
    return Card(
      elevation: 0.4,
      color: Colors.white,
      borderOnForeground: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12.0, 4.0, 12.0, 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8.0),
            customRowForSummary(title: 'Name', subTitle: 'Mr XSD'),
            SizedBox(height: 8.0),
            customRowForSummary(
              title: 'Relationship To Patient',
              subTitle: 'Father',
            ),
            SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }

  Widget patientAppointmentSummary() {
    return Card(
      elevation: 0.4,
      color: Colors.white,
      borderOnForeground: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 12.0, 12.0, 8.0),
        child: Column(
          children: [
            customRowForSummary(title: 'Appointment Date', subTitle: ''),
            SizedBox(height: 16.0),
            customRowForSummary(title: 'Name', subTitle: 'Father'),
            SizedBox(height: 16.0),
            customRowForSummary(title: 'Age', subTitle: 'Father'),
            SizedBox(height: 16.0),
            customRowForSummary(title: 'Gender', subTitle: 'Father'),
            SizedBox(height: 4.0),
          ],
        ),
      ),
    );
  }

  Widget patientLifestyleSummary() {
    return Card(
      elevation: 0.4,
      color: Colors.white,
      borderOnForeground: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 12.0, 12.0, 8.0),
        child: Column(
          children: [
            customRowForSummary(title: 'Diet Type', subTitle: ''),
            SizedBox(height: 16.0),
            customRowForSummary(
              title: 'Alcohol Consumption',
              subTitle: 'Father',
            ),
            SizedBox(height: 16.0),
            customRowForSummary(title: 'Exercise Level', subTitle: 'Father'),
            SizedBox(height: 4.0),
            customRowForSummary(
              title: 'Intake Of Homeopathy',
              subTitle: 'Father',
            ),
            SizedBox(height: 4.0),
            SelectedTherapiesMenu(),
          ],
        ),
      ),
    );
  }

  Widget patientAreaOfConcernSummary(BuildContext context) {
    return Card(
      elevation: 0.4,
      color: Colors.white,
      borderOnForeground: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 12.0, 12.0, 8.0),
        child: Column(
          children: [
            customLayoutForPatientConcern(
              title: 'Symptoms Suffering',
              context: context,
            ),
            SizedBox(height: 20.0),
            customLayoutForPatientConcern(
              title: 'Current Mdeciation',
              context: context,
            ),
            SizedBox(height: 20.0),
            customLayoutForPatientConcern(
              title: 'Intake Of Last Antibiotics',
              context: context,
            ),
            SizedBox(height: 8.0),
          ],
        ),
      ),
    );
  }

  Widget patientVaccination() {
    return Card(
      elevation: 0.4,
      color: Colors.white,
      borderOnForeground: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 12.0, 12.0, 8.0),
        child: Column(
          children: [
            customRowForSummary(title: 'Vaccination Taken', subTitle: 'No'),
          ],
        ),
      ),
    );
  }

  Widget customRowForSummary({
    required String title,
    required String subTitle,
  }) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                subTitle,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget customLayoutForPatientConcern({
    required String title,
    required BuildContext context,
  }) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext con) => SymptomDetailScreen(),
          ),
        );
      },
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [Icon(Icons.keyboard_arrow_right_rounded)],
            ),
          ),
        ],
      ),
    );
  }

  Widget customLayoutForUsedHemoepathyTheaphy({
    required String title,
    required BuildContext context,
  }) {
    return InkWell(
      onTap: () {},
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [Icon(Icons.keyboard_arrow_right_rounded)],
            ),
          ),
        ],
      ),
    );
  }

  Widget appointmentDate() {
    return Text('Appointment Date: 2023-04-15');
  }

  Widget textHeading(String label) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12.0, 8, 0.0, 0.0),
      child: Text(
        label,
        style: TextStyle(
          color: Colors.blueAccent.shade700,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
