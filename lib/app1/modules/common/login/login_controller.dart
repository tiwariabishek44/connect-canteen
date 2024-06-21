import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_canteen/app/local_notificaiton/local_notifications.dart';
import 'package:connect_canteen/app/modules/canteen_helper/helper%20main%20screen/main_screen.dart';
import 'package:connect_canteen/app1/cons/api_end_points.dart';
import 'package:connect_canteen/app1/cons/prefs.dart';
import 'package:connect_canteen/app1/model/student_model.dart';
import 'package:connect_canteen/app1/modules/canteen_helper/helper_main_screen/helper_main.dart';
import 'package:connect_canteen/app1/modules/canteen_module.dart/canteen_main_screen/canteen_main_screen.dart';
import 'package:connect_canteen/app1/modules/common/logoin_option/login_option.dart';
import 'package:connect_canteen/app1/modules/common/logoin_option/login_option_controller.dart';
import 'package:connect_canteen/app1/modules/student_modules/student_mainscreen/student_main_screen.dart';
import 'package:connect_canteen/app1/widget/custom_sncak_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LoginController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  var termsAndConditions = false.obs;
  var isPasswordVisible = false.obs;
  final formkeys = GlobalKey<FormState>();

  final storage = GetStorage();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // Observable for student data response
  final studentDataResponse = Rxn<StudentDataResponse?>();
  final loiginOptionController = Get.put(LoginOptionController());
  @override
  void onClose() {
    // Dispose controllers when the controller is closed
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void userLogin() {
    log('-----------------this is user loign ${loiginOptionController.userTypes.value}');
    if (formkeys.currentState!.validate()) {
      dologin();
    }
  }

  var isLoginLoading = false.obs;

  void dologin() async {
    try {
      String endpoint = loiginOptionController.userTypes.value == 'student'
          ? ApiEndpoints.prodcutionStudentCollection
          : ApiEndpoints.productioCanteenCollection;

      isLoginLoading.value = true;
      // Attempt to sign in with email and password
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      bool userExits = await checkIfUserExits(_auth.currentUser!.uid, endpoint);
      if (userExits) {
        LocalNotifications.showScheduleNotification(
            title: "Login Succesfull",
            body: "Have a greate Day!",
            payload: "This is periodic data");
        saveDataLocally(Get.context!);
      } else {
        // Perform both sign-out and display the login failure dialog
        await _auth.signOut();
        showDialog(
          context: Get.context!,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              title: Text(
                "Login Failed",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                  color: Colors.red,
                ),
              ),
              content: Text(
                "You are not allowed to login.",
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black,
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "OK",
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      }
      isLoginLoading.value = false;
    } on FirebaseAuthException catch (e) {
      log('Error: $e');
      // Handle FirebaseAuthException
      isLoginLoading.value = false;

      if (e.code == 'user-not-found') {
        CustomSnackbar.error(Get.context!, 'User Not Fount');
      } else if (e.code == 'wrong-password') {
        CustomSnackbar.error(Get.context!, 'Wrong Password');
      } else if (e.code == 'invalid-credential') {
        log(e.code);
        CustomSnackbar.error(Get.context!, 'Invalid-credential');
      }
    } catch (e) {
      log('Error: $e');
      CustomSnackbar.error(Get.context!, 'Something went wrong');
      // Handle other errors
    }
  }

//-----------------TO CHECK USER IS REGISTER OR NOT

  Future<bool> checkIfUserExits(String userId, String collection) async {
    try {
      log(" thisi sthe collection name :::::$collection");

      // Query the "canteen" collection using the provided user ID
      QuerySnapshot querySnapshot = await _firestore
          .collection(collection)
          .where('userid', isEqualTo: userId)
          .get();

      // Return true if data exists for the user in the "canteen" collection
      return querySnapshot.docs.isNotEmpty ? true : false;
    } catch (e) {
      // Handle errors
      log("Error checking if canteen exists: $e");
      return false; // Return false in case of error
    }
  }

//----------- TO FETCH THE STUDETN DATA

  Stream<StudentDataResponse?> getStudetnData() {
    return _firestore
        .collection(ApiEndpoints.prodcutionStudentCollection)
        .where('userid', isEqualTo: storage.read(userId))
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        studentDataResponse.value = StudentDataResponse.fromJson(
            snapshot.docs.first.data() as Map<String, dynamic>);

        // Assuming that userId is unique and there will be only one document
        return StudentDataResponse.fromJson(
            snapshot.docs.first.data() as Map<String, dynamic>);
      } else {
        return null;
      }
    });
  }

//-------to do auto login---------
  bool autoLogin() {
    if (storage.read(userId) != null && storage.read(userTypes) != null) {
      return true;
    }
    return false;
  }

//--to do logout------------------
  Future<void> logout() async {
    try {
      await _auth.signOut();
      storage.remove(userTypes);
      storage.remove(
        userId,
      );

      Get.offAll(() => OnboardingScreen());
    } catch (e) {
      // Handle logout errors
      Get.snackbar("Logout Failed", e.toString());
    }
  }

//-------- to save data locally

  void saveDataLocally(BuildContext context) {
    storage.write(userId, _auth.currentUser!.uid);
    storage.write(
        userTypes,
        loiginOptionController.userTypes.value == 'student'
            ? 'student'
            : 'canteen');

    if (loiginOptionController.userTypes.value == 'student') {
      log(' this is hte collection name :::::${loiginOptionController.userTypes.value}');
      Get.offAll(() => StudentMainScreenView());
    } else if (loiginOptionController.userTypes.value == 'canteen') {
      log(' this is hte collection name :::::${loiginOptionController.userTypes.value}');

      Get.offAll(() => CanteenMainScreen());
    }
  }
}
