import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:connect_canteen/app1/model/cart_modeld.dart';
import 'package:connect_canteen/app1/modules/canteen_module.dart/menue_edit/menue_edit.dart';
import 'package:connect_canteen/app1/modules/student_modules/cart/cart_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';

class ProductCard extends StatelessWidget {
  final String name;
  final String imageUrl;
  final double price;
  final String productId;

  final String type;
  final String userType; // New field userType
  final bool active;

  ProductCard(
      {required this.productId,
      this.userType = 'student', // Default value is 'student'

      required this.name,
      required this.imageUrl,
      required this.price,
      required this.type,
      required this.active});

  final cartController = Get.put(CartController());

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Image Section
        Stack(
          children: [
            GestureDetector(
              onTap: () {
                if (userType == 'student') {
                  cartController.addItem(
                      CartItem(
                          id: productId, name: name, quantity: 1, price: price),
                      context);
                } else {
                  Get.to(
                      () => MenueEditPage(
                            productId: productId,
                          ),
                      transition: Transition.cupertinoDialog);
                }
              },
              child: AspectRatio(
                aspectRatio: 1,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: CachedNetworkImage(
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) => Opacity(
                      opacity: 0.8,
                      child: Shimmer.fromColors(
                        baseColor: Colors.black12,
                        highlightColor: Colors.red,
                        child: Container(),
                      ),
                    ),
                    imageUrl: imageUrl == ''
                        ? 'https://b.zmtcdn.com/data/pictures/chains/3/19056943/06029b048ef65a9180d3ab70f50c3f19.jpg?fit=around|960:500&crop=960:500;*,*'
                        : imageUrl,
                    fit: BoxFit.fill,
                    width: double.infinity,
                    errorWidget: (context, url, error) =>
                        Icon(Icons.error_outline, size: 40),
                  ),
                ),
              ),
            ),
            Positioned(
                right: 2.w,
                bottom: 0.3.h,
                child: userType == 'student'
                    ? GestureDetector(
                        onTap: () {
                          Timer(Duration(milliseconds: 100), () {
                            cartController.addItem(
                                CartItem(
                                    id: productId,
                                    name: name,
                                    quantity: 1,
                                    price: price),
                                context);
                          });
                        },
                        child: CircleAvatar(
                          radius: 17,
                          backgroundColor: Color.fromARGB(255, 38, 121, 41),
                          child: Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                        ),
                      )
                    : CircleAvatar(
                        radius: 17,
                        backgroundColor: active == true
                            ? Color.fromARGB(255, 38, 121, 41)
                            : Colors.red,
                      )),
          ],
        ),
        SizedBox(height: 8.0),
        // Product Name
        Text(
          name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Color.fromARGB(255, 74, 74, 74),
            fontSize: 17.0.sp,
            fontWeight: FontWeight.w300,
          ),
        ),

        // Price and Add to Cart Button Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Price
            Text(
              '\Rs.$price',
              style: TextStyle(
                  fontSize: 16.0.sp,
                  fontWeight: FontWeight.w500,
                  color: Color.fromARGB(255, 0, 0, 0)),
            ),
          ],
        ),
      ],
    );
  }
}
