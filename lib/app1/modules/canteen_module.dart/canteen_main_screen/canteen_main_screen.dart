import 'package:connect_canteen/app1/modules/canteen_module.dart/canteen_main_screen/canteen_main_screen_controller.dart';

import 'package:connect_canteen/app1/modules/canteen_module.dart/dashboard/dashboard.dart';

import 'package:connect_canteen/app1/modules/canteen_module.dart/order_requirement/order_requirement.dart';
import 'package:connect_canteen/app1/modules/canteen_module.dart/setting/setting.dart';
import 'package:connect_canteen/app1/modules/canteen_module.dart/studentClass/studetnclass.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CanteenMainScreen extends StatelessWidget {
  CanteenMainScreen({Key? key});
  final canteenScreenController = Get.put(CanteenScreenController());

  final List<Widget> pages = [
    CanteenDashboard(),
    OrderRequirementPage(),
    CanteenSetting(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => MealTimePage());
          // Quick order processing action
        },
        backgroundColor: Color.fromARGB(255, 216, 48, 113),
        child: Icon(Icons.checklist_outlined, color: Colors.white),
      ),
      body: Obx(
        () => PageStorage(
          bucket: canteenScreenController.bucket,
          child: canteenScreenController.currentScreen.value,
        ),
      ),
      bottomNavigationBar: Obx(
        () => Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 10,
              ),
            ],
          ),
          height: 12.h,
          child: BottomAppBar(
            notchMargin: 8,
            shape: CircularNotchedRectangle(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                _buildNavItem(
                  Icons.dashboard_rounded,
                  'Dashboard',
                  0,
                  canteenScreenController,
                ),

                _buildNavItem(
                  Icons.restaurant_menu_rounded,
                  'Orders',
                  1,
                  canteenScreenController,
                ),
                SizedBox(width: 5.w), // Space for FAB

                _buildNavItem(
                  Icons.settings_rounded,
                  'Setting',
                  2,
                  canteenScreenController,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index,
      CanteenScreenController controller) {
    final isSelected = controller.currentTab.value == index;
    return InkWell(
      onTap: () {
        controller.currentTab.value = index;
        controller.currentScreen.value = pages[index];
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color:
              isSelected ? Colors.purple.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.purple : Colors.grey,
              size: 24.sp,
            ),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.purple : Colors.grey,
                fontSize: 12.sp,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
