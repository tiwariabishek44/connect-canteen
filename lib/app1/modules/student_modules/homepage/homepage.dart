import 'dart:developer';
 

import 'package:cached_network_image/cached_network_image.dart';
import 'package:connect_canteen/app/config/prefs.dart';
import 'package:connect_canteen/app1/model/student_model.dart';
import 'package:connect_canteen/app1/modules/common/login/login_controller.dart';
import 'package:connect_canteen/app1/cons/colors.dart';
import 'package:connect_canteen/app1/cons/style.dart';
import 'package:connect_canteen/app1/model/product_model.dart';
import 'package:connect_canteen/app1/modules/student_modules/menue_product/menue_product.dart';
import 'package:connect_canteen/app1/modules/common/wallet/utils/balance_card.dart';
import 'package:connect_canteen/app1/utils/date.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class StudentHomePage extends StatelessWidget {
  final storage = GetStorage();
  DateController dateController = Get.put(DateController());
  final loignController = Get.put(LoginController());
  
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
            SizedBox(
              height: 3.h,
            ),
_buildProfileCard(context),
      
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
                  fontWeight: FontWeight.w400,
                  color: Color.fromARGB(255, 80, 79, 79),
                ),
              ),
            ),
            SizedBox(height: 3.h),
            MenueSection(
              products: const [
                // Provide your list of products here
                Products(
                  type: "VEG",
                  imageUrl:
                      'https://tb-static.uber.com/prod/image-proc/processed_images/738d85f881e2063a399fa8858183c06e/b4facf495c22df52f3ca635379ebe613.jpeg',
                  name: 'Product 1',
                  price: 19.99,
                ),
                Products(
                  type: "VEG",
                  imageUrl:
                      'https://tb-static.uber.com/prod/image-proc/processed_images/12a65c8086d9349620e7af6453fecd3a/859baff1d76042a45e319d1de80aec7a.jpeg',
                  name: 'Product 1',
                  price: 19.99,
                ),
                Products(
                  type: "NON",
                  imageUrl:
                      'https://tb-static.uber.com/prod/image-proc/processed_images/a306037b3802d6bada1729e55a8b016f/9b3aae4cf90f897799a5ed357d60e09d.jpeg',
                  name: 'Samosa Achar ',
                  price: 19.99,
                ),
                Products(
                    type: "VEG",
                    imageUrl:
                        'https://d1ralsognjng37.cloudfront.net/d65ca498-dba0-4033-a21d-d550e567842c.jpeg',
                    name: "Veg-Fried Rice",
                    price: 60),

                Products(
                    type: "VEG",
                    imageUrl:
                        "https://media-cdn.tripadvisor.com/media/photo-m/1280/1b/57/52/cb/roti-and-tarkari-vegan.jpg",
                    name: 'Roti Tarkari',
                    price: 140),                

                // Add more products as needed
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context) {
    return StreamBuilder<StudentDataResponse?>(
      stream: loignController.getStudetnData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container();
        } else if (snapshot.hasError) {
          return SizedBox.shrink();
        } else if (snapshot.data == null) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '\Rs.0', // Display total balance
                style: TextStyle(
                  fontSize: 38,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              Text(
                'Wallet BALANCE',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                ),
              ),
              SizedBox(height: 30),
            ],
          );
        } else {
          StudentDataResponse studetnData = snapshot.data!;
          log("${loignController.studentDataResponse.value!.classes}");

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
                          '${studetnData.name}! 👋',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w400,
                            color: Color.fromARGB(255, 70, 69, 69),
                          ),
                        ),
                        Text(
                          '${studetnData.classes}',
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
                    child: studetnData.name == ''
                        ? CircleAvatar(
                            radius: 21.sp,
                            backgroundColor: Colors.white,
                          )
                        : CachedNetworkImage(
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) =>
                              CircularProgressIndicator(
                                  value: downloadProgress.progress),
                      imageUrl:
 studetnData.profilePicture,
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
      },
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
