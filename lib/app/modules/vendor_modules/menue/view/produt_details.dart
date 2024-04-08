import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:get/get.dart';

import 'package:connect_canteen/app/config/colors.dart';
import 'package:connect_canteen/app/config/style.dart';

import 'package:connect_canteen/app/models/product_model.dart';

import 'package:connect_canteen/app/modules/vendor_modules/menue/price_update_controller.dart';

import 'package:connect_canteen/app/widget/customized_button.dart';

import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';

class CanteenProductEditPage extends StatefulWidget {
  final Product product;

  CanteenProductEditPage({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  State<CanteenProductEditPage> createState() => _CanteenProductEditPageState();
}

class _CanteenProductEditPageState extends State<CanteenProductEditPage> {
  final priceController = Get.put(PriceUpdateController());

  @override
  Widget build(BuildContext context) {
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
                  height: 30.h,
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
                                    child: Container()),
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

                // Display product name

                Padding(
                  padding: AppPadding.screenHorizontalPadding,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Display product name
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: AppPadding.screenHorizontalPadding,
                              child: Text(
                                widget.product.name,
                                style: AppStyles.appbar,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: widget.product.active
                                    ? Colors.green
                                    : Colors.red,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(
                                widget.product.active
                                    ? 'Product is LIVE'
                                    : "Product is OFF",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          ],
                        ),

                        // Display product price
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            "Rs. " +
                                widget.product.price
                                    .toString(), // Replace with actual price
                            style: AppStyles.listTileTitle,
                          ),
                        ),

                        Row(
                          children: [
                            Text(
                              'Update the product state',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            Switch(
                              value: widget.product
                                  .active, // Example value for the switch
                              onChanged: (value) {
                                priceController.stateUpdate(
                                    context,
                                    widget.product.name,
                                    !widget.product.active);
                                // Add your logic here
                              },
                            ),
                          ],
                        ),
                        Form(
                          key: priceController.priceFormKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(height: 10),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: TextFormField(
                                  validator: priceController.priceValidator,
                                  controller: priceController.price,
                                  decoration: InputDecoration(
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        Icons.money,
                                        color: AppColors.secondaryColor,
                                        size: 30,
                                      ),
                                      onPressed: () {},
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: AppColors.secondaryColor,
                                            width: 1),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: AppColors.secondaryColor,
                                            width: 1),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    fillColor:
                                        Color.fromARGB(255, 255, 255, 255),
                                    filled: true,
                                    labelText: 'Enter the latest Price',
                                    labelStyle: TextStyle(
                                        color: AppColors.secondaryColor),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ),
                              CustomButton(
                                  text: 'Update Price',
                                  onPressed: () {
                                    FocusScope.of(context).unfocus();
                                    priceController.priceSubmit(
                                        context, widget.product.name);
                                  },
                                  isLoading: false)
                            ],
                          ),
                        ),
                      ]),
                ),
              ],
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
                    color: AppColors.greyColor,
                  ),
                  child: Icon(
                    Icons.chevron_left,
                    size: 25.sp,
                  ),
                ),
              )),
          Obx(
            () => priceController.isloading.value
                ? Positioned(
                    top: 40.h,
                    left: 35.w,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.orange,

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
        ],
      ),
    );
  }
}
