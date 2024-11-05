import 'package:connect_canteen/app1/modules/canteen_helper/setting/setting.dart';
import 'package:connect_canteen/app1/modules/canteen_module.dart/order_requirement/order_requirement.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HelperScreenController extends GetxController {
  var currentTab = 0.obs;
  final PageStorageBucket bucket = PageStorageBucket();
  Rx<Widget> currentScreen = Rx<Widget>(
    OrderRequirementPage(),
  );

  var isloading = false.obs;
}
