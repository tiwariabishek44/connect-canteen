import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class NoSalse extends StatelessWidget {
  const NoSalse({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color.fromARGB(255, 245, 255, 255),
            Color.fromARGB(255, 200, 232, 200)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(66, 109, 109, 109),
            blurRadius: 1,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Gross Sales',
            style: TextStyle(
              fontSize: 18,
              color: const Color.fromARGB(179, 60, 58, 58),
            ),
          ),
          SizedBox(height: 5),
          Text(
            '\NPR 00.0',
            style: TextStyle(
              fontSize: 27.sp,
              fontWeight: FontWeight.bold,
              color: const Color.fromARGB(255, 17, 17, 17),
            ),
          ),
          SizedBox(height: 2.h),
          Align(
            alignment: Alignment.bottomRight,
            child: Column(
              children: [
                Text(
                  '\NPR 00.0',
                  style: TextStyle(
                    fontSize: 21.sp,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 192, 156, 11),
                  ),
                ),
                const Text(
                  'Net Sales',
                  style: TextStyle(
                    fontSize: 18,
                    color: const Color.fromARGB(179, 60, 58, 58),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
