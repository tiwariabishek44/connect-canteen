import 'package:connect_canteen/app/config/colors.dart';
import 'package:connect_canteen/app/config/style.dart';
import 'package:connect_canteen/app/modules/student_modules/orders/orders_controller.dart';
import 'package:connect_canteen/app/modules/student_modules/group/group_controller.dart';
import 'package:connect_canteen/app/modules/student_modules/orders/view/order_product_list.dart';
import 'package:connect_canteen/app/widget/empty_cart_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class OrderPage extends StatelessWidget {
  final orderContorller = Get.put(OrderController());
  final groupController = Get.put(GroupController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: Color(0xff06C167),
        title: Text(
          "Orders",
          style: AppStyles.appbar,
        ),
      ),
      body: Padding(
          padding: AppPadding.screenHorizontalPadding,
          child: Obx(
            () {
              if (groupController.fetchGroupedData.value == false) {
                return EmptyCartPage(onClick: () {});
              } else {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                        child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 1.h,
                          ),
                          Obx(() => Text(
                                "GroupCode : ${groupController.groupResponse.value.response!.first.groupCode}",
                                style: AppStyles.titleStyle,
                              )),
                          SizedBox(
                            height: 1.h,
                          ),
                          OrderPRoductList(),
                        ],
                      ),
                    )),
                  ],
                );
              }
            },
          )),
    );
  }
}
