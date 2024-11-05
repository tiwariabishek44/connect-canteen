import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';

class ProductCard extends StatelessWidget {
  final String name;
  final String imageUrl;
  final double price;

  final String type;
  final String userType; // New field userType
  final bool active;

  ProductCard(
      {this.userType = 'student', // Default value is 'student'

      required this.name,
      required this.imageUrl,
      required this.price,
      required this.type,
      required this.active});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Image Section
        Stack(
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: CachedNetworkImage(
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      Opacity(
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
            Positioned(
                right: 2.w,
                bottom: 0.3.h,
                child: userType == 'student'
                    ? CircleAvatar(
                        radius: 17,
                        backgroundColor: Color.fromARGB(255, 38, 121, 41),
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
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
            // Add to Cart Button
            Row(
              children: [
                Container(
                  width: 19.0,
                  height: 19.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: type == 'VEG' ? Colors.green : Colors.red,
                        width: 2.0),
                    color: Colors.white,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.circle, // Use an appropriate icon
                      color: type == 'VEG' ? Colors.green : Colors.red,
                      size: 9.0,
                    ),
                  ),
                ),
                SizedBox(
                  width: 1.w,
                ),
                Text(
                  type == 'VEG' ? "Veg" : 'Non-veg',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15.sp,
                    color: type == 'VEG' ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
