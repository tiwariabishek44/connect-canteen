import 'package:connect_canteen/app1/modules/canteen_module.dart/order_requirement/order_requirement.dart';
import 'package:connect_canteen/app1/modules/canteen_module.dart/studentClass/classController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:connect_canteen/app1/model/meal_time.dart';
import 'package:connect_canteen/app1/modules/canteen_module.dart/order_requirement/order_requirement_controller.dart';
import 'package:connect_canteen/app1/modules/student_modules/cart/utils/emptycart.dart';

class OrderRequirementWidget extends StatefulWidget {
  final bool showHeader;

  const OrderRequirementWidget({
    Key? key,
    this.showHeader = false,
  }) : super(key: key);

  @override
  State<OrderRequirementWidget> createState() => _OrderRequirementWidgetState();
}

class _OrderRequirementWidgetState extends State<OrderRequirementWidget> {
  final orderRequirementController = Get.put(OrderRequirementController());
  final mealTimeController = Get.put(MealTimeController());

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize:
            MainAxisSize.min, // This makes the Column wrap its content
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.showHeader) _buildHeader(),
          _buildOrderRequirements(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Today\'s Requirement',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.sp,
            ),
          ),
          Text(
            'Manage your daily order requirements',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderRequirements() {
    return StreamBuilder<Map<String, Map<String, dynamic>>>(
      stream: orderRequirementController
          .getOrderRequirements('texasinternationalcollege'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return ShimmerLoadingEffect();
        }

        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(2.h),
              child: Text('Error loading orders'),
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Padding(
            padding: EdgeInsets.all(2.h),
            child: EmptyOrdersWidget(isHistory: false),
          );
        }

        final requirements = snapshot.data!;
        return ListView.builder(
          shrinkWrap: true, // Makes ListView take only the space it needs
          physics:
              NeverScrollableScrollPhysics(), // Disables scrolling in the ListView
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          itemCount: requirements.length,
          itemBuilder: (context, index) {
            final productName = requirements.keys.elementAt(index);
            final data = requirements[productName]!;
            return _buildRequirementCard(
              productName,
              data['quantity'],
              data['unitPrice'],
            );
          },
        );
      },
    );
  }

  Widget _buildRequirementCard(
      String productName, int quantity, double unitPrice) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Padding(
        padding: EdgeInsets.all(3.w),
        child: Row(
          children: [
            Container(
              width: 10.w,
              height: 10.w,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.restaurant,
                color: Colors.grey[600],
                size: 20.sp,
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    productName,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    'Rs. ${unitPrice.toStringAsFixed(0)} per item',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.8.h),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                quantity.toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerEffect() {
    return Container(
      height: 8.h,
      padding: EdgeInsets.symmetric(horizontal: 2.w),
      child: Row(
        children: List.generate(
          4,
          (index) => Padding(
            padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 0.5.h),
            child: Container(
              width: 20.w,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
