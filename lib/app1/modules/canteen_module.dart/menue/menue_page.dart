import 'package:connect_canteen/app/config/style.dart';
import 'package:connect_canteen/app/widget/custom_loging_widget.dart';
import 'package:connect_canteen/app1/cons/colors.dart';
import 'package:connect_canteen/app1/model/category_model.dart';
import 'package:connect_canteen/app1/model/product_model.dart';
import 'package:connect_canteen/app1/modules/canteen_module.dart/menue/menue_controller.dart';
import 'package:connect_canteen/app1/modules/canteen_module.dart/menue/utils/menue_shrimmer.dart';
import 'package:connect_canteen/app1/modules/canteen_module.dart/menue_add/menue_add_controller.dart';
import 'package:connect_canteen/app1/modules/canteen_module.dart/menue_add/menue_add_page.dart';
import 'package:connect_canteen/app1/modules/student_modules/homepage/utils/category.dart';
import 'package:connect_canteen/app1/widget/product_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';

class CanteenMenuePage extends StatelessWidget {
  CanteenMenuePage({super.key});
  final menueController = Get.put(MenueContorller());
  final menueADdController = Get.put(MenueAddController());
  final categoryController = Get.put(CategoryController());

  void delete(BuildContext context, String name, String proudctId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 0,
          backgroundColor: AppColors.backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(12.0), // Adjust border radius as needed
          ),
          title: Text(
            'Remove  $name',
            style: TextStyle(
              fontSize: 17.5.sp,
              color: Color.fromARGB(221, 37, 36, 36),
              fontWeight: FontWeight.w700,
            ),
          ),
          content: Text(
            'Product Will not able for order.',
            style: TextStyle(
              color: const Color.fromARGB(221, 72, 71, 71),
              fontSize: 16.0.sp,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Close the dialog

                Get.back();
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                    color: Colors.purple),
              ),
            ),
            GestureDetector(
              onTap: () async {
                Get.back();

                menueADdController.itemDelete(proudctId);
              },
              child: Container(
                padding: EdgeInsets.all(12.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Remove",
                      style: TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontWeight: FontWeight.bold,
                        fontSize: 17.sp,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: AppColors.backgroundColor,
          appBar: AppBar(
            scrolledUnderElevation: 0,
            backgroundColor: AppColors.backgroundColor,
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
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 24.sp),
                  ),
                ),
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: AppPadding.screenHorizontalPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 2.h,
                  ),
                  //divider
                  Row(
                    children: [
                      Expanded(
                        child: Divider(
                          color: const Color.fromARGB(255, 211, 210, 210),
                          thickness: 1,
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        "Category ",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w300,
                          color: Color.fromARGB(255, 80, 79, 79),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Divider(
                          color: const Color.fromARGB(255, 211, 210, 210),
                          thickness: 1,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Container(
                    height:
                        250, // Adjust the height according to your requirement
                    child: StreamBuilder<List<CategoryModel>>(
                      stream: categoryController
                          .getAllMenue("texasinternationalcollege"),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          //shrimmer
                          return GridView.builder(
                            scrollDirection: Axis.horizontal,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 8.0,
                              crossAxisSpacing: 10.0,
                              childAspectRatio: 1.0,
                            ),
                            itemCount: 4, // Number of shimmer items
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Shimmer.fromColors(
                                        baseColor: Colors.grey[300]!,
                                        highlightColor: Colors.grey[100]!,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.grey,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text('Error: ${snapshot.error}'),
                          );
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return Center(
                            child: Text(
                                'No data available'), // Handle case where data is empty
                          );
                        } else {
                          final menueProducts = snapshot.data!;

                          return GridView.builder(
                            scrollDirection: Axis.horizontal,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 8.0,
                              crossAxisSpacing: 10.0,
                              childAspectRatio: 1.0,
                            ),
                            itemCount: menueProducts
                                .length, // Number of items in the grid
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: GestureDetector(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.transparent,
                                            image: DecorationImage(
                                              image: NetworkImage(
                                                  menueProducts[index].image!),
                                              fit: BoxFit.cover,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Center(
                                      child: Text(
                                        menueProducts[index].name!,
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Text("Products",
                      style: TextStyle(
                          fontSize: 22.sp, fontWeight: FontWeight.bold)),

                  SizedBox(
                    height: 10,
                  ),

                  StreamBuilder<List<ProductResponseModel>>(
                    stream: menueController
                        .getAllMenue("texasinternationalcollege"),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return MenueShrimmer();
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text('Error: ${snapshot.error}'),
                        );
                      } else if (snapshot.data!.isEmpty) {
                        //return a page with th product no icon and the text no product avilable
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.shopping_bag_outlined,
                                size: 50.sp,
                                color: Colors.grey,
                              ),
                              Text(
                                'No Product Available',
                                style: TextStyle(
                                  fontSize: 20.sp,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        );
                      } else {
                        final menueProducts = snapshot.data!;

                        return Padding(
                          padding: AppPadding.screenHorizontalPadding,
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 12.0.h),
                            child: GridView.builder(
                              shrinkWrap: true,
                              physics: ScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount:
                                    2, // Number of columns in the grid
                                crossAxisSpacing:
                                    20.0, // Spacing between columns
                                mainAxisSpacing: 20.sp, // Spacing between rows
                                childAspectRatio:
                                    0.7, // Aspect ratio of grid items (width/height)
                              ),
                              itemCount: menueProducts.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onLongPress: () {
                                    delete(context, menueProducts[index].name,
                                        menueProducts[index].productId);
                                  },
                                  child: ProductCard(
                                    productId: menueProducts[index].productId,
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
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Get.to(() => MenueAddPage());
              // Define the action to be performed when the FAB is pressed
            },
            child: Icon(Icons.add),
            backgroundColor:
                Colors.blue, // You can customize the color as needed
          ),
        ),
        Positioned(
            top: 30.h,
            left: 50.w,
            child: Obx(() => menueADdController.loading.value
                ? LoadingWidget()
                : SizedBox.shrink()))
      ],
    );
  }
}
