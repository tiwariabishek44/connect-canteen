import 'package:connect_canteen/app/widget/custom_loging_widget.dart';
import 'package:connect_canteen/app1/cons/colors.dart';
import 'package:connect_canteen/app1/cons/style.dart';
import 'package:connect_canteen/app1/model/food_order_time_model.dart';
import 'package:connect_canteen/app1/model/product_model.dart';
import 'package:connect_canteen/app1/modules/common/login/login_controller.dart';
import 'package:connect_canteen/app1/modules/common/wallet/wallet_controller.dart';
import 'package:connect_canteen/app1/modules/student_modules/product_detail/controller.dart';
import 'package:connect_canteen/app1/modules/student_modules/product_detail/utils/info_widget.dart';
import 'package:connect_canteen/app1/modules/student_modules/product_detail/utils/no_group.dart';
import 'package:connect_canteen/app1/modules/student_modules/product_detail/utils/update_profile_popup.dart';
import 'package:connect_canteen/app1/widget/order_cornfirmation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ProductDetailPage extends StatefulWidget {
  final Products product;

  ProductDetailPage({required this.product});

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  final loignController = Get.put(LoginController());
  final walletController = Get.put(WalletController());
  final addOrderControllre = Get.put(AddOrderController());
  int quantity = 1; // Initial quantity
  final List<FoodOrderTime> foodOrdersTime = [
    FoodOrderTime(mealTime: "12:30", orderHoldTime: "8:00"),
    FoodOrderTime(mealTime: "1:15", orderHoldTime: "8:00"),
    FoodOrderTime(mealTime: "2:00", orderHoldTime: "8:00"),
    FoodOrderTime(mealTime: "1:15", orderHoldTime: "8:00"),
    FoodOrderTime(mealTime: "2:00", orderHoldTime: "8:00"),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              child: Image.network(
                widget.product.imageUrl,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: 5.h,
            left: 3.w,
            child: GestureDetector(
              onTap: () {
                Get.back();
              },
              child: Container(
                height: 6.h,
                width: 6.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.cardColor,
                ),
                child: Icon(
                  Icons.chevron_left,
                  size: 25.sp,
                ),
              ),
            ),
          ),
          Positioned(
            top: 180, // Adjust as necessary to overlap the image slightly
            left: 0,
            right: 0,
            bottom: 0,
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30)),
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
                    SizedBox(height: 2.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment:
                          CrossAxisAlignment.start, // Added this line
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.product.name,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 70, 69, 69),
                                ),
                              ),
                              Text(
                                '/plate',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(179, 50, 49, 49),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text("Rs.200")
                      ],
                    ),

                    SizedBox(height: 3.h),
                    Divider(
                      height: 0.4.h,
                      thickness: 0.4.h,
                      color:
                          Color.fromARGB(255, 222, 219, 219).withOpacity(0.5),
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Select Meal Time:-   ",
                              style: AppStyles.titleStyle,
                            ),
                            GridView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      crossAxisSpacing: 8.0,
                                      mainAxisSpacing: 10.0,
                                      childAspectRatio: 3.5),
                              itemCount: foodOrdersTime.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {},
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: AppColors.secondaryColor),
                                      borderRadius: BorderRadius.circular(10),
                                      color: const Color.fromARGB(
                                          255, 247, 245, 245),
                                    ),
                                    child: Center(
                                      child: Text(
                                        foodOrdersTime[index].mealTime,
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            color: Color.fromARGB(
                                                255, 84, 82, 82)),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Product description
                    SizedBox(
                      height: 1.h,
                    ),
                    Divider(
                      height: 0.4.h,
                      thickness: 0.4.h,
                      color:
                          Color.fromARGB(255, 222, 219, 219).withOpacity(0.5),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Quantity:',
                            style:
                                TextStyle(fontSize: 18, color: Colors.black87),
                          ),
                          SizedBox(width: 16),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(0.0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 8,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: IconButton(
                                  icon: Icon(Icons.remove, color: Colors.teal),
                                  onPressed: () {
                                    // Decrement quantity logic
                                    setState(() {
                                      if (quantity > 1) {
                                        quantity--;
                                      }
                                    });
                                  },
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(12.0),
                                child: Text(
                                  '$quantity',
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.black87),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(0.0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 8,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: IconButton(
                                  icon: Icon(Icons.add, color: Colors.teal),
                                  onPressed: () {
                                    // Increment quantity logic
                                    setState(() {
                                      quantity++;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 1.h),

                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.backgroundColor,
                        borderRadius: BorderRadius.circular(
                            10.0), // Adjust the value for the desired curve
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromARGB(255, 189, 187, 187)
                                .withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: Offset(0,
                                2), // Adjust the values to control the shadow appearance
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Final Order Details',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                children: [
                                  topicRow('Order For ', 'date'),
                                  topicRow('Subtotal',
                                      "Rs. ${widget.product.price.toInt()}"),
                                  topicRow('Grand Total',
                                      'Rs. ${widget.product.price.toInt()}'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(
                      height: 2.h,
                    ),
                  ],
                ),
              ),
            ),
          ),

          Positioned(
              top: 40.h,
              width: 40.2,
              child: Obx(() => addOrderControllre.isLoading.value
                  ? LoadingWidget()
                  : SizedBox.shrink()))
        ],
      ),
      bottomNavigationBar: Container(
        height: 12.h,
        color: Color.fromARGB(255, 243, 243, 243),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 90.w,
                height: 6.h,
                child: ElevatedButton(
                  onPressed: () {
                 
                    addOrderControllre.addDummyOrder(context);

                    // if (walletController.totalbalances.value <=
                    //     widget.product.price.toInt()) {
                    //   showDialog(
                    //     context: context,
                    //     builder: (BuildContext context) {
                    //       return InfoDialog();
                    //     },
                    //   );
                    // } else if (loignController
                    //             .studentDataResponse.value!.classes !=
                    //         '' ||
                    //     loignController
                    //             .studentDataResponse.value!.profilePicture !=
                    //         '') {
                    //   showUpdateProfileDialog(Get.context!);
                    // } else if (loignController
                    //         .studentDataResponse.value!.groupid ==
                    //     '') {
                    //   showDialog(
                    //     context: context,
                    //     builder: (BuildContext context) {
                    //       return NoGroup(
                    //         heading: 'You are not in any group',
                    //         subheading: "Make a group or join a group",
                    //       );
                    //     },
                    //   );
                    // } else {
                    //   showDialog(
                    //     context: context,
                    //     builder: (BuildContext context) {
                    //       return ConfirmationDialog();
                    //     },
                    //   );
                    // }

                    // Add to cart logic
                  },
                  child: Text(
                    'Order Now',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.teal,
                    textStyle: TextStyle(fontSize: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
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

  Widget topicRow(String topic, String subtopic) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.6.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            topic,
            style: AppStyles.listTileTitle,
          ),
          SizedBox(width: 8), //  Add spacing between topic and subtopic
          Text(subtopic, style: AppStyles.listTileTitle),
        ],
      ),
    );
  }
}
