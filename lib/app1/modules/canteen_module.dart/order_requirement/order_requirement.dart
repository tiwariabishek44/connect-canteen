import 'package:connect_canteen/app1/cons/colors.dart';
import 'package:connect_canteen/app1/model/meal_time.dart';
import 'package:connect_canteen/app1/modules/canteen_module.dart/order_requirement/order_requirement_controller.dart';
import 'package:connect_canteen/app1/modules/canteen_module.dart/studentClass/classController.dart';
import 'package:connect_canteen/app1/modules/student_modules/cart/utils/emptycart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';

class OrderRequirementPage extends StatefulWidget {
  @override
  State<OrderRequirementPage> createState() => _OrderRequirementPageState();
}

class _OrderRequirementPageState extends State<OrderRequirementPage> {
  final orderRequirementController = Get.put(OrderRequirementController());
  final mealTimeController = Get.put(MealTimeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildMealTimeSelector(),
          Expanded(
            child: _buildOrderRequirements(),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      scrolledUnderElevation: 0,
      backgroundColor: Colors.white,
      titleSpacing: 4.0.w,
      title: Text(
        'Orders',
        style: TextStyle(fontWeight: FontWeight.w300),
      ),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: EdgeInsets.only(left: 4.0.w, bottom: 2.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Today\'s Requirement',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24.sp,
                  ),
                ),
                Text(
                  'Manage your daily order requirements',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 16.sp,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMealTimeSelector() {
    return Container(
      height: 8.h,
      padding: EdgeInsets.symmetric(horizontal: 2.w),
      child: StreamBuilder<List<MealTime>>(
        stream: mealTimeController.getMealTimes('texasinternationalcollege'),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<MealTime> mealTimes = snapshot.data!;
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: mealTimes.length + 1,
              itemBuilder: (context, index) {
                return Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 1.w, vertical: 0.5.h),
                  child: _buildMealTimeChip(
                    index == 0 ? null : mealTimes[index - 1],
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading meal times'));
          }
          return shrimmerffet();
        },
      ),
    );
  }

  Widget _buildMealTimeChip(MealTime? mealTime) {
    final isAll = mealTime == null;
    final mealTimeName = isAll ? 'All' : mealTime.mealTime;

    return Obx(() {
      final isSelected =
          orderRequirementController.mealtime.value == mealTimeName;
      return GestureDetector(
        onTap: () {
          setState(() {
            orderRequirementController.mealtime.value = mealTimeName;
          });
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          decoration: BoxDecoration(
            color: isSelected ? Colors.black : Colors.grey[100],
            borderRadius: BorderRadius.circular(20),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isAll ? Icons.all_inclusive : Icons.access_time,
                color: isSelected ? Colors.white : Colors.grey[700],
                size: 16.sp,
              ),
              SizedBox(width: 1.w),
              Text(
                mealTimeName,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected ? Colors.white : Colors.grey[700],
                ),
              ),
            ],
          ),
        ),
      );
    });
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
          return Center(child: Text('Error loading orders'));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return EmptyOrdersWidget(
            isHistory: false,
          );
        }

        final requirements = snapshot.data!;
        double totalRevenue = 0;
        requirements.forEach((_, data) => totalRevenue += data['totalPrice']);

        // Removed the Expanded widget here
        return ListView.builder(
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Row(
          children: [
            Container(
              width: 12.w,
              height: 12.w,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.restaurant,
                color: Colors.grey[600],
                size: 24.sp,
              ),
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    productName,
                    maxLines: 2,
                    style: TextStyle(
                      overflow: TextOverflow.ellipsis,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    '/Rs. ${unitPrice.toStringAsFixed(0)} ',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                quantity.toString(),
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget shrimmerffet() {
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

class ShimmerLoadingEffect extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        // Removed the Column and Expanded here
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        itemCount: 5, // Show 5 placeholder cards
        itemBuilder: (context, index) => Container(
          margin: EdgeInsets.only(bottom: 2.h),
          height: 15.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                Container(
                  width: 12.w,
                  height: 12.w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 2.h,
                        color: Colors.white,
                      ),
                      SizedBox(height: 1.h),
                      Container(
                        width: 20.w,
                        height: 1.5.h,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 10.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
