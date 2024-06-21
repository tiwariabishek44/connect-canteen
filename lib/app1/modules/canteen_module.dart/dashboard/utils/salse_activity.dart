import 'package:connect_canteen/app1/modules/canteen_module.dart/checkout/search_page.dart';
import 'package:connect_canteen/app1/modules/canteen_module.dart/order%20verify/verify_search_page.dart';
import 'package:flutter/material.dart';
import 'package:connect_canteen/app1/cons/colors.dart';
import 'package:connect_canteen/app1/cons/style.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SalseActivity extends StatelessWidget {
  const SalseActivity({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: BorderRadius.circular(
            10.0), // Adjust the value for the desired curve
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(255, 189, 187, 187).withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(
                0, 2), // Adjust the values to control the shadow appearance
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                "Sales Activity",
                style: AppStyles.topicsHeading,
              ),
            ),
            SizedBox(
              height: 1.h,
            ),
            Container(
              // Set a fixed height
              child: GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                childAspectRatio: 1,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.to(() => VerifySearchPage(),
                          transition: Transition.cupertinoDialog);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Color.fromARGB(255, 225, 222, 222)),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Image.asset(
                            'assets/cash.png',
                            scale: 9.sp,
                          ),
                          SizedBox(height: 2.0),
                          Center(
                            child: Text(
                              'Verify Order',
                              style: TextStyle(
                                color: const Color.fromARGB(255, 59, 57, 57),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
