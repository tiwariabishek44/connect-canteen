import 'dart:developer';

import 'package:connect_canteen/app1/model/meal_time.dart';
import 'package:connect_canteen/app1/widget/custom_sncak_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MealTimeController extends GetxController {
  final CollectionReference mealTimeCollection =
      FirebaseFirestore.instance.collection('mealTime');

  final GlobalKey<FormState> mealForm = GlobalKey<FormState>();

  final loading = false.obs;
  Future<void> uploadMealTime(MealTime mealTime) async {
    try {
      loading(true);
      await mealTimeCollection.add(mealTime.toJson());
      loading(false);
    } catch (e) {
      log('Error uploading MealTime: $e');
    }
  }

  Stream<List<MealTime>> getAllMealTimes(String schoolReference) {
    return mealTimeCollection
        .where('schoolReference', isEqualTo: schoolReference)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => MealTime.fromJson(doc.data() as Map<String, dynamic>))
            .toList());
  }

  //-------------------Update MealTime-------------------

  // ------------to update the user name
  Future<void> updateMealTime(
      String schoolRefrence, String mealtime, String lastiTime) async {
    try {
      log(" this i the update meal time ${mealtime}");

      log(" this i the update   time ${lastiTime}");
      loading(true);
      // Query for the document with the given product ID
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("mealTime")
          .where('mealTime',
              isEqualTo: mealtime) // Assuming productId is the field name
          .where('schoolReference', isEqualTo: schoolRefrence)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        await querySnapshot.docs.first.reference
            .update({'finalOrderTime': lastiTime});
        loading(false);
        CustomSnackbar.success(Get.context!, 'updated successfully');
      } else {
        loading(false);

        CustomSnackbar.error(Get.context!, 'Error Occured while updating');
      }
      loading(false);
    } catch (e) {
      loading(false);

      log(e.toString());
      Get.snackbar('Error', 'Failed to update product status: $e');
    }
  }
}
