import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:patient_holistic_healing/widget/screen/appointment/schedules_screen.dart';
import 'package:patient_holistic_healing/widget/screen/login/login_screen.dart';
import 'package:patient_holistic_healing/widget/services/firebase_services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashState();
}

class _SplashState extends State<SplashScreen> {
  final Duration _minSplashDuration = const Duration(seconds: 2);

  // Future to ensure the minimum delay is met
  late Future<void> _splashDelayFuture;
  FirebaseServices? firebaseServices;

  @override
  void initState() {
    super.initState();
    _splashDelayFuture = Future.delayed(_minSplashDuration);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: FutureBuilder(
        future: _splashDelayFuture,
        builder: (ctx, futureSnapshot) {
          final splashContent = Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Holistic \n  Healing \n For Patient',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 45,
                  fontWeight: FontWeight.w400,
                  color: Colors.lightBlueAccent.shade400,
                ),
              ),
              const SizedBox(height: 50),
              // Show a CircularProgressIndicator during the delay
              const SizedBox(
                width: 30,
                height: 30,
                child: CircularProgressIndicator(
                  strokeWidth: 3.0,
                  color: Colors.lightBlueAccent,
                ),
              ),
            ],
          );

          // If the minimum delay is NOT yet complete, show the splash content with progress
          if (futureSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: splashContent);
          }

          return StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (ctx, snapshot) {
              if (snapshot.hasData) {
                return SchedulesScreen();
              }
              return LoginScreen();
            },
          );
        },
      ),
    );
  }
}
