// import 'package:flutter/material.dart';

// class PatientPersonalDataPersonInfo extends StatefulWidget {
//   const PatientPersonalDataPersonInfo({
//     super.key,
//     required this.createAppointmentFormKey,
//   });
//   final GlobalKey<FormState> createAppointmentFormKey;
//   String _appointmentCreatedBy = '';
//   String _relatedToPatient = '';

//   @override
//   Widget build(BuildContext context) {
//     return _patientScheduleForm();
//   }

//   Widget _patientScheduleForm() {
//     return Form(
//       key: createAppointmentFormKey,
//       child: Column(
//         mainAxisSize: MainAxisSize.max,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           textHeading('Appointment Created By'),
//           SizedBox(height: 12),
//           appointmentCreatedbyNameInputField(),
//           // SizedBox(height: 20),
//           // relatedToPatientDropDownMenu(),
//           // SizedBox(height: 20),
//           // textHeading('Patient Personal Information'),
//           // SizedBox(height: 12),
//           // patientNameInputField(),
//           // SizedBox(height: 20),
//           // patientAgeInputField(),
//           // SizedBox(height: 20),
//           // patientGenderSelect(),
//           // SizedBox(height: 16),
//           // patientSelectDate(),
//           // SizedBox(height: 8),
//         ],
//       ),
//     );
//   }

//     Widget appointmentCreatedbyNameInputField() {
//     return TextFormField(
//       decoration: InputDecoration(
//         hintText: 'Enter Your Full Name',
//         hintStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//       ),
//       keyboardType: TextInputType.name,
//       validator: (updatedUserNameValue) {
//         if (updatedUserNameValue == null || updatedUserNameValue.isEmpty) {
//           return 'Please enter a valid username';
//         }
//         return null;
//       },
//       onSaved: (savePatientNameText) {
//         setState(() {
//           _appointmentCreatedBy = savePatientNameText!;
//         });
//       },
//       onChanged: (value) {
//         _appointmentCreatedBy = value;
//       },
//     );
//   }

//   Widget relatedToPatientDropDownMenu() {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       mainAxisSize: MainAxisSize.max,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Relation to Patient',
//           style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//         ),
//         DropdownButtonFormField(
//           hint: Text('Select your realtion'),
//           dropdownColor: Colors.white,
//           items: relationLevel
//               .map(
//                 (relationTypeSelected) => DropdownMenuItem(
//                   value: relationTypeSelected,
//                   child: Text(
//                     relationTypeSelected,
//                     style: TextStyle(
//                       fontSize: 12,
//                       color: _relatedToPatient == relationTypeSelected
//                           ? Colors.black
//                           : Colors.blue.shade600,
//                     ),
//                   ),
//                 ),
//               )
//               .toList(),
//           validator: (selectedRelationLevel) {
//             if (selectedRelationLevel == null) {
//               return 'Please Select Your Relation With Patient';
//             }
//             return null;
//           },
//           onSaved: (newValue) {
//             if (newValue == null) return;
//             setState(() {
//               _relatedToPatient = newValue;
//             });
//           },
//           onChanged: (value) {
//             _relatedToPatient = value!;
//           },
//         ),
//       ],
//     );
//   }

//   Widget textHeading(String label) {
//     return Text(
//       label,
//       style: TextStyle(
//         color: Colors.blueAccent.shade400,
//         fontSize: 16,
//         fontWeight: FontWeight.bold,
//       ),
//     );
//   }
// }
