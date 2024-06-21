import 'package:connect_canteen/app1/cons/style.dart';
import 'package:connect_canteen/app1/model/product_model.dart';
import 'package:connect_canteen/app1/modules/canteen_module.dart/menue/menue_controller.dart';
import 'package:connect_canteen/app1/modules/canteen_module.dart/menue/utils/menue_shrimmer.dart';
import 'package:connect_canteen/app1/modules/student_modules/product_detail/product_detail.dart';
import 'package:connect_canteen/app1/widget/product_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class MenueSection extends StatelessWidget {
  MenueSection({super.key});
  final menueController = Get.put(MenueContorller());

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ProductResponseModel>>(
      stream: menueController.getAllMenue("texasinternationalcollege"),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MenueShrimmer();
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else {
          final menueProducts = snapshot.data!;

          return Padding(
            padding: AppPadding.screenHorizontalPadding,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 2.h,
                  ),
                  SizedBox(height: 1.h),
                  ListView.builder(
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      itemCount: menueProducts.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(
                              left: 2.0, right: 2, bottom: 3),
                          child: Container(
                            child: ListTile(
                              onTap: () {
                                Get.to(() => ProductDetailPage(
                                      product: Products(
                                          type: menueProducts[index].type,
                                          imageUrl:
                                              menueProducts[index].proudctImage,
                                          name: menueProducts[index].name,
                                          price: menueProducts[index].price),
                                    ));
                              },
                              title: Text(
                                menueProducts[index].name,
                                style: TextStyle(
                                    fontSize: 21.sp,
                                    fontWeight: FontWeight.w400),
                              ),
                              subtitle: Text(
                                "Rs. ${menueProducts[index].price}",
                                style: TextStyle(fontSize: 17.sp),
                              ),
                              trailing: CircleAvatar(
                                backgroundColor: Colors.grey[300],
                                child: Icon(
                                  Icons.add,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                          ),
                        );
                      })
                  //
                  // GridView.builder( // Stack(
                  //   children: [
                  //     Container(
                  //       width: 14.h,
                  //       height: 14.h,
                  //       child: CachedNetworkImage(
                  //         progressIndicatorBuilder:
                  //             (context, url, downloadProgress) => Opacity(
                  //           opacity: 0.8,
                  //           child: Shimmer.fromColors(
                  //             baseColor: const Color.fromARGB(255, 248, 246, 246),
                  //             highlightColor: Color.fromARGB(255, 238, 230, 230),
                  //             child: Container(
                  //               decoration: BoxDecoration(
                  //                 borderRadius: BorderRadius.circular(20),
                  //                 color: const Color.fromARGB(255, 243, 242, 242),
                  //               ),
                  //               width: 14.h,
                  //               height: 14.h,
                  //             ),
                  //           ),
                  //         ),
                  //         imageUrl: order.productImage ?? '',
                  //         imageBuilder: (context, imageProvider) => Container(
                  //           decoration: BoxDecoration(
                  //             borderRadius: BorderRadius.circular(20),
                  //             image: DecorationImage(
                  //               image: imageProvider,
                  //               fit: BoxFit.cover,
                  //             ),
                  //           ),
                  //         ),
                  //         fit: BoxFit.fill,
                  //         width: double.infinity,
                  //         errorWidget: (context, url, error) => CircleAvatar(
                  //           radius: 21.4.sp,
                  //           child: Icon(
                  //             Icons.person,
                  //             color: Colors.white,
                  //           ),
                  //           backgroundColor:
                  //               const Color.fromARGB(255, 224, 218, 218),
                  //         ),
                  //       ),
                  //     ),
                  //     Positioned(
                  //         right: 0,
                  //         top: 0,
                  //         child:
                  //             loignController.studentDataResponse.value!.userid ==
                  //                     order.cid
                  //                 ? Container(
                  //                     decoration: BoxDecoration(
                  //                         color: Color.fromARGB(255, 0, 0, 0),
                  //                         borderRadius: BorderRadius.circular(16)),
                  //                     child: Padding(
                  //                       padding: const EdgeInsets.symmetric(
                  //                           horizontal: 6.0, vertical: 1.5),
                  //                       child: Text(
                  //                         "My Order",
                  //                         style: TextStyle(
                  //                             fontSize: 14.sp,
                  //                             fontWeight: FontWeight.w700,
                  //                             color: const Color.fromARGB(
                  //                                 255, 255, 255, 255)),
                  //                       ),
                  //                     ),
                  //                   )
                  //                 : SizedBox.shrink())
                  //   ],
                  // ),
                  //   shrinkWrap: true,
                  //   physics: ScrollPhysics(),
                  //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  //     crossAxisCount: 2, // Number of columns in the grid
                  //     crossAxisSpacing: 20.0, // Spacing between columns
                  //     mainAxisSpacing: 20.sp, // Spacing between rows
                  //     childAspectRatio:
                  //         0.7, // Aspect ratio of grid items (width/height)
                  //   ),
                  //   itemCount: menueProducts.length,
                  //   itemBuilder: (context, index) {
                  //     return GestureDetector(
                  // onTap: () {
                  //   Get.to(() => ProductDetailPage(
                  //         product: Products(
                  //             type: menueProducts[index].type,
                  //             imageUrl: menueProducts[index].proudctImage,
                  //             name: menueProducts[index].name,
                  //             price: menueProducts[index].price),
                  //       ));
                  // },
                  //       child: ProductCard(
                  //         active: true,
                  //         type: menueProducts[index].type,
                  //         name: menueProducts[index].name,
                  //         imageUrl: menueProducts[index].proudctImage,
                  //         price: menueProducts[index].price,
                  //       ),
                  //     );
                  //     ;
                  //   },
                  // ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
