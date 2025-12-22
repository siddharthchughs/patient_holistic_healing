import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import 'package:patient_holistic_healing/widget/screen/appointment/create_appointmernt_screen.dart';
import 'package:patient_holistic_healing/widget/screen/appointment/schedules_screen.dart';
import 'package:patient_holistic_healing/widget/screen/appointment/summary_screen/patient_summary_screen.dart';
import 'package:patient_holistic_healing/widget/screen/login/login_screen.dart';
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

  // This widget is the root of your application.
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
        'setting': (context) => PatientPreferences(),
        'register': (context) => SignUpScreen(),
        'login': (context) => LoginScreen(),
        'home': (context) => SchedulesScreen(),
        'welcome': (context) => SplashScreen(),
      },
    );
  }
}
