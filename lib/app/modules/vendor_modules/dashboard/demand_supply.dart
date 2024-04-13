import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:connect_canteen/app/config/colors.dart';
import 'package:connect_canteen/app/config/style.dart';
import 'package:connect_canteen/app/modules/vendor_modules/class_wise_analytics/class_reoprt_controller.dart';
import 'package:connect_canteen/app/modules/vendor_modules/dashboard/salse_controller.dart';
import 'package:connect_canteen/app/widget/empty_cart_page.dart';
import 'package:connect_canteen/app/widget/loading_screen.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class DemandSupply extends StatelessWidget {
  final salesController = Get.put(SalsesController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          Align(
              alignment: Alignment.topLeft,
              child: Text(
                "Sales Report",
                style: AppStyles.topicsHeading,
              )),
          Obx(
            () {
              if (salesController.isLoading.value) {
                return Center(child: CircularProgressIndicator());
              } else {
                if (salesController.productWithQuantity.value.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 7.h),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.shopping_cart_outlined,
                            size: 100.0,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 20.0),
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
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        itemCount: salesController.productWithQuantity.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.only(bottom: 0.7.h),
                            child: Container(
                              decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 255, 255, 255),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color: const Color.fromARGB(
                                          255, 225, 225, 225))),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 1, horizontal: 2.0.w),
                                child: Row(children: [
                                  Container(
                                    height: 60,
                                    width: 60,
                                    decoration: BoxDecoration(
                                        color: const Color.fromARGB(
                                            255, 255, 255, 255)),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: CachedNetworkImage(
                                        imageUrl: salesController
                                                .productWithQuantity[index]
                                                .image ??
                                            '', // Use a default empty string if URL is null
                                        fit: BoxFit.cover,
                                        errorWidget: (context, url, error) =>
                                            Icon(
                                          Icons.error_outline,
                                          size: 40,
                                        ), // Placeholder icon for error
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Expanded(
                                    child: Text(
                                        '${salesController.productWithQuantity[index].productName}',
                                        overflow: TextOverflow.clip,
                                        maxLines: 2,
                                        style: AppStyles.listTileTitle),
                                  ),
                                  Spacer(),
                                  Column(
                                    children: [
                                      Text(
                                        'Sales: ${salesController.productWithQuantity[index].totalQuantity} -Plate',
                                        style: TextStyle(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.w600,
                                          color:
                                              Color.fromARGB(255, 35, 68, 68),
                                        ),
                                      ),
                                      Text(
                                        'Rs: ${salesController.productWithQuantity[index].price}',
                                        style: AppStyles.titleStyle,
                                      ),
                                    ],
                                  )
                                ]),
                              ),
                            ),
                          );
                        }),
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }
}
