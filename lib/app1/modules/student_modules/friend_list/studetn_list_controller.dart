import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_canteen/app1/cons/api_end_points.dart';
import 'package:connect_canteen/app1/model/student_model.dart';
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
}
