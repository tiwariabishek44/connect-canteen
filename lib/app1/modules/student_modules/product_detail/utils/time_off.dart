import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CustomAlertDialog extends StatelessWidget {
  final String timeString;
  const CustomAlertDialog({Key? key, required this.timeString})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    DateTime specifiedTime = DateFormat.Hm().parse(timeString);
    specifiedTime = DateTime(
        now.year, now.month, now.day, specifiedTime.hour, specifiedTime.minute);

    return AlertDialog(
      backgroundColor: Colors.white,
      elevation: 0,
      content: Container(
        color: Colors.white,
        width: double.maxFinite,
        height: 9.h,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Clock icon in red
            Expanded(
              flex: 1,
              child: Center(
                child: Icon(
                  Icons.access_time,
                  size: 40,
                  color: Colors.red,
                ),
              ),
            ),
            // Order time label
            Expanded(
              flex: 6,
              child: Center(
                child: Text(
                  "Order time is over at: $timeString",
                  style: TextStyle(fontSize: 16.sp),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
