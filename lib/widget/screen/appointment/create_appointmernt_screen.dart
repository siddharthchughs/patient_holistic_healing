import 'package:flutter/material.dart';

class CreateAppointmentScreen extends StatefulWidget {
  const CreateAppointmentScreen({super.key});

  @override
  State<CreateAppointmentScreen> createState() => _CreateAppointmentState();
}

class _CreateAppointmentState extends State<CreateAppointmentScreen> {
  double? _deviceWidth, _deviceHeight;
  var patientName = '';
  var patientAge = '';
  final bool _isLoading = false;
  final _createAppointmentFormKey = GlobalKey<FormState>();

  void postPatientInfo() async {
    final isValid = _createAppointmentFormKey.currentState!.validate();

    if (isValid) {
      _createAppointmentFormKey.currentState!.save();
      print(patientName);
      print(patientAge);
    }
  }

  @override
  Widget build(BuildContext context) {
    _deviceWidth = MediaQuery.of(context).size.width;
    _deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(209, 18, 97, 233),
        title: Text(
          'Schedule Appointment',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: _deviceWidth! * 0.05),
          margin: EdgeInsets.only(left: 16, right: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [signUpForm()],
          ),
        ),
      ),
    );
  }

  Widget signUpForm() {
    return Form(
      key: _createAppointmentFormKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,

        children: [
          patientNameInputField(),
          SizedBox(height: 8),
          patientAgeInputField(),
          SizedBox(height: 8),
          if (_isLoading) const CircularProgressIndicator(),
          submitButton(),
        ],
      ),
    );
  }

  Widget patientNameInputField() {
    return TextFormField(
      decoration: InputDecoration(
        prefixStyle: TextStyle(backgroundColor: Colors.orangeAccent),
        hintText: 'Username',
        hintStyle: TextStyle(fontSize: 16),
      ),
      keyboardType: TextInputType.name,
      validator: (updatedUserNameValue) {
        if (updatedUserNameValue == null ||
            updatedUserNameValue.isEmpty ||
            updatedUserNameValue.trim().length < 0) {
          return 'Please enter a valid username';
        }
        return null;
      },
      onSaved: (savePatientNameText) {
        patientName = savePatientNameText!;
      },
    );
  }

  Widget patientAgeInputField() {
    return TextFormField(
      decoration: InputDecoration(
        hintText: 'Age',
        hintStyle: TextStyle(fontSize: 16),
      ),
      keyboardType: TextInputType.emailAddress,
      validator: (updateAgeText) {
        // 1. check if the  _updateEmailValue is null || empty

        if (updateAgeText == null || updateAgeText.isEmpty) {
          return 'Please enter your age';
        }

        return null;
      },

      // emailState is saved over here !
      onSaved: (savePatientAge) {
        setState(() {
          patientAge = savePatientAge!;
          print(patientAge);
        });
      },
    );
  }

  Widget submitButton() {
    return GestureDetector(
      onTap: postPatientInfo,
      child: Text(
        'Submit',
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.w400),
      ),
    );
  }
}
