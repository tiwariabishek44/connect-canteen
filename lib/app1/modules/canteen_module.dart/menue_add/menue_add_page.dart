import 'package:connect_canteen/app/widget/custom_loging_widget.dart';
import 'package:connect_canteen/app1/cons/colors.dart';
import 'package:connect_canteen/app1/model/category_model.dart';
import 'package:connect_canteen/app1/modules/canteen_module.dart/menue_add/menue_add_controller.dart';
import 'package:connect_canteen/app1/modules/student_modules/homepage/utils/category.dart';
import 'package:connect_canteen/app1/widget/black_textform_field.dart';
import 'package:connect_canteen/app1/widget/custom_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';

class MenueAddPage extends StatelessWidget {
  MenueAddPage({super.key});
  final menueAddController = Get.put(MenueAddController());
  final categoryController = Get.put(CategoryController());

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: AppColors.backgroundColor,
          appBar: AppBar(
            scrolledUnderElevation: 0,
            backgroundColor: AppColors.backgroundColor,
            titleSpacing: 4.0, // Adjusts the spacing above the title
            title: Text(
              'Menue ',
              style: TextStyle(fontWeight: FontWeight.w300),
            ),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(50.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 4.0.w),
                  child: Text(
                    'Add New Item',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 24.sp),
                  ),
                ),
              ),
            ),
          ),
          body: Form(
            key: menueAddController.formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // divider and the text in middle( Choolse the categoy)
                  SizedBox(
                    height: 2.h,
                  ),
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
                        "Choose the category",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w300,
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
                                        onTap: () {
                                          menueAddController.category.value =
                                              menueProducts[index].name!;
                                        },
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

                  // divider and the text in middle( Add New Item)
                  SizedBox(
                    height: 2.h,
                  ),
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
                        "Add New Item",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w300,
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
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Row(
                      children: [
                        Text(
                          "Category :-",
                          style: TextStyle(
                              fontSize: 19.sp,
                              color: Colors.black,
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Obx(() => Text(
                              menueAddController.category.value,
                              style: TextStyle(
                                  fontSize: 19.sp,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600),
                            ))
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: BlackTextFormField(
                      prefixIcon: const Icon(Icons.person),
                      textInputType: TextInputType.text,
                      hintText: 'Product Name',
                      controller: menueAddController.productNameController,
                      validatorFunction: (value) {
                        if (value.isEmpty) {
                          return '  Name Can\'t be empty';
                        }
                        return null;
                      },
                      actionKeyboard: TextInputAction.next,
                      onSubmitField: () {},
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: BlackTextFormField(
                      prefixIcon: const Icon(Icons.person),
                      textInputType: TextInputType.number,
                      hintText: 'Price',
                      controller: menueAddController.priceController,
                      validatorFunction: (value) {
                        if (value.isEmpty) {
                          return 'Price can\'t be empty';
                        }
                        // Add additional validation logic for price here
                        return null;
                      },
                      actionKeyboard: TextInputAction.next,
                      onSubmitField: () {},
                    ),
                  ),
                  CustomButton(
                      text: 'Submint',
                      onPressed: () {
                        FocusScope.of(context).unfocus();

                        menueAddController.doAdd();
                      },
                      isLoading: false),

                  SizedBox(
                    height: 3.h,
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
            top: 30.h,
            left: 50.w,
            child: Obx(() => menueAddController.loading.value
                ? LoadingWidget()
                : SizedBox.shrink()))
      ],
    );
  }
}
