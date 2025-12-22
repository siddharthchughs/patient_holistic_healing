import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;

class FirebaseServices {
  String IMAGECOLLECTION = 'image_post';
  Map? loggedInUser;
  final _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseStore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  File? _image;
  String? userId;

  FirebaseServices();

  Future<bool> userLogin({
    required BuildContext context,
    required String username,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: username, password: password);
      print('Logged value ::${loggedInUser!['name']}');
      if (userCredential.user != null) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      print(error);
      return false;
    }
  }

  // Future<Map> getInfo({required uid}) async {
  //   final userSnnaphot = FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(uid);
  //   DocumentSnapshot snapshot = await userSnnaphot.get();
  //   print('Snapshot :: ${snapshot.id}');
  //   return snapshot.id as Map;
  // }

  Future<bool> signUpUser({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      String userId = userCredential.user!.uid;
      // String filePathName =
      //     Timestamp.now().millisecondsSinceEpoch.toString() +
      //     p.extension(image.path);
      // final uploadImage = _storage
      //     .ref('images/$userId/$filePathName')
      //     .putFile(image);
      // print('Path :: $uploadImage');
      // return uploadImage.then((snaphot) async {
      //   String downloadUrl = await snaphot.ref.getDownloadURL();
      print('Detail ${email + name}');
      //   await FirebaseFirestore.instance.collection('users').doc(userId).set({
      //     'email': email,
      //     'name': name,
      //     'profile_image': downloadUrl,
      //   });
      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        'email': email,
        'name': name,
      });

      // final imageStorageRef = FirebaseStorage.instance
      //     .ref()
      //     .child('user_images')
      //     .child('${userCredntial.user!.uid}.jpg');

      // //      print('SignUp in:: $userCredentials');
      // await imageStorageRef.putFile(image);
      // final imageUrl = await imageStorageRef.getDownloadURL();
      // //    print(imageUrl);

      return true;
    } on FirebaseAuthException catch (e) {
      // 2. Catch the specific error code
      if (e.code == 'email-already-in-use') {
        // 3. Show a user-friendly message and prompt for sign-in
        // ignore: use_build_context_synchronously

        print('Already Exists');

        // Optional: You might offer to send a password reset email here
        // if the user claims they forgot their password.
        // await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      } else {
        // Handle other sign-up errors (e.g., 'weak-password', 'invalid-email')
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     content: Text('Sign Up Failed: ${e.message}'),
        //     backgroundColor: Colors.red,
        //   ),
        // );
        print('Doesnt Exists');
      }
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
  /*
   return _uploadImage.putFile(image).then((_snapshot) async {
        String _downloadUrl = await _snapshot.ref.getDownloadURL();
        await _firebaseStorage.collection(USER_COLLECTION).doc(userId).set({
          'name': name,
          'email': email, 
          'profile_image': image,
        });
        return true;
      });
  */

  Future<bool> postImage(File image) async {
    try {
      String userId = _auth.currentUser!.uid;
      String fileName =
          Timestamp.now().millisecondsSinceEpoch.toString() +
          p.extension(image.path);
      final task = _storage.ref('user_images/$userId/$fileName').putFile(image);
      return task.then((snapshot) async {
        String downloadUrl = await snapshot.ref.getDownloadURL();
        await _firebaseStore.collection('image_feeds').add({
          'userId': userId,
          'timestamp': Timestamp.now(),
          'image': downloadUrl,
        });
        return true;
      });
    } catch (e) {
      print(e);
      return false;
    }
  }

  Stream<QuerySnapshot> getListOfAppointments() {
    return _firebaseStore
        .collection('patient_info')
        .doc(_auth.currentUser!.uid)
        .collection('appointments')
        .snapshots();
  }
  // Stream<QuerySnapshot> getListOfAppointments() {
  //   return _firebaseStore
  //       .collection('patient_info')
  //       .doc(_auth.currentUser!.uid)
  //       .get()
  //       .asStream()
  //       .asyncExpand((documentSnapshot) {
  //     if (documentSnapshot.exists) {
  //       return _firebaseStore
  //           .collection('appointments')
  //           .doc(documentSnapshot.id)
  //           .snapshots();
  //     } else {
  //       return Stream.empty();
  // }

  Future<int?> getcountFeedsById() async {
    final aggregateQuery = await _firebaseStore
        .collection('appointments')
        .count()
        .get();
    return aggregateQuery.count;
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }

  Stream<QuerySnapshot> getUserID() {
    return _firebaseStore.collection('users').snapshots();
  }
}
