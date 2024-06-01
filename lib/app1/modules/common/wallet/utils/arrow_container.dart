import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ArrowContainer extends StatelessWidget {
  final IconData arrowIcon;
  final String text;
  final bool isUpward;

  ArrowContainer({
    required this.arrowIcon,
    required this.text,
    required this.isUpward,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(6.0),
      decoration: BoxDecoration(
        color: Colors.blue[100],
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Transform.rotate(
            angle: isUpward
                ? 20 * 3.1415927 / 180
                : 40 * 3.1415927 / 180, // Convert degrees to radians
            child: Icon(
              arrowIcon,
              size: 20.0,
              color:
                  isUpward ? Colors.green : Color.fromARGB(255, 227, 132, 125),
            ),
          ),
          SizedBox(width: 1.w),
          Text(
            text,
            style: TextStyle(
              fontSize: 16.0.sp,
              fontWeight: FontWeight.bold,
              color:
                  isUpward ? Colors.green : Color.fromARGB(255, 227, 132, 125),
            ),
          ),
        ],
      ),
    );
  }
}
