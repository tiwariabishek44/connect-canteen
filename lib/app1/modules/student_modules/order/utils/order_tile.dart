import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:connect_canteen/app/config/style.dart';
import 'package:connect_canteen/app1/model/order_model.dart';
import 'package:connect_canteen/app1/modules/common/login/login_controller.dart';
import 'package:connect_canteen/app1/modules/student_modules/order/order_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';

class OrderTiles extends StatelessWidget {
  final OrderResponse order;
  final String type;
  OrderTiles({super.key, required this.order, required this.type});
  final loignController = Get.put(LoginController());
  final ordreCotroller = Get.put(StudetnORderController());
  @override
  Widget build(BuildContext context) {
    log('order type $type');
    return Padding(
      padding: AppPadding.screenHorizontalPadding,
      child: GestureDetector(
        onTap: () {
          // if (type == 'regular')
          //   loignController.studentDataResponse.value!.userid == order.cid
          //       ? Get.to(
          //           () => HoldYourOrder(
          //                 order: order,
          //               ),
          //           transition: Transition.cupertinoDialog)
          //       : null;
        },
        child: Container(
          padding: EdgeInsets.all(8.0),
          // margin: EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.productName,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 20.0.sp,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          'NPR ${order.price}',
                          style: TextStyle(
                              fontSize: 16.0.sp,
                              color: Colors.black,
                              fontWeight: FontWeight.w400),
                        ),
                        SizedBox(
                          width: 3.w,
                        ),
                        Icon(
                          Icons.alarm_outlined,
                          size: 17.sp,
                        ),
                        SizedBox(
                          width: 1.w,
                        ),
                        Text(
                          '${order.mealtime}',
                          style: TextStyle(
                              fontSize: 16.0.sp,
                              color: Colors.black,
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                    SizedBox(height: 0.6.h),
                    Row(
                      children: [
                        Icon(
                          Icons.person_outline,
                          size: 17.sp,
                        ),
                        SizedBox(
                          width: 1.w,
                        ),
                        Text(
                          '${order.customer}',
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 0.6.h),
                    if (order.orderType != 'hold')
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 17.sp,
                          ),
                          SizedBox(
                            width: 1.w,
                          ),
                          Text(
                            '${order.date}',
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(width: 2.w),
                          SizedBox(
                            width: 1.w,
                          ),
                          Text(
                            '${order.quantity}/plate',
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),

                    // SizedBox(height: 0.6.h),
                    // Container(
                    //   child: Padding(
                    //     padding: const EdgeInsets.symmetric(
                    //         horizontal: 6.0, vertical: 1.5),
                    //     child: Text("Order By : ${order.isCahsed}",
                    //         style: TextStyle(
                    //             fontSize: 14.0.sp,
                    //             color: Colors.green[600],
                    //             fontWeight: FontWeight.w700)),
                    //   ),
                    // ),
                    // SizedBox(height: 0.6.h),

                    // if (loignController.studentDataResponse.value!.name ==
                    //         order.isCahsed &&
                    //     type == 'history')
                    //   order.coinCollect == 'false'
                    //       ? GestureDetector(
                    //           onTap: () {
                    //             ordreCotroller.collectCoin(
                    //                 10,
                    //                 order.id!,
                    //                 order.productName,
                    //                 loignController.studentDataResponse.value!);
                    //           },
                    //           child: Container(
                    //             decoration: BoxDecoration(
                    //               borderRadius: BorderRadius.circular(5.0),
                    //               color: Color(0xFF123456),
                    //             ),
                    //             child: Padding(
                    //               padding: EdgeInsets.symmetric(
                    //                   horizontal: 6.0, vertical: 1.h),
                    //               child: Text("Collect Coin",
                    //                   style: TextStyle(
                    //                       fontSize: 14.0.sp,
                    //                       color: const Color.fromARGB(
                    //                           255, 255, 255, 255),
                    //                       fontWeight: FontWeight.w700)),
                    //             ),
                    //           ),
                    //         )
                    //       : SizedBox.shrink(),
                  ],
                ),
              ),
              // Stack(
              //   children: [
              //     Container(
              //       width: 14.h,
              //       height: 14.h,
              //       child: CachedNetworkImage(
              //         progressIndicatorBuilder:
              //             (context, url, downloadProgress) => Opacity(
              //           opacity: 0.8,
              //           child: Shimmer.fromColors(
              //             baseColor: const Color.fromARGB(255, 248, 246, 246),
              //             highlightColor: Color.fromARGB(255, 238, 230, 230),
              //             child: Container(
              //               decoration: BoxDecoration(
              //                 borderRadius: BorderRadius.circular(20),
              //                 color: const Color.fromARGB(255, 243, 242, 242),
              //               ),
              //               width: 14.h,
              //               height: 14.h,
              //             ),
              //           ),
              //         ),
              //         imageUrl: order.productImage ?? '',
              //         imageBuilder: (context, imageProvider) => Container(
              //           decoration: BoxDecoration(
              //             borderRadius: BorderRadius.circular(20),
              //             image: DecorationImage(
              //               image: imageProvider,
              //               fit: BoxFit.cover,
              //             ),
              //           ),
              //         ),
              //         fit: BoxFit.fill,
              //         width: double.infinity,
              //         errorWidget: (context, url, error) => CircleAvatar(
              //           radius: 21.4.sp,
              //           child: Icon(
              //             Icons.person,
              //             color: Colors.white,
              //           ),
              //           backgroundColor:
              //               const Color.fromARGB(255, 224, 218, 218),
              //         ),
              //       ),
              //     ),
              //     Positioned(
              //         right: 0,
              //         top: 0,
              //         child:
              //             loignController.studentDataResponse.value!.userid ==
              //                     order.cid
              //                 ? Container(
              //                     decoration: BoxDecoration(
              //                         color: Color.fromARGB(255, 0, 0, 0),
              //                         borderRadius: BorderRadius.circular(16)),
              //                     child: Padding(
              //                       padding: const EdgeInsets.symmetric(
              //                           horizontal: 6.0, vertical: 1.5),
              //                       child: Text(
              //                         "My Order",
              //                         style: TextStyle(
              //                             fontSize: 14.sp,
              //                             fontWeight: FontWeight.w700,
              //                             color: const Color.fromARGB(
              //                                 255, 255, 255, 255)),
              //                       ),
              //                     ),
              //                   )
              //                 : SizedBox.shrink())
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
