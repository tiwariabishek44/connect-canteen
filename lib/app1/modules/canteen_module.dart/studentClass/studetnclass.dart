import 'dart:developer';

import 'package:connect_canteen/app1/model/meal_time.dart';
import 'package:connect_canteen/app1/modules/canteen_module.dart/studentClass/classController.dart';
import 'package:connect_canteen/app1/modules/canteen_module.dart/studentClass/controller.dart';
import 'package:connect_canteen/app1/modules/canteen_module.dart/studentClass/studetnData.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';

class MealTimePage extends StatelessWidget {
  final mealTimeController = Get.put(MealTimeController());
  final String schoolId = 'texasinternationalcollege';
  final controller = Get.put(OrderSegragateController());

  // Helper method to format time display
  String formatTime(String mealTime) {
    // Remove any extra spaces and convert to uppercase
    return mealTime.trim();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.grey[50],
        elevation: 0,
        title: Text(
          'Order List ',
          style: TextStyle(
            color: const Color.fromARGB(255, 25, 24, 24),
          ),
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return StreamBuilder<List<MealTime>>(
      stream: mealTimeController.getMealTimes(schoolId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildShimmerEffect();
        }

        if (snapshot.hasError) {
          return Center(
            child: Text('Error loading meal times'),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.access_time_rounded,
                  size: 64,
                  color: Colors.grey,
                ),
                SizedBox(height: 16),
                Text(
                  'No Meal Times Available',
                  style: TextStyle(
                    fontSize: 18.sp,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          );
        }

        // Sort meal times
        final sortedMealTimes = snapshot.data!
          ..sort((a, b) => a.mealTime.compareTo(b.mealTime));

        return GridView.builder(
          padding: EdgeInsets.all(4.w),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.5,
            crossAxisSpacing: 4.w,
            mainAxisSpacing: 4.w,
          ),
          itemCount: sortedMealTimes.length,
          itemBuilder: (context, index) {
            final mealTime = sortedMealTimes[index];
            return _buildMealTimeCard(mealTime);
          },
        );
      },
    );
  }

  Widget _buildMealTimeCard(MealTime mealTime) {
    return GestureDetector(
      onTap: () {
        controller.timeSelected.value = mealTime.mealTime.toString();
        log('meal time is ${controller.timeSelected.value}');
        Get.to(() => StudentListPage(), arguments: mealTime.mealTime);
      },
      child: Container(
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.access_time_rounded,
                size: 21.sp,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              formatTime(mealTime.mealTime),
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerEffect() {
    return GridView.builder(
      padding: EdgeInsets.all(4.w),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.5,
        crossAxisSpacing: 4.w,
        mainAxisSpacing: 4.w,
      ),
      itemCount: 6, // Show 6 shimmer cards while loading
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(height: 2.h),
                Container(
                  width: 80,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
