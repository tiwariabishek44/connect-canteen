import 'package:connect_canteen/app1/modules/common/logoin_option/login_option_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class OptionChoose extends StatelessWidget {
  final loginOptionController = Get.put(LoginOptionController());

  @override
  Widget build(BuildContext context) {
    return loginOptionController.userTypes.value != 'student'
        ? Container(
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: [
                Expanded(
                  child: Obx(() => Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color:
                              loginOptionController.userTypes.value == 'canteen'
                                  ? const Color.fromARGB(255, 15, 17, 18)
                                  : Color.fromARGB(255, 213, 213, 213),
                        ),
                        child: TextButton(
                          onPressed: () {
                            loginOptionController.userTypes.value = 'canteen';
                            // Handle "As Canteen" button press
                          },
                          child: Text(
                            "As Canteen",
                            style: TextStyle(
                              color: loginOptionController.userTypes.value ==
                                      'canteen'
                                  ? Color.fromARGB(255, 229, 230, 230)
                                  : Color.fromARGB(255, 9, 8, 8),
                              fontSize: 16,
                            ),
                          ),
                        ),
                      )),
                ),
                SizedBox(
                  width: 3.w,
                ),
                Expanded(
                  child: Obx(() => Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: loginOptionController.userTypes.value ==
                                  'canteenHelper'
                              ? Color.fromRGBO(15, 17, 18, 1)
                              : Color.fromARGB(255, 207, 209, 207),
                        ),
                        child: TextButton(
                          onPressed: () {
                            loginOptionController.userTypes.value =
                                'canteenHelper';

                            // Handle "As Helper" button press
                          },
                          child: Text(
                            "As Helper",
                            style: TextStyle(
                              color: loginOptionController.userTypes.value ==
                                      'canteenHelper'
                                  ? Color.fromARGB(255, 255, 255, 255)
                                  : Color.fromARGB(255, 0, 0, 0),
                              fontSize: 16,
                            ),
                          ),
                        ),
                      )),
                ),
              ],
            ),
          )
        : SizedBox.shrink();
  }
}
