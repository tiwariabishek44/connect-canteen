import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:connect_canteen/app/config/colors.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connect_canteen/app/config/style.dart';
import 'package:connect_canteen/app/modules/student_modules/home/product_controller.dart';
import 'package:connect_canteen/app/modules/vendor_modules/menue/view/price_update.dart';
import 'package:connect_canteen/app/modules/vendor_modules/menue/view/produt_details.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

// Define the reusable product grid widget
class VendorProductGrid extends StatelessWidget {
  VendorProductGrid({
    Key? key,
  }) : super(key: key);

  // State to maintain quantities of each product
  final productContorller = Get.put(ProductController());

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // number of items in each row
          mainAxisSpacing: 20.0, // spacing between rows
          crossAxisSpacing: 20.0, // spacing between columns
          childAspectRatio: 0.72),
      itemCount: productContorller
          .allProductResponse.value.response!.length, // total number of items
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Get.to(() => CanteenProductEditPage(
                product: productContorller
                    .allProductResponse.value.response![index]));
          },
          child: Container(
            decoration: const BoxDecoration(
                color: AppColors.lightColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20))),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(
                flex: 6,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  child: CachedNetworkImage(
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) => SpinKitFadingCircle(
                      color: AppColors.secondaryColor,
                    ),
                    imageUrl: productContorller
                            .allProductResponse.value.response![index].image ??
                        '',
                    fit: BoxFit.fill,
                    width: double.infinity,
                    errorWidget: (context, url, error) =>
                        Icon(Icons.error_outline, size: 40),
                  ),
                ),
              ),
              Expanded(
                  flex: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 8,
                                child: Text(
                                    "${productContorller.allProductResponse.value.response![index].name}",
                                    style: AppStyles.listTilesubTitle),
                              ),
                              Expanded(
                                flex: 2,
                                child: Obx(() => Container(
                                      height: 3.h,
                                      width: 3.h,
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: productContorller
                                                .allProductResponse
                                                .value
                                                .response![index]
                                                .active
                                            ? Colors.green
                                            : Colors.red,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    )),
                              ),
                            ],
                          ),
                          Text(
                              "Rs ${productContorller.allProductResponse.value.response![index].price.toInt()}/plate",
                              style: AppStyles.listTilesubTitle),
                        ]),
                  )),
            ]),
          ),
        );
      },
    );
  }
}
