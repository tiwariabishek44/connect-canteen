import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool isLeadingBack;

  const CustomAppBar({
    Key? key,
    required this.title,
    required this.isLeadingBack,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      leading: isLeadingBack
          ? Padding(
              padding: const EdgeInsets.all(4.0),
              child: IconButton(
                icon: Icon(Icons.chevron_left, size: 26.sp),
                onPressed: () {
                  Get.back();
                },
              ),
            )
          : null,
      centerTitle: false,
      backgroundColor: Colors.white,
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
