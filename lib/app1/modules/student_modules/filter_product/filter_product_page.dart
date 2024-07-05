import 'package:connect_canteen/app1/cons/colors.dart';
import 'package:connect_canteen/app1/cons/style.dart';
import 'package:connect_canteen/app1/model/product_model.dart';
import 'package:connect_canteen/app1/modules/canteen_module.dart/menue/utils/menue_shrimmer.dart';
import 'package:connect_canteen/app1/modules/student_modules/filter_product/product_filter_controller.dart';
import 'package:connect_canteen/app1/widget/product_card.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class FilterProductPage extends StatelessWidget {
  final String title;
  FilterProductPage({super.key, required this.title});
  final productFilterController = Get.put(ProductFilterController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        // back icons as ios icon
        leading: kIsWeb
            ? null
            : IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: () {
                  Get.back();
                },
              ),
        backgroundColor: AppColors.backgroundColor,
        title: Text(title),
      ),
      body: Padding(
        padding: AppPadding.screenHorizontalPadding,
        child: StreamBuilder<List<ProductResponseModel>>(
          stream: productFilterController.getAllMenue(
              "texasinternationalcollege", title),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return MenueShrimmer();
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Text(
                    'No data available'), // Handle case where data is empty
              );
            } else {
              final menueProducts = snapshot.data!;

              return GridView.builder(
                physics: ScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Number of columns in the grid
                  crossAxisSpacing: 20.0, // Spacing between columns
                  mainAxisSpacing: 5.sp, // Spacing between rows
                  childAspectRatio:
                      0.7, // Aspect ratio of grid items (width/height)
                ),
                itemCount: menueProducts.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    child: ProductCard(
                      productId: menueProducts[index].productId,
                      active: true,
                      type: menueProducts[index].type,
                      name: menueProducts[index].name,
                      imageUrl: menueProducts[index].proudctImage,
                      price: menueProducts[index].price,
                    ),
                  );
                  ;
                },
              );
            }
          },
        ),
      ),
    );
  }
}
