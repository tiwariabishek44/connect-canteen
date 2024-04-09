import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:connect_canteen/app/widget/custom_loging_widget.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:connect_canteen/app/config/colors.dart';
import 'package:connect_canteen/app/config/style.dart';
import 'package:connect_canteen/app/modules/common/login/login_controller.dart';
import 'package:connect_canteen/app/modules/user_module/home/product_controller.dart';
import 'package:connect_canteen/app/widget/loading_screen.dart';
import 'package:connect_canteen/app/widget/no_data_widget.dart';
import 'package:connect_canteen/app/modules/user_module/add_order/view/product_gridview.dart';
import 'package:connect_canteen/app/widget/top_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nepali_utils/nepali_utils.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final homepagecontroller = Get.put(ProductController());
  final loginController = Get.put(LoginController());

  Future<void> _refreshData() async {
    homepagecontroller
        .fetchProducts(); // Fetch data based on the selected category
    loginController.fetchUserData();
  }

  String dat = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    LoginController().fetchUserData();
    return Scaffold(
      backgroundColor:
          AppColors.greyColor, // Make scaffold background transparent
      body: RefreshIndicator(
        onRefresh: () => _refreshData(),
        child: Padding(
          padding: AppPadding.screenHorizontalPadding,
          child: Obx(() {
            if (homepagecontroller.isLoading.value) {
              return LoadingWidget();
            } else {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 3.h,
                          ),
                          CustomTopBar(),
                          SizedBox(
                            height: 2.h,
                          ),
                          SizedBox(
                            width: 70.w,
                            child: Text(
                              "Popular Food Items",
                              style: AppStyles.appbar,
                            ),
                          ),
                          ProductGrid(
                            dat: dat,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }
          }),
        ),
      ),
    );
  }
}
