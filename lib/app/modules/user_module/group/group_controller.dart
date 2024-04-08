import 'dart:convert';
import 'dart:developer';

import 'package:connect_canteen/app/models/product_model.dart';
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
  final groupPinController = TextEditingController();

  FirebaseAuth _auth = FirebaseAuth.instance;
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

  Future<void> createNewGroup() async {
    try {
      isloading(true);
      String userId = _auth.currentUser!.uid;
      // Check if a group with the same pin already exists
      QuerySnapshot pinSnapshot = await _firestore
          .collection('groups')
          .where('groupCode', isEqualTo: "1429"

              //  groupPinController.text.trim()

              )
          .get();

      if (pinSnapshot.docs.isNotEmpty) {
        // If a group with the same pin already exists, throw an exception
        throw Exception('Another group with the same pin already exists.');
      }

      // If no group with the same pin exists, proceed to create a new group
      GroupApiResponse newGroup = GroupApiResponse(
        groupId: userId,
        groupCode: "1429",
        groupName: groupPinController.text.trim(),
        moderator: logincontroller.userDataResponse.value.response!.first.name,
      );

      // Add the new group to the 'groups' collection
      await _firestore.collection('groups').add(newGroup.toJson());

      // Update the user's 'groupid' field in the 'students' collection
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      final studentDocRef = firestore.collection('students').doc(userId);
      await studentDocRef.update({'groupid': userId});

      logincontroller.fetchUserData();
      fecthGroupMember();
      Get.back();
      isloading(false);
    } catch (e) {
      isloading(false);
      log('Error: $e');
      // You can handle the error here, for example, display an error message to the user
    }
  }

//---------to fetch the group  data------------
  var fetchGrouped = false.obs;
  final GetGroupRepository groupRepository = GetGroupRepository();
  final Rx<ApiResponse<GroupApiResponse>> groupResponse =
      ApiResponse<GroupApiResponse>.initial().obs;
  Future<void> fetchGroupData() async {
    try {
      isloading(true);
      fetchGrouped(false);
      groupResponse.value = ApiResponse<GroupApiResponse>.loading();
      final groupResult = await groupRepository.getGroupData(
          logincontroller.userDataResponse.value.response!.first.groupid);
      if (groupResult.status == ApiStatus.SUCCESS) {
        groupResponse.value =
            ApiResponse<GroupApiResponse>.completed(groupResult.response);
        if (groupResponse.value.response!.isNotEmpty) {
          fetchGrouped(true);
        }
        fecthGroupMember();
      }
    } catch (e) {
      isloading(false);

      debugPrint('Error while getting data: $e');
    } finally {
      isloading(false);
    }
  }

//------------fetch the group members ----------//

  final FetchGroupMemberRepository groupMemberRepository =
      FetchGroupMemberRepository();
  final Rx<ApiResponse<UserDataResponse>> groupMemberResponse =
      ApiResponse<UserDataResponse>.initial().obs;
  Future<void> fecthGroupMember() async {
    try {
      debugPrint("--------Fetching all the group members=======");
      isloading(true);
      groupMemberResponse.value = ApiResponse<UserDataResponse>.loading();
      final groupMemberResult = await groupMemberRepository.getGroupMember(
          logincontroller.userDataResponse.value.response!.first.groupid);
      if (groupMemberResult.status == ApiStatus.SUCCESS) {
        groupMemberResponse.value =
            ApiResponse<UserDataResponse>.completed(groupMemberResult.response);
      }
    } catch (e) {
      isloading(false);

      debugPrint('Error while getting data: $e');
    } finally {
      isloading(false);
    }
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
      fecthGroupMember();

      isloading(false);
    } catch (e) {
      // Document for the user doesn't exist, handle this case

      print('Error adding friends: $e');
      // Add further error handling logic if needed
    }
  }

  final deleteGroupMemberRepository =
      GroupMemberDeleteRepository(); // Instantiate AddFriendRepository

  Future<void> deleteMember(BuildContext context, String studentId) async {
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
    } finally {
      deleteMemberLoading(false);
    }
  }
}
