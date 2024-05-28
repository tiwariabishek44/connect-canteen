import 'package:cached_network_image/cached_network_image.dart';
import 'package:connect_canteen/app1/cons/colors.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class OrderPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: AppColors.backgroundColor,
        title: Text('Order Details'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Section
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "Group Code: 1429",
              style: TextStyle(
                fontSize: 20.0.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // Order List Section
          Expanded(
            child: ListView.builder(
              itemCount: 5, // Replace with actual order count
              itemBuilder: (context, index) {
                return _buildOrderCard();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard() {
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: Container(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  color: Colors.white, // Add a background color
                ),
                height: 13.h,
                width: 25.w,
                child: ClipRRect(
                  // Use ClipRRect to ensure that the curved corners are applied
                  borderRadius: BorderRadius.circular(15),
                  child: CachedNetworkImage(
                    imageUrl:
                        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSWHfWUUM6yRcofKabUwmIJH2lhUCMpWuP_9h7TprNY9A&s' ??
                            '',
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) =>
                        Icon(Icons.error_outline, size: 40),
                  ),
                ),
              ),
              SizedBox(width: 5.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Samosa with achar',
                      style: TextStyle(
                        color: Color.fromARGB(255, 80, 79, 79),
                        fontSize: 19.0.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 0.3.h),
                    Text(
                      'Customer Name',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16.0,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Rs.100',
                          style: TextStyle(
                              fontSize: 17.0.sp,
                              fontStyle: FontStyle.values[0],
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 227, 106, 97)),
                        ),
                        Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 4.w, vertical: 1.h),
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 110, 209, 114),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Text(
                              '10-Plate',
                              style: TextStyle(
                                color: Colors.grey[100],
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0.sp,
                              ),
                            )),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
