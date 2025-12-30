import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:patient_holistic_healing/widget/screen/appointment/create_appointmernt_screen.dart';
import 'package:patient_holistic_healing/widget/screen/appointment/schedules_screen.dart';
import 'package:patient_holistic_healing/widget/screen/appointment/summary_screen/current_medication_screen.dart';
import 'package:patient_holistic_healing/widget/screen/appointment/summary_screen/patient_summary_screen.dart';
import 'package:patient_holistic_healing/widget/screen/appointment/summary_screen/selected_therapies_screen.dart';
import 'package:patient_holistic_healing/widget/screen/appointment/summary_screen/symptom_detail_screen.dart';
import 'package:patient_holistic_healing/widget/screen/forgotpassword/forgot_passwrd_screen.dart';
import 'package:patient_holistic_healing/widget/screen/login/login_screen.dart';
import 'package:patient_holistic_healing/widget/screen/profile/profile_screen.dart';
import 'package:patient_holistic_healing/widget/screen/settings/patient_preferences.dart';
import 'package:patient_holistic_healing/widget/screen/signup/signup_screen.dart';
import 'package:patient_holistic_healing/widget/screen/welcome/spash_screen.dart';
import 'package:patient_holistic_healing/widget/services/firebase_services.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  GetIt.instance.registerSingleton<FirebaseServices>(FirebaseServices());
  runApp(PatientHealingHome());
}

class PatientHealingHome extends StatelessWidget {
  const PatientHealingHome({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: 'welcome',
      routes: {
        'create_appointment': (context) => CreateAppointmentScreen(
          selectedTherapies: [].isNotEmpty
              ? ModalRoute.of(context)!.settings.arguments as List<String>
              : [],
        ),
        'appointment_detail': (context) => PatientDetailScreen(),
        'symptoms': (context) => SymptomDetailScreen(),
        'medication': (context) => CurrentMedicationScreen(),
        'therapies': (context) => SelectedTherapiesScreen(),
        'settings': (context) => PatientPreferencesScreen(),
        'register': (context) => SignUpScreen(),
        'login': (context) => LoginScreen(),
        'forgotpassword': (context) => ForgotPasswordScreen(),
        'home': (context) => SchedulesScreen(),
        'profile': (context) => ProfileScreen(),
        'welcome': (context) => SplashScreen(),
      },
    );
  }
}
