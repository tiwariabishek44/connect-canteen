import 'package:connect_canteen/app/modules/vendor_modules/penalty/clase_wise_order/class_wise_order.dart';
import 'package:connect_canteen/app/modules/vendor_modules/penalty/clase_wise_order/class_wise_order_controller.dart';
import 'package:connect_canteen/app/modules/vendor_modules/widget/list_tile_contailer.dart';
import 'package:connect_canteen/app/widget/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:connect_canteen/app/config/colors.dart';
import 'package:connect_canteen/app/config/style.dart';
import 'package:connect_canteen/app/modules/vendor_modules/penalty/class_reoprt_controller.dart';

class Penaltys extends StatelessWidget {
  final String date;
  Penaltys({required this.date});
  final classReportController = Get.put(ClassReportController());
  final classWiseOrderController = Get.put(ClassWiseOrderController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: Color(0xff06C167),
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Penalty Charge",
                style: AppStyles.appbar,
              ),
              Text(
                date,
                style: AppStyles.listTilesubTitle1,
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Obx(() {
          if (classReportController.isLoading.value) {
            return LoadingScreen();
          } else {
            if (classReportController.remaningOrderResponse.value.response ==
                    null ||
                classReportController
                    .remaningOrderResponse.value.response!.isEmpty) {
              // Show an empty cart page if there are no orders available
              return const Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.insert_emoticon_sharp,
                    size: 60,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'No Order Left',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ));
            } else {
              return ListView.builder(
                itemCount:
                    classReportController.remaningproductQuantities.length,
                itemBuilder: (context, index) {
                  final productQuantity =
                      classReportController.remaningproductQuantities[index];
                  return GestureDetector(
                    onTap: () {
                      classWiseOrderController.className.value =
                          productQuantity.className;
                      classWiseOrderController.fetchOrders(date);
                      Get.to(
                          () => ClassWiseOrder(
                                date: date,
                                classs: productQuantity.className,
                              ),
                          transition: Transition.rightToLeft);
                    },
                    child: ListTileContainer(
                      name: productQuantity.className,
                      quantit: productQuantity.totalQuantity,
                    ),
                  );
                },
              );
            }
          }
        }),
      ),
    );
  }
}
