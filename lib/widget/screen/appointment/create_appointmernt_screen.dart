import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:patient_holistic_healing/widget/screen/appointment/add_therapires.dart/Theraphy_list_screen.dart';
import 'package:patient_holistic_healing/widget/screen/appointment/appointment_model.dart';

class CreateAppointmentScreen extends StatefulWidget {
  final List<String> selectedTherapies;

  const CreateAppointmentScreen({super.key, required this.selectedTherapies});

  @override
  State<CreateAppointmentScreen> createState() => _CreateAppointmentState();
}

class _CreateAppointmentState extends State<CreateAppointmentScreen> {
  double? _deviceWidth, _deviceHeight;
  String _patientName = '';
  String _patientAge = '';
  String _appointmentCreatedBy = '';
  String _relatedToPatient = '';
  String _patientSymptomtext = '';
  String _patientCurrentMeds = '';
  String _patientGenderSelect = '';
  String _patientAntibioticsSelect = '';
  String _patientConcern = '';
  String _patientDietType = '';
  String _patientAlcholoConsumption = '';
  String _patientExerciseLevel = '';
  bool isAppointmentConfirmed = false;
  final String _pateintAppointmentStatus = '';

  List<String> _currentSelectedTherapies = [];
  DateTime? _selectedAppointmentDate;
  bool _isLoading = false;

  final _createAppointmentFormKey = GlobalKey<FormState>();
  final _createHealthFormKey = GlobalKey<FormState>();
  final _createLifeStyleFormKey = GlobalKey<FormState>();

  PatientFlueOptions _patientFluOption = PatientFlueOptions.Select;
  PatientFlueOptions _patientVacinated = PatientFlueOptions.Select;
  final _patientAppointmentStatus = 'Pending';

  @override
  void initState() {
    super.initState();
    _currentSelectedTherapies = widget.selectedTherapies;
  }

