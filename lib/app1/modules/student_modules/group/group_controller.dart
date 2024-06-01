import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_canteen/app1/cons/api_end_points.dart';
import 'package:connect_canteen/app1/cons/prefs.dart';
import 'package:connect_canteen/app1/model/group_model.dart';
import 'package:connect_canteen/app1/model/student_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class GroupController extends GetxController {
  var moderatorName = ''.obs;
  var nogroup = true.obs;
  final storage = GetStorage();
  final TextEditingController groupNameController = TextEditingController();
  final TextEditingController groupCodeController = TextEditingController();

  final GlobalKey<FormState> groupFormKey = GlobalKey<FormState>();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  void onClose() {
    // Dispose controllers when the controller is closed
    groupCodeController.dispose();
    groupNameController.dispose();
    super.onClose();
  }

  void creategrout() {
    if (groupFormKey.currentState!.validate()) {
      createNewGroup();
    }
  }

  var groupCreateLoading = false.obs;
  Future<void> createNewGroup() async {
    try {
      groupCreateLoading(true);
      String userid = storage.read(userId);

//------------check whether the group exist or not -------------

      bool groutExist = await checkIfGroupExits();

      if (groutExist) {
        showDialog(
          context: Get.context!,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              title: Text(
                "Failed to Make Group",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                  color: Colors.red,
                ),
              ),
              content: Text(
                "The group code is been reserved",
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
        groupCreateLoading(false);
      } else {
        StudentGroupApiResponse newGroup = StudentGroupApiResponse(
            groupId: userid,
            groupCode: groupCodeController.text.trim(),
            groupName: groupNameController.text.trim(),
            moderator: moderatorName.value);

        // Add the new group to the 'groups' collection
        await _firestore
            .collection(ApiEndpoints.productionGroupCollection)
            .add(newGroup.toJson());

        // Update the user's 'groupid' field in the 'students' collection
        final FirebaseFirestore firestore = FirebaseFirestore.instance;
        final studentDocRef = firestore
            .collection(ApiEndpoints.prodcutionStudentCollection)
            .doc(userid);
        await studentDocRef.update({'groupid': userid});
        groupCreateLoading(false);

        Get.back();
      }
    } catch (e) {
      groupCreateLoading(false);
      log('Error: $e');
      // You can handle the error here, for example, display an error message to the user
    }
  }

//-----------------check if gorup exist ------------
  Future<bool> checkIfGroupExits() async {
    try {
      // Query the "canteen" collection using the provided user ID
      QuerySnapshot querySnapshot = await _firestore
          .collection(ApiEndpoints.productionGroupCollection)
          .where('groupCode', isEqualTo: groupCodeController.text.trim())
          .get();

      // Return true if data exists for the user in the "canteen" collection
      return querySnapshot.docs.isNotEmpty ? true : false;
    } catch (e) {
      // Handle errors
      return false; // Return false in case of error
    }
  }

  //--------------to check if order exist or not. -------

  Future<bool> checkIfOrderExits(String userid) async {
    try {
      // Query the "canteen" collection using the provided user ID
      QuerySnapshot querySnapshot = await _firestore
          .collection(ApiEndpoints.productionOrderCollection)
          .where('cid', isEqualTo: userid)
          .where('checkout', isEqualTo: 'false')
          .get();

      // Return true if data exists for the user in the "canteen" collection
      return querySnapshot.docs.isNotEmpty ? true : false;
    } catch (e) {
      // Handle errors
      return false; // Return false in case of error
    }
  }

  //---------TO FETCH THE GROUP

  Stream<StudentGroupApiResponse?> getGroupData(String groupid) {
    return _firestore
        .collection(ApiEndpoints.productionGroupCollection)
        .where('groupId', isEqualTo: groupid)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        // Assuming that userId is unique and there will be only one document
        return StudentGroupApiResponse.fromJson(
            snapshot.docs.first.data() as Map<String, dynamic>);
      } else {
        return null;
      }
    });
  }

  Stream<List<StudentDataResponse>> getMemberStream(String groupId) {
    return _firestore
        .collection(ApiEndpoints.prodcutionStudentCollection)
        .where('groupid',
            isEqualTo: groupId) // Filter documents by groupid field
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => StudentDataResponse.fromJson(doc.data()))
              .toList(),
        );
  }
  //------------------TO FETCH THE CLASS FRIEND

  Stream<StudentDataResponse?> getClassFriend(String grade) {
    return _firestore
        .collection(ApiEndpoints.productionGroupCollection)
        .where('classes', isEqualTo: storage.read(grade))
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        // Assuming that userId is unique and there will be only one document
        return StudentDataResponse.fromJson(
            snapshot.docs.first.data() as Map<String, dynamic>);
      } else {
        return null;
      }
    });
  }
}
