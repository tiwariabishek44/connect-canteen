import 'package:connect_canteen/app1/cons/colors.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class TextFormFieldWidget extends StatelessWidget {
  const TextFormFieldWidget({
    super.key,
    required this.textInputType,
    required this.hintText,
    this.onChanged,
    this.prefixIcon,
    this.suffixIcon,
    this.defaultText,
    this.focusNode,
    this.obscureText,
    required this.controller,
    required this.validatorFunction,
    required this.actionKeyboard,
    this.onSubmitField,
    this.last,
    this.showIcons = true, // Default to true
    this.readOnly = false, // Default value is false
  });
  final bool readOnly; // New parameter to control read-only mode

  final TextInputType textInputType;
  final String hintText;
  final Function? onChanged;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? defaultText;
  final FocusNode? focusNode;
  final bool? obscureText;
  final TextEditingController? controller;
  final Function? validatorFunction;
  final TextInputAction actionKeyboard;
  final Function? onSubmitField;
  final bool? last;
  final bool showIcons; // New parameter

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Text(hintText),
        ),
        SizedBox(
          height: 1.h,
        ),
        TextFormField(
          readOnly: readOnly,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          cursorColor: AppColors.primaryColor,
          textAlign: TextAlign.left,
          obscureText: obscureText ?? false,
          keyboardType: textInputType,
          textInputAction: actionKeyboard,
          controller: controller,
          onChanged: onChanged as String? Function(String?)?,
          style: const TextStyle(color: Colors.black),
          validator: validatorFunction as String? Function(String?)?,
          decoration: InputDecoration(
            labelStyle: TextStyle(
              color: Colors.grey,
              fontSize: 18.sp,
              fontWeight: FontWeight.w400,
            ),
            suffixIcon:
                showIcons ? suffixIcon : null, // Conditionally show suffixIcon
            suffixIconColor: AppColors.primaryColor,
            prefixIcon:
                showIcons ? prefixIcon : null, // Conditionally show prefixIcon
            prefixIconColor: AppColors.primaryColor,
            errorBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.transparent,
              ),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            focusedErrorBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.transparent,
              ),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.transparent,
              ),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Color.fromARGB(255, 202, 201, 201),
              ),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            contentPadding: EdgeInsets.all(2.h),
            filled: true,
            fillColor: const Color.fromARGB(24, 152, 151, 151),
            border: InputBorder.none,
            hintStyle: TextStyle(
              color: Colors.grey,
              fontSize: 18.sp,
              fontWeight: FontWeight.w400,
            ),
            errorMaxLines: 3,
          ),
        ),
      ],
    );
  }
}
