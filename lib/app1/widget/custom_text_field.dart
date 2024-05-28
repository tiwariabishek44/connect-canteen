import 'package:connect_canteen/app1/cons/colors.dart';
import 'package:connect_canteen/app1/cons/style.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CustomizedTextfield extends StatelessWidget {
  final TextEditingController myController;
  final String? hintText;
  final IconData icon;
  final String? Function(String?) validator; // Validator function
  final bool readOnly; // New parameter to control read-only mode

  const CustomizedTextfield({
    Key? key,
    required this.icon,
    required this.validator,
    required this.myController,
    this.hintText,
    this.readOnly = false, // Default value is false
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.5.h),
      child: TextFormField(
        validator: validator,
        controller: myController,
        readOnly: readOnly, // Set the readOnly property based on the parameter
        decoration: InputDecoration(
          prefixIcon: Icon(
            icon,
            color: AppColors.iconColors,
            size: 30,
          ),
          enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                  color: AppColors.inputFieldBorderColor, width: 1),
              borderRadius: BorderRadius.circular(10)),
          focusedBorder: OutlineInputBorder(
              borderSide:
                  const BorderSide(color: AppColors.secondaryColor, width: 1),
              borderRadius: BorderRadius.circular(10)),
          fillColor: Color.fromARGB(255, 255, 255, 255),
          filled: true,
          labelText: hintText,
          labelStyle: AppStyles.titleStyle,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
