import 'dart:developer';
import 'dart:io';

import 'package:connect_canteen/app/config/api_end_points.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_storage/get_storage.dart';
import 'package:connect_canteen/app/models/group_api_response.dart';
import 'package:connect_canteen/app/models/users_model.dart';
import 'package:connect_canteen/app/modules/common/login/login_controller.dart';
import 'package:connect_canteen/app/repository/fetch_groupmenber_repository.dart';
import 'package:connect_canteen/app/repository/get_group_repository.dart';
import 'package:connect_canteen/app/repository/group_member_delete_repository.dart';
import 'package:connect_canteen/app/service/api_client.dart';

class GroupController extends GetxController {
  final startNewGroup = false.obs;
  final logincontroller = Get.put(LoginController());
  final storage = GetStorage();
  final groupnameController = TextEditingController();
  final newGroupKey = GlobalKey<FormState>();
  var groupCode = ''.obs;
  var otpError = true.obs;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var deleteMemberLoading = false.obs;

  final RxList<UserDataResponse> students = <UserDataResponse>[].obs;
  Rx<GroupApiResponse?> currentGroup = Rx<GroupApiResponse?>(null);

  var isloading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchGroupData();
    fecthGroupMember();
  }

  void createGroup(BuildContext context) {
    if (newGroupKey.currentState!.validate()) {
      createNewGroup();
    }
  }




  var groupCreateLoading = false.obs;
  Future<void> createNewGroup() async {
    try {
      groupCreateLoading(true);
      String userId = _auth.currentUser!.uid;

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
        GroupApiResponse newGroup = GroupApiResponse(
          groupId: userId,
          groupCode: groupCode.value,
          groupName: groupnameController.text.trim(),
          moderator:
              logincontroller.userDataResponse.value.response!.first.name,
        );

        // Add the new group to the 'groups' collection
        await _firestore.collection('groups').add(newGroup.toJson());

        // Update the user's 'groupid' field in the 'students' collection
        final FirebaseFirestore firestore = FirebaseFirestore.instance;
        final studentDocRef = firestore.collection('students').doc(userId);
        await studentDocRef.update({'groupid': userId});
        logincontroller.fetchUserData().then((value) {
          fetchGroupData();
          fecthGroupMember();
          Get.back();
        });
        groupCreateLoading(false);
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
          .collection('groups')
          .where('groupCode', isEqualTo: groupCode.value)
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
          .collection(ApiEndpoints.orderCollection)
          .where('cid', isEqualTo: userid)
          .where('checkout', isEqualTo: 'false')
          .get();

      log(" this is the query snapshot result  ${querySnapshot.docs.length} ");

      // Return true if data exists for the user in the "canteen" collection
      return querySnapshot.docs.isNotEmpty ? true : false;
    } catch (e) {
      // Handle errors
      return false; // Return false in case of error
    }
  }

//---------to fetch the group  data------------
  var fetchGroupedData = false.obs;
  final GetGroupRepository groupRepository = GetGroupRepository();
  final Rx<ApiResponse<GroupApiResponse>> groupResponse =
      ApiResponse<GroupApiResponse>.initial().obs;

  Future<void> fetchGroupData() async {
    try {
      isloading(true);
      fetchGroupedData(false);
      groupResponse.value = ApiResponse<GroupApiResponse>.loading();
      final groupResult = await groupRepository.getGroupData(
          logincontroller.userDataResponse.value.response!.first.groupid);
      if (groupResult.status == ApiStatus.SUCCESS) {
        groupResponse.value =
            ApiResponse<GroupApiResponse>.completed(groupResult.response);
        if (groupResponse.value.response!.isNotEmpty) {
          fecthGroupMember();
          isloading(false);

          log("********** fetch group data ");

          fetchGroupedData(true);
        }
      }
      isloading(false);
    } catch (e) {
      isloading(false);

      debugPrint('Error while getting data: $e');
    }
  }

//------------fetch the group members ----------//

  final FetchGroupMemberRepository groupMemberRepository =
      FetchGroupMemberRepository();
  final Rx<ApiResponse<UserDataResponse>> groupMemberResponse =
      ApiResponse<UserDataResponse>.initial().obs;

  var grouMemberFetch = false.obs;
  Future<void> fecthGroupMember() async {
    try {
      grouMemberFetch(false);
      groupMemberResponse.value = ApiResponse<UserDataResponse>.loading();
      final groupMemberResult = await groupMemberRepository.getGroupMember(
          logincontroller.userDataResponse.value.response!.first.groupid);
      if (groupMemberResult.status == ApiStatus.SUCCESS) {
        groupMemberResponse.value =
            ApiResponse<UserDataResponse>.completed(groupMemberResult.response);
        if (groupMemberResponse.value.response!.length != 0) {
          grouMemberFetch(true);
        }
      }
    } catch (e) {}
  }

  ///-----------to fetchall student of class----------//

//-----------add friends in group----------//
  Future<void> addFriends(String studentid) async {
    try {
      isloading(true);
      String userId = _auth.currentUser!.uid;
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Get the document reference for the current user
      final DocumentSnapshot<Map<String, dynamic>> studentDocSnapshot =
          await firestore.collection('students').doc(studentid).get();
      await studentDocSnapshot.reference.update({'groupid': userId});
      fecthGroupMember().then((value) {
        isloading(false);
      });
    } catch (e) {
      // Document for the user doesn't exist, handle this case

      print('Error adding friends: $e');
      // Add further error handling logic if needed
    }
  }

  final deleteGroupMemberRepository =
      GroupMemberDeleteRepository(); // Instantiate AddFriendRepository

  Future<void> deleteMember(String studentId) async {
    try {
      deleteMemberLoading(true);
      final response =
          await deleteGroupMemberRepository.deleteGroupMember(studentId);
      if (response.status == ApiStatus.SUCCESS) {
        fecthGroupMember();

        deleteMemberLoading(false);
      } else {
        deleteMemberLoading(false);
      }
    } catch (e) {
      deleteMemberLoading(false);
    }
  }

  String? textVaidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter  group name';
    }

    return null; // Return null if the password meets the criteria
  }
}
