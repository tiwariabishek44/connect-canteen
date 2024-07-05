import 'package:connect_canteen/app1/cons/style.dart';
import 'package:connect_canteen/app1/model/product_model.dart';
import 'package:connect_canteen/app1/modules/canteen_module.dart/menue/menue_controller.dart';
import 'package:connect_canteen/app1/modules/canteen_module.dart/menue/utils/menue_shrimmer.dart';
import 'package:connect_canteen/app1/modules/student_modules/product_detail/product_detail.dart';
import 'package:connect_canteen/app1/widget/product_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class MenueSection extends StatelessWidget {
  MenueSection({super.key});
  final menueController = Get.put(MenueContorller());

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ProductResponseModel>>(
      stream: menueController.getAllMenue("texasinternationalcollege"),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MenueShrimmer();
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else {
          final menueProducts = snapshot.data!;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 2.h,
                ),
                GridView.builder(
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Number of columns in the grid
                    crossAxisSpacing: 20.0, // Spacing between columns
                    mainAxisSpacing: 10.sp, // Spacing between rows
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
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
