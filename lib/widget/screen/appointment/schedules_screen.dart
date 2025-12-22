import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:patient_holistic_healing/widget/services/firebase_services.dart';

class SchedulesScreen extends StatefulWidget {
  const SchedulesScreen({super.key});

  @override
  State<SchedulesScreen> createState() => _ScheduleState();
}

class _ScheduleState extends State<SchedulesScreen> {
  double? _deviceWidth, _deviceHeight;
  bool isLoading = true;
  FirebaseServices? firebaseServices;

  @override
  void initState() {
    super.initState();
    firebaseServices = GetIt.instance.get<FirebaseServices>();
  }

  @override
  Widget build(BuildContext context) {
    _deviceWidth = MediaQuery.of(context).size.width;
    _deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(209, 18, 97, 233),
        title: Text(
          'Appointments',
          style: TextStyle(
            fontSize: 22,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, 'setting');
              },
              child: const Icon(Icons.settings, color: Colors.white),
            ),
          ),

          SizedBox(width: 8.0),
        ],
      ),
      body: Container(
        color: Colors.white,
        margin: EdgeInsets.only(bottom: _deviceHeight! * 0.05),
        height: _deviceHeight!,
        width: _deviceWidth!,
        child: _showAppointments(),
      ),
      floatingActionButton: FloatingActionButton(
        hoverColor: Colors.amberAccent.shade400,
        backgroundColor: const Color.fromARGB(209, 18, 97, 233),
        onPressed: () {
          Navigator.pushNamed(context, 'create_appointment');
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add, color: Colors.amberAccent),
      ),
    );
  }

  Widget _showAppointments() {
    return StreamBuilder<QuerySnapshot>(
      stream: firebaseServices!.getListOfAppointments(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: Text("Try again later !"));
        }

        if (snapshot.data!.docChanges.isEmpty) {
          return const Center(child: Text('No Appointments Yet Created'));
        }

        if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
          List appointments = snapshot.data!.docs.map((e) => e.data()).toList();
          return ListView.builder(
            itemCount: appointments.length,
            itemBuilder: (context, index) {
              final userAppointment = appointments[index];
              // final appointmentId =
              //     (snapshot.data!.docs[index].id).toString();

              return Card(
                color: Colors.white,
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      'appointment_detail',
                      arguments: userAppointment,
                    );
                  },
                  child: ListTile(
                    title: Text(
                      userAppointment['personal']['fullname'] ?? 'No Name',
                      style: const TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
