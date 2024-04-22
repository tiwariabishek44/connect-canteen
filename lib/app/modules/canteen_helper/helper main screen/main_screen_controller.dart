import 'package:connect_canteen/app/modules/canteen_helper/verified%20orders/get_verified_orders.dart';
import 'package:connect_canteen/app/modules/student_modules/home/view/homepage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainScreenController extends GetxController {
  var currentTab = 0.obs;
  final PageStorageBucket bucket = PageStorageBucket();
  Rx<Widget> currentScreen = Rx<Widget>(CanteenHelper());
}
