import 'package:connect_canteen/app/widget/custom_loging_widget.dart';
import 'package:connect_canteen/app1/modules/canteen_module.dart/mealTime/meal_time_controller.dart';
import 'package:connect_canteen/app1/widget/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class UpdateMealTime extends StatefulWidget {
  final String mealTime;
  UpdateMealTime({Key? key, required this.mealTime}) : super(key: key);

  @override
  _UpdateMealTimeState createState() => _UpdateMealTimeState();
}

class _UpdateMealTimeState extends State<UpdateMealTime> {
  final mealtimeController = Get.put(MealTimeController());
  TimeOfDay? selectedTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        titleSpacing: 4.0, // Adjusts the spacing above the title
        title: Text(
          'Settings',
          style: TextStyle(fontWeight: FontWeight.w300),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 4.0.w),
              child: Text(
                'Meal Time ${widget.mealTime}',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.sp),
              ),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(18.0),
                  child: Text(
                    "Update Last Time meal order ",
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 19.sp,
                        color: Colors.black),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _selectTime(context);
                  },
                  child: Container(
                    width: 100.0.w,
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: selectedTime != null
                        ? Text(
                            '${selectedTime!.hour}:${selectedTime!.minute}',
                            style: TextStyle(fontSize: 18.sp),
                          )
                        : Text(
                            'Select Time',
                            style: TextStyle(fontSize: 18.sp),
                          ),
                  ),
                ),
                SizedBox(height: 15.h),
                CustomButton(
                  isLoading: false,
                  text: 'Update',
                  onPressed: () {
                    if (selectedTime != null) {
                      final updateTime =
                          '${selectedTime!.hour}:${selectedTime!.minute}';
                      mealtimeController.updateMealTime(
                          'texasinternationalcollege',
                          widget.mealTime,
                          updateTime);
                    } else {
                      // Handle if no time is selected
                    }
                  },
                )
              ],
            ),
          ),
          Positioned(
              top: 40.h,
              left: 40.w,
              child: Obx(() => mealtimeController.loading.value
                  ? LoadingWidget()
                  : SizedBox.shrink())),
        ],
      ),
    );
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null && pickedTime != selectedTime) {
      setState(() {
        selectedTime = pickedTime;
      });
    }
  }
}
