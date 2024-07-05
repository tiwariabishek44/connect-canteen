import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_canteen/app1/model/cart_modeld.dart';
import 'package:connect_canteen/app1/model/meal_time.dart';
import 'package:connect_canteen/app1/modules/common/login/login_controller.dart';
import 'package:connect_canteen/app1/modules/student_modules/cart/utils/otp_generator.dart';
import 'package:connect_canteen/app1/widget/custom_snack.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CartController extends GetxController {
  OTPGenerator otpGenerator = OTPGenerator();

  final loginController = Get.put(LoginController());
  var cartItems = <CartItem>[].obs;
  var mealTime = <MealTime>[].obs;
  var itemAddLoading = false.obs;
  var mealtime = 'NA'.obs;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    fetchCartItems();
    fetchMealTime();
  }

  // Add an item to the cart
  void addItem(CartItem item, BuildContext context) {
    itemAddLoading.value = true;
    var existingItem =
        cartItems.firstWhereOrNull((element) => element.id == item.id);
    if (existingItem != null) {
      existingItem.quantity += item.quantity;
    } else {
      cartItems.add(item);
    }
    updateCartInFirestore();
    itemAddLoading.value = false;
    _showSnackBar(context, 'Item added to cart', Icons.check_sharp);
  }

  // Remove an item from the cart
  void removeItem(String id, BuildContext context) {
    cartItems.removeWhere((item) => item.id == id);
    updateCartInFirestore();
    _showSnackBar(context, 'Item removed from cart', Icons.delete_outline);
  }

  // Update the quantity of an item
  void updateQuantity(CartItem item, int quantity) {
    item.quantity = quantity;
    cartItems.refresh();
    updateCartInFirestore();
  }

  // Calculate the total price
  double get totalPrice =>
      cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));

  // Save the cart items to Firestore
  void updateCartInFirestore() async {
    var userId = loginController
        .studentDataResponse.value!.userid; // Replace with actual user ID
    var cartCollection =
        FirebaseFirestore.instance.collection('productionCart').doc(userId);

    var cartMap = cartItems.map((item) => item.toMap()).toList();

    await cartCollection.set({'items': cartMap});
  }

  // Fetch the cart items from Firestore
  var isFetching = false.obs;
  void fetchCartItems() async {
    try {
      isFetching.value = true;
      var userId = loginController
          .studentDataResponse.value!.userid; // Replace with actual user ID
      var cartCollection =
          FirebaseFirestore.instance.collection('productionCart').doc(userId);

      var cartDoc = await cartCollection.get();
      if (cartDoc.exists) {
        var items = List<CartItem>.from(
            cartDoc.data()?['items']?.map((item) => CartItem.fromMap(item)));
        cartItems.assignAll(items);
        isFetching.value = false;
      }
      isFetching.value = false;
    } catch (error) {
      throw error;
    }
  }

//---------------------------------to fetch meal time from firestore--------------------------------
  void fetchMealTime() async {
    try {
      var schoolId = loginController.studentDataResponse.value!
          .schoolId; // Replace with your actual school ID
      var mealTimeCollection =
          FirebaseFirestore.instance.collection('mealTime');

      var querySnapshot = await mealTimeCollection
          .where('schoolReference', isEqualTo: schoolId)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        var mealTimes = querySnapshot.docs
            .map((doc) => MealTime.fromJson(doc.data()))
            .toList();
        mealTime.assignAll(mealTimes);
      }
    } catch (error) {
      log('Error fetching mealTime: $error');
      throw error;
    }
  }

//---------------------------------to make order--------------------------------
  var orderLoading = false.obs;
  Future<void> makeOrder(double price, List<CartItem> product) async {
    try {
      DateTime nowUtc = DateTime.now().toUtc();
      DateTime nowNepal = nowUtc.add(Duration(hours: 5, minutes: 45));
      final todayDate = "${nowNepal.day}/${nowNepal.month}/${nowNepal.year}";
      final otp = otpGenerator.generateUniqueOTP(4); // Generate a 5-digit OTP

      orderLoading.value = true;
      DocumentReference userDoc = _firestore
          .collection('productionStudents')
          .doc(loginController.studentDataResponse.value!.userid);

      await _firestore.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(userDoc);
        if (!snapshot.exists) {
          throw Exception("User does not exist!");
        }

        double currentBalance = snapshot['balance'];
        if (currentBalance < price) {
          throw Exception("Insufficient funds!");
        }

        double newBalance = currentBalance - price;

        transaction.update(userDoc, {'balance': newBalance});

        transaction.set(_firestore.collection('Transactions').doc(), {
          'userId': loginController.studentDataResponse.value!.userid,
          'type': 'load',
          'amount': price,
          'date': todayDate,
          'status': 'completed',
          'classes': loginController.studentDataResponse.value!.classes,
          'studentName': loginController.studentDataResponse.value!.name,
          'schoolReference': "texasinternationalcollege",
          'itemId': '',
        });

        transaction.set(_firestore.collection('studentOrders').doc(), {
          'otp': otp,
          'userId': loginController.studentDataResponse.value!.userid,
          'username': loginController.studentDataResponse.value!.name,
          'userClass': loginController.studentDataResponse.value!.classes,

          'date': todayDate,
          'mealTime': mealtime.value, // Replace with actual mealTime value
          'totalAmount': price,
          'status': 'uncompleted',
          "schoolRefrenceId":
              loginController.studentDataResponse.value!.schoolId,

          'products': product
              .map((product) => product.toMap())
              .toList(), // Placeholder, replace with actual products array
        });
        // Delete the document from productionCart collection
        var userId = loginController.studentDataResponse.value!.userid;
        var cartCollection =
            FirebaseFirestore.instance.collection('productionCart').doc(userId);
        transaction.delete(cartCollection);
      });
      cartItems.clear();
      log('::::::::::::::this is the total cart items: $cartItems');

      orderLoading.value = false;
    } catch (error) {
      log('Error making order: $error');
      orderLoading.value = false;
      if (error.toString() == "Insufficient funds!") {
        showInsufficientBalanceDialog(Get.context!);
      } else {
        showInsufficientBalanceDialog(Get.context!);
      }
    }
  }

  void _showSnackBar(BuildContext context, String message, IconData icon) {
    final snackBar = SnackBar(
      duration: Duration(seconds: 1),
      content: CustomSnackBarContent(
        message: message,
        icon: icon,
      ),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      backgroundColor: Color.fromARGB(255, 223, 97, 97),
      margin: EdgeInsets.all(10),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

void showInsufficientBalanceDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 20.sp,
                  ),
                  SizedBox(
                    width: 2.w,
                  ),
                  Text(
                    'Insufficient Balance',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text(
                'You don\'t have sufficient balance to place this order. Please add more funds to your account.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.black54,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red, // Background color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 28, vertical: 5),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'OK',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
