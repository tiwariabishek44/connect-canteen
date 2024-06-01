import 'package:connect_canteen/app/config/style.dart';
import 'package:connect_canteen/app1/cons/colors.dart';
import 'package:connect_canteen/app1/widget/product_card.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';

class MenueShrimmer extends StatelessWidget {
  const MenueShrimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 3.w, right: 3.w, top: 2.h),
      child: GridView.builder(
        physics: ScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Number of columns in the grid
          crossAxisSpacing: 20.0, // Spacing between columns
          mainAxisSpacing: 20.sp, // Spacing between rows
          childAspectRatio: 0.7, // Aspect ratio of grid items (width/height)
        ),
        itemCount: 6,
        itemBuilder: (context, index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Section
              Stack(
                children: [
                  Shimmer.fromColors(
                    baseColor: const Color.fromARGB(255, 248, 246, 246),
                    highlightColor: Color.fromARGB(255, 230, 227, 227),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Container(
                          color: AppColors.shrimmerColorText,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                      right: 2.w,
                      bottom: 0.3.h,
                      child: CircleAvatar(
                        radius: 17,
                        backgroundColor: Color.fromARGB(255, 232, 234, 232),
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                      )),
                ],
              ),
              SizedBox(height: 8.0),
              Shimmer.fromColors(
                baseColor: const Color.fromARGB(255, 248, 246, 246),
                highlightColor: Color.fromARGB(255, 230, 227, 227),
                child: Padding(
                  padding: EdgeInsets.all(8.0.sp),
                  child: Container(
                    color: AppColors.shrimmerColorText,
                    child: Text(
                      'Samosa Acha  ',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: AppColors.shrimmerColorText,
                        fontSize: 17.0.sp,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ),
              ),
              // Product Name

              // Price and Add to Cart Button Row
              Shimmer.fromColors(
                baseColor: const Color.fromARGB(255, 248, 246, 246),
                highlightColor: Color.fromARGB(255, 230, 227, 227),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Price
                    Container(
                      color: AppColors.shrimmerColorText,
                      child: Text(
                        '\Rs.300',
                        style: TextStyle(
                            fontSize: 16.0.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.shrimmerColorText),
                      ),
                    ),
                    // Add to Cart Button
                    Row(
                      children: [
                        Container(
                          width: 19.0,
                          height: 19.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.shrimmerColorText,
                          ),
                          child: Center(
                            child: Icon(
                              Icons.circle, // Use an appropriate icon

                              color: AppColors.shrimmerColorText,
                              size: 9.0,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 1.w,
                        ),
                        Container(
                          color: AppColors.shrimmerColorText,
                          child: Text(
                            'VEG',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 15.sp,
                              color: AppColors.shrimmerColorText,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
          ;
        },
      ),
    );
  }
}
