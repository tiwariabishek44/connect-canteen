import 'package:connect_canteen/app1/cons/colors.dart';
import 'package:connect_canteen/app1/cons/style.dart';
import 'package:connect_canteen/app1/modules/student_modules/homepage/homepage.dart';
import 'package:connect_canteen/app1/widget/order_cornfirmation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class DetailPageShortcuts extends StatelessWidget {
  final DetailPageController _controller = Get.put(DetailPageController());

  @override
  Widget build(BuildContext context) {
    return Dialog(
      alignment: Alignment.bottomCenter,
      insetPadding: EdgeInsets.zero,
      child: Container(
        height: 56.h,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 244, 243, 243),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Container(
                      height: 0.5.h,
                      width: 20.w,
                      decoration: BoxDecoration(
                          color: Colors.green, // Changed color to green
                          borderRadius: BorderRadius.circular(10))),
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                      color: Colors.white, // Add a background color
                    ),
                    height: 10.h,
                    width: 25.w,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSWHfWUUM6yRcofKabUwmIJH2lhUCMpWuP_9h7TprNY9A&s',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Icon(Icons.error_outline, size: 40),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Product Name',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4.0),
                        Text(
                          'Rs.200-plate',
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: const Color.fromARGB(255, 236, 234, 234),
                  border: Border.all(
                    color: Colors.grey
                        .withOpacity(0.5), // Set border color to light grey
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Quantity:',
                        style: TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove, color: Colors.teal),
                            onPressed: _controller.decrement,
                          ),
                          Obx(() => Text(
                                '${_controller.quantity}',
                                style: TextStyle(fontSize: 18),
                              )),
                          IconButton(
                            icon: Icon(Icons.add, color: Colors.teal),
                            onPressed: _controller.increment,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: const Color.fromARGB(255, 236, 234, 234),
                  border: Border.all(
                    color: Colors.grey
                        .withOpacity(0.5), // Set border color to light grey
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Group Code:',
                            style: TextStyle(fontSize: 14.0),
                          ),
                          Text(
                            '1420',
                            style: TextStyle(fontSize: 14.0),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Meal Time:',
                            style: TextStyle(fontSize: 14.0),
                          ),
                          Text(
                            '8:00 AM',
                            style: TextStyle(fontSize: 14.0),
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Date:',
                            style: TextStyle(fontSize: 14.0),
                          ),
                          Text(
                            'YYYY-MM-DD',
                            style: TextStyle(fontSize: 14.0),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Qnty:',
                            style: TextStyle(fontSize: 14.0),
                          ),
                          Obx(() => Text(
                                '${_controller.quantity}-plate',
                                style: TextStyle(fontSize: 14.0),
                              )),
                        ],
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total:',
                            style: TextStyle(fontSize: 14.0),
                          ),
                          Text(
                            'Rs.100',
                            style: TextStyle(fontSize: 14.0),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 12),
              GestureDetector(
                onTap: () {
                  Get.back();
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return ConfirmationDialog();
                    },
                  );
                },
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 4.0.w, vertical: 0.9.h),
                    child: Center(
                      child: Text('Order Now',
                          style: AppStyles.listTileTitle.copyWith(
                            fontSize: 16.0,
                            color: Colors.white,
                          )),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
