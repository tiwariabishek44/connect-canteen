import 'dart:developer';

import 'package:connect_canteen/app1/cons/colors.dart';
import 'package:connect_canteen/app1/model/student_model.dart';
import 'package:connect_canteen/app1/model/transction_model.dart';
import 'package:connect_canteen/app1/modules/common/login/login_controller.dart';
import 'package:connect_canteen/app1/modules/common/wallet/transcton_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class BalanceCard extends StatelessWidget {
  final transctionController = Get.put(TransctionController());
  final String userid;
  final loignController = Get.put(LoginController());

  BalanceCard({super.key, required this.userid});
  @override
  Widget build(BuildContext context) {
    transctionController.showMoney.value = false;
    return Column(
      children: [
        StreamBuilder<StudentDataResponse?>(
          stream: transctionController.getStudetnData(userIds: userid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container();
            } else if (snapshot.hasError) {
              return SizedBox.shrink();
            } else if (snapshot.data == null) {
              return SizedBox.shrink();
            } else {
              StudentDataResponse studetnData = snapshot.data!;

              return Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color.fromARGB(255, 245, 255, 255),
                      Color.fromARGB(255, 200, 232, 200)
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromARGB(66, 109, 109, 109),
                      blurRadius: 1,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Wallet BALANCE',
                      style: TextStyle(
                        fontSize: 17,
                        color: const Color.fromARGB(179, 60, 58, 58),
                      ),
                    ),
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Obx(() => Text(
                              transctionController.showMoney.value
                                  ? '\NPR ${NumberFormat('#,##,###').format(studetnData.balance)}'
                                  : 'NPR ****',
                              style: TextStyle(
                                fontSize: 24.sp,
                                fontWeight: FontWeight.bold,
                                color: const Color.fromARGB(255, 17, 17, 17),
                              ),
                            )),
                        SizedBox(
                          width: 2.w,
                        ),
                        Obx(() => GestureDetector(
                              onTap: () {
                                transctionController.showMoney.value =
                                    !transctionController.showMoney.value;
                              },
                              child: Icon(
                                transctionController.showMoney.value
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                              ),
                            ))
                      ],
                    ),
                  ],
                ),
              );
            }
          },
        )
      ],
    );

    // oooooo
  }
}
