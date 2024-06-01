import 'package:connect_canteen/app1/model/product_model.dart';
import 'package:connect_canteen/app1/modules/student_modules/homepage/homepage.dart';
import 'package:connect_canteen/app1/modules/student_modules/product_detail/product_detail.dart';
import 'package:connect_canteen/app1/widget/product_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class MenueSection extends StatelessWidget {
  final List<Products> products;

  MenueSection({required this.products});

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
            return GestureDetector(
              onTap: () {
                Get.to(() => ProductDetailPage(
                      product: Products(
                          type: products[index].type,
                          imageUrl: products[index].imageUrl,
                          name: products[index].name,
                          price: products[index].price),
                    ));
              },
              child: ProductCard(
                active: true,
                type: products[index].type,
                name: products[index].name,
                imageUrl: products[index].imageUrl,
                price: products[index].price,
              ),
            );
          },
        ),
      ],
    );
  }
}
