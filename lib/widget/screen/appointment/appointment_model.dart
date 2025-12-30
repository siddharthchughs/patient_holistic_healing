import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final dateFormatter = DateFormat.yMd();
final Map<String, Color> isStatusPending = {
  'Pending': Colors.redAccent.shade200,
  'Confirm': Colors.lightGreen.shade400,
  'Cancelled': Colors.deepOrange,
};

enum PopMenuItems { Setting, Profile }

enum PatientFlueOptions { Select, Yes, No }

enum AppointmentStatus { Pending, Confirm }

enum PatientRoute { symptoms, medication, listOfTherapies }

final List<String> genderType = [
  'Male',
  'Female',
  'Non Binary',
  'Pefer Not To Say',
];

final List<String> antibioticsDuration = [
  'Never taken',
  'Within The Last Month',
  '1-3 Months Ago',
  '3-6 Months Ago',
  '6-12 Months Ago',
  'Over A Year Ago',
];

final List<String> dietType = [
  'Select',
  'Omnivore',
  'Vegetarian',
  'Pescatarian',
  'Gluten Free',
  'Dairy Free',
  'Low Carb',
];

final List<String> consumptionTimePeriod = [
  'Select',
  'None',
  'Occasional (few times a month)',
  'Moderate (1-2 drinks per week)',
  'Regular (3-7 drinks per week)',
  'Daily',
  'Prefer not to say',
];

final List<String> exerciseLevel = [
  'Sedentary (little to no exercise)',
  'Light (1-2 times per week)',
  'Moderate (3-4 times per week)',
  'Active (5-6 times per week)',
  'Very Active (daily intense exercise)',
];

final List<String> relationLevel = [
  'Mother',
  'Father',
  'Relative',
  'Grandparent',
  'Sibling',
];

final List<String> areaOfConcerns = [
  'Select Primary Concern',
  'Digestive Issues',
  'Anxiety & Stress',
  'Sleep Problemms',
  'Pain (chronic or acute)',
  'Skin Conditions',
  'Respiratory Issues',
  'Womens Health',
  'Mesns Health',
  'Allergies',
  'Fatigue & Energy',
  'Emotional Wellbeing',
  'Other (please specify below)',
];

final List<String> listOfTherapies = [
  'Select Primary Concern',
  'Digestive Issues',
  'Anxiety & Stress',
  'Sleep Problemms',
  'Pain (chronic or acute)',
  'Skin Conditions',
  'Respiratory Issues',
  'Womens Health',
  'Mesns Health',
  'Allergies',
  'Fatigue & Energy',
  'Emotional Wellbeing',
  'Other (please specify below)',
];

enum PatientCheck { personal, health, lifestyle }

const patientActivities = {
  PatientCheck.personal: 'patient_personal_info',
  PatientCheck.health: 'patient_health_info',
  PatientCheck.lifestyle: 'patient_lifestyle_info',
};

class Therapies {
  Therapies({required this.title});
  final String title;

  Map<String, dynamic> toMap() {
    return {'title': title};
  }

  factory Therapies.fromMap(Map<String, dynamic> map) {
    return Therapies(title: map['title']);
  }
}
