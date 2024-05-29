import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String boldTitle; 

  const CustomAppBar({Key? key, required this.title, required this.boldTitle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      titleSpacing: 4.0, // Adjusts the spacing above the title
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.w300),
      ),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: EdgeInsets.only(left: 4.0.w),
            child: Text(
              boldTitle,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.sp),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
