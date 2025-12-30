import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:patient_holistic_healing/widget/screen/settings/local_prefrences.dart';
import 'package:shared_preferences/shared_preferences.dart';

final firebase = FirebaseAuth.instance;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginState();
}

class _LoginState extends State<LoginScreen> {
  double? _deviceWidth, _deviceHeight;
  var usernameState = '';
  var passwordState = '';
  final _loginFormKey = GlobalKey<FormState>();
  String loggedInUser = "";
  bool isLoading = false;
  bool isTextObsecure = true;

  void loginUser() async {
    final prefs = await SharedPreferences.getInstance();

    final isValid = _loginFormKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _loginFormKey.currentState!.save();
    setState(() {
      isLoading = true;
    });

    try {
      final userValid = await firebase.signInWithEmailAndPassword(
        email: usernameState,
        password: passwordState,
      );
      print(userValid.user);
      print(userValid.user!.phoneNumber);
      if (userValid.user != null && mounted) {
        saveData(userValid.user!.email, userValid.user!.phoneNumber);
        Navigator.of(context).pushReplacementNamed('home');
      }
    } on FirebaseAuthException catch (error) {
      if (error.code == 'email_already_exists') {}
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.message ?? 'Authentication Falied')),
      );
    } finally {
      Future.delayed(const Duration(seconds: 5), () {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
      });
    }
  }

  void toggleVisibility() {
    setState(() {
      isTextObsecure = !isTextObsecure;
    });
  }

  Widget customProgressBar() {
    if (Platform.isIOS) {
      return const Center(
        child: CupertinoActivityIndicator(radius: 15, color: Colors.blueAccent),
      );
    } else {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
        ),
      );
    }
  }

  // Future<Map> getInfo({required uid}) async {
  //   // UserCredential userCredential = await FirebaseAuth.instance
  //   //     .signInWithEmailAndPassword(
  //   //       email: usernameState,
  //   //       password: passwordState,
  //   //     );
  //   final userSnnaphot = FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(FirebaseAuth.instance.currentUser!.uid);
  //   final DocumentSnapshot snapshot = await userSnnaphot.get();
  //   return snapshot.id as Map;
  // }

  // Stream<QuerySnapshot> getUserID() {
  //   return FirebaseFirestore.instance.collection('users').snapshots();
  // }

  // Future<String> getUserInfoMap({required String userId}) async {
  //   String userInfoSnapshot = FirebaseAuth.instance.currentUser!.refreshToken
  //       .toString();
  //   return userInfoSnapshot;
  // }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _deviceWidth = MediaQuery.of(context).size.width;
    _deviceHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        appBar: AppBar(
          actions: const [],
          title: const Text(
            'Login',
            style: TextStyle(color: Colors.blueAccent, fontSize: 22),
          ),

          backgroundColor: Colors.white,
        ),
        body: Container(alignment: Alignment.center, child: loginForm()),
      ),
    );
  }

  Widget loginForm() {
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
      height: _deviceHeight! * 0.70,
      child: Form(
        key: _loginFormKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Column(
              children: [
                userTextInputField(),
                SizedBox(height: 30),
                userPasswordInputField(),
                SizedBox(height: 30),
                if (isLoading) customProgressBar() else loginButton(),
                SizedBox(height: 32),
                navigateToSignUp(),
                SizedBox(height: 28),
                Container(
                  width: _deviceWidth!,
                  alignment: Alignment.topLeft,
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: navigateToForgotPassword(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget userTextInputField() {
    return TextFormField(
      decoration: InputDecoration(
        hintText: 'Username',
        hintStyle: TextStyle(fontSize: 16),
      ),
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.text,
      validator: (newUpdatedValue) {
        // 1. check if the  _newUpdatedValue is null || empty

        if (newUpdatedValue == null || newUpdatedValue.isEmpty) {
          return 'Please enter an email address';
        }
        // 2. followed to this _newUpdatedValue has Regex.hasmatch()

        final emailValidFormat = RegExp(
          ''
          r'^[\w-\.]+@([\w-]+\.com)+[\w-]{2,4}$',
        );
        if (emailValidFormat.hasMatch(newUpdatedValue)) {
          return 'Please enter the email in valid format';
        }
        return null;
      },
      onSaved: (updateUserTextState) {
        usernameState = updateUserTextState!;
      },
    );
  }

  Widget userPasswordInputField() {
    return TextFormField(
      decoration: InputDecoration(
        hintText: 'Password',
        hintStyle: TextStyle(fontSize: 16),
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              isTextObsecure = !isTextObsecure;
              print(isTextObsecure);
            });
          },
          icon: Icon(
            isTextObsecure ? Icons.visibility_off : Icons.visibility,
            color: Colors.blueAccent.shade400,
          ),
        ),
      ),
      obscureText: isTextObsecure,
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.visiblePassword,

      validator: (updatePasswordValue) {
        // 1. check if the  _updatePasswordValue is null || empty

        if (updatePasswordValue == null || updatePasswordValue.isEmpty) {
          return 'Please enter your password';
        }
        // 2. followed to this _updatePasswordValue has length > 0

        if (updatePasswordValue.length < 3) {
          return 'Password must be greater than 3 characters';
        }

        //3. followed to this _updatePasswordValue has to have one Uppercase

        final passwordValidAlphabetFormat = RegExp(r'[A-Z]');
        if (!updatePasswordValue.contains(passwordValidAlphabetFormat)) {
          return 'Must have atleast one Uppercase letter';
        }

        //4. // followed to this _updatePasswordValue has to have one digit atleast

        final passwordValidNumberFormat = RegExp(r'[0-9]');
        if (!updatePasswordValue.contains(passwordValidNumberFormat)) {
          return 'Must have atleast one digit atleast';
        }
        //5. returns null if the _updatePasswordValue is valid.

        return null;
      },

      // passwordState is saved over here !
      onSaved: (updatePasswordTextState) {
        passwordState = updatePasswordTextState!;
      },
    );
    // return TextFormField(
    //   // 2. Set obscureText to your variable
    //   obscureText: isTextObsecure,
    //   decoration: InputDecoration(
    //     labelText: 'Password',
    //     hintText: 'Enter your password',
    //     suffixIcon: IconButton(
    //       onPressed: toggleVisibility,
    //       icon: Icon(
    //         // 5. Change the icon based on the state
    //         isTextObsecure ? Icons.visibility_off : Icons.visibility,
    //       ),
    //     ),
    //   ),
    // );
  }

  Widget loginButton() {
    return MaterialButton(
      onPressed: loginUser,
      minWidth: _deviceWidth!,
      height: 45,
      clipBehavior: Clip.hardEdge,
      color: Colors.white,
      textColor: Colors.blueAccent.shade400,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
        side: BorderSide(color: Colors.blueAccent.shade400),
      ),
      child: Text(
        'Submit',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
      ),
    );
  }

  Widget navigateToSignUp() {
    return MaterialButton(
      onPressed: () {
        Navigator.of(context).pushNamed('register');
      },
      minWidth: _deviceWidth!,
      height: 45,
      color: Colors.blueAccent.shade400,
      textColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
        side: BorderSide(color: Colors.white),
      ),

      child: Text('SignUp', style: TextStyle(fontSize: 16)),
    );
  }

  Widget navigateToForgotPassword() {
    return TextButton.icon(
      onPressed: () {
        Navigator.of(context).pushNamed('forgotpassword');
      },
      label: Text(
        'Forgot Password',
        style: TextStyle(color: Colors.blueAccent.shade400, fontSize: 16),
      ),
    );
  }
}
