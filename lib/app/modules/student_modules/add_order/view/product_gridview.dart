import 'package:connect_canteen/app/config/colors.dart';
import 'package:connect_canteen/app/config/style.dart';
import 'package:connect_canteen/app/modules/common/login/login_controller.dart';
import 'package:connect_canteen/app/modules/student_modules/add_order/add_product_controller.dart';
import 'package:connect_canteen/app/modules/student_modules/home/product_controller.dart';
import 'package:connect_canteen/app/modules/student_modules/group/group_controller.dart';
import 'package:connect_canteen/app/widget/custom_loging_widget.dart';
import 'package:connect_canteen/app/widget/loading_screen.dart';
import 'package:connect_canteen/app/widget/no_data_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connect_canteen/app/modules/student_modules/home/view/product_details_view.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';

class ProductGrid extends StatelessWidget {
  final String dat;
  ProductGrid({Key? key, required this.dat}) : super(key: key);

  final logincontroller = Get.put(LoginController());
  final productContorller = Get.put(ProductController());
  final groupcontroller = Get.put(GroupController());
  final addproductController = Get.put(AddOrderController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (productContorller.isLoading.value) {
        return LoadingWidget();
      } else {
        return productContorller.productLoaded.value == false
            ? const NoDataWidget(
                message: "There is no items", iconData: Icons.error_outline)
            : Padding(
                padding: EdgeInsets.only(bottom: 5.0.h),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // number of items in each row
                      mainAxisSpacing: 15.0, // spacing between rows
                      crossAxisSpacing: 20.0, // spacing between columns
                      childAspectRatio: 0.72),
                  itemCount: productContorller.allProductResponse.value
                      .response!.length, // total number of items
                  itemBuilder: (context, index) {
                    final product = productContorller
                        .allProductResponse.value.response![index];
                    if (product.active == true) {
                      // Added condition to check if product is active
                      return GestureDetector(
                        onTap: () async {
                          addproductController.checkTimeAndSetVisibility();
                          groupcontroller.fetchGroupData();
                          Get.to(
                              () => ProductDetailsPage(
                                    dat: dat,
                                    product: product,
                                    user: logincontroller
                                        .userDataResponse.value.response!.first,
                                  ),
                              transition: Transition.rightToLeft,
                              duration: duration);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8.0),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 1,
                                    blurRadius: 3,
                                    offset: const Offset(2, 2))
                              ]),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AspectRatio(
                                aspectRatio: 1.11,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: CachedNetworkImage(
                                    progressIndicatorBuilder:
                                        (context, url, downloadProgress) =>
                                            Opacity(
                                      opacity: 0.8,
                                      child: Shimmer.fromColors(
                                        baseColor: Colors.black12,
                                        highlightColor: Colors.red,
                                        child: Container(),
                                      ),
                                    ),
                                    imageUrl: product.image ?? '',
                                    fit: BoxFit.fill,
                                    width: double.infinity,
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error_outline, size: 40),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${product.name}",
                                      style: AppStyles.listTilesubTitle,
                                    ),
                                    Text(
                                      "Rs ${product.price.toInt()}/plate",
                                      style: AppStyles.listTilesubTitle,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    } else {
                      return SizedBox(); // If the product is not active, return an empty SizedBox
                    }
                  },
                ),
              );
      }
    });
  }
}
