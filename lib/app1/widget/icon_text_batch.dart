import 'package:connect_canteen/app1/cons/style.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class IconTextBatch extends StatelessWidget {
  final IconData icon;
  final String text;

  const IconTextBatch({
    Key? key,
    required this.icon,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          // You can adjust the size and color of the icon as needed
          size: 18.sp,
          color: Colors.black,
        ),
        SizedBox(width: 5), // Add spacing between icon and text
        Text(
          text,
          style: AppStyles.listTilesubTitle,
        ),
      ],
    );
  }
}
