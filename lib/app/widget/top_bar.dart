import 'package:cached_network_image/cached_network_image.dart';
import 'package:connect_canteen/app/config/style.dart';
import 'package:connect_canteen/app/modules/common/login/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:connect_canteen/app/widget/custom_loging_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';

class CustomTopBar extends StatelessWidget implements PreferredSizeWidget {
  final logincontroller = Get.put(LoginController());

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Color(0xff06C167),
        child: Obx(() {
          if (logincontroller.isFetchLoading.value) {
            return LoadingWidget();
          } else {
            double percentage = (logincontroller
                    .userDataResponse.value.response!.first.studentScore /
                3);
            Color indicatorColor = percentage > 0.5 ? Colors.green : Colors.red;
            return Column(
              children: [
                SizedBox(
                  height: 5.h,
                ),
                Padding(
                  padding: AppPadding.screenHorizontalPadding,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color.fromARGB(255, 134, 29, 29),
                        ),
                        child: CircleAvatar(
                          radius: 22.sp,
                          backgroundColor: Colors.white,
                          child: CachedNetworkImage(
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) => Opacity(
                              opacity: 0.8,
                              child: Shimmer.fromColors(
                                baseColor: Colors.black12,
                                highlightColor: Colors.red,
                                child: Container(),
                              ),
                            ),
                            imageUrl: logincontroller.userDataResponse.value
                                    .response!.first.profilePicture ??
                                '',
                            imageBuilder: (context, imageProvider) => Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle, // Apply circular shape
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
                              backgroundColor:
                                  const Color.fromARGB(255, 224, 218, 218),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 3.w,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Hi,${logincontroller.userDataResponse.value.response!.first.name}",
                            textAlign: TextAlign
                                .center, // Centers text within the container
                            style: AppStyles.appbar,
                          ),
                          Text(
                            logincontroller
                                .userDataResponse.value.response!.first.classes,
                            textAlign: TextAlign
                                .center, // Centers text within the container
                            style: AppStyles.listTilesubTitle1,
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    height: 8.h,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(
                          255, 84, 84, 83), // Deep dark blue color
                      borderRadius: BorderRadius.circular(
                          20), // Adjust this value for curved edges
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Your Score ',
                          style: AppStyles.listTileTitle1,
                        ),
                        SizedBox(width: 20),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 6.h,
                              height: 6.h,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey[300],
                              ),
                            ),
                            Container(
                              width: 5.h,
                              height: 5.h,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.transparent,
                                border: Border.all(
                                  color: indicatorColor,
                                  width: 4,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  logincontroller.userDataResponse.value
                                      .response!.first.studentScore
                                      .toString(),
                                  style: TextStyle(
                                    color: indicatorColor,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 1.h,
                )
              ],
            );
          }
        }));
  }
}
