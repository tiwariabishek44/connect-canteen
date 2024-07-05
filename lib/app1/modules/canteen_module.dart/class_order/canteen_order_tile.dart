import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_canteen/app/config/style.dart';
import 'package:connect_canteen/app1/model/order_response.dart';
import 'package:connect_canteen/app1/modules/canteen_module.dart/checkout/chekcout_page.dart';
import 'package:connect_canteen/app1/modules/common/login/login_controller.dart';
import 'package:connect_canteen/app1/modules/student_modules/cart/utils/otp_generator.dart';
import 'package:connect_canteen/app1/modules/student_modules/order/order_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CanteenORderTile extends StatefulWidget {
  final UserOrderResponse order;
  CanteenORderTile({super.key, required this.order});

  @override
  _CanteenORderTileState createState() => _CanteenORderTileState();
}

class _CanteenORderTileState extends State<CanteenORderTile> {
  final loginController = Get.put(LoginController());
  final orderController = Get.put(StudetnORderController());
  bool isExpanded = false;
  final otpController = Get.put(OTPGenerator());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppPadding.screenHorizontalPadding,
      child: GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return OtpVerification(
                order: widget.order,
                otp: widget.order.otp,
              );
            },
          );
        },
        child: Container(
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            border: isExpanded
                ? Border.all(color: Colors.blueAccent, width: 1.5)
                : Border.all(color: Colors.transparent),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.order.username,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 20.0.sp,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              'NPR ${widget.order.totalAmount}',
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
                              '${widget.order.mealTime}',
                              style: TextStyle(
                                  fontSize: 16.0.sp,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                        SizedBox(height: 0.6.h),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OtpVerification extends StatefulWidget {
  final UserOrderResponse order;
  final String otp;

  const OtpVerification({required this.otp, required this.order, Key? key})
      : super(key: key);

  @override
  _OtpVerificationState createState() => _OtpVerificationState();
}

class _OtpVerificationState extends State<OtpVerification> {
  final TextEditingController _otpController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _otpController.addListener(() {
      print('Entered OTP: ${_otpController.text}');
    });
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  void _verifyOtp() {
    if (_otpController.text == widget.otp) {
      setState(() {
        _isLoading = true;
      });
      FocusScope.of(context).unfocus();

      Timer(Duration(seconds: 1), () {
        setState(() {
          _isLoading = false;
        });
        Get.back();

        Get.to(
            () => OrderCheckoutPage(
                  order: widget.order,
                ),
            transition: Transition.cupertinoDialog);
      });
    } else {
      Get.snackbar(
        duration: Duration(seconds: 1),
        'Error',
        'OTP is wrong',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      alignment: Alignment.bottomCenter,
      insetPadding: EdgeInsets.zero,
      child: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.3,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Padding(
              padding: AppPadding.screenHorizontalPadding,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 3.0.h),
                    child: Column(
                      children: [
                        Text('Enter Order OTP',
                            style: TextStyle(
                                fontSize: 27.0, fontWeight: FontWeight.bold)),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _otpController,
                        maxLength: 4,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'Enter OTP',
                          counterText: '', // Hide the character counter
                        ),
                        onChanged: (value) {
                          if (value.length == 4) {
                            _verifyOtp();
                          }
                        },
                      ),
                    ),
                  ),
                  if (_isLoading)
                    Center(
                      child: CircularProgressIndicator(),
                    ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 10,
            right: 10,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: CircleAvatar(
                backgroundColor: Colors.grey,
                child: Icon(Icons.close, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class NextPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Next Page'),
      ),
      body: Center(
        child: Text('Welcome to the next page!'),
      ),
    );
  }
}
