import 'package:cloud_firestore/cloud_firestore.dart';
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
  var isLoading = false;
  bool isTextObsecure = true;
  final FirebaseFirestore _firebaseStore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  final _signUpFormKey = GlobalKey<FormState>();
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    _device_Width = MediaQuery.of(context).size.width;
    _device_height = MediaQuery.of(context).size.height;

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
            'Sign Up',
            style: TextStyle(color: Colors.blueAccent, fontSize: 20),
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
          if (isLoading) const CircularProgressIndicator() else signUpButton(),
        ],
      ),
    );
  }

  // Widget addUserImage() {
  //   var imageReceiver = _selectedImage != null
  //       ? FileImage(_selectedImage!)
  //       : NetworkImage('https://i.pravatar.cc/150?img=3');
  //   return GestureDetector(
  //     onTap: () {
  //       FilePicker.platform
  //           .pickFiles(type: FileType.image)
  //           .then(
  //             (imageValue) => {
  //               setState(() {
  //                 _selectedImage = File(imageValue!.files.first.path!);
  //               }),
  //               print(' Image path $_selectedImage'),
  //             },
  //           );
  //     },
  //     child: Container(
  //       width: _device_Width! * 0.60,
  //       height: _device_height! * 0.30,
  //       decoration: BoxDecoration(
  //         borderRadius: BorderRadius.circular(20),
  //         image: DecorationImage(
  //           fit: BoxFit.cover,
  //           image: imageReceiver as ImageProvider,
  //         ),
  //       ),
  //     ),
  //   );
  // }

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
      onTap: () => _focusNode,
      decoration: InputDecoration(
        hintText: 'Email',
        hintStyle: TextStyle(fontSize: 16),
      ),
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.emailAddress,
      validator: (updateEmailValue) {
        if (updateEmailValue == null || updateEmailValue.isEmpty) {
          return 'Please enter your email address';
        }
        final emailValidFormat = RegExp(
          ''
          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
        );
        if (!emailValidFormat.hasMatch(updateEmailValue)) {
          return 'Please enter the email in valid format';
        }
        return null;
      },
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
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              isTextObsecure = !isTextObsecure;
            });
          },
          icon: Icon(isTextObsecure ? Icons.visibility_off : Icons.visibility),
        ),
      ),
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.visiblePassword,
      obscureText: isTextObsecure,
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
      focusNode: _focusNode,
      decoration: InputDecoration(
        hintText: 'ReEnter New Password',
        hintStyle: TextStyle(fontSize: 16),
        suffixIcon: IconButton(
          onPressed: () {},
          icon: Icon(Icons.visibility_off, color: Colors.blueAccent.shade400),
        ),
      ),
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.visiblePassword,
      obscureText: true,
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

  Widget signUpPhoneNoInputField() {
    return TextFormField(
      onTap: () => _focusNode,
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'Phone Number',
        hintStyle: TextStyle(fontSize: 16),
      ),
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.done,
      maxLength: 10,
      maxLines: 1,
      validator: (updatePhoneNo) {
        if (updatePhoneNo == null || updatePhoneNo.isEmpty) {
          return 'Please enter your phone number';
        }
        if (updatePhoneNo.length < 0) {
          return 'Phone Number must have 10 digits';
        }
        return null;
      },
      onChanged: (value) {
        phoneNumberState = value;
      },

      onSaved: (savedPhoneNumberState) {
        setState(() {
          phoneNumberState = savedPhoneNumberState!;
        });
      },
    );
  }

  void _registerPatient() async {
    final isValid = _signUpFormKey.currentState!.validate();

    if (!isValid) {
      return;
    }

    _signUpFormKey.currentState!.save();

    try {
      setState(() {
        isLoading = true;
      });
      if (isLoading) {
        final userCredentials = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
              email: emailAddressState,
              password: passwordState,
            );
        await FirebaseFirestore.instance
            .collection('patients')
            .doc(userCredentials.user!.uid)
            .set({
              'email': emailAddressState,
              'name': usernameState,
              'phone': phoneNumberState,
            });
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
      onPressed: _registerPatient,
      minWidth: _device_Width!,
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

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }
}
