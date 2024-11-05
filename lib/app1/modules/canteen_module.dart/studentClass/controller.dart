import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_canteen/app1/model/order_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nepali_utils/nepali_utils.dart';

// Model to hold student information
class StudentInfo {
  final String name;
  final String phoneNumber;
  final List<OrderResponse> orders;

  StudentInfo({
    required this.name,
    required this.phoneNumber,
    required this.orders,
  });
}

class OrderSegragateController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var isLoading = false.obs;
  var students = <String, StudentInfo>{}.obs;
  var timeSelected = ''.obs;
  // Stream orders and group by student
  Stream<Map<String, StudentInfo>> streamStudentOrders(String schoolId) {
    final now = NepaliDateTime.now();
    final today = DateFormat('yyyy-MM-dd').format(now);
    log('meal time is ${timeSelected.value}');
    return _firestore
        .collection('orders')
        .where('referenceSchoolId', isEqualTo: schoolId)
        .where('mealDate', isEqualTo: today)
        .where('mealTime', isEqualTo: timeSelected.value)
        .where('isCheckout', isEqualTo: false)
        .snapshots()
        .map((snapshot) => _processOrders(snapshot.docs));
  }

  Stream<Map<String, StudentInfo>> pendingORders(String schoolId) {
    final now = NepaliDateTime.now();
    final today = DateFormat('yyyy-MM-dd').format(now);
    log('meal time is ${timeSelected.value}');
    return _firestore
        .collection('orders')
        .where('referenceSchoolId', isEqualTo: schoolId)
        .where('mealDate', isEqualTo: today)
        .where('isCheckout', isEqualTo: false)
        .snapshots()
        .map((snapshot) => _processOrders(snapshot.docs));
  }

  // Process orders and group by student
  Map<String, StudentInfo> _processOrders(List<QueryDocumentSnapshot> docs) {
    Map<String, StudentInfo> studentOrders = {};

    for (var doc in docs) {
      final order = OrderResponse.fromMap(doc.data() as Map<String, dynamic>);
      final key =
          '${order.studentName}_${order.studentId}'; // Unique key for each student

      if (!studentOrders.containsKey(key)) {
        studentOrders[key] = StudentInfo(
          name: order.studentName,
          phoneNumber: order.phoneno, // Using studentId as phone number
          orders: [],
        );
      }
      studentOrders[key]!.orders.add(order);
    }

    // Sort by student name
    final sortedEntries = studentOrders.entries.toList()
      ..sort((a, b) =>
          a.value.name.toLowerCase().compareTo(b.value.name.toLowerCase()));

    return Map.fromEntries(sortedEntries);
  }

  // Get students grouped by first letter
  Map<String, List<MapEntry<String, StudentInfo>>> getGroupedStudents() {
    Map<String, List<MapEntry<String, StudentInfo>>> grouped = {};

    // Get all entries and sort them
    var entries = students.entries.toList()
      ..sort((a, b) =>
          a.value.name.toLowerCase().compareTo(b.value.name.toLowerCase()));

    for (var entry in entries) {
      String firstLetter = entry.value.name[0].toUpperCase();
      if (!grouped.containsKey(firstLetter)) {
        grouped[firstLetter] = [];
      }
      grouped[firstLetter]!.add(entry);
    }

    return grouped;
  }

  // to checkout the order.
  Future<bool> checkoutOrders(StudentInfo student) async {
    try {
      isLoading(true);

      // Get all order IDs
      List<String> orderIds =
          student.orders.map((order) => order.orderId).toList();

      // Extract student ID from the first order
      final studentId = student.orders.first.studentId;

      // Run transaction to handle both order updates and cashback
      await _firestore.runTransaction((transaction) async {
        // First verify all orders still exist and are not checked out
        for (String orderId in orderIds) {
          DocumentReference orderRef =
              _firestore.collection('orders').doc(orderId);
          DocumentSnapshot orderDoc = await transaction.get(orderRef);

          if (!orderDoc.exists ||
              (orderDoc.data() as Map<String, dynamic>)['isCheckout'] == true) {
            throw Exception(
                'One or more orders have already been checked out or deleted');
          }
        }

        // Update each order within the transaction
        for (String orderId in orderIds) {
          DocumentReference orderRef =
              _firestore.collection('orders').doc(orderId);
          transaction.update(orderRef, {
            'isCheckout': true,
          });
        }

        // Update student's cashback amount
        DocumentReference studentRef =
            _firestore.collection('productionStudents').doc(studentId);
        transaction.update(studentRef, {
          'cashbackAmount': FieldValue.increment(10),
        });
      });

      return true;
    } catch (e) {
      print('Error during checkout: $e');

      // Show error message
      Get.snackbar(
        'Error',
        'Failed to checkout orders. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        borderRadius: 10,
        margin: const EdgeInsets.all(10),
      );

      return false;
    } finally {
      isLoading(false);
    }
  }

  bool validateOrders(StudentInfo student) {
    if (student.orders.isEmpty) return false;

    return true;
  }

  Future<bool> deleteOrders(Set<String> orderIds) async {
    try {
      isLoading(true);

      // Create batch for multiple deletes
      WriteBatch batch = _firestore.batch();

      // Delete each order
      for (String orderId in orderIds) {
        DocumentReference orderRef =
            _firestore.collection('orders').doc(orderId);
        batch.delete(orderRef);
      }

      // Commit the batch
      await batch.commit();

      Get.snackbar(
        'Success',
        'Orders deleted successfully',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green.shade400,
        colorText: Colors.white,
        duration: Duration(seconds: 2),
        borderRadius: 10,
        margin: EdgeInsets.all(10),
      );

      return true;
    } catch (e) {
      print('Error deleting orders: $e');
      Get.snackbar(
        'Error',
        'Failed to delete orders. Please try again.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.shade400,
        colorText: Colors.white,
        borderRadius: 10,
        margin: EdgeInsets.all(10),
      );
      return false;
    } finally {
      isLoading(false);
    }
  }
}
