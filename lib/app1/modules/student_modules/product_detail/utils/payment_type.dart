import 'package:connect_canteen/app1/modules/student_modules/product_detail/controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class PaymentTypeRow extends StatelessWidget {
  final addOrderControllre = Get.put(AddOrderController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(7.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Payment Type',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Obx(() => Row(
                children: [
                  // GestureDetector(
                  //   onTap: () {
                  //     addOrderControllre.paymentType.value = 'wallet';
                  //   },
                  //   child: Container(
                  //     padding:
                  //         EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  //     decoration: BoxDecoration(
                  //       color: addOrderControllre.paymentType.value == 'wallet'
                  //           ? Colors.black
                  //           : const Color.fromARGB(255, 233, 230, 230),
                  //       borderRadius: BorderRadius.circular(4),
                  //     ),
                  //     child: Text(
                  //       'Wallet',
                  //       style: TextStyle(
                  //         color:
                  //             addOrderControllre.paymentType.value == 'wallet'
                  //                 ? Colors.white
                  //                 : Colors.black,
                  //         fontSize: 14,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  // SizedBox(width: 10), // Add spacing between the containers
                  GestureDetector(
                    onTap: () {
                      addOrderControllre.paymentType.value = 'cash';
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: addOrderControllre.paymentType.value == 'cash'
                            ? Colors.black
                            : const Color.fromARGB(255, 233, 230, 230),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'Cash',
                        style: TextStyle(
                          color: addOrderControllre.paymentType.value == 'cash'
                              ? const Color.fromARGB(255, 236, 236, 236)
                              : const Color.fromARGB(255, 0, 0, 0),
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              )),
        ],
      ),
    );
  }
}
