import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:connect_canteen/app/config/colors.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CustomizedTextfield extends StatelessWidget {
  final TextEditingController myController;
  final String? hintText;
  final IconData icon;
  final TextInputType keyboardType;
  final String? Function(String?) validator; // Validator function

  const CustomizedTextfield(
      {Key? key,
      required this.icon,
      required this.keyboardType,
      required this.validator,
      required this.myController,
      this.hintText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.7.h),
      child: TextFormField(
        validator: validator,
        controller: myController,
        enableSuggestions: true,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(8),
          prefixIcon: IconButton(
            icon: Icon(
              icon,
              color: AppColors.secondaryColor,
              size: 20.sp,
            ),
            onPressed: () {},
          ),
          enabledBorder: OutlineInputBorder(
              borderSide:
                  const BorderSide(color: AppColors.secondaryColor, width: 1),
              borderRadius: BorderRadius.circular(10)),
          focusedBorder: OutlineInputBorder(
              borderSide:
                  const BorderSide(color: AppColors.secondaryColor, width: 1),
              borderRadius: BorderRadius.circular(10)),
          fillColor: Color.fromARGB(255, 255, 255, 255),
          filled: true,
          labelText: hintText,
          labelStyle:
              TextStyle(color: AppColors.secondaryColor, fontSize: 16.sp),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
