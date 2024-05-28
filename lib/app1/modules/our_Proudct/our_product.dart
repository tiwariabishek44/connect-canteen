import 'package:connect_canteen/app1/model/product_model.dart';
import 'package:connect_canteen/app1/modules/student_modules/homepage/homepage.dart';
import 'package:connect_canteen/app1/widget/product_card.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class OurProductsSection extends StatelessWidget {
  final List<Product> products;

  OurProductsSection({required this.products});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 2.h,
        ),
        SizedBox(height: 1.h),
        GridView.builder(
          shrinkWrap: true,
          physics: ScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Number of columns in the grid
            crossAxisSpacing: 20.0, // Spacing between columns
            mainAxisSpacing: 20.sp, // Spacing between rows
            childAspectRatio: 0.7, // Aspect ratio of grid items (width/height)
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            return ProductCard(
              name: products[index].name,
              imageUrl: products[index].imageUrl,
              price: products[index].price,
            );
          },
        ),
      ],
    );
  }
}
