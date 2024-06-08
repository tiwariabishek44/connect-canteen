import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_canteen/app/modules/common/login/login_page.dart';
import 'package:connect_canteen/app/modules/common/wallet/controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class RegisterController extends GetxController {
  final WalletController walletController = Get.put(WalletController());

  final storage = GetStorage();
  // TextEditingController for the email field
  final emailcontroller = TextEditingController();
  final namecontroller = TextEditingController();
  final phonenocontroller = TextEditingController();
  final passwordcontroller = TextEditingController();
  final storeNamecontroller = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final termsAndConditions = false.obs;
  final isregisterloading = false.obs;
  final registerFromkey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  var image = File('').obs; // Here's an example using GetX

//-------------TO PICK THE IMAGE FORM THE MOBILE-------------//
  Future<void> pickImages() async {
    final picker = ImagePicker();

    await showModalBottomSheet(
      context: Get.overlayContext!,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Gallery'),
                onTap: () async {
                  Navigator.of(context).pop();
                  final pickedFile =
                      await picker.pickImage(source: ImageSource.gallery);
                  if (pickedFile != null) {
                    image.value = File(pickedFile.path);
                  }
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Camera'),
                onTap: () async {
                  Navigator.of(context).pop();
                  final pickedFile =
                      await picker.pickImage(source: ImageSource.camera);
                  if (pickedFile != null) {
                    image.value = File(pickedFile.path);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void registerSubmit(
    String classes,
  ) {
    if (registerFromkey.currentState!.validate()) {
      termsAndConditions.value == true && image.value != null
          ? registerUser(classes)
          : Get.snackbar(
              snackPosition: SnackPosition.TOP,
              "Accept Terms & Condition",
              'Accept it');
    }
  }

  Future<void> registerUser(String classes) async {
    try {
      isregisterloading(true);

      {
        Reference storageReference = FirebaseStorage.instance
            .ref()
            .child('profilePicture/${DateTime.now()}.png');
        UploadTask uploadTask = storageReference.putFile(image.value);
        TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);

        // Get download URL from Firebase Storage
        String imageURL = await taskSnapshot.ref.getDownloadURL();

//-----------update the user -----------
        UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
          email: emailcontroller.text,
          password: passwordcontroller.text,
        );

        await FirebaseFirestore.instance
            .collection('students')
            .doc(userCredential.user!.uid)
            .set({
          'userid': userCredential.user!.uid, // Saving userid
          'name': namecontroller.text,
          'phone': phonenocontroller.text,
          'email': emailcontroller.text,
          'groupid': '',
          'classes': classes,
          'profilePicture': imageURL,
          'studentScore': 0,
          "fineAmount": 0,
        });
        log("User registration successful");

        await walletController
            .createWallet(userCredential.user!.uid, namecontroller.text)
            .then((value) {
          isregisterloading(false);

          clearTextControllers();

          Get.offAll(LoginScreen());
          showDialog(
              context: Get.context!,
              builder: (BuildContext context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(0.0), // No border radius
                  ),
                  scrollable: false,
                  elevation: 0,
                  title: Text('Success!'),
                  content: const Text('Account created successfully.'),
                  actions: [
                    GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Container(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.0.w, vertical: 2.h),
                          child: Text(
                            "OK",
                            style:
                                TextStyle(fontSize: 19.sp, color: Colors.red),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              });
        });
      }
    } catch (e) {
      isregisterloading(false);
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

  String? usernameValidator(String? value) {
    // if(fieldLostFocus == usernameController.hashCode)
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    if (value.trim().length < 4) {
      return 'Username must be at least 4 characters in length';
    }
    // Return null if the entered username is valid
    return null;
  }

  String? emailValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your email address';
    }
    // Check if the entered email has the right format
    if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    // Return null if the entered email is valid
    return null;
  }

  String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    // Check for additional criteria (e.g., at least one digit and one special character)

    return null; // Return null if the password meets the criteria
  }

  String? confirmPasswordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    if (value != passwordcontroller.value.text) {
      return 'Confimation password does not match the entered password';
    }

    return null;
  }

  String? phoneValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a phone no';
    }
    if (value.length != 10) {
      return 'Phone no must be  10 digits';
    }
    // Check for additional criteria (e.g., at least one digit and one special character)

    return null; // Return null if the password meets the criteria
  }

  void clearTextControllers() {
    emailcontroller.clear();
    namecontroller.clear();
    phonenocontroller.clear();
    passwordcontroller.clear();
  }

  //==========CANTEEN REGISTER =========

  Future<void> helperRegister() async {
    try {
      isregisterloading(true);

      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: 'canteen@gmail.com',
        password: "1234567890",
      );

      await FirebaseFirestore.instance
          .collection('canteen')
          .doc(userCredential.user!.uid)
          .set({
        'userid': userCredential.user!.uid, // Saving userid
        'name': 'Texas Canteen',
        'phone': '9090909090',
        'email': "canteen@gmail.com",
        'type': "owner",
      });
      log("User registration successful");

      isregisterloading(false);
      clearTextControllers();
      Get.back();
    } catch (e) {
      isregisterloading(false);
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
}
