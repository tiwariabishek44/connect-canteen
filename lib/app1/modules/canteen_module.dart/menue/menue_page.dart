import 'package:connect_canteen/app/config/style.dart';
import 'package:connect_canteen/app/modules/student_modules/home/product_controller.dart';
import 'package:connect_canteen/app1/model/product_model.dart';
import 'package:connect_canteen/app1/modules/canteen_module.dart/menue/menue_controller.dart';
import 'package:connect_canteen/app1/modules/canteen_module.dart/menue/utils/menue_shrimmer.dart';
import 'package:connect_canteen/app1/modules/canteen_module.dart/menue_edit/menue_edit.dart';
import 'package:connect_canteen/app1/modules/canteen_module.dart/menue_edit/menue_edit_controller.dart';
import 'package:connect_canteen/app1/modules/student_modules/group/utils/listtile_shrimmer.dart';
import 'package:connect_canteen/app1/widget/product_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CanteenMenuePage extends StatelessWidget {
  CanteenMenuePage({super.key});
  final menueController = Get.put(MenueContorller());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        titleSpacing: 4.0.w, // Adjusts the spacing above the title
        title: Text(
          'Menue',
          style: TextStyle(fontWeight: FontWeight.w300),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 4.0.w),
              child: Text(
                'Manage Your Menue ',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.sp),
              ),
            ),
          ),
        ),
      ),
      body: StreamBuilder<List<ProductResponseModel>>(
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

            return Padding(
              padding: AppPadding.screenHorizontalPadding,
              child: SingleChildScrollView(
                child: Column(
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
                        childAspectRatio:
                            0.7, // Aspect ratio of grid items (width/height)
                      ),
                      itemCount: menueProducts.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Get.to(
                                () => MenueEditPage(
                                      productId: menueProducts[index].productId,
                                    ),
                                transition: Transition.cupertinoDialog);
                          },
                          child: ProductCard(
                            userType: 'canteen',
                            active: menueProducts[index].active,
                            type: menueProducts[index].type,
                            name: menueProducts[index].name,
                            imageUrl: menueProducts[index].proudctImage,
                            price: menueProducts[index].price,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
