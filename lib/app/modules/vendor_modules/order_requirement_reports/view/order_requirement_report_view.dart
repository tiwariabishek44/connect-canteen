import 'package:connect_canteen/app/widget/custom_loging_widget.dart';
import 'package:get/get.dart';
import 'package:connect_canteen/app/config/colors.dart';
import 'package:flutter/material.dart';
import 'package:connect_canteen/app/config/style.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart' as picker;
import 'package:connect_canteen/app/modules/vendor_modules/order_requirements/order_requirement_controller.dart';
import 'package:connect_canteen/app/modules/vendor_modules/widget/list_tile_contailer.dart';
import 'package:connect_canteen/app/widget/custom_app_bar.dart';
import 'package:connect_canteen/app/widget/empty_cart_page.dart';
import 'package:connect_canteen/app/widget/loading_screen.dart';
import 'package:intl/intl.dart';
import 'package:nepali_utils/nepali_utils.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class OrderRequirementReport extends StatefulWidget {
  @override
  State<OrderRequirementReport> createState() => _OrderRequirementReportState();
}

class _OrderRequirementReportState extends State<OrderRequirementReport> {
  final orderRequestController = Get.put(OrderRequirementContoller());

  int selectedIndex = -1;

  String dat = '';

  @override
  void initState() {
    super.initState();
    checkTimeAndSetDate();
  }

  void checkTimeAndSetDate() {
    DateTime currentDate = DateTime.now();
    NepaliDateTime nepaliDateTime = NepaliDateTime.fromDateTime(currentDate);

    setState(() {
      selectedIndex = 0;
      dat = DateFormat('dd/MM/yyyy\'', 'en').format(nepaliDateTime);
    });
    orderRequestController.fetchMeal(selectedIndex.toInt(), dat);
    // 1 am or later
  }

  Future<void> selectDate(BuildContext context) async {
    final NepaliDateTime? picked = await picker.showMaterialDatePicker(
      context: context,
      initialDate: NepaliDateTime.now(),
      firstDate: NepaliDateTime(2000),
      lastDate: NepaliDateTime(2090),
      initialDatePickerMode: DatePickerMode.day,
    );

    if (picked != null) {
      setState(() {
        dat = DateFormat('dd/MM/yyyy\'', 'en').format(picked);
      });
      orderRequestController.fetchMeal(0, dat);
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime currentDate = DateTime.now();

    NepaliDateTime nepaliDateTime = NepaliDateTime.fromDateTime(currentDate);

    String formattedDate =
        DateFormat('dd/MM/yyyy\'', 'en').format(nepaliDateTime);
    orderRequestController.date.value = formattedDate;

    return Scaffold(
      backgroundColor:
          AppColors.backgroundColor, // Make scaffold background transparent

      appBar: CustomAppBar(
        title: 'Order Requirement Report',
      ),
      body: Padding(
        padding: AppPadding.screenHorizontalPadding,
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  selectDate(context);
                },
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color.fromARGB(221, 149, 87, 7),
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
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Report Of : $dat',
                        style: AppStyles.topicsHeading,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Obx(() {
                          if (orderRequestController.isLoading.value) {
                            // Show a loading screen while data is being fetched
                            return LoadingWidget();
                          } else {
                            if (orderRequestController
                                        .requirmentResponse.value.response ==
                                    null ||
                                orderRequestController.requirmentResponse.value
                                    .response!.isEmpty) {
                              // Show an empty cart page if there are no orders available
                              return EmptyCartPage(
                                onClick: () {},
                              );
                            } else {
                              return Obx(() {
                                if (orderRequestController.isLoading.value) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else {
                                  if (orderRequestController.requirmentResponse
                                          .value.response!.length ==
                                      0) {
                                    return Container(
                                      color: AppColors.iconColors,
                                    );
                                  } else {
                                    return ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: orderRequestController
                                          .productQuantities.length,
                                      itemBuilder: (context, index) {
                                        final productQuantity =
                                            orderRequestController
                                                .productQuantities[index];
                                        return ListTileContainer(
                                          name: productQuantity.productName,
                                          quantit:
                                              productQuantity.totalQuantity,
                                        );
                                      },
                                    );
                                  }
                                }
                              });
                            }
                          }
                        }),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
