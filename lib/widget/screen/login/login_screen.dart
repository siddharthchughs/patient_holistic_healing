import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final firebase = FirebaseAuth.instance;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginState();
}

class _LoginState extends State<LoginScreen> {
  double? _deviceWidth;
  double? _deviceHeight;
  var usernameState = '';
  var passwordState = '';
  final _loginFormKey = GlobalKey<FormState>();
  String loggedInUser = "";

  @override
  void initState() {
    super.initState();
  }

  void loginUser() async {
    final isValid = _loginFormKey.currentState!.validate();
    print(isValid);
    if (!isValid) {
      return;
    }

    _loginFormKey.currentState!.save();
    print(usernameState);
    print(passwordState);
    try {
      final response = await firebase.signInWithEmailAndPassword(
        email: usernameState,
        password: passwordState,
      );
      print(response);
      Navigator.popAndPushNamed(context, 'home');
    } on FirebaseAuthException catch (error) {
      if (error.code == 'email_already_exists') {}
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.message ?? 'Authentication Falied')),
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

  Future<String> getUserInfoMap({required String userId}) async {
    String userInfoSnapshot = FirebaseAuth.instance.currentUser!.refreshToken
        .toString();
    return userInfoSnapshot;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _deviceWidth = MediaQuery.of(context).size.width;
    _deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
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
    );
  }

  Widget loginForm() {
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: _deviceWidth! * 0.05),
      height: _deviceHeight! * 0.50,
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
                SizedBox(height: 28),
                userPasswordInputField(),
                SizedBox(height: 40),
                loginButton(),
                SizedBox(height: 32),
                navigateToSignUp(),
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
      keyboardType: TextInputType.name,
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

        // 3. returns null if the _newUpdatedValue is valid.

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
      ),
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.visiblePassword,
      obscureText: true,
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
  }

  Widget loginButton() {
    return MaterialButton(
      onPressed: loginUser,
      minWidth: _deviceWidth!,
      height: _deviceHeight! * 0.06,
      clipBehavior: Clip.hardEdge,
      color: Colors.blueAccent.shade100,
      textColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: Colors.white),
      ),

      child: Text(
        'Submit',
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.w400),
      ),
    );
  }

  Widget navigateToSignUp() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed('register');
      },
      child: Container(
        clipBehavior: Clip.hardEdge,
        width: _deviceWidth!,
        height: _deviceHeight! * 0.06,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.blueAccent.shade200, width: 2.0),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          'SignUp',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.blueAccent.shade200,
            fontSize: 22,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
