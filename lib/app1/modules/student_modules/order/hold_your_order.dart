import 'package:connect_canteen/app1/model/order_model.dart';
import 'package:connect_canteen/app1/modules/student_modules/order/utils/order_tile.dart';
import 'package:connect_canteen/app1/widget/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class HoldYourOrder extends StatelessWidget {
  final OrderResponse order;
  const HoldYourOrder({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        titleSpacing: 4.0, // Adjusts the spacing above the title
        title: Text(
          'Order Setting',
          style: TextStyle(fontWeight: FontWeight.w300),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 4.0.w),
              child: Text(
                'Hold Your Order',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.sp),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(18.0),
              child: Text(
                "You can hold your order. The order will not be prepared. Later, you can reschedule your order.",
                style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 19.sp,
                    color: Colors.black),
              ),
            ),
            SizedBox(
              height: 4.h,
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 4.0.w),
                child: Text(
                  'Your Order',
                  style:
                      TextStyle(fontWeight: FontWeight.w400, fontSize: 23.sp),
                ),
              ),
            ),
            OrderTiles(
              order: order,
              type: 'hold',
            ),
            SizedBox(
              height: 17.h,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomButton(
                isLoading: false,
                text: 'Hold',
                onPressed: () {},
              ),
            )
          ],
        ),
      ),
    );
  }
}
