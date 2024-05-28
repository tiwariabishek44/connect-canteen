import 'package:cached_network_image/cached_network_image.dart';
import 'package:connect_canteen/app1/cons/colors.dart';
import 'package:connect_canteen/app1/cons/style.dart';
import 'package:connect_canteen/app1/model/product_model.dart';
import 'package:connect_canteen/app1/modules/our_Proudct/our_product.dart';
import 'package:connect_canteen/app1/modules/student_modules/homepage/detail_poduct_shortcurt.dart';
import 'package:connect_canteen/app1/modules/student_modules/product_detail/product_detail.dart';
import 'package:connect_canteen/app1/modules/wallet/utils/arrow_container.dart';
import 'package:connect_canteen/app1/modules/wallet/utils/balance_card.dart';
import 'package:connect_canteen/app1/utils/date.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class StudentHomePage extends StatelessWidget {
  DateController dateController = Get.put(DateController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        toolbarHeight: 1.0.h,
        backgroundColor: AppColors.backgroundColor,
      ),
      body: Padding(
        padding: AppPadding.screenHorizontalPadding,
        child: ListView(
          children: [
            Obx(() => _buildProfileCard(context, dateController.selectedDate)),
            BalanceCard(),
            SizedBox(height: 3.h),
            Container(
              width: 100.w,
              height: 14.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Color.fromARGB(255, 237, 234, 234).withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3), // changes the position of the shadow
                  ),
                ],
              ),
              child: Text(
                'What do you want to eat today? 🍔',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 25.sp,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 80, 79, 79),
                ),
              ),
            ),
            SizedBox(height: 3.h),
            OurProductsSection(
              products: const [
                // Provide your list of products here
                Product(
                  imageUrl:
                      'https://english.onlinekhabar.com/wp-content/uploads/2018/09/Mexican-Buff-Burger.jpg',
                  name: 'Product 1',
                  price: 19.99,
                ),
                Product(
                  imageUrl:
                      'https://english.onlinekhabar.com/wp-content/uploads/2018/09/Mexican-Buff-Burger.jpg',
                  name: 'Product 1',
                  price: 19.99,
                ),
                Product(
                  imageUrl:
                      'https://english.onlinekhabar.com/wp-content/uploads/2018/09/Mexican-Buff-Burger.jpg',
                  name: 'Product 1',
                  price: 19.99,
                ),
                Product(
                  imageUrl:
                      'https://english.onlinekhabar.com/wp-content/uploads/2018/09/Mexican-Buff-Burger.jpg',
                  name: 'Product 1',
                  price: 19.99,
                ),
                Product(
                  imageUrl:
                      'https://english.onlinekhabar.com/wp-content/uploads/2018/09/Mexican-Buff-Burger.jpg',
                  name: 'Product 1',
                  price: 19.99,
                ),
                Product(
                  imageUrl:
                      'https://english.onlinekhabar.com/wp-content/uploads/2018/09/Mexican-Buff-Burger.jpg',
                  name: 'Product 1',
                  price: 19.99,
                ),

                // Add more products as needed
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context, String date) {
    return Container(
      width: 100.w,
      height: 12.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Color.fromARGB(255, 255, 255, 255),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start, // Added this line
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sumit kumar shresta ! 👋',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 70, 69, 69),
                    ),
                  ),
                  Text(
                    'Class 12',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(179, 50, 49, 49),
                    ),
                  ),
                ],
              ),
            ),
            CircleAvatar(
              radius: 21.sp,
              backgroundColor: Colors.white,
              child: CachedNetworkImage(
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    CircularProgressIndicator(value: downloadProgress.progress),
                imageUrl:
                    'https://res.cloudinary.com/dndtiooiy/image/upload/v1694107077/jcqp06eon60nd99g5i4v.png',
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Icon(
                  Icons.person,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DetailPageController extends GetxController {
  var quantity = 1.obs;

  void increment() => quantity++;
  void decrement() {
    if (quantity > 1) {
      quantity--;
    }
  }
}
