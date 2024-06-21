import 'package:connect_canteen/app/widget/custom_loging_widget.dart';
import 'package:connect_canteen/app1/cons/colors.dart';
import 'package:connect_canteen/app1/modules/canteen_module.dart/menue_add/menue_add_controller.dart';
import 'package:connect_canteen/app1/widget/black_textform_field.dart';
import 'package:connect_canteen/app1/widget/custom_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class MenueAddPage extends StatelessWidget {
  MenueAddPage({super.key});
  final menueAddController = Get.put(MenueAddController());
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
                children: [
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
                      isLoading: false)
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
