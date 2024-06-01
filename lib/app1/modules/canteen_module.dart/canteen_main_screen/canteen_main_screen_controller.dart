import 'package:connect_canteen/app1/modules/canteen_module.dart/menue/menue_page.dart';
import 'package:connect_canteen/app1/modules/student_modules/homepage/homepage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CanteenScreenController extends GetxController {
  var currentTab = 0.obs;
  final PageStorageBucket bucket = PageStorageBucket();
  Rx<Widget> currentScreen = Rx<Widget>(CanteenMenuePage());

  var isloading = false.obs;
}
