import 'package:connect_canteen/app1/cons/style.dart';
import 'package:connect_canteen/app1/model/product_model.dart';
import 'package:connect_canteen/app1/modules/canteen_module.dart/menue_edit/menue_edit_controller.dart';
import 'package:connect_canteen/app1/modules/canteen_module.dart/menue_edit/utils/menue_edit_shrimmer.dart';
import 'package:connect_canteen/app1/widget/black_textform_field.dart';
import 'package:connect_canteen/app1/widget/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';

class MenueEditPage extends StatelessWidget {
  MenueEditPage({super.key, required this.productId});
  final String productId;
  final menueEditController = Get.put(MenueEditController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        titleSpacing: 4.0.w,
        title: Text(
          'Setting',
          style: TextStyle(fontWeight: FontWeight.w300),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 4.0.w),
              child: Text(
                'Menue Edit ',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.sp),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: StreamBuilder<ProductResponseModel?>(
          stream: menueEditController.getmenueProduct(
              productId, "texasinternationalcollege"),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const MenueEditShrimmer();
            } else if (snapshot.hasError) {
              return const MenueEditShrimmer();
            } else if (snapshot.data == null) {
              return const Center(
                child: Text(" sorry there is no proudct "),
              );
            }

            final menueProduct = snapshot.data!;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 3.h),
                _buildProductImage(menueProduct),
                _buildDivider(),
                _buildProductDetails(menueProduct),
                _buildStatusBadge(menueProduct),
                _buildDivider(),
                _buildEditControls(menueProduct),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildProductImage(ProductResponseModel product) {
    return Container(
      width: double.infinity,
      height: 200,
      child: CachedNetworkImage(
        progressIndicatorBuilder: (context, url, downloadProgress) => Opacity(
          opacity: 0.8,
          child: Shimmer.fromColors(
            baseColor: const Color.fromARGB(255, 248, 246, 246),
            highlightColor: Color.fromARGB(255, 238, 230, 230),
            child: Container(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 140, 115, 115),
              ),
              width: double.infinity,
              height: 260,
            ),
          ),
        ),
        imageUrl: product.proudctImage ?? '',
        imageBuilder: (context, imageProvider) => Container(
          width: double.infinity,
          height: 260,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(-20),
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
            ),
          ),
        ),
        fit: BoxFit.fill,
        width: double.infinity,
        errorWidget: (context, url, error) => CircleAvatar(
          radius: 21.4.sp,
          child: Icon(
            Icons.person,
            color: Colors.white,
          ),
          backgroundColor: const Color.fromARGB(255, 224, 218, 218),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Container(
              height: 0.5.h,
              width: 20.w,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 0, 0, 0),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
        SizedBox(height: 2.h),
      ],
    );
  }

  Widget _buildProductDetails(ProductResponseModel product) {
    return Padding(
      padding: AppPadding.screenHorizontalPadding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 70, 69, 69),
                  ),
                ),
                Text(
                  '/plate',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(179, 50, 49, 49),
                  ),
                ),
              ],
            ),
          ),
          Text(
            "Rs.${product.price}",
            style: TextStyle(fontSize: 19.sp, fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(ProductResponseModel product) {
    return Align(
      alignment: Alignment.topRight,
      child: Container(
        margin: EdgeInsets.all(16),
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: product.active ? Colors.green : Colors.red,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(
          product.active ? 'Product is LIVE' : "Product is OFF",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildEditControls(ProductResponseModel product) {
    return Padding(
      padding: AppPadding.screenHorizontalPadding,
      child: Column(
        children: [
          SizedBox(height: 4.h),
          _buildAvailabilityToggle(product),
          SizedBox(height: 4.h),
          _buildPriceUpdateForm(product),
          SizedBox(height: 4.h),
          CustomButton(
            isLoading: false,
            text: 'Update Price',
            onPressed: () {
              menueEditController.doPriceUpdate(
                product.productId,
                product.price,
              );
            },
          ),
          SizedBox(height: 10.h),
        ],
      ),
    );
  }

  Widget _buildAvailabilityToggle(ProductResponseModel product) {
    return Row(
      children: [
        Text(
          'Update the product state',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        Spacer(),
        Switch(
          value: product.active,
          onChanged: (value) {
            menueEditController.updateProductActiveStatus(
              product.productId,
              !product.active,
            );
          },
        ),
      ],
    );
  }

  Widget _buildPriceUpdateForm(ProductResponseModel product) {
    return Form(
      key: menueEditController.priceFormKey,
      child: BlackTextFormField(
        textInputType: TextInputType.number,
        hintText: "New Price",
        controller: menueEditController.priceController,
        validatorFunction: (String? value) {
          if (value == null || value.isEmpty) {
            return 'Please enter a price';
          }
          if (double.tryParse(value) == null) {
            return 'Please enter a valid number';
          }
          return null;
        },
        actionKeyboard: TextInputAction.next,
        onSubmitField: () {},
      ),
    );
  }
}
