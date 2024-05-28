import 'package:connect_canteen/app1/cons/colors.dart';
import 'package:connect_canteen/app1/cons/style.dart';
import 'package:connect_canteen/app1/modules/common/logoin_option/login_option_controller.dart';
import 'package:connect_canteen/app1/widget/custom_button.dart';
import 'package:connect_canteen/app1/widget/welcome_heading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SchoolChoose extends StatelessWidget {
  SchoolChoose({super.key});

  final loginOptionController = Get.put(LoginOptionController());

  final List<String> dummySchools = [
    "School 1",
    "School 2",
    "School 3",
    "School 4",
    "School 5",
    "School 6",
    "School 7",
    "School 8",
    "School 9",
    "School 10",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: AppColors.backgroundColor,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_sharp),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: AppPadding.screenHorizontalPadding,
          child: Column(
            children: [
              SizedBox(
                height: 4.h,
              ),
              WelcomeHeading(
                  mainHeading: "Choose your School/College", subHeading: " "),
              ListView.builder(
                shrinkWrap: true,
                physics: ScrollPhysics(),
                itemCount: dummySchools.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: ListTile(
                        title: Text(dummySchools[index]),
                        onTap: () {
                          // Handle school selection
                        },
                      ),
                    ),
                  );
                },
              ),
              CustomButton(
                text: "Cotinue",
                onPressed: () {
                  FocusScope.of(context).unfocus();
                },
                isLoading: false,
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
