import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

final String USER_COLLECTION = 'users';
Map? currentUser;

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});
  @override
  State<SignUpScreen> createState() => _SignUpState();
}

class _SignUpState extends State<SignUpScreen> {
  double? _device_Width;
  double? _device_height;
  var usernameState = '';
  var emailAddressState = '';
  var passwordState = '';
  var phoneNumberState = '';
  bool isValid = true;
  bool isloggedIn = true;
  var isLoading = false;
  String? confirmpasswordState = '';
  File? _selectedImage;
  final FirebaseFirestore _firebaseStore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  final _signUpFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void registerPatient() async {}

  @override
  Widget build(BuildContext context) {
    _device_Width = MediaQuery.of(context).size.width;
    _device_height = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: const [],
        title: const Text(
          'Sign Up',
          style: TextStyle(color: Colors.blueAccent, fontSize: 25),
        ),

        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: _device_Width! * 0.05),
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
      key: _signUpFormKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,

        children: [
          SizedBox(height: 44),
          signUpUsernameInputField(),
          SizedBox(height: 24),
          signUpEmailInputField(),
          SizedBox(height: 24),
          signUpPasswordInputField(),
          SizedBox(height: 28),
          signUpPhoneNoInputField(),
          SizedBox(height: 28),
          if (isLoading) const CircularProgressIndicator(),
          signUpButton(),
        ],
      ),
    );
  }

  Widget addUserImage() {
    var imageReceiver = _selectedImage != null
        ? FileImage(_selectedImage!)
        : NetworkImage('https://i.pravatar.cc/150?img=3');
    return GestureDetector(
      onTap: () {
        FilePicker.platform
            .pickFiles(type: FileType.image)
            .then(
              (imageValue) => {
                setState(() {
                  _selectedImage = File(imageValue!.files.first.path!);
                }),
                print(' Image path $_selectedImage'),
              },
            );
      },
      child: Container(
        width: _device_Width! * 0.60,
        height: _device_height! * 0.30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: imageReceiver as ImageProvider,
          ),
        ),
      ),
    );
  }

  Widget signUpUsernameInputField() {
    return TextFormField(
      decoration: InputDecoration(
        prefixStyle: TextStyle(backgroundColor: Colors.orangeAccent),
        hintText: 'Username',
        hintStyle: TextStyle(fontSize: 16),
      ),
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.name,
      validator: (updatedUserNameValue) {
        if (updatedUserNameValue == null ||
            updatedUserNameValue.isEmpty ||
            updatedUserNameValue.trim().length < 0) {
          return 'Please enter a valid username';
        }
        return null;
      },
      onSaved: (savedUserText) {
        usernameState = savedUserText!;
      },
    );
  }

  Widget signUpEmailInputField() {
    return TextFormField(
      decoration: InputDecoration(
        hintText: 'Email',
        hintStyle: TextStyle(fontSize: 16),
      ),
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.emailAddress,
      validator: (updateEmailValue) {
        // 1. check if the  _updateEmailValue is null || empty

        if (updateEmailValue == null || updateEmailValue.isEmpty) {
          return 'Please enter your email address';
        }

        //3. followed to this _updateEmailValue has to match the RegExpression

        final emailValidFormat = RegExp(
          ''
          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
        );
        if (!emailValidFormat.hasMatch(updateEmailValue)) {
          return 'Please enter the email in valid format';
        }
        //4. returns null if the _updatePasswordValue is valid.

        return null;
      },

      // emailState is saved over here !
      onSaved: (saveEmail) {
        setState(() {
          emailAddressState = saveEmail!;
          print(emailAddressState);
        });
      },
    );
  }

  Widget signUpPasswordInputField() {
    return TextFormField(
      decoration: InputDecoration(
        hintText: 'Password',
        hintStyle: TextStyle(fontSize: 16),
      ),
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.visiblePassword,
      obscureText: true,
      validator: (updatePasswordValue) {
        // 1. check if the  _updatePasswordValue is null || empty

        if (updatePasswordValue == null || updatePasswordValue.isEmpty) {
          return 'Please enter your password';
        }
        // 2. followed to this _updatePasswordValue has length > 0

        if (updatePasswordValue.length < 0 || updatePasswordValue.length <= 6) {
          return 'Password must be greater than 6 characters';
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
      onChanged: (value) {
        passwordState = value;
      },

      // passwordState is saved over here !
      onSaved: (updatePasswordState) {
        setState(() {
          passwordState = updatePasswordState!;
        });
      },
    );
  }

  Widget signUpPhoneNoInputField() {
    return TextFormField(
      decoration: InputDecoration(
        hintText: 'Phone No',
        hintStyle: TextStyle(fontSize: 16),
      ),
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.number,
      maxLength: 10,
      maxLines: 1,
      validator: (updatePhoneNo) {
        // 1. check if the  updatePhoneNo is null || empty

        if (updatePhoneNo == null || updatePhoneNo.isEmpty) {
          return 'Please enter your phone number';
        }
        // 2. followed to this updatePhoneNo has length > 0

        if (updatePhoneNo.length <= 15) {
          return 'Phone Number must have 10 digits';
        }
        return null;
      },
      onChanged: (value) {
        phoneNumberState = value;
      },

      // passwordState is saved over here !
      onSaved: (savedPhoneNumberState) {
        setState(() {
          phoneNumberState = savedPhoneNumberState!;
        });
      },
    );
  }

  void _registerUser() async {
    final isValid = _signUpFormKey.currentState!.validate();

    if (!isValid || !isloggedIn && _selectedImage == null) {
      return;
    }

    _signUpFormKey.currentState!.save();

    try {
      setState(() {
        isLoading = true;
      });
      if (isLoading) {
        if (isloggedIn) {
          final userCredentials = await FirebaseAuth.instance
              .createUserWithEmailAndPassword(
                email: emailAddressState,
                password: passwordState,
              );

          // final imageStorageRef = FirebaseStorage.instance
          //     .ref()
          //     .child('user_images')
          //     .child('${userCredentials.user!.uid}.jpg');

          // await imageStorageRef.putFile(_selectedImage!);
          // final imageUrl = await imageStorageRef.getDownloadURL();
          await FirebaseFirestore.instance
              .collection('patient_users')
              .doc(userCredentials.user!.uid)
              .set({
                'email': emailAddressState,
                'name': usernameState,
                //                'image_url': imageUrl,
              });
        }
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

  Widget signUpButton() {
    return MaterialButton(
      onPressed: _registerUser,
      minWidth: _device_Width!,
      height: _device_height! * 0.06,
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
}
