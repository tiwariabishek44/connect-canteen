import 'package:connect_canteen/app/modules/student_modules/home/view/homepage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:connect_canteen/app/modules/vendor_modules/menue/view/menue_view.dart';
import 'package:connect_canteen/app/modules/vendor_modules/dashboard/dashboard_page.dart';

class VendorScreenController extends GetxController {
  var currentTab = 0.obs;
  final PageStorageBucket bucket = PageStorageBucket();
  Rx<Widget> currentScreen = Rx<Widget>(DshBoard());
}
