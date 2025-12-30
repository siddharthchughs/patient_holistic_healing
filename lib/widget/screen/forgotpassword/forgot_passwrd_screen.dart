import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

final String USER_COLLECTION = 'users';
Map? currentUser;

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});
  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPasswordScreen> {
  double? _deviceWidth, _deviceHeight;
  var emailAddressState = '';
  var passwordState = '';
  var newpasswordState = '';
  bool isValid = true;
  var isLoading = false;
  bool isTextObsecure = true;
  bool isTextNewPasswordObsecure = true;
  final FirebaseFirestore _firebaseStore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final _forgotPasswordFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  // void forgotPassword() async {
  //   final isValid = _forgotPasswordFormKey.currentState!.validate();
  //   if (!isValid) {
  //     return;
  //   }
  //   _forgotPasswordFormKey.currentState!.save();
  //   setState(() {
  //     isLoading = true;
  //   });

  //   try {
  //     // final userValid = await FirebaseAuth.instance.sendPasswordResetEmail(email: email)
  //     // );

  //     // if (userValid.user != null && mounted) {
  //     //   Navigator.of(context).pushReplacementNamed('home');
  //     // }
  //   } on FirebaseAuthException catch (error) {
  //     if (error.code == 'email_already_exists') {}
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text(error.message ?? 'Authentication Falied')),
  //     );
  //   } finally {
  //     Future.delayed(const Duration(seconds: 5), () {
  //       if (mounted) {
  //         setState(() {
  //           isLoading = false;
  //         });
  //       }
  //     });
  //   }
  // }

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
          iconTheme: IconThemeData(color: Colors.blueAccent.shade400),
          centerTitle: true,
          title: const Text(
            'Forgot Password',
            style: TextStyle(color: Colors.blueAccent, fontSize: 20),
          ),

          backgroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: _deviceWidth! * 0.05),
            margin: EdgeInsets.only(left: 16, right: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [forgotPasswordForm()],
            ),
          ),
        ),
      ),
    );
  }

  Widget forgotPasswordForm() {
    return Form(
      key: _forgotPasswordFormKey,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,

          children: [
            SizedBox(height: 24),
            signUpPasswordInputField(),
            SizedBox(height: 28),
            signUpReConfirmPasswordInputField(),
            SizedBox(height: 28),
            if (isLoading)
              const CircularProgressIndicator()
            else
              submitButton(),
          ],
        ),
      ),
    );
  }

  Widget signUpPasswordInputField() {
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
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.visiblePassword,
      validator: (updatePasswordValue) {
        if (updatePasswordValue == null || updatePasswordValue.isEmpty) {
          return 'Please enter your password';
        }

        if (updatePasswordValue.length < 0 || updatePasswordValue.length <= 6) {
          return 'Password must be greater than 6 characters';
        }

        final passwordValidAlphabetFormat = RegExp(r'[A-Z]');
        if (!updatePasswordValue.contains(passwordValidAlphabetFormat)) {
          return 'Must have atleast one Uppercase letter';
        }

        final passwordValidNumberFormat = RegExp(r'[0-9]');
        if (!updatePasswordValue.contains(passwordValidNumberFormat)) {
          return 'Must have atleast one digit atleast';
        }
        return null;
      },
      onChanged: (value) {
        passwordState = value;
      },

      onSaved: (updatePasswordState) {
        setState(() {
          passwordState = updatePasswordState!;
        });
      },
    );
  }

  Widget signUpReConfirmPasswordInputField() {
    return TextFormField(
      decoration: InputDecoration(
        hintText: 'ReEnter New Password',
        hintStyle: TextStyle(fontSize: 16),
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              isTextNewPasswordObsecure = !isTextNewPasswordObsecure;
              print(isTextNewPasswordObsecure);
            });
          },
          icon: Icon(
            isTextNewPasswordObsecure ? Icons.visibility_off : Icons.visibility,
            color: Colors.blueAccent.shade400,
          ),
        ),
      ),
      obscureText: isTextNewPasswordObsecure,
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.visiblePassword,
      validator: (updatePasswordValue) {
        if (updatePasswordValue == null || updatePasswordValue.isEmpty) {
          return 'Please enter your password';
        }

        if (updatePasswordValue.isEmpty ||
            updatePasswordValue.length < 0 ||
            updatePasswordValue.length <= 6) {
          return 'Password must be greater than 6 characters';
        }

        if (!RegExp(r'[A-Z]').hasMatch(updatePasswordValue)) {
          return 'Must have atleast one Uppercase letter';
        }

        if (!RegExp(r'[0-9]').hasMatch(updatePasswordValue)) {
          return 'Must have atleast one digit atleast';
        }

        if (!newpasswordState.contains(passwordState)) {
          return 'Password Does not match !';
        }

        return null;
      },
      onChanged: (value) {
        newpasswordState = value;
      },

      onSaved: (updatePasswordState) {
        setState(() {
          newpasswordState = updatePasswordState!;
        });
      },
    );
  }

  void _forgotPasswordRecovery() async {
    final isValid = _forgotPasswordFormKey.currentState!.validate();

    if (!isValid) {
      return;
    }

    _forgotPasswordFormKey.currentState!.save();

    try {
      setState(() {
        isLoading = true;
      });
      if (isLoading) {
        final userCredentials = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
              email: 'siddharthchughs@gmail.com',
              password: 'Sid@1234',
            );
        userCredentials.user!.updatePassword('Sid@1212');
      }
    } on FirebaseAuthException catch (errorException) {
      if (errorException.code == 'email alreayd in use') {}
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorException.message ?? 'Authentication failed !'),
        ),
      );
    }
    setState(() {
      isLoading = false;
    });
    Navigator.of(
      context,
    ).pushNamedAndRemoveUntil('login', (Route<dynamic> route) => false);
  }

  Widget submitButton() {
    return MaterialButton(
      onPressed: _forgotPasswordRecovery,
      minWidth: _deviceWidth!,
      height: 45,
      color: Colors.blueAccent.shade400,
      textColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
        side: BorderSide(color: Colors.white),
      ),

      child: Text('Submit', style: TextStyle(fontSize: 16)),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
