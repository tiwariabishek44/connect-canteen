import 'package:get/get.dart';
import 'package:connect_canteen/app/config/colors.dart';
import 'package:connect_canteen/app/models/product_model.dart';
import 'package:connect_canteen/app/modules/student_modules/orders/orders_controller.dart';
import 'package:connect_canteen/app/modules/vendor_modules/menue/price_update_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class PriceUpdatePage extends StatelessWidget {
  final Product product;

  PriceUpdatePage({
    super.key,
    required this.product,
  });

  final priceController = Get.put(PriceUpdateController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          child: Column(
            children: [
              Expanded(
                flex: 7,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 1,
                            height: MediaQuery.of(context).size.height * 0.3,
                            child: CachedNetworkImage(
                              imageUrl: product.image ??
                                  '', // Use a default empty string if URL is null
                              fit: BoxFit.cover,
                              errorWidget: (context, url, error) => Icon(
                                  Icons.error_outline,
                                  size: 40), // Placeholder icon for error
                            ),
                          ),

                          // Add detailed description
                          // ... other product details and add to cart button
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.all(18.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name, // Replace with actual product name
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),

                            Text(
                              "Rs.${product.price}",
                              style: TextStyle(
                                  color: Colors.red.shade200,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold),
                            ), // Replace with actual price
                            SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      )
                    ],
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
