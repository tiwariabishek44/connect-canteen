import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_canteen/app1/model/meal_time.dart';
import 'package:connect_canteen/app1/model/order_model.dart';
import 'package:connect_canteen/app1/model/product_model.dart';
import 'package:connect_canteen/app1/model/student_model.dart';
import 'package:connect_canteen/app1/modules/common/login/login_controller.dart';
import 'package:connect_canteen/app1/widget/snackbarHelper.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nepali_utils/nepali_utils.dart';

class StudentOrderController extends GetxController {
  final loginController = Get.find<LoginController>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final RxBool isLoading = false.obs;
  final RxList<OrderResponse> activeOrders =
      <OrderResponse>[].obs; // Unchecked out orders
  final RxList<OrderResponse> orderHistory =
      <OrderResponse>[].obs; // Checked out orders
  final RxList<String> availableMealTimes = <String>[].obs;

  Stream<List<OrderResponse>> getActiveOrders() {
    final studentId = loginController.studentDataResponse.value?.userid;
    if (studentId == null) return Stream.value([]);

    return _firestore
        .collection('orders')
        .where('studentId', isEqualTo: studentId)
        .where('isCheckout', isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => OrderResponse.fromMap(doc.data()))
            .toList());
  }

  Stream<List<OrderResponse>> getOrderHistory() {
    final studentId = loginController.studentDataResponse.value?.userid;
    if (studentId == null) return Stream.value([]);

    return _firestore
        .collection('orders')
        .where('studentId', isEqualTo: studentId)
        .where('isCheckout', isEqualTo: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => OrderResponse.fromMap(doc.data()))
            .toList());
  }

  Stream<List<MealTime>> getMealTimes() {
    final schoolId = loginController.studentDataResponse.value?.schoolId;
    if (schoolId == null) return Stream.value([]);

    return _firestore
        .collection('mealTime')
        .where('schoolReference', isEqualTo: schoolId)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => MealTime.fromJson(doc.data())).toList());
  }

  Future<bool> placeOrder(bool isfreemium, ProductResponseModel item,
      String mealTime, DateTime mealDate) async {
    try {
      isLoading.value = true;

      final studentData = loginController.studentDataResponse.value;
      if (studentData == null) {
        SnackbarHelper.showErrorSnackbar('Student data not available');
        return false;
      }

      // Check credit score only if it's a freemium order
      if (isfreemium) {
        final uncheckedOrders = await _firestore
            .collection('orders')
            .where('studentId', isEqualTo: studentData.userid)
            .where('isCheckout', isEqualTo: false)
            .where('itemType', isEqualTo: 'Basic Items')
            .get();

        if (uncheckedOrders.docs.length >= 2 || studentData.creditScore <= 0) {
          SnackbarHelper.showErrorSnackbar(
              'Please load your balance to place more orders.');
          return false;
        }
      }

      // Parse meal time into DateTime object
      final parsedMealTime = DateTime(
        mealDate.year,
        mealDate.month,
        mealDate.day,
        int.parse(mealTime.split(":")[0]),
        int.parse(mealTime.split(":")[1]),
      );

      // Check if current time is within 30 minutes before the meal time
      final now = DateTime.now();
      final minimumOrderTime = parsedMealTime.subtract(Duration(minutes: 30));
      if (now.isAfter(minimumOrderTime)) {
        SnackbarHelper.showErrorSnackbar(
            'Orders must be placed at least 30 minutes before meal time');
        return false;
      }

      // Start a batch write for atomic operations
      final batch = _firestore.batch();

      // Generate order ID
      final orderId = _firestore.collection('orders').doc().id;
      final nepalinow = NepaliDateTime.now();
      final today = DateFormat('yyyy-MM-dd').format(nepalinow);
      // Create order document
      final order = OrderResponse(
        orderId: orderId,
        studentId: studentData.userid,
        referenceSchoolId: studentData.schoolId,
        mealType: item.type,
        mealTime: mealTime,
        price: item.price,
        isCheckout: false,
        orderDate: DateTime.now(),
        mealDate: today,
        createdAt: Timestamp.now(),
        productName: item.name,
        studentName: studentData.name,
        itemType: item.type,
        phoneno: studentData.phone,
      );

      // Set the order document in batch
      batch.set(_firestore.collection('orders').doc(orderId), order.toMap());

      // If it's a freemium order, update credit score
      if (isfreemium) {
        final studentRef =
            _firestore.collection('productionStudents').doc(studentData.userid);

        // Get latest student data to ensure current credit score
        final latestStudentData = await studentRef.get();
        if (!latestStudentData.exists) {
          throw 'Student document not found';
        }

        final currentCreditScore =
            latestStudentData.data()?['creditScore'] ?? 0;

        // Update student's credit score in batch
        batch.update(studentRef, {
          'creditScore': currentCreditScore - 1,
        });
      }

      // Commit all operations
      await batch.commit();

      // Show success message
      Get.back(); // Close the bottom sheet
      await Future.delayed(Duration(milliseconds: 300));

      final successMessage = isfreemium
          ? 'Order placed successfully!\nOrder ID: $orderId\nCredit points used: 1'
          : 'Order placed successfully!\nOrder ID: $orderId';

      SnackbarHelper.showSuccessSnackbar(successMessage);

      return true;
    } catch (e) {
      SnackbarHelper.showErrorSnackbar(
          'Failed to place order: ${e.toString()}');
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
