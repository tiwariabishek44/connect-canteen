import 'package:cached_network_image/cached_network_image.dart';
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
import 'package:shimmer/shimmer.dart';

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
            child: Container(
              width: double.infinity,
              height: 260,
              child: CachedNetworkImage(
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    Opacity(
                  opacity: 0.8,
                  child: Shimmer.fromColors(
                    baseColor: const Color.fromARGB(255, 248, 246, 246),
                    highlightColor: Color.fromARGB(255, 238, 230, 230),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 140, 115, 115),
                      ),
                      width: double.infinity,
                      height: 260,
                    ),
                  ),
                ),
                imageUrl: widget.product.imageUrl ?? '',
                imageBuilder: (context, imageProvider) => Container(
                  width: double.infinity,
                  height: 260,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(-20),
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                fit: BoxFit.fill,
                width: double.infinity,
                errorWidget: (context, url, error) => CircleAvatar(
                  radius: 21.4.sp,
                  child: Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                  backgroundColor: const Color.fromARGB(255, 224, 218, 218),
                ),
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
            top: 240, // Adjust as necessary to overlap the image slightly
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
                                color: const Color.fromARGB(
                                    255, 0, 0, 0), // Changed color to green
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
                        Text(
                          "Rs.200",
                          style: TextStyle(
                              fontSize: 19.sp, fontWeight: FontWeight.w400),
                        )
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


                            Container(
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color.fromARGB(255, 237, 240, 240),
                                    Color.fromARGB(255, 223, 224, 223)
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
                              ), // Set the background color of the card
                              child: Column(
                                children: [
                                  loignController.studentDataResponse.value!
                                              .groupcod ==
                                          ""
                                      ? Row(
                                          children: [
                                            Icon(
                                              Icons
                                                  .group, // You can choose any icon that fits your needs
                                              color: Colors
                                                  .black, // Change the color if needed
                                              size:
                                                  24.0, // Change the size if needed
                                            ),
                                            SizedBox(
                                                width:
                                                    8.0), // Add some spacing between the icon and the text
                                            Text(
                                              "Sorry, you are not in any group.",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 19.sp,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        )
                                      : Text(
                                          'Your order is under group ${loignController.studentDataResponse.value!.groupcod}',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 19.sp,
                                            color: Colors.black,
                                          ),
                                          maxLines: 2,
                                        ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 2.h,
                            ),
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
                                        color:
                                            Color.fromARGB(255, 166, 167, 167),
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                      color: Color.fromARGB(255, 255, 255, 255),
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
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(width: 2.w),
              Expanded(
                flex: 3,
                child: Row(
                  children: [
                    Container(
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
                        style: TextStyle(fontSize: 18, color: Colors.black87),
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
              ),
              Expanded(
                flex: 4,
                child: SizedBox(
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
                        borderRadius: BorderRadius.circular(30),
                      ),
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
