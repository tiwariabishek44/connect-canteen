// reg controller

import 'dart:developer';
import 'dart:isolate';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_canteen/app1/cons/api_end_points.dart';
import 'package:connect_canteen/app1/cons/style.dart';
import 'package:connect_canteen/app1/data/api_models/register_api_response.dart';
import 'package:connect_canteen/app1/modules/common/login/view/login_view.dart';
import 'package:connect_canteen/app1/modules/common/wallet/wallet_controller.dart';
 
import 'package:connect_canteen/app1/widget/custom_sncak_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class RegisterController extends GetxController {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileNumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  var schoolname = ''.obs;
  var schoolId = ''.obs;
  var isPasswordVisible = false.obs;
  var iscPasswordVisible = false.obs;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  var termsAndConditions = false.obs;
  final GlobalKey<FormState> registerFormKey = GlobalKey<FormState>();
  final walletController = Get.put(WalletController());

  // Check validation for the inputs for login
  void userRegister(BuildContext context) {
    if (termsAndConditions.value != true) {
      CustomSnackbar.error(context, "Agree to read terms and conditions");
      return;
    }
    if (!registerFormKey.currentState!.validate()) {}
    registerUser();
  }

//-------Register Student-------
  var isRegisterLoading = false.obs;
  Future<void> registerUser() async {
    try {
      isRegisterLoading(true);

      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      await FirebaseFirestore.instance
          .collection(ApiEndpoints.prodcutionStudentCollection)
          .doc(userCredential.user!.uid)
          .set({
        'userid': userCredential.user!.uid, // Saving userid
        'name': nameController.text,
        'phone': mobileNumberController.text,
        'email': emailController.text,
        'groupid': '',
        'classes': '',
        "schoolId": schoolId.value,
        'schoolName': schoolname.value,
        'profilePicture': '',
        "fineAmount": 0,
      });
      isRegisterLoading(false);
      log("User registration successful");

      await walletController
          .createWallet(userCredential.user!.uid, nameController.text)
          .then((value) {
        isRegisterLoading(false);

        Get.offAll(LoginView());

        showDialog(
            context: Get.context!,
            builder: (BuildContext context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0), // No border radius
                ),
                scrollable: false,
                elevation: 0,
                title: Text(
                  'Success!',
                  style: AppStyles.appbar
                      .copyWith(fontWeight: FontWeight.bold, fontSize: 20.sp),
                ),
                content: Text(
                  'Account created successfully.',
                  style: AppStyles.listTileTitle,
                ),
              );
            });
      });
    } catch (e) {
      isRegisterLoading(false);
      log("Error during user registration: $e");
      // Display an error message to the user
      // You can customize this based on your UI
      Get.snackbar(
        "Registration Failed",
        "An error occurred during registration.",
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  //-----------TO CREATE THE SCHOOLS
  final CollectionReference _schoolCollection = FirebaseFirestore.instance
      .collection(ApiEndpoints.productionSchoolcollection);
  Future<void> uploadDummySchools() async {
    try {
      isRegisterLoading.value = true;

      // List of dummy schools with names and addresses
      final List<Map<String, dynamic>> dummySchools = [
        {
          "name": "Texas International College",
          "address": "Mitrapark-Chabahil, Kathmandu"
        },
        {"name": "St. Xavier's College", "address": "Maitighar, Kathmandu"},
        {"name": "Kathmandu Model College", "address": "Bagbazar, Kathmandu"},
        {
          "name": "Trinity International College",
          "address": "Dillibazar, Kathmandu"
        },
        {"name": "Prime College", "address": "Nayabazar, Kathmandu"},
        {
          "name": "Kathmandu University",
          "address": "Dhulikhel, Kavrepalanchok"
        },
        {
          "name": "Nepal Engineering College",
          "address": "Changunarayan, Bhaktapur"
        },
      ];

      // Upload each dummy school to Firestore
      for (final school in dummySchools) {
        final schoolId = "${school['name'].toLowerCase().replaceAll(' ', '')}";
        await _schoolCollection.add({
          'schoolId': schoolId,
          'name': school['name'],
          'address': school['address'],
          'classes': ['Class A', 'Class B', 'Class C'] // Add your dummy classes

          // You can add additional fields as needed
        });
      }

      isRegisterLoading.value = false;
      // Success message or any other action after upload
    } catch (e) {
      // Error handling
      print("Error uploading dummy schools: $e");
      isRegisterLoading.value = false;
    }
  }

  @override
  void onClose() {
    // Dispose controllers when the controller is closed
    nameController.dispose();
    emailController.dispose();
    mobileNumberController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
