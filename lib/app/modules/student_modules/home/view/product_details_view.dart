import 'package:cached_network_image/cached_network_image.dart';
import 'package:connect_canteen/app/models/food_order_time_model.dart';
import 'package:connect_canteen/app/widget/custom_loging_widget.dart';
import 'package:connect_canteen/app/widget/customized_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:connect_canteen/app/config/colors.dart';
import 'package:connect_canteen/app/config/style.dart';
import 'package:connect_canteen/app/eSewa/esewa_function.dart';
import 'package:connect_canteen/app/models/product_model.dart';
import 'package:connect_canteen/app/models/users_model.dart';
import 'package:connect_canteen/app/modules/common/login/login_controller.dart';
import 'package:connect_canteen/app/modules/student_modules/add_order/add_product_controller.dart';
import 'package:connect_canteen/app/modules/student_modules/group/group_controller.dart';
import 'package:connect_canteen/app/widget/confirmation_dialog.dart';
import 'package:connect_canteen/app/widget/loading_screen.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';

class ProductDetailsPage extends StatefulWidget {
  final Product product;
  final UserDataResponse user;
  final String dat;

  ProductDetailsPage({
    Key? key,
    required this.dat,
    required this.product,
    required this.user,
  }) : super(key: key);

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  final groupcontroller = Get.put(GroupController());
  final logincontroller = Get.put(LoginController());

  final addproductController = Get.put(AddOrderController());

  late final Esewa esewa;
  final List<FoodOrderTime> foodOrdersTime = [
    FoodOrderTime(mealTime: "09:00", orderHoldTime: "8:00"),
    FoodOrderTime(mealTime: "10:30", orderHoldTime: "9:30"),
    FoodOrderTime(mealTime: "11:00", orderHoldTime: "10:00"),
  ];

  // Add this variable
  int selectedIndex = -1;

  @override
  void initState() {
    super.initState();
    esewa = Esewa(addproductController);
  }

  void showNoSelectionMessage() {
    Get.snackbar(
      'No Time Slot Selected',
      'Please select a time slot',
      backgroundColor: Color.fromARGB(
          255, 229, 226, 226), // Set your desired background color here
      colorText: Color.fromARGB(255, 6, 6, 6), // Set the text color
    );
  }

