import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:patient_holistic_healing/widget/navigation_utility/navigation_services.dart';
import 'package:patient_holistic_healing/widget/screen/appointment/appointment_model.dart';
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
  bool ifRead = false;

  @override
  void initState() {
    super.initState();
    firebaseServices = GetIt.instance.get<FirebaseServices>();
  }

  @override
  Widget build(BuildContext context) {
    _deviceWidth = MediaQuery.of(context).size.width;
    _deviceHeight = MediaQuery.of(context).size.height;

    Widget showAppointments() {
      return StreamBuilder<QuerySnapshot>(
        stream: firebaseServices!.getListOfAppointments(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            List appointments = snapshot.data!.docs
                .map((e) => e.data())
                .toList();

            return appointments.isEmpty
                ? const Center(
                    child: Text(
                      "No Appointment Yet Made !",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: appointments.length,
                    itemBuilder: (context, index) {
                      var userAppointment = appointments[index];
                      var userDocPersonal = userAppointment['patient_personal'];
                      var userDocHealthInfo =
                          userAppointment['patient_health_info'];
                      var userDocLifeStyle =
                          userAppointment['patient_lifestyle_info'];
                      final scheduledDate = userDocPersonal['appointment_date'];
                      var userSelectedTherapies =
                          userDocLifeStyle['patient_selected_therapies'];
                      return Card(
                        color: Colors.white,
                        surfaceTintColor: Colors.white24,
                        shadowColor: Colors.blueAccent.shade700,
                        margin: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).pushNamed(
                              'appointment_detail',
                              arguments: {
                                'appointment_status':
                                    userAppointment['patient_appointment_status'],
                                'createdBy':
                                    userAppointment['appointment_created_by'],
                                'relatedToPatient':
                                    userAppointment['related_to_patient'],
                                'appointment_date':
                                    NavigationServices.formatStringDate(
                                      scheduledDate,
                                    ),
                                'patientName': userDocPersonal['fullname'],
                                'patientAge': userDocPersonal['age'],
                                'patientGender': userDocPersonal['gender'],
                                'patientVaccine':
                                    userDocHealthInfo['flu_vaccine_taken'],
                                'patientAreaOfConcern':
                                    userDocHealthInfo['area_of_concern'],
                                'patientSymptomsSuffering':
                                    userDocHealthInfo['key_symptoms'],
                                'patientCurrentMedication':
                                    userDocHealthInfo['current_medications'],
                                'patientDietType': userDocLifeStyle['dietType'],
                                'patientAlcoholInTake':
                                    userDocLifeStyle['alcoholInTake'],
                                'patientLastAntibioticsInTake':
                                    userDocHealthInfo['last_anitbioticstaken'],
                                'patientExerciseLevel':
                                    userDocLifeStyle['exerciseLevel'],
                                'patientHomeopathyInTake':
                                    userDocLifeStyle['homeopathyTreatmentTaken'],
                                'selectedTherapies': userSelectedTherapies,
                              },
                            );
                          },
                          child: ListTile(
                            contentPadding: EdgeInsets.only(
                              left: 12,
                              top: 10,
                              bottom: 10,
                            ),
                            minTileHeight: 72.0,
                            title: Text(
                              userDocPersonal['fullname'],
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            ),
                            leading: Container(
                              alignment: Alignment.center,
                              width: 58,
                              height: 58,
                              decoration: BoxDecoration(
                                color: Colors.blueAccent.shade200,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Text(
                                userDocPersonal['fullname'][0],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                ),
                              ),
                            ),
                            subtitle: Padding(
                              padding: EdgeInsetsGeometry.symmetric(
                                vertical: 4,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          NavigationServices.formatStringDate(
                                            scheduledDate,
                                          ),
                                          style: TextStyle(fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      alignment: Alignment.center,
                                      child: Text(
                                        'Pending',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.redAccent.shade200,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
          }
          return const Center(child: Text("Hey, No Appointments Scheduled !"));
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent.shade400,
        title: Text(
          'Appointments',
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        actions: [
          PopupMenuButton(
            iconColor: Colors.white,
            surfaceTintColor: Colors.white,
            elevation: 4,
            itemBuilder: (context) {
              return <PopupMenuEntry<PopMenuItems>>[
                PopupMenuItem<PopMenuItems>(
                  onTap: () {
                    Navigator.of(context).pushNamed('settings', arguments: {});
                  },
                  value: PopMenuItems.Setting,
                  child: Text(
                    'Settings',
                    style: TextStyle(color: Colors.black, fontSize: 14),
                  ),
                ),
                PopupMenuItem<PopMenuItems>(
                  onTap: () {
                    Navigator.of(context).pushNamed('profile', arguments: {});
                  },
                  value: PopMenuItems.Profile,
                  child: Text(
                    'Profile',
                    style: TextStyle(color: Colors.black, fontSize: 14),
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.white,
        margin: EdgeInsets.only(bottom: _deviceHeight! * 0.05),
        height: _deviceHeight!,
        width: _deviceWidth!,
        child: showAppointments(),
      ),
      floatingActionButton: FloatingActionButton.extended(
        shape: RoundedSuperellipseBorder(
          borderRadius: BorderRadius.circular(40.0), // 0.0 makes it a square
        ),
        backgroundColor: Colors.blueAccent.shade400,
        onPressed: () {
          Navigator.pushNamed(context, 'create_appointment');
        },
        tooltip: 'Increment',
        label: const Text(
          'Schedule',
          style: TextStyle(
            fontSize: 14,
            color: Colors.white,
            fontWeight: FontWeight.w300,
          ),
        ),
        icon: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
