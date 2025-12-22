import 'package:intl/intl.dart';

final dateFormatter = DateFormat.yMd();

enum PatientFlueOptions { Select, Yes, No }

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

// enum AreaOfConcern {
//   selectprimaryconcern,
//   digestive,
//   anxiety_stress,
//   sleep,
//   pain,
//   skin,
//   respiratory,
//   womens_health,
//   mens_health,
//   allergies,
//   fatigue,
//   immune,
//   emotional,
//   other,
// }

// const area_of_Concern = {
//   AreaOfConcern.selectprimaryconcern: 'Select Primary Concern',
//   AreaOfConcern.digestive: 'Digestive Issues',
//   AreaOfConcern.anxiety_stress: 'Anxiety & Stress',
//   AreaOfConcern.sleep: 'Sleep Problemms',
//   AreaOfConcern.pain: 'Pain (chronic or acute)',
//   AreaOfConcern.skin: 'Skin Conditions',
//   AreaOfConcern.respiratory: 'Respiratory Issues',
//   AreaOfConcern.womens_health: 'Womens Health',
//   AreaOfConcern.mens_health: 'Mesns Health',
//   AreaOfConcern.allergies: 'Allergies',
//   AreaOfConcern.fatigue: 'Fatigue & Energy',
//   AreaOfConcern.emotional: 'Emotional Wellbeing',
//   AreaOfConcern.other: 'Other (please specify below)',
// };
