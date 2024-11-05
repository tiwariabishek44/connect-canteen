import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_canteen/app1/model/meal_time.dart';
import 'package:get/get.dart';

class MealTimeController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var isLoading = false.obs;

  // Stream meal times
  Stream<List<MealTime>> getMealTimes(String schoolId) {
    return _firestore
        .collection('mealTime')
        .where('schoolReference', isEqualTo: schoolId)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => MealTime.fromJson(doc.data())).toList());
  }
}