  @override
  Widget build(BuildContext context) {
    addproductController.checkTimeAndSetVisibility();
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Display product image
                Container(
                  height: 25.h,
                  child: CachedNetworkImage(
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) => Positioned(
                            bottom: 32.0,
                            left: 0.0,
                            right: 0.0,
                            child: Center(
                              child: Opacity(
                                opacity: 0.8,
                                child: Shimmer.fromColors(
                                  baseColor: Colors.black12,
                                  highlightColor: Colors.white,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Image.asset(
                                        'assets/logo.png',
                                        height: 20.0,
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 4.0),
                                      ),
                                      const Text(
                                        'Slide to unlock',
                                        style: TextStyle(
                                          fontSize: 28.0,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            )),
                    imageUrl: widget.product.image ?? '',
                    fit: BoxFit.fill,
                    width: double.infinity,
                    errorWidget: (context, url, error) =>
                        Icon(Icons.error_outline, size: 40),
                  ),
                ),
                SizedBox(height: 2.h),

                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  // Display product name
                  Padding(
                    padding: AppPadding.screenHorizontalPadding,
                    child: Text(
                      widget.product.name,
                      style: AppStyles.appbar,
                    ),
                  ),
                  SizedBox(height: 2),
                  // Display product price
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      "Rs. " +
                          widget.product.price
                              .toString(), // Replace with actual price
                      style: AppStyles.listTileTitle,
                    ),
                  )
                ]),

                Padding(
                  padding: AppPadding.screenHorizontalPadding,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      logincontroller.isGroupId.value
                          ? Obx(() {
                              if (groupcontroller.isloading.value) {
                                return LoadingWidget();
                              } else {
                                if (groupcontroller.fetchGroupedData.value ==
                                    false) {
                                  return Container();
                                } else {
                                  return Card(
                                    elevation:
                                        4, // Adjust the elevation for shadow intensity
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          20), // Adjust the border radius here
                                    ),
                                    child: Container(
                                      padding: EdgeInsets.all(16),
                                      color: Colors
                                          .white, // Set the background color of the card
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: 3.h,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Group Code : ',
                                                style: AppStyles.subtitleStyle,
                                              ),
                                              Text(
                                                groupcontroller
                                                    .groupResponse
                                                    .value
                                                    .response!
                                                    .first
                                                    .groupCode,
                                                style: AppStyles.titleStyle,
                                              )
                                            ],
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            'Your order is under group ${groupcontroller.groupResponse.value.response!.first.groupName}',
                                            style: AppStyles.listTilesubTitle,
                                            maxLines: 2,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }
                              }
                            })
                          : Container(),
                      SizedBox(
                        height: 1.h,
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      SizedBox(height: 2.h),
                      Obx(() => addproductController.isorderStart.value
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Select Meal Time:-  ${addproductController.mealtime.value}",
                                  style: AppStyles.titleStyle,
                                ),
                                Container(
                                  child: GridView.builder(
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
                                        onTap: () {
                                          addproductController.mealtime.value =
                                              foodOrdersTime[index].mealTime;
                                          addproductController
                                                  .orderHoldTime.value =
                                              foodOrdersTime[index]
                                                  .orderHoldTime
                                                  .toString();
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color:
                                                    AppColors.secondaryColor),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: addproductController
                                                        .mealtime.value ==
                                                    foodOrdersTime[index]
                                                        .mealTime
                                                ? Color.fromARGB(
                                                    255, 219, 211, 163)
                                                : const Color.fromARGB(
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
                                ),
                                SizedBox(height: 3.h),
                                topicRow('Order For ',
                                    addproductController.orderDate.value),
                                topicRow('Subtotal',
                                    "Rs. ${widget.product.price.toInt()}"),
                                topicRow('Platform Fee', 'Rs.1'),
                                topicRow('Grand Total',
                                    'Rs. ${widget.product.price.toInt() + 1}'),
                                SizedBox(
                                  height: 2.h,
                                ),
                                CustomButton(
                                  text: 'Order',
                                  onPressed: () {
                                    addproductController.mealtime.value.isEmpty
                                        ? showNoSelectionMessage()
                                        : logincontroller
                                                .userDataResponse
                                                .value
                                                .response!
                                                .first
                                                .groupid
                                                .isNotEmpty
                                            ?

                                            // addproductController.addItemToOrder(
                                            //     context,
                                            //     groupName: groupcontroller
                                            //         .groupResponse
                                            //         .value
                                            //         .response!
                                            //         .first
                                            //         .groupName,
                                            //     customerImage:
                                            //         widget.user.profilePicture,
                                            //     orderHoldTime:
                                            //         addproductController
                                            //             .orderHoldTime.value,
                                            //     mealtime: addproductController
                                            //         .mealtime.value,
                                            //     classs: widget.user.classes,
                                            //     date: addproductController
                                            //         .orderDate.value,
                                            //     checkout: 'false',
                                            //     customer: widget.user.name,
                                            //     groupcod: groupcontroller
                                            //         .groupResponse
                                            //         .value
                                            //         .response!
                                            //         .first
                                            //         .groupCode,
                                            //     groupid: widget.user.groupid,
                                            //     cid: widget.user.userid,
                                            //     productName:
                                            //         widget.product.name,
                                            //     price: widget.product.price + 1,
                                            //     quantity: 1,
                                            //     productImage:
                                            //         widget.product.image)

                                            esewa.pay(context,
                                                groupName: groupcontroller
                                                    .groupResponse
                                                    .value
                                                    .response!
                                                    .first
                                                    .groupName,
                                                customerImage:
                                                    widget.user.profilePicture,
                                                orderHoldTime:
                                                    addproductController
                                                        .orderHoldTime.value,
                                                mealtime: addproductController
                                                    .mealtime.value,
                                                classs: widget.user.classes,
                                                date: addproductController
                                                    .orderDate.value,
                                                checkout: 'false',
                                                customer: widget.user.name,
                                                groupcod: groupcontroller
                                                    .groupResponse
                                                    .value
                                                    .response!
                                                    .first
                                                    .groupCode,
                                                groupid: widget.user.groupid,
                                                cid: widget.user.userid,
                                                productName:
                                                    widget.product.name,
                                                price: widget.product.price + 1,
                                                quantity: 1,
                                                productImage:
                                                    widget.product.image)
                                            : showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return ConfirmationDialog(
                                                    isbutton: false,
                                                    heading:
                                                        'You are not in any group',
                                                    subheading:
                                                        "Make a group or join a group",
                                                    firstbutton:
                                                        "Create A group",
                                                    secondbutton: 'Cancle',
                                                    onConfirm: () {},
                                                  );
                                                },
                                              );
                                  },
                                  isLoading: false,
                                ),
                              ],
                            )
                          : Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Order Time is scheduled from 4 PM to 8 AM",
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                            )),
                    ],
                  ),
                )
              ],
            ),
          ),
          Obx(
            () => addproductController.isLoading.value
                ? Positioned(
                    top: 40.h,
                    left: 35.w,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xff06C167),

                        borderRadius: BorderRadius.circular(
                            20), // Adjust the border radius here
                      ),
                      height: 15.h,
                      width: 30.w,
                      child: SpinKitCircle(
                        color: Colors.white,
                        size: 30.sp,
                      ),
                    ),
                  )
                : SizedBox(),
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
                    color: AppColors.greyColor,
                  ),
                  child: Icon(
                    Icons.chevron_left,
                    size: 25.sp,
                  ),
                ),
              ))
        ],
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
            style: AppStyles.topicsHeading,
          ),
          SizedBox(width: 8), //  Add spacing between topic and subtopic
          Text(subtopic, style: AppStyles.listTilesubTitle1),
        ],
      ),
    );
  }
}
