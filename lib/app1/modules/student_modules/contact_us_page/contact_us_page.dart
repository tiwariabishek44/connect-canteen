import 'package:connect_canteen/app1/cons/style.dart';
import 'package:connect_canteen/app1/modules/common/login/login_controller.dart';
import 'package:connect_canteen/app1/widget/custom_button.dart';
import 'package:connect_canteen/app1/widget/custom_text_field.dart';
import 'package:connect_canteen/app1/widget/textFormField.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ContactUsPage extends StatelessWidget {
  final loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Contact Us'),
        ),
        body: Padding(
          padding: AppPadding.screenHorizontalPadding,
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(1.0),
                child: Container(
                  padding: const EdgeInsets.all(2.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromARGB(31, 0, 0, 0),
                        blurRadius: 8,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(13.0),
                    child: Column(children: [
                      TextFormFieldWidget(
                        showIcons: false,
                        textInputType: TextInputType.text,
                        hintText: "Name",
                        controller: loginController.emailController,
                        validatorFunction: (value) {
                          if (value.isEmpty) {
                            return "Email is required";
                          }
                          return null;
                        },
                        actionKeyboard: TextInputAction.next,
                        prefixIcon: const Icon(Icons.person_outline),
                      ),
                      SizedBox(
                        height: 3.h,
                      ),
                      TextFormFieldWidget(
                        showIcons: false,
                        textInputType: TextInputType.text,
                        hintText: "Phone",
                        controller: loginController.emailController,
                        validatorFunction: (value) {
                          if (value.isEmpty) {
                            return "Email is required";
                          }
                          return null;
                        },
                        actionKeyboard: TextInputAction.next,
                        prefixIcon: const Icon(Icons.phone),
                      ),
                      SizedBox(
                        height: 3.h,
                      ),
                      TextFormFieldWidget(
                        showIcons: false,
                        textInputType: TextInputType.text,
                        hintText: "Email",
                        controller: loginController.emailController,
                        validatorFunction: (value) {
                          if (value.isEmpty) {
                            return "Email is required";
                          }
                          return null;
                        },
                        actionKeyboard: TextInputAction.next,
                        prefixIcon: const Icon(Icons.email_outlined),
                      ),
                      SizedBox(
                        height: 3.h,
                      ),
                      TextFormFieldWidget(
                        showIcons: false,
                        textInputType: TextInputType.text,
                        hintText: "Message",
                        controller: loginController.emailController,
                        validatorFunction: (value) {
                          if (value.isEmpty) {
                            return "Email is required";
                          }
                          return null;
                        },
                        actionKeyboard: TextInputAction.next,
                        prefixIcon: const Icon(Icons.message),
                      ),
                      SizedBox(
                        height: 3.h,
                      ),
                      Obx(
                        () => CustomButton(
                          text: "SUBMIT",
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            loginController.userLogin();
                          },
                          isLoading: loginController.isLoginLoading.value,
                        ),
                      ),
                    ]),
                  ),
                ),
              ),
              SizedBox(
                height: 4.h,
              ),
              Padding(
                padding: const EdgeInsets.all(1.0),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Align(
                      alignment: Alignment.center,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Contact Admin Information:',
                            style: TextStyle(
                              fontSize: 20, // Increase the font size
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Phone: +973838838383',
                            style: TextStyle(
                              color: Colors.grey[800], // Grey toward black
                            ),
                          ),
                          Text(
                            'Email: slls@gmail.com',
                            style: TextStyle(
                              color: Colors.grey[800], // Grey toward black
                            ),
                          ),
                          Text(
                            'Address: timkune-32, kathmandu',
                            style: TextStyle(
                              color: Colors.grey[800], // Grey toward black
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
