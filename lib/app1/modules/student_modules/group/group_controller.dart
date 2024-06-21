import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_canteen/app1/cons/api_end_points.dart';
import 'package:connect_canteen/app1/cons/prefs.dart';
import 'package:connect_canteen/app1/model/group_model.dart';
import 'package:connect_canteen/app1/model/student_model.dart';
import 'package:connect_canteen/app1/widget/custom_sncak_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class GroupController extends GetxController {
  var moderatorName = ''.obs;
  var nogroup = true.obs;
  final storage = GetStorage();
  final TextEditingController groupNameController = TextEditingController();
  final TextEditingController groupCodeController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final GlobalKey<FormState> groupFormKey = GlobalKey<FormState>();
  var deleteLoading = false.obs;

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

  void deleteGro(String groupCode) async {
    deleteLoading(true);
    if (formKey.currentState!.validate()) {
      bool isexist = await checkIfGroupOrder(groupCode);
      if (isexist) {
        deleteLoading(false);
        showDialog(
          context: Get.context!,
          builder: (BuildContext context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              elevation: 0,
              backgroundColor: Colors.transparent,
              child: contentBox(context),
            );
          },
        );
      } else {
        deleteGroup(groupCode);
      }
    }
  }

  Widget contentBox(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(20.0),
            child: Column(
              children: [
                Icon(
                  Icons.warning,
                  color: Color.fromARGB(255, 255, 17, 0),
                  size: 30.sp,
                ),
                SizedBox(height: 20),
                const Text(
                  'Cannot Delete Group',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Some One have ordered under this group.',
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: Container(
                      padding: EdgeInsets.all(12.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "   Ok   ",
                            style: TextStyle(
                              color: Color.fromARGB(255, 255, 255, 255),
                              fontWeight: FontWeight.bold,
                              fontSize: 17.sp,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> checkIfGroupOrder(String groupcod) async {
    try {
      // Query the "canteen" collection using the provided user ID
      QuerySnapshot querySnapshot = await _firestore
          .collection(ApiEndpoints.productionOrderCollection)
          .where('groupcod', isEqualTo: groupcod)
          .where('checkout', isEqualTo: 'false')
          .get();

      // Return true if data exists for the user in the "canteen" collection
      return querySnapshot.docs.isNotEmpty ? true : false;
    } catch (e) {
      // Handle errors
      return false; // Return false in case of error
    }
  }

// Method to delete a group and remove associated students
  Future<void> deleteGroup(String groupCode) async {
    try {
      deleteLoading(true);
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Step 1: Query all students in the group
      QuerySnapshot studentQuerySnapshot = await firestore
          .collection(ApiEndpoints.prodcutionStudentCollection)
          .where('groupcod', isEqualTo: groupCode)
          .get();

      List<DocumentSnapshot> studentDocs = studentQuerySnapshot.docs;

      // Step 2: Query the group document itself
      QuerySnapshot groupQuerySnapshot = await firestore
          .collection(ApiEndpoints.productionGroupCollection)
          .where('groupCode', isEqualTo: groupCode)
          .get();

      List<DocumentSnapshot> groupDocs = groupQuerySnapshot.docs;

      // Start a batch
      WriteBatch batch = firestore.batch();

      // Update each student document in the batch
      for (DocumentSnapshot studentDoc in studentDocs) {
        batch.update(studentDoc.reference, {
          'groupid': '',
          'groupcod': '',
          'groupname': '',
        });
      }

      // Delete the group document in the batch
      for (DocumentSnapshot groupDoc in groupDocs) {
        batch.delete(groupDoc.reference);
      }

      // Commit the batch
      await batch.commit();
      deleteLoading(false);
      Get.back();
      CustomSnackbar.success(Get.context!, 'Group deleted successfully');
    } catch (e) {
      log('Error deleting group: $e');
      CustomSnackbar.error(Get.context!, 'Failed to delete group');
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
                "Failed to Make Pin",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                  color: Colors.red,
                ),
              ),
              content: Text(
                "The PIn code is been reserved",
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
            groupName: moderatorName.value,
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
        await studentDocRef.update({
          'groupid': userid,
          'groupcod': groupCodeController.text.trim(),
          'groupname': moderatorName.value
        });
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

  var loading = false.obs;
// to remove user form group.
  Future<void> removeMember(
    String studetnId,
  ) async {
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
        await querySnapshot.docs.first.reference
            .update({'groupid': '', 'groupcod': '', 'groupname': ''});
        loading(false);
        CustomSnackbar.success(Get.context!, 'Remove successfully');
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

// -------------add friend to group

  Future<void> addMember(
    String studetnId,
    String groupid,
    String groupcode,
  ) async {
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
        await querySnapshot.docs.first.reference.update({
          'groupid': groupid,
          'groupcod': groupcode,
        });
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
}
