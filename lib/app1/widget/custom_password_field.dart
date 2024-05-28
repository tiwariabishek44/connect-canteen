import 'package:connect_canteen/app1/cons/colors.dart';
import 'package:connect_canteen/app1/cons/style.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CustomPasswordField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final bool isPasswordVisible;
  final void Function() togglePasswordVisibility;

  const CustomPasswordField({
    Key? key,
    required this.controller,
    required this.labelText,
    required this.isPasswordVisible,
    required this.togglePasswordVisibility,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: !isPasswordVisible,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.lock_outline),
        labelText: labelText,
        labelStyle: AppStyles.titleStyle,
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
              color: AppColors.inputFieldBorderColor, width: 1),
          borderRadius: BorderRadius.circular(0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide:
              const BorderSide(color: AppColors.secondaryColor, width: 1),
          borderRadius: BorderRadius.circular(0),
        ),
        fillColor: Color.fromARGB(255, 255, 255, 255),
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(0),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            isPasswordVisible
                ? Icons.visibility
                : Icons.visibility_off_outlined,
            color: AppColors.iconColors,
          ),
          onPressed: togglePasswordVisibility,
        ),
        contentPadding: EdgeInsets.symmetric(
            vertical: 10.0), // Adjust the vertical padding to reduce height
      ),
    );
  }
}
