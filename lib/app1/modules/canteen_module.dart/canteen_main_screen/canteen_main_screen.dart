import 'package:connect_canteen/app1/modules/canteen_module.dart/canteen_main_screen/canteen_main_screen_controller.dart';
import 'package:connect_canteen/app1/modules/canteen_module.dart/checkout/chekcout_page.dart';
import 'package:connect_canteen/app1/modules/canteen_module.dart/checkout/search_page.dart';
import 'package:connect_canteen/app1/modules/canteen_module.dart/demo%20buttons/demo_buttons.dart';
import 'package:connect_canteen/app1/modules/canteen_module.dart/menue/menue_page.dart';
import 'package:connect_canteen/app1/modules/student_modules/profile/profile_page.dart';
import 'package:connect_canteen/app1/cons/colors.dart';
import 'package:connect_canteen/app1/modules/student_modules/order/order_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CanteenMainScreen extends StatelessWidget {
  CanteenMainScreen({Key? key});
  final canteenScreenController = Get.put(CanteenScreenController());

  final List<Widget> pages = [
    CanteenMenuePage(),
    ButtonColumnPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          return await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                elevation: 0,
                backgroundColor: AppColors.backgroundColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      12.0), // Adjust border radius as needed
                ),
                title: Text(
                  'Exit App?',
                  style: TextStyle(
                    fontSize: 17.5.sp,
                    color: Color.fromARGB(221, 37, 36, 36),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                content: Text(
                  'Are you sure you want to exit the app?',
                  style: TextStyle(
                    color: const Color.fromARGB(221, 72, 71, 71),
                    fontSize: 16.0.sp,
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      // Close the dialog

                      Get.back();
                    },
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                          color: Colors.purple),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop(true);
                    },
                    child: Container(
                      padding: EdgeInsets.all(12.0),
                      child: Text(
                        "Exit",
                        style: TextStyle(
                          color: Color.fromARGB(255, 225, 6, 6),
                          fontWeight: FontWeight.bold,
                          fontSize: 17.sp,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
          ; // Allow back navigation
        },
        child: Obx(
          () => PageStorage(
            bucket: canteenScreenController.bucket,
            child: canteenScreenController.currentScreen.value,
          ),
        ),
      ),
      bottomNavigationBar: Obx(
        () => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(
                color: Color.fromARGB(
                    255, 210, 207, 207), // Specify your desired border color
                width: 0.50, // Specify the border width
              ),
            ),
          ),
          height: 7.5.h,
          child: MyBottomNavigationBar(
            currentIndex: canteenScreenController.currentTab.value,
            onTap: (index) {
              canteenScreenController.currentTab.value = index;
              canteenScreenController.currentScreen.value = pages[index];
            },
            items: [
              MyBottomNavigationBarItem(
                  nonSelectedicon: Icons.dashboard_customize,
                  icon: Icons.dashboard_customize,
                  label: 'Dashboard'),
              MyBottomNavigationBarItem(
                  nonSelectedicon: Icons.shopping_cart_outlined,
                  icon: Icons.shopping_cart,
                  label: 'MyOrders'),
            ],
          ),
        ),
      ),
    );
  }
}

class MyBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<MyBottomNavigationBarItem> items;

  MyBottomNavigationBar({
    required this.currentIndex,
    required this.onTap,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: items.map((item) {
        var index = items.indexOf(item);
        return Expanded(
          child: InkWell(
            onTap: () => onTap(index),
            splashColor: Colors.transparent, // Disable tap effect

            child: item.build(index == currentIndex),
          ),
        );
      }).toList(),
    );
  }
}

class MyBottomNavigationBarItem {
  final IconData icon;
  final IconData nonSelectedicon;

  final String label;

  MyBottomNavigationBarItem({
    required this.nonSelectedicon,
    required this.icon,
    required this.label,
  });

  Widget build(bool isSelected) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isSelected ? icon : nonSelectedicon,
            color: isSelected
                ? Colors.black
                : const Color.fromARGB(255, 69, 67, 67),
            // Outline the icon if not selected
            size: 20.0.sp,
            semanticLabel: label,
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: isSelected
                  ? Colors.black
                  : const Color.fromARGB(255, 69, 67, 67),
            ),
          ),
        ],
      ),
    );
  }
}