  void _datePicker() async {
    final now = DateTime.now();
    //    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final firstDate = DateTime(2100);

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: firstDate,
    );
    setState(() {
      _selectedAppointmentDate = pickedDate;
    });
  }

  void _selectFromTherapies() async {
    final List<String>? selectedTherapies = await showModalBottomSheet(
      useSafeArea: true,
      showDragHandle: true,
      isScrollControlled: true,
      context: context,
      builder: (ctx) => TheraphyListScreen(),
    );

    if (selectedTherapies != null) {
      setState(() {
        _currentSelectedTherapies = selectedTherapies;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _deviceWidth = MediaQuery.of(context).size.width;
    _deviceHeight = MediaQuery.of(context).size.height;

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
          'Schedule Appointment',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: _deviceWidth! * 0.05,
            vertical: _deviceHeight! * 0.06,
          ),
          margin: EdgeInsets.only(left: 8, right: 8, bottom: 18),
          child: _isLoading
              ? Container(
                  alignment: Alignment.center,
                  child: customProgressBar(),
                )
              : Stack(
                  children: [
                    Column(
                      children: [
                        _patientPersonalInfoForm(),
                        _patientHealthForm(),
                        _patientLifeStyleForm(),
                        _submitButton(),
                      ],
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget customProgressBar() {
    if (Platform.isIOS) {
      return CupertinoActivityIndicator(
        radius: 15,
        color: Colors.blueAccent.shade400,
      );
    } else {
      return CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent.shade400),
      );
    }
  }

  Widget _patientPersonalInfoForm() {
    return Form(
      key: _createAppointmentFormKey,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          textHeading('Appointment Created By'),
          SizedBox(height: 12),
          appointmentCreatedbyNameInputField(),
          SizedBox(height: 20),
          relatedToPatientDropDownMenu(),
          SizedBox(height: 20),
          textHeading('Patient Personal Information'),
          SizedBox(height: 12),
          patientNameInputField(),
          SizedBox(height: 20),
          patientAgeInputField(),
          SizedBox(height: 20),
          patientGenderSelect(),
          SizedBox(height: 16),
          patientScheduleStatus(),
          SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _patientHealthForm() {
    return Form(
      key: _createHealthFormKey,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          textHeading('Patient Health Information'),
          SizedBox(height: 20),
          _patientAreaOfConcernDropDownMenu(),
          SizedBox(height: 20),
          _patientSymptomInputField(),
          SizedBox(height: 20),
          _patientMedicationInputField(),
          SizedBox(height: 16),
          _patientAntibioticsDropDownMenu(),
          SizedBox(height: 20),
          _patientReceiveFluVacine(),
        ],
      ),
    );
  }

  Widget _patientLifeStyleForm() {
    return Form(
      key: _createLifeStyleFormKey,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          textHeading('Patient Lifestyle Information'),
          SizedBox(height: 20),
          patientDietTypeDropDownMenu(),
          SizedBox(height: 20),
          patientAlcholoConsumptionDropDownMenu(),
          SizedBox(height: 20),
          patientExerciseLevelDropDownMenu(),
          SizedBox(height: 20),
          _patientHomeopathyTreatment(),
          SizedBox(height: 20),
          _bottomSheetComplementaryTherapies(),
        ],
      ),
    );
  }

  Widget appointmentCreatedbyNameInputField() {
    return TextFormField(
      decoration: InputDecoration(
        hintText: 'Enter Your Full Name',
        hintStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
      ),
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.next,
      validator: (updatedUserNameValue) {
        if (updatedUserNameValue == null || updatedUserNameValue.isEmpty) {
          return 'Please enter a valid username';
        }
        return null;
      },
      onSaved: (savePatientNameText) {
        setState(() {
          _appointmentCreatedBy = savePatientNameText!;
        });
      },
      onChanged: (value) {
        _appointmentCreatedBy = value;
      },
    );
  }

  Widget relatedToPatientDropDownMenu() {
    return SizedBox(
      width: _deviceWidth! * 0.60,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Relation to Patient',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
          ),
          DropdownButtonFormField(
            icon: Icon(
              Icons.keyboard_arrow_down_sharp,
              color: Colors.blueAccent.shade400,
            ),
            decoration: InputDecoration(
              focusedBorder: UnderlineInputBorder(
                // Color when the field is tapped
                borderSide: BorderSide(color: Colors.black, width: 1),
              ),
            ),
            hint: Text('Select your realtion'),
            dropdownColor: Colors.white,
            items: relationLevel
                .map(
                  (relationTypeSelected) => DropdownMenuItem(
                    value: relationTypeSelected,
                    child: Text(
                      relationTypeSelected,
                      style: TextStyle(fontSize: 14, color: Colors.black),
                    ),
                  ),
                )
                .toList(),
            validator: (selectedRelationLevel) {
              if (selectedRelationLevel == null) {
                return 'Please Select Your Relation With Patient';
              }
              return null;
            },
            onSaved: (newValue) {
              if (newValue == null) return;
              setState(() {
                _relatedToPatient = newValue;
              });
            },
            onChanged: (value) {
              _relatedToPatient = value!;
            },
          ),
        ],
      ),
    );
  }

  Widget patientNameInputField() {
    return TextFormField(
      scrollPadding: EdgeInsets.only(bottom: 100),
      decoration: InputDecoration(
        hintText: 'Enter Your Full Name',
        hintStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
      ),
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.next,
      validator: (updatedUserNameValue) {
        if (updatedUserNameValue == null || updatedUserNameValue.isEmpty) {
          return 'Please enter a valid username';
        }
        return null;
      },
      onSaved: (savePatientNameText) {
        setState(() {
          _patientName = savePatientNameText!;
        });
      },
      onChanged: (value) {
        _patientName = value;
      },
    );
  }

  Widget textHeading(String label) {
    return Text(
      label,
      style: TextStyle(
        color: Colors.blueAccent.shade200,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  Widget patientAgeInputField() {
    return TextFormField(
      scrollPadding: EdgeInsets.only(bottom: 100),
      decoration: InputDecoration(
        hintText: 'Enter Your Age',
        hintStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
      ),
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.done,
      maxLength: 2,
      validator: (updateAgeText) {
        if (updateAgeText == null || updateAgeText.isEmpty) {
          return 'Please enter your age';
        }
        return null;
      },
      onSaved: (savePatientAge) {
        setState(() {
          _patientAge = savePatientAge!;
        });
      },
      onChanged: (value) {
        _patientAge = value;
      },
    );
  }

  Widget patientGenderSelect() {
    return SizedBox(
      width: _deviceWidth! * 0.60,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Gender',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
          ),
          DropdownButtonFormField(
            icon: Icon(
              Icons.keyboard_arrow_down_sharp,
              color: Colors.blueAccent.shade400,
            ),
            decoration: InputDecoration(
              focusedBorder: UnderlineInputBorder(
                // Color when the field is tapped
                borderSide: BorderSide(color: Colors.black, width: 1),
              ),
            ),
            hint: Text('Select your gender'),
            dropdownColor: Colors.white,
            items: genderType
                .map(
                  (genderTypeSelected) => DropdownMenuItem(
                    value: genderTypeSelected,
                    child: Text(
                      genderTypeSelected,
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ),
                )
                .toList(),
            validator: (selectedGender) {
              if (selectedGender == null) {
                return 'Please Select Your Gender';
              }
              return null;
            },
            onSaved: (newValue) {
              if (newValue == null) return;
              setState(() {
                _patientGenderSelect = newValue;
              });
            },
            onChanged: (value) {
              _patientGenderSelect = value!;
            },
          ),
        ],
      ),
    );
  }

  Widget patientScheduleStatus() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16),
        Text(
          'Select Date for Appointment',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Text(
                _selectedAppointmentDate == null
                    ? 'No Date Selected'
                    : dateFormatter.format(_selectedAppointmentDate!),
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                  color: Colors.black45,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: IconButton(
                iconSize: 32,
                onPressed: _datePicker,
                icon: Icon(Icons.date_range, color: Colors.blueAccent.shade400),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _patientAreaOfConcernDropDownMenu() {
    return SizedBox(
      width: _deviceWidth! * 0.70,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Main Area of Concern',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
          ),
          DropdownButtonFormField(
            icon: Icon(
              Icons.keyboard_arrow_down_sharp,
              color: Colors.blueAccent.shade400,
            ),
            decoration: InputDecoration(
              focusedBorder: UnderlineInputBorder(
                // Color when the field is tapped
                borderSide: BorderSide(color: Colors.black, width: 1),
              ),
            ),
            hint: Text('Select Your Concern'),
            dropdownColor: Colors.white,
            items: areaOfConcerns
                .map(
                  (concernSelected) => DropdownMenuItem(
                    value: concernSelected,
                    child: Text(
                      concernSelected,
                      style: TextStyle(fontSize: 14, color: Colors.black),
                    ),
                  ),
                )
                .toList(),
            validator: (selectedPatientConcern) {
              if (selectedPatientConcern == null) {
                return 'Please Select Your Concern';
              }
              return null;
            },
            onSaved: (savePatientConcern) {
              if (savePatientConcern == null) return;
              setState(() {
                _patientConcern = savePatientConcern;
              });
            },
            onChanged: (value) {
              _patientConcern = value!;
            },
          ),
        ],
      ),
    );
  }

  Widget patientDietTypeDropDownMenu() {
    return SizedBox(
      width: _deviceWidth! * 0.70,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Diet Type',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
          ),
          SizedBox(height: 2),
          DropdownButtonFormField(
            icon: Icon(
              Icons.keyboard_arrow_down_sharp,
              color: Colors.blueAccent.shade400,
            ),
            decoration: InputDecoration(
              focusedBorder: UnderlineInputBorder(
                // Color when the field is tapped
                borderSide: BorderSide(color: Colors.black, width: 1),
              ),
            ),

            hint: Text('Select Your Diet'),
            dropdownColor: Colors.white,
            items: dietType
                .map(
                  (dietSelected) => DropdownMenuItem(
                    value: dietSelected,
                    child: Text(
                      dietSelected,
                      style: TextStyle(fontSize: 14, color: Colors.black),
                    ),
                  ),
                )
                .toList(),
            validator: (selectedPatientDietType) {
              if (selectedPatientDietType == null) {
                return 'Please Select Your Diet Type';
              }
              return null;
            },
            onSaved: (savePatientDietType) {
              if (savePatientDietType == null) return;
              setState(() {
                _patientDietType = savePatientDietType;
              });
            },
            onChanged: (value) {
              _patientDietType = value!;
            },
          ),
        ],
      ),
    );
  }

  Widget patientAlcholoConsumptionDropDownMenu() {
    return SizedBox(
      width: _deviceWidth! * 0.80,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'AlcholoConsumption',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
          ),
          SizedBox(height: 2),
          DropdownButtonFormField(
            icon: Icon(
              Icons.keyboard_arrow_down_sharp,
              color: Colors.blueAccent.shade400,
            ),
            decoration: InputDecoration(
              focusedBorder: UnderlineInputBorder(
                // Color when the field is tapped
                borderSide: BorderSide(color: Colors.black, width: 1),
              ),
            ),
            hint: Text('Select Your Diet'),
            dropdownColor: Colors.white,
            items: consumptionTimePeriod
                .map(
                  (consumptionSelected) => DropdownMenuItem(
                    value: consumptionSelected,
                    child: Text(
                      consumptionSelected,
                      style: TextStyle(fontSize: 14, color: Colors.black),
                    ),
                  ),
                )
                .toList(),
            validator: (selectedPatientDietType) {
              if (selectedPatientDietType == null) {
                return 'Please Select Your Alcohol Intake';
              }
              return null;
            },
            onSaved: (savePatientCconsumption) {
              if (savePatientCconsumption == null) return;
              setState(() {
                _patientAlcholoConsumption = savePatientCconsumption;
              });
            },
            onChanged: (value) {
              _patientAlcholoConsumption = value!;
            },
          ),
        ],
      ),
    );
  }

  Widget patientExerciseLevelDropDownMenu() {
    return SizedBox(
      width: _deviceWidth! * 0.80,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Exercise Level',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
          ),
          SizedBox(height: 3.5),
          DropdownButtonFormField(
            icon: Icon(
              Icons.keyboard_arrow_down_sharp,
              color: Colors.blueAccent.shade400,
            ),
            decoration: InputDecoration(
              focusedBorder: UnderlineInputBorder(
                // Color when the field is tapped
                borderSide: BorderSide(color: Colors.black, width: 1),
              ),
            ),
            hint: Text('Select Level'),
            dropdownColor: Colors.white,
            items: exerciseLevel
                .map(
                  (exerciseLevelUpdated) => DropdownMenuItem(
                    value: exerciseLevelUpdated,
                    child: Text(
                      exerciseLevelUpdated,
                      style: TextStyle(fontSize: 14, color: Colors.black),
                    ),
                  ),
                )
                .toList(),
            validator: (selectedPatientAlcoholIntake) {
              if (selectedPatientAlcoholIntake == null) {
                return 'Please Select Your Alcohol Intake';
              }
              return null;
            },
            onSaved: (savePatientExerciseLevel) {
              if (savePatientExerciseLevel == null) return;
              setState(() {
                _patientExerciseLevel = savePatientExerciseLevel;
              });
            },
            onChanged: (value) {
              _patientExerciseLevel = value!;
            },
          ),
        ],
      ),
    );
  }

  Widget _patientSymptomInputField() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Text(
          'Describe your symptoms',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
        ),
        SizedBox(height: 20),
        SizedBox(
          width: _deviceWidth!,
          height: 300,
          child: TextFormField(
            decoration: InputDecoration(
              hintText:
                  'Please describe your main symptoms, when they occur, and any patterns you have noticed',
              hintStyle: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w300,
                color: Colors.black45,
              ),
              border: OutlineInputBorder(),
            ),
            validator: (updateConcernText) {
              if (updateConcernText == null || updateConcernText.isEmpty) {
                return 'Please enter your symptoms';
              }
              return null;
            },
            onSaved: (savePatientSymtoms) {
              setState(() {
                _patientSymptomtext = savePatientSymtoms!;
              });
            },
            onChanged: (value) {
              _patientSymptomtext = value;
            },

            textCapitalization: TextCapitalization.sentences,
            textAlign: TextAlign.left,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.multiline,
            maxLines: 20, // Allows unlimited lines to expand
            maxLength: 500,
          ),
        ),
        SizedBox(height: 16),
        Text(
          'Include details like duration, frequency, and what makes symptoms better or worse',
        ),
      ],
    );
  }

  Widget _patientMedicationInputField() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'On going Medication or Suppliments ?',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
        ),
        SizedBox(height: 20),
        SizedBox(
          width: _deviceWidth!,
          height: 300,
          child: TextFormField(
            decoration: InputDecoration(
              hintText:
                  'Kindly provide your medication or suppliments that you are taking currently',
              hintStyle: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w300,
                color: Colors.black45,
              ),
              border: OutlineInputBorder(),
            ),
            validator: (updateConcernText) {
              if (updateConcernText == null || updateConcernText.isEmpty) {
                return 'Please enter your age';
              }
              return null;
            },
            onSaved: (saveCurrentMedication) {
              setState(() {
                _patientCurrentMeds = saveCurrentMedication!;
              });
            },
            onChanged: (value) {
              _patientCurrentMeds = value;
            },
            textCapitalization: TextCapitalization.sentences,
            textAlign: TextAlign.left,
            textInputAction: TextInputAction.done,
            keyboardType: TextInputType.multiline,
            maxLines: 20, // Allows unlimited lines to expand
            maxLength: 500,
          ),
        ),
      ],
    );
  }

  Widget _patientAntibioticsDropDownMenu() {
    return SizedBox(
      width: _deviceWidth! * 0.60,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            'When did you last take Anitbiotics ?',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
          ),
          SizedBox(height: 3.0),
          DropdownButtonFormField(
            icon: Icon(
              Icons.keyboard_arrow_down_sharp,
              color: Colors.blueAccent.shade400,
            ),
            decoration: InputDecoration(
              focusedBorder: UnderlineInputBorder(
                // Color when the field is tapped
                borderSide: BorderSide(color: Colors.black, width: 1),
              ),
            ),
            hint: const Text('Select'),
            dropdownColor: Colors.white,
            items: antibioticsDuration
                .map(
                  (durationType) => DropdownMenuItem(
                    value: durationType,
                    child: Text(
                      durationType,
                      style: TextStyle(fontSize: 14, color: Colors.black),
                    ),
                  ),
                )
                .toList(),
            validator: (selectedPatientAntibiotics) {
              if (selectedPatientAntibiotics == null) {
                return 'Please Select Your Concern';
              }
              return null;
            },
            onSaved: (newValue) {
              if (newValue == null) return;
              setState(() {
                _patientAntibioticsSelect = newValue;
              });
            },
            onChanged: (updateSelection) {
              _patientAntibioticsSelect = updateSelection!;
            },
          ),
        ],
      ),
    );
  }

  Widget _patientReceiveFluVacine() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        SizedBox(height: 24),
        Text(
          'Did you receive the flu vaccine this year ?',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
        ),
        SizedBox(height: 20),
        RadioGroup<PatientFlueOptions>(
          groupValue: _patientVacinated,
          onChanged: (PatientFlueOptions? value) {
            setState(() {
              _patientVacinated = value!;
            });
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              RadioListTile<PatientFlueOptions>(
                title: Text(
                  'Yes',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
                ),
                value: PatientFlueOptions.Yes,
                activeColor: Colors.blueAccent.shade200,
                radioSide: BorderSide(
                  color: Colors.blueAccent,
                  width: 1.5,
                  strokeAlign: 1.3,
                ),
                selected: false,
                onChanged: (value) {
                  _patientVacinated = value!;
                },
                groupValue: _patientVacinated,
              ),
              RadioListTile<PatientFlueOptions>(
                title: Text(
                  'No',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
                ),
                value: PatientFlueOptions.No,
                activeColor: Colors.blueAccent.shade200,
                selected: false,
                radioSide: BorderSide(
                  color: Colors.blueAccent,
                  width: 1.5,
                  strokeAlign: 1.3,
                ),
                onChanged: (value) {
                  _patientVacinated = value!;
                },
                groupValue: _patientVacinated,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _patientHomeopathyTreatment() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        Text(
          'Have you used homeopathy before ?',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
        ),
        SizedBox(height: 20),
        RadioGroup<PatientFlueOptions>(
          groupValue: _patientFluOption,
          onChanged: (PatientFlueOptions? value) {
            setState(() {
              _patientFluOption = value!;
            });
          },
          child: Column(
            children: <Widget>[
              RadioListTile<PatientFlueOptions>(
                dense: true,
                visualDensity: VisualDensity(horizontal: -4),
                title: Text(
                  'Yes',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
                ),
                value: PatientFlueOptions.Yes,
                activeColor: Colors.blueAccent.shade200,
                radioSide: BorderSide(
                  color: Colors.blueAccent,
                  width: 1.5,
                  strokeAlign: 1.3,
                ),
                selected: false,
                onChanged: (value) {
                  _patientFluOption = value!;
                },
                groupValue: _patientFluOption,
              ),
              RadioListTile<PatientFlueOptions>(
                title: Text('No'),
                value: PatientFlueOptions.No,
                activeColor: Colors.blueAccent.shade200,
                radioSide: BorderSide(
                  color: Colors.blueAccent,
                  width: 1.5,
                  strokeAlign: 1.3,
                ),
                onChanged: (value) {
                  _patientFluOption = value!;
                },
                groupValue: _patientFluOption,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _bottomSheetComplementaryTherapies() {
    return Padding(
      padding: EdgeInsets.only(top: 8, bottom: BorderSide.strokeAlignCenter),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Have you used any Complementary Therapies before ?',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
          ),
          SizedBox(height: 12),
          _currentSelectedTherapies.isEmpty
              ? Text(
                  'Nothing Selected',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                    color: Colors.black45,
                  ),
                )
              : Wrap(
                  spacing: 8.0,
                  runSpacing: 4.0,
                  children: _currentSelectedTherapies.map((therapy) {
                    return Chip(
                      label: Text(
                        therapy,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.blueAccent.shade400,
                        ),
                      ),
                      backgroundColor: Colors.white,
                      deleteIcon: Icon(
                        Icons.close,
                        size: 18,
                        color: Colors.blueAccent.shade400,
                      ),
                      onDeleted: () {
                        setState(() {
                          _currentSelectedTherapies.remove(therapy);
                        });
                      },
                    );
                  }).toList(),
                ),
          SizedBox(height: 4),
          MaterialButton(
            onPressed: _selectFromTherapies,
            minWidth: 200,
            height: 45,
            color: Colors.blueAccent.shade400,
            textColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
              side: BorderSide(color: Colors.white),
            ),

            child: Text('Select', style: TextStyle(fontSize: 16)),
          ),
          SizedBox(height: 30),
        ],
      ),
    );
  }

  void _postPatientForm() async {
    late var authId = FirebaseAuth.instance.currentUser!.uid;
    late CollectionReference doctorReference = FirebaseFirestore.instance
        .collection('appointments');

    late CollectionReference patientInfoReference = FirebaseFirestore.instance
        .collection('patient_info');

    late DocumentReference doctorRef = doctorReference.doc(authId);
    late DocumentReference patientDocRef = patientInfoReference.doc(authId);

    String appointmentID = patientInfoReference
        .doc(authId)
        .collection('appointments')
        .doc()
        .id;

    final isValid = _createAppointmentFormKey.currentState!.validate();
    final isHealthInputValid = _createHealthFormKey.currentState!.validate();
    final isLifeStyleInputValid = _createLifeStyleFormKey.currentState!
        .validate();

    if (!isValid || !isHealthInputValid || !isLifeStyleInputValid) {
      return;
    }
    setState(() {
      _isLoading = true;
      Future.delayed(Duration(seconds: 10));
    });

    _createAppointmentFormKey.currentState!.save();
    _createHealthFormKey.currentState!.save();
    _createLifeStyleFormKey.currentState!.save();

    try {
      await doctorRef.collection('patients').doc(appointmentID).set({
        'patient_personal': {
          'fullname': _patientName,
          'age': _patientAge,
          'gender': _patientGenderSelect,
          'appointment_date': _selectedAppointmentDate.toString(),
        },
        'patient_health_info': {
          'fullname': _patientName,
          'area_of_concern': _patientConcern,
          'key_symptoms': _patientSymptomtext,
          'flu_vaccine_taken': _patientVacinated.name,
          'current_medications': _patientCurrentMeds,
          'last_anitbioticstaken': _patientAntibioticsSelect,
          'timestamp': FieldValue.serverTimestamp(),
        },
        'patient_lifestyle_info': {
          'fullname': _patientName,
          'dietType': _patientDietType,
          'alcoholInTake': _patientAlcholoConsumption,
          'exerciseLevel': _patientExerciseLevel,
          'homeopathyTreatmentTaken': _patientFluOption.name,
          'patient_selected_therapies': _currentSelectedTherapies,
          'timestamp': FieldValue.serverTimestamp(),
        },
        'patient_appointment_id': appointmentID,
        'patient_appointment_status': '_patientAppointmentStatus.name',
        'related_to_patient': _relatedToPatient,
        'appointment_created_by': _appointmentCreatedBy,
        'created_at': FieldValue.serverTimestamp(),
      });

      await patientDocRef.collection('appointments').doc(appointmentID).set({
        'patient_personal': {
          'fullname': _patientName,
          'age': _patientAge,
          'gender': _patientGenderSelect,
          'appointment_date': _selectedAppointmentDate.toString(),
        },
        'patient_health_info': {
          'fullname': _patientName,
          'area_of_concern': _patientConcern,
          'key_symptoms': _patientSymptomtext,
          'flu_vaccine_taken': _patientVacinated.name,
          'current_medications': _patientCurrentMeds,
          'last_anitbioticstaken': _patientAntibioticsSelect,
          'timestamp': FieldValue.serverTimestamp(),
        },
        'patient_lifestyle_info': {
          'fullname': _patientName,
          'dietType': _patientDietType,
          'alcoholInTake': _patientAlcholoConsumption,
          'exerciseLevel': _patientExerciseLevel,
          'homeopathyTreatmentTaken': _patientFluOption.name,
          'patient_selected_therapies': _currentSelectedTherapies,
          'timestamp': FieldValue.serverTimestamp(),
        },
        'patient_appointment_id': appointmentID,
        'patient_appointment_status': _patientAppointmentStatus,
        'related_to_patient': _relatedToPatient,
        'appointment_created_by': _appointmentCreatedBy,
        'created_at': FieldValue.serverTimestamp(),
      });
    } on FirebaseAuthException catch (errorException) {
      if (errorException.code == 'email alreayd in use') {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('This email is already in use !')),
        );
        return;
      }
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorException.message ?? 'Authentication failed !'),
        ),
      );
    } finally {
      setState(() {
        Future.delayed(Duration(seconds: 5));
        _isLoading = false;
      });
    }

    Navigator.of(
      context,
    ).pushNamedAndRemoveUntil('home', (Route<dynamic> route) => false);
  }

  Widget _submitButton() {
    return GestureDetector(
      onTap: _postPatientForm,
      child: Center(
        child: Container(
          clipBehavior: Clip.hardEdge,
          width: _deviceWidth!,
          height: 48,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.blueAccent.shade200, width: 2.0),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Text(
            'Submit',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.blueAccent.shade200,
              fontSize: 16,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
      ),
    );
  }
}
