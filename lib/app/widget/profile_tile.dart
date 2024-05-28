import 'package:flutter/material.dart';
import 'package:connect_canteen/app/config/colors.dart';
import 'package:connect_canteen/app/config/style.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ProfileTile extends StatelessWidget {
  final String title;
  final Icon leadingIcon;
  final VoidCallback? onTap;

  const ProfileTile({
    Key? key,
    required this.title,
    required this.leadingIcon,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 4,
      ),
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        leading: leadingIcon,
        tileColor: Color.fromARGB(255, 248, 251, 251),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        title: Text(
          title,
          style: TextStyle(
              fontSize: 17.sp,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 105, 102, 102)),
        ),
        onTap: onTap,
      ),
    );
  }
}
