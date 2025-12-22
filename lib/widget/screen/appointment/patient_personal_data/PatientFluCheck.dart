import 'package:flutter/material.dart';
import 'package:patient_holistic_healing/widget/screen/appointment/appointment_model.dart';

class PatientFluCheckState extends StatefulWidget {
  const PatientFluCheckState({super.key, required this.onSelectedOption});

  final Function(PatientFlueOptions) onSelectedOption;

  @override
  State<PatientFluCheckState> createState() => _PatientFluState();
}

class _PatientFluState extends State<PatientFluCheckState> {
  PatientFlueOptions _patientfluCheck = PatientFlueOptions.Select;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'Select an Option:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),

          Card(
            elevation: 2,
            child: RadioListTile<PatientFlueOptions>(
              title: Text(PatientFlueOptions.Yes.name),
              value: PatientFlueOptions.Select, // Value this tile represents
              groupValue: _patientfluCheck, // The state variable
              onChanged: (PatientFlueOptions? value) {
                setState(() {
                  if (value != null) {
                    _patientfluCheck = value;
                    print(_patientfluCheck);
                    widget.onSelectedOption(_patientfluCheck);
                  }
                });
              },
              activeColor: Colors.deepPurple,
            ),
          ),

          // --- RadioListTile for FALSE ---
          Card(
            elevation: 2,
            child: RadioListTile<PatientFlueOptions>(
              title: Text(PatientFlueOptions.Yes.name),
              value: PatientFlueOptions.Select, // Value this tile represents
              groupValue: _patientfluCheck, // The state variable
              onChanged: (PatientFlueOptions? value) {
                setState(() {
                  if (value != null) {
                    _patientfluCheck = value;
                  }
                });
              },
              activeColor: Colors.deepPurple,
            ),
          ),

          const SizedBox(height: 30),

          // Display the current result
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.deepPurple.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'Selected Value: ${_patientfluCheck.name}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
