import 'package:connect_canteen/app1/modules/canteen_module.dart/checkout/search_page.dart';
import 'package:connect_canteen/app1/modules/canteen_module.dart/order%20hold/hold_search_page.dart';
import 'package:connect_canteen/app1/modules/canteen_module.dart/order%20verify/verify_search_page.dart';
import 'package:connect_canteen/app1/modules/canteen_module.dart/order_requirement/order_requirement.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ButtonColumnPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Button Column Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildButtonContainer(
              label: 'Order Checkout ',
              color: Colors.red,
              onTap: () {
                Get.to(() => OrderCheckoutSearch(),
                    transition: Transition.cupertinoDialog);
                print('Button A pressed');
              },
            ),
            SizedBox(height: 20), // Add spacing between buttons
            buildButtonContainer(
              label: 'Order Hold ',
              color: Colors.green,
              onTap: () {
                Get.to(() => HoldSearchPage(),
                    transition: Transition.cupertinoDialog);
                print('Button A pressed');
              },
            ),
            SizedBox(height: 20), // Add spacing between buttons
            buildButtonContainer(
              label: 'Order Verify',
              color: Colors.blue,
              onTap: () {
                Get.to(() => VerifySearchPage(),
                    transition: Transition.cupertinoDialog);
                print('Button A pressed');
              },
            ),
            buildButtonContainer(
              label: 'Order Requirement ',
              color: Colors.blue,
              onTap: () {
                Get.to(() => OrderRequirementPage(),
                    transition: Transition.cupertinoDialog);
                print('Button A pressed');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildButtonContainer({
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 24,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
