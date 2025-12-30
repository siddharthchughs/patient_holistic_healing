import 'package:flutter/material.dart';
import 'package:patient_holistic_healing/widget/screen/appointment/appointment_model.dart';

class PatientDetailScreen extends StatelessWidget {
  const PatientDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Map argument = ModalRoute.of(context)?.settings.arguments as Map;
    String status = argument['appointment_status'];
    String createdBy = argument['createdBy'];
    String relatedToPatient = argument['relatedToPatient'];
    String appointmentDate = argument['appointment_date'];
    String patientName = argument['patientName'];
    String patientAge = argument['patientAge'];
    String patientGender = argument['patientGender'];
    String patientVaccine = argument['patientVaccine'];
    String patientDietType = argument['patientDietType'];
    String pateientAlcoholInTake = argument['patientAlcoholInTake'];
    String patientHomeopathyInTake = argument['patientHomeopathyInTake'];
    String patientExerciseLevel = argument['patientExerciseLevel'];
    String patientLastIntake = argument['patientLastAntibioticsInTake'];
    String patientAreaOfConcern = argument['patientAreaOfConcern'];
    String patientSymptomsSuffering = argument['patientSymptomsSuffering'];
    String patientCurrentMedication = argument['patientCurrentMedication'];
    String patientSelectedTherapies = argument['selectedTherapies'].toString();
    print('summary $patientSelectedTherapies');
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors
              .white, // Changes the back button, menu icon, and all other icons' color
        ),
        automaticallyImplyLeading: true,
        backgroundColor: Colors.blueAccent.shade400,
        title: Text(
          'Detail',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: buildAppointmentSummary(
              context = context,
              status = status,
              createdBy = createdBy,
              relatedToPatient = relatedToPatient,
              appointmentDate = appointmentDate,
              patientName = patientName,
              patientAge = patientAge,
              patientGender = patientGender,
              patientVaccine = patientVaccine,
              patientDietType = patientDietType,
              pateientAlcoholInTake = pateientAlcoholInTake,
              patientHomeopathyInTake = patientHomeopathyInTake,
              patientExerciseLevel = patientExerciseLevel,
              patientLastIntake = patientLastIntake,
              patientAreaOfConcern = patientAreaOfConcern,
              patientSymptomsSuffering = patientSymptomsSuffering,
              patientCurrentMedication = patientCurrentMedication,
              patientSelectedTherapies = patientSelectedTherapies,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildAppointmentSummary(
    BuildContext context,
    String status,
    String createdBy,
    String relatedToPatient,
    String appointmentDate,
    String patientName,
    String patientAge,
    String patientGender,
    String patientVaccine,
    String patientDietType,
    String pateientAlcoholInTake,
    String pateientExerciseLevel,
    String pateientHomeopathyInTake,
    String patientLastIntake,
    String patientAreaOfConcern,
    String patientSymptomsSuffering,
    String patientCurrentMedication,
    String patientSelectedTherapies,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        appointmentStatus(status = status),
        SizedBox(height: 16),
        textHeading('Appointment Created By'),
        appointmentCreatedBy(
          createdBy = createdBy,
          relatedToPatient = relatedToPatient,
        ),
        SizedBox(height: 16),
        textHeading('Patient Appointment Sumary'),
        patientAppointmentSummary(
          appointmentDate = appointmentDate,
          patientName = patientName,
          patientAge = patientAge,
          patientGender = patientGender,
        ),
        SizedBox(height: 16),
        textHeading('Patient Health Info Summary'),
        patientHealthInfoSummary(
          context = context,
          patientLastIntake = patientLastIntake,
          patientAreaOfConcern = patientAreaOfConcern,
          patientSymptomsSuffering = patientSymptomsSuffering,
          patientCurrentMedication = patientCurrentMedication,
          patientName = patientName,
        ),
        SizedBox(height: 16),
        textHeading('Patient Vaccination'),
        patientVaccination(patientVaccine = patientVaccine),
        SizedBox(height: 16),
        textHeading('Patient Lifestyle'),
        patientLifestyleSummary(
          context = context,
          patientDietType = patientDietType,
          pateientAlcoholInTake = pateientAlcoholInTake,
          pateientExerciseLevel = pateientExerciseLevel,
          pateientHomeopathyInTake = pateientHomeopathyInTake,
          patientSelectedTherapies = patientSelectedTherapies,
        ),
        SizedBox(height: 16),
      ],
    );
  }

  Widget appointmentStatus(String status) {
    final Color textColor =
        isStatusPending[status] ?? Colors.redAccent.shade200;

    return Card(
      elevation: 0.4,
      color: Colors.white,
      shadowColor: Colors.blueAccent.shade700,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Status',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [Text(status, style: TextStyle(color: textColor))],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget appointmentCreatedBy(String createdBy, String relatedToPatient) {
    return Card(
      elevation: 0.4,
      color: Colors.white,
      shadowColor: Colors.blueAccent.shade700,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12.0, 4.0, 12.0, 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8.0),
            customRowForSummary(title: 'Name', subTitle: createdBy),
            SizedBox(height: 8.0),
            customRowForSummary(
              title: 'Relationship To Patient',
              subTitle: relatedToPatient,
            ),
          ],
        ),
      ),
    );
  }

  Widget patientAppointmentSummary(
    String appointmentDate,
    String patientName,
    String patientAge,
    String patientGender,
  ) {
    return Card(
      elevation: 0.4,
      color: Colors.white,
      shadowColor: Colors.blueAccent.shade700,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 12.0, 12.0, 8.0),
        child: Column(
          children: [
            customRowForSummary(
              title: 'Appointment Date',
              subTitle: appointmentDate,
            ),
            SizedBox(height: 16.0),
            customRowForSummary(title: 'Name', subTitle: patientName),
            SizedBox(height: 16.0),
            customRowForSummary(title: 'Age', subTitle: patientAge),
            SizedBox(height: 16.0),
            customRowForSummary(title: 'Gender', subTitle: patientGender),
          ],
        ),
      ),
    );
  }

  Widget patientLifestyleSummary(
    BuildContext context,
    String patientDietType,
    String patientAlcoholInTake,
    String patientHomeopathyInTake,
    String patientExerciseLevel,
    String patientSelectedTherapies,
  ) {
    return Card(
      elevation: 0.4,
      color: Colors.white,
      shadowColor: Colors.blueAccent.shade700,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          customLayoutSubListTile(
            title: 'Diet Type',
            subTitle: patientDietType,
          ),
          SizedBox(height: 4.0),
          customLayoutSubListTile(
            title: 'Alcohol Consumption',
            subTitle: patientAlcoholInTake,
          ),
          SizedBox(height: 4.0),
          customLayoutSubListTile(
            title: 'Exercise Level',
            subTitle: patientExerciseLevel,
          ),
          SizedBox(height: 4.0),
          customLayoutSubListTile(
            title: 'Intake Of Homeopathy',
            subTitle: patientHomeopathyInTake,
          ),
          customLayoutListTileTrail(
            title: 'Therapies Used Earlier',
            onTap: () => Navigator.of(context).pushNamed(
              'therapies',
              arguments: {
                'patientName': 'patientName',
                'selectedTherapies': patientSelectedTherapies,
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget patientHealthInfoSummary(
    BuildContext context,
    String patientLastIntake,
    String patientAreaOfConcern,
    String patientSymptomsSuffering,
    String patientCurrentMedication,
    String patientName,
  ) {
    return Card(
      elevation: 0.4,
      color: Colors.white,
      shadowColor: Colors.blueAccent.shade700,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: Column(
        children: [
          customLayoutSubListTile(
            title: 'Selected Area Of Concern',
            subTitle: patientAreaOfConcern,
          ),

          customLayoutListTileTrail(
            title: 'Symptoms Suffering',
            onTap: () {
              Navigator.of(context).pushNamed(
                'symptoms',
                arguments: {
                  'patientName': patientName,
                  'symptoms': patientSymptomsSuffering,
                },
              );
            },
          ),
          SizedBox(height: 2.0),
          customLayoutListTileTrail(
            title: 'Current Mdeciation',
            onTap: () => Navigator.of(context).pushNamed(
              'medication',
              arguments: {
                'patientName': patientName,
                'current_medication': patientCurrentMedication,
              },
            ),
          ),
          customLayoutSubListTile(
            title: 'Intake Of Last Antibiotics',
            subTitle: patientLastIntake,
          ),
        ],
      ),
    );
  }

  Widget patientVaccination(String patientVaccine) {
    return Card(
      elevation: 0.4,
      color: Colors.white,
      shadowColor: Colors.blueAccent.shade700,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
      child: Column(
        children: [
          customLayoutSubListTile(
            title: 'Vaccination Taken',
            subTitle: patientVaccine,
          ),
        ],
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

  Widget customLayoutListTileTrail({
    required String title,
    required Function() onTap,
  }) {
    return ListTile(
      onTap: () => onTap(),
      contentPadding: EdgeInsets.fromLTRB(8, 2, 8, 2),
      dense: true,
      visualDensity: VisualDensity(horizontal: -4, vertical: -4),
      title: Text(title, style: TextStyle(fontSize: 16)),
      trailing: Icon(
        Icons.keyboard_arrow_right_rounded,
        color: Colors.blueAccent.shade200,
      ),
    );
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

  Widget textHeading(String label) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12.0, 8, 0.0, 0.0),
      child: Text(
        label,
        style: TextStyle(
          color: Colors.blueAccent.shade200,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
