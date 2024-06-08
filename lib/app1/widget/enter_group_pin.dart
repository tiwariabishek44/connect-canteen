import 'package:connect_canteen/app/config/colors.dart';
import 'package:connect_canteen/app/config/style.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class EnterGroupPin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(right: 8.0, top: 6.h),
          child: Image.asset(
            'assets/pinentry.png', // Replace with your image asset path
            width: 150, // Adjust image width as needed
            height: 150, // Adjust image height as needed
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 18.0, top: 8),
          child: Text('Enter the  Student Group Code.',
              style: AppStyles.listTileTitle),
        ),
      ],
    );
  }
}
