import 'package:flutter/material.dart';
import 'package:connect_canteen/app/config/colors.dart';
import 'package:connect_canteen/app/config/style.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool iconrequired;

  const CustomAppBar({required this.title, bool? iconrequired})
      : iconrequired = iconrequired ?? true;

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: iconrequired
          ? IconButton(
              icon: Icon(
                Icons.chevron_left,
                size: 26.sp,
              ),
              onPressed: () {
                Get.back();
              },
            )
          : null,
      centerTitle: false,
      scrolledUnderElevation: 0,
      backgroundColor: Color(0xff06C167),
      title: Text(
        title,
        style: AppStyles.appbar,
      ),
    );
  }
}
