import 'package:connect_canteen/app1/cons/colors.dart';
import 'package:connect_canteen/app1/modules/canteen_module.dart/report/canteen_report_controller.dart';
import 'package:connect_canteen/app1/modules/canteen_module.dart/report/utils/requiremetn.dart';
import 'package:connect_canteen/app1/modules/canteen_module.dart/report/utils/un_checkout_order.dart';
import 'package:connect_canteen/app1/modules/canteen_module.dart/salse_figure/salse_figure.dart';
import 'package:flutter/material.dart';
import 'package:connect_canteen/app/config/style.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class SwitchController extends GetxController {
  var isTotalOrder = true.obs;
}

class CanteenDailyReport extends StatefulWidget {
  final bool isDailyReport;
  CanteenDailyReport({super.key, required this.isDailyReport});

  @override
  State<CanteenDailyReport> createState() => _CanteenDailyReportState();
}

class _CanteenDailyReportState extends State<CanteenDailyReport> {
  final canteenDailyReport = Get.put(CanteenReportController());
  final switchController = Get.put(SwitchController());
  DateTime _selectedDate = DateTime.now();

  void selectDate() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            height: 400,
            width: 300,
            child: SfDateRangePicker(
              onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                setState(() {
                  _selectedDate = args.value;
                  canteenDailyReport.selectedDate.value =
                      "${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}";
                });
                Navigator.of(context).pop(); // Close the date picker dialog
              },
              initialSelectedDate: _selectedDate,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        titleSpacing: 4.0, // Adjusts the spacing above the title
        title: Text(
          'Report',
          style: TextStyle(fontWeight: FontWeight.w300),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 4.0.w),
              child: Text(
                widget.isDailyReport ? 'Daily Report' : 'Canteen Report',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.sp),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: AppPadding.screenHorizontalPadding,
        child: Column(
          children: [
            SizedBox(
              height: 1.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Date : ${canteenDailyReport.selectedDate.value}',
                  style:
                      TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w800),
                ),
                widget.isDailyReport
                    ? SizedBox.shrink()
                    : Align(
                        alignment: Alignment.topRight,
                        child: GestureDetector(
                          onTap: () {
                            selectDate();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8), // Adjust padding as needed
                              child: Row(
                                mainAxisSize: MainAxisSize
                                    .min, // Ensure the row takes up minimum space needed
                                children: [
                                  Icon(Icons.filter_list),
                                  SizedBox(
                                      width:
                                          8), // Add space between icon and text
                                  Text(
                                    "Filter",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight
                                            .w600), // Adjust font size as needed
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
              ],
            ),
            SizedBox(
              height: 3.h,
            ),
            SalseFigure(
              date: canteenDailyReport.selectedDate.value,
            ),
            SizedBox(
              height: 5.h,
            ),
            Container(
                width: double.infinity,
                height: 6.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
                child: Obx(() {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {
                          switchController.isTotalOrder.value = true;
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: switchController.isTotalOrder.value
                                ? Colors.black
                                : Colors.grey[200],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, right: 8, top: 5, bottom: 5),
                            child: Text(
                              'Total Order',
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w600,
                                color: switchController.isTotalOrder.value
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          switchController.isTotalOrder.value = false;
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: switchController.isTotalOrder.value
                                ? Colors.grey[200]
                                : Colors.black,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, right: 8, top: 5, bottom: 5),
                            child: Text(
                              '  Remaining    ',
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w600,
                                color: switchController.isTotalOrder.value
                                    ? Colors.black
                                    : Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                })),
            SizedBox(
              height: 2.h,
            ),
            Obx(() {
              switch (switchController.isTotalOrder.value) {
                case true:
                  return RequirementSection(
                    date: canteenDailyReport.selectedDate.value,
                  );
                case false:
                  return RemaningORders(
                    date: canteenDailyReport.selectedDate.value,
                  );
                default:
                  return SizedBox.shrink(); // Default case if needed
              }
            }),
          ],
        ),
      )),
    );
  }
}
