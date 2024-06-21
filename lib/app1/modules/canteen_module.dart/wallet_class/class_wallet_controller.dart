import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_canteen/app1/cons/api_end_points.dart';
import 'package:connect_canteen/app1/model/school_model.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class ClassListController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<SchoolModel?> getSchoolData(String schoolId) {
    return _firestore
        .collection(ApiEndpoints.productionSchoolcollection)
        .where('schoolId', isEqualTo: schoolId) // Filter by schoolId field
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        // Assuming there's only one document per schoolId
        return SchoolModel.fromJson(
            snapshot.docs.first.data() as Map<String, dynamic>);
      } else {
        return null;
      }
    });
  }
}
