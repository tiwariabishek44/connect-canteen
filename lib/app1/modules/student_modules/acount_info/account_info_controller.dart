import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_canteen/app1/cons/api_end_points.dart';
import 'package:connect_canteen/app1/widget/custom_sncak_bar.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AccountInfoController extends GetxController {
  var image = File('').obs; // Here's an example using GetX
  final GlobalKey<FormState> nameForm = GlobalKey<FormState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void doUpdate(String studetnid, String newName) {
    if (nameForm.currentState!.validate()) {
      updateUserName(studetnid, newName).then((value) {
        Get.back();
      });
      ;
    }
  }

  void doCalssUpdae(String studetnid, String grade) {
    if (grade != '') {
      updateClass(studetnid, grade).then((value) {
        Get.back();
      });
    }
  }

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

//------------to update the profile picture

  Future<void> updateProfilePicture(
    String studentid,
  ) async {
    try {
      loading(true);

      // Fetch the user's current profile picture URL
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection(ApiEndpoints.prodcutionStudentCollection)
          .where('userid', isEqualTo: studentid)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
        String currentProfilePictureURL =
            documentSnapshot.get('profilePicture');

        // Delete the existing profile picture from Firebase Storage
        if (currentProfilePictureURL != null &&
            currentProfilePictureURL.isNotEmpty) {
          Reference oldStorageReference =
              FirebaseStorage.instance.refFromURL(currentProfilePictureURL);
          await oldStorageReference.delete();
        }

        // Upload the new profile picture
        Reference newStorageReference = FirebaseStorage.instance
            .ref()
            .child('studentProfilePicture/${DateTime.now()}.png');
        UploadTask uploadTask = newStorageReference.putFile(image.value);
        TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);

        // Get download URL from Firebase Storage
        String newImageURL = await taskSnapshot.ref.getDownloadURL();

        // Update Firestore document with the new profile picture URL
        await documentSnapshot.reference
            .update({'profilePicture': newImageURL});

        loading(false);
        Get.back();
        CustomSnackbar.success(Get.context!, 'Updated successfully');
      } else {
        loading(false);
        Get.snackbar('Error', 'No student found with ID');
      }
    } catch (e) {
      loading(false);
      Get.snackbar('Error', e.toString());
    }
  }

  // ------------to update the user name
  var loading = false.obs;
  Future<void> updateUserName(String studetnId, String newName) async {
    try {
      loading(true);
      // Query for the document with the given product ID
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection(ApiEndpoints.prodcutionStudentCollection)
          .where('userid',
              isEqualTo: studetnId) // Assuming productId is the field name
          .get();

      // Check if any documents match the query
      if (querySnapshot.docs.isNotEmpty) {
        // Update the 'active' field of the first document that matches the query
        await querySnapshot.docs.first.reference.update({'name': newName});
        loading(false);
        CustomSnackbar.success(Get.context!, 'updated successfully');
      } else {
        loading(false);

        Get.snackbar('Error', 'No student found with ID');
      }
      loading(false);
    } catch (e) {
      loading(false);

      log(e.toString());
      Get.snackbar('Error', 'Failed to update product status: $e');
    }
  }

  var newClass = 'Select Class'.obs;
  //------------- to update the class .
  Future<void> updateClass(String studentId, String className) async {
    try {
      loading(true);

      // Query for the document with the given product ID
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection(ApiEndpoints.prodcutionStudentCollection)
          .where('userid',
              isEqualTo: studentId) // Assuming productId is the field name
          .get();

      // Check if any documents match the query
      if (querySnapshot.docs.isNotEmpty) {
        // Update the 'active' field of the first document that matches the query
        await querySnapshot.docs.first.reference.update({'classes': className});
        loading(false);

        CustomSnackbar.success(Get.context!, 'updated successfully');
      } else {
        loading(false);

        Get.snackbar('Error', 'No student found ');
      }
    } catch (e) {
      loading(false);

      log(e.toString());
      Get.snackbar('Error', 'Failed to update product status: $e');
    }
  }

  //-------------------to fetch the list of the school class.
  Stream<List<String>> getClassNames(String schoolId) {
    return _firestore
        .collection(ApiEndpoints.productionSchoolcollection)
        .where('schoolId', isEqualTo: schoolId)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        // Assuming there's only one document per schoolId
        List<dynamic> classes = snapshot.docs.first.data()['classes'];
        return List<String>.from(classes);
      } else {
        return [];
      }
    });
  }
}
