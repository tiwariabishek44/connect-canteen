import 'package:cached_network_image/cached_network_image.dart';
import 'package:connect_canteen/app1/cons/colors.dart';
import 'package:connect_canteen/app1/model/wallet_model.dart';
import 'package:connect_canteen/app1/modules/common/wallet/balance_load.dart';
import 'package:connect_canteen/app1/modules/common/wallet/utils/balance_card.dart';
import 'package:connect_canteen/app1/modules/common/wallet/utils/transctionItems.dart';
import 'package:connect_canteen/app1/modules/common/wallet/utils/transction_shrimmer.dart';
import 'package:connect_canteen/app1/modules/common/wallet/transcton_controller.dart';
import 'package:connect_canteen/app1/modules/student_modules/coin%20collect/utils/coin_card.dart';
import 'package:connect_canteen/app1/widget/product_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';

class CoinCollectPage extends StatefulWidget {
  final String userId;

  CoinCollectPage({
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
  _CoinCollectPageState createState() => _CoinCollectPageState();
}

class _CoinCollectPageState extends State<CoinCollectPage> {
  final transctionController = Get.put(TransctionController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        elevation: 0,
        backgroundColor: Colors.white,
        titleSpacing: 4.0, // Adjusts the spacing above the title
        title: Text(
          "Coins",
          style: TextStyle(fontWeight: FontWeight.w300),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 4.0.w),
              child: Text(
                'Redeem your coins here!',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 21.sp),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 1.h),
              CoinCard(
                userid: widget.userId,
              ),
              SizedBox(height: 3.h),
              Text('Gifts for you',
                  style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
              SizedBox(height: 3.h),
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
                itemCount: 1,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {},
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Image Section
                        Stack(
                          children: [
                            AspectRatio(
                              aspectRatio: 1,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
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
                                  imageUrl:
                                      "https://tb-static.uber.com/prod/image-proc/processed_images/bd14a0d999de83c417a0d009b2b36ac9/b4facf495c22df52f3ca635379ebe613.jpeg" ??
                                          '',
                                  fit: BoxFit.fill,
                                  width: double.infinity,
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error_outline, size: 40),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.0),
                        // Product Name
                        Text(
                          'Chicken Momo',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Color.fromARGB(255, 74, 74, 74),
                            fontSize: 17.0.sp,
                            fontWeight: FontWeight.w300,
                          ),
                        ),

                        // Price and Add to Cart Button Row
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
