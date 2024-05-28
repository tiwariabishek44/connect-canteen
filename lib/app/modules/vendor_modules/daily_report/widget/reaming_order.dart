import 'package:connect_canteen/app/config/colors.dart';
import 'package:connect_canteen/app/config/style.dart';
import 'package:connect_canteen/app/modules/vendor_modules/daily_report/remaning_orders_controller.dart';
import 'package:connect_canteen/app/widget/custom_loging_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ReamingOrder extends StatelessWidget {
  ReamingOrder({super.key});
  final remainingOrdersController = Get.put(RemaningController());

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 3.0.w, top: 2.h),
            child: Text(
              "Remaning Order",
              style: AppStyles.topicsHeading,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Obx(
                  () {
                    if (remainingOrdersController.isLoading.value) {
                      return LoadingWidget();
                    } else {
                      if (remainingOrdersController
                          .productWithQuantity.value.isEmpty) {
                        return Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 7.h),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'No sales till now.',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 20.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        return ListView.builder(
                            shrinkWrap: true,
                            physics: ScrollPhysics(),
                            itemCount: remainingOrdersController
                                .productWithQuantity.length,
                            itemBuilder: (context, index) {
                              return Container(
                                height: 5.h,
                                width: double.infinity,
                                child: Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 2.0.w),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${remainingOrdersController.productWithQuantity[index].productName}',
                                        style: AppStyles.listTilesubTitle,
                                      ),
                                      Text(
                                        '${remainingOrdersController.productWithQuantity[index].totalQuantity} -Plate',
                                        style: TextStyle(
                                            fontSize: 17.sp,
                                            fontWeight: FontWeight.w500,
                                            color: const Color.fromARGB(
                                                255, 151, 16, 7)),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            });
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
