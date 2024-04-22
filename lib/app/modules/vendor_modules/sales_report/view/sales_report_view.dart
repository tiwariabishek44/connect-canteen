import 'package:cached_network_image/cached_network_image.dart';
import 'package:connect_canteen/app/modules/vendor_modules/dashboard/demand_supply.dart';
import 'package:connect_canteen/app/modules/vendor_modules/dashboard/salse_controller.dart';
import 'package:get/get.dart';
import 'package:connect_canteen/app/config/colors.dart';
import 'package:flutter/material.dart';
import 'package:connect_canteen/app/config/style.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart' as picker;
import 'package:connect_canteen/app/widget/custom_app_bar.dart';
import 'package:intl/intl.dart';
import 'package:nepali_utils/nepali_utils.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SalseReportView extends StatefulWidget {
  @override
  State<SalseReportView> createState() => _SalseReportViewState();
}

class _SalseReportViewState extends State<SalseReportView> {
  final salesController = Get.put(SalsesController());

  Future<void> selectDate(BuildContext context) async {
    final NepaliDateTime? picked = await picker.showMaterialDatePicker(
      context: context,
      initialDate: NepaliDateTime.now(),
      firstDate: NepaliDateTime(2000),
      lastDate: NepaliDateTime(2090),
      initialDatePickerMode: DatePickerMode.day,
    );

    if (picked != null) {
      salesController.calenderDate.value =
          DateFormat('dd/MM/yyyy\'', 'en').format(picked);

      salesController.fetchTotalSales();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          AppColors.backgroundColor, // Make scaffold background transparent

      appBar: const CustomAppBar(
        title: 'Salse Report',
      ),
      body: Padding(
        padding: AppPadding.screenHorizontalPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 2.h,
            ),
            GestureDetector(
              onTap: () {
                selectDate(context);
              },
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color.fromARGB(221, 149, 87, 7),
                ),
                height: 6.h,
                child: Center(
                    child: Text(
                  'Select the date ',
                  style: AppStyles.buttonText,
                )),
              ),
            ),
            SizedBox(
              height: 2.h,
            ),
            Divider(
              height: 1.h,
              thickness: 1.h,
              color: Color.fromARGB(255, 220, 216, 216),
            ),
            Expanded(
              child: SingleChildScrollView(child: SalseReport()),
            ),
          ],
        ),
      ),
    );
  }
}
