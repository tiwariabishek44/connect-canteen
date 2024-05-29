import 'package:connect_canteen/app/config/colors.dart';
import 'package:connect_canteen/app1/cons/style.dart';
import 'package:flutter/material.dart';

void showUpdateProfileDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0), // No border radius
        ),
        backgroundColor: AppColors.backgroundColor,
        title: Text(
          'Update Your Profile',
          style: AppStyles.appbar,
        ),
        content: Text('Please update your profile to continue.'),
      );
    },
  );
}
