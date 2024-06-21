import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_canteen/app1/cons/api_end_points.dart';
import 'package:connect_canteen/app1/model/student_model.dart';
import 'package:connect_canteen/app1/widget/custom_sncak_bar.dart';
import 'package:get/get.dart';

class StudetnListController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<StudentDataResponse>> fetchClassStudent(String grade) {
    return _firestore
        .collection(ApiEndpoints.prodcutionStudentCollection)
        .where('classes', isEqualTo: grade) // Filter documents by groupid field
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => StudentDataResponse.fromJson(doc.data()))
              .toList(),
        );
  }

// -------------add friend to group
  var loading = false.obs;
  Future<void> addMember(
    String studetnId,
    String groupid,
    String groupcode,
    String groupname,
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
          'groupname': groupname,
        });
        loading(false);
        CustomSnackbar.success(Get.context!, 'Add successfully');
      } else {
        loading(false);

        Get.snackbar('Error', 'No student found with ID');
      }
      loading(false);
    } catch (e) {
      loading(false);

      log(e.toString());
      Get.snackbar('Error', 'Failed to Add: $e');
    }
  }
}
