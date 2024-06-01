import 'package:connect_canteen/app1/widget/black_textform_field.dart';
import 'package:connect_canteen/app1/widget/custom_app_bar.dart';
import 'package:connect_canteen/app1/widget/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class NameUpdate extends StatelessWidget {
  final String initialName;

  const NameUpdate({Key? key, required this.initialName}) : super(key: key);

  Widget build(BuildContext context) {
    TextEditingController nameController =
        TextEditingController(text: initialName);

    return Scaffold(
      backgroundColor: Colors.white, 
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        titleSpacing: 4.0, // Adjusts the spacing above the title
        title: Text(
          'User Account',
          style: TextStyle(fontWeight: FontWeight.w300),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 4.0.w),
              child: Text(
                'Name',
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
                "This is the name you would like other people to use when refering to you",
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 19.sp,
                    color: Colors.black),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: BlackTextFormField(
                prefixIcon: const Icon(Icons.person),
                textInputType: TextInputType.text,
                hintText: 'Name',
                controller: nameController,
                validatorFunction: (value) {
                  if (value.isEmpty) {
                    return '  Name Can\'t be empty';
                  }
                  return null;
                },
                actionKeyboard: TextInputAction.next,
                onSubmitField: () {},
              ),
            ),
            SizedBox(
              height: 15.h,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomButton(
                isLoading: false,
                text: 'Update',
                onPressed: () {},
                buttonColor: Colors.black,
                textColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
