import 'dart:ffi';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:connect_canteen/app1/cons/colors.dart';
import 'package:connect_canteen/app1/cons/style.dart';
import 'package:connect_canteen/app1/model/product_model.dart';
import 'package:connect_canteen/app1/modules/student_modules/homepage/detail_poduct_shortcurt.dart';
import 'package:connect_canteen/app1/modules/student_modules/product_detail/product_detail.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';

class ProductCard extends StatelessWidget {
  final String name;
  final String imageUrl;
  final double price;
  final VoidCallback? onAddToCart;

  ProductCard({
    required this.name,
    required this.imageUrl,
    required this.price,
    this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => ProductDetailPage(
              product: Product(imageUrl: imageUrl, name: name, price: price),
            ));
      },
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                      color:
                          Color.fromARGB(255, 228, 224, 224).withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: const Offset(0.1, 0.1))
                ]),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image Section
                AspectRatio(
                  aspectRatio: 1.2,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
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
                      imageUrl: imageUrl ?? '',
                      fit: BoxFit.fill,
                      width: double.infinity,
                      errorWidget: (context, url, error) =>
                          Icon(Icons.error_outline, size: 40),
                    ),
                  ),
                ),
                SizedBox(height: 8.0),
                // Product Name
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Color.fromARGB(255, 74, 74, 74),
                      fontSize: 18.0.sp,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4.0),
                // Price and Add to Cart Button Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Price
                    Text(
                      '\Rs.$price',
                      style: TextStyle(
                          fontSize: 17.0.sp,
                          color: const Color.fromARGB(255, 94, 92, 92)),
                    ),
                    // Add to Cart Button
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
