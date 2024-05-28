import 'package:connect_canteen/app1/modules/student_modules/homepage/homepage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StudentScreenController extends GetxController {
  var currentTab = 0.obs;
  final PageStorageBucket bucket = PageStorageBucket();
  Rx<Widget> currentScreen = Rx<Widget>(StudentHomePage());

  var isloading = false.obs;
}
