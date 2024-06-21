import 'package:connect_canteen/app/widget/custom_loging_widget.dart';
import 'package:connect_canteen/app1/cons/colors.dart';
import 'package:connect_canteen/app1/model/product_model.dart';
import 'package:connect_canteen/app1/model/student_model.dart';
import 'package:connect_canteen/app1/modules/common/wallet/transcton_controller.dart';
import 'package:connect_canteen/app1/modules/student_modules/group/group_controller.dart';
import 'package:connect_canteen/app1/modules/student_modules/product_detail/controller.dart';
import 'package:connect_canteen/app1/modules/student_modules/product_detail/utils/info_widget.dart';
import 'package:connect_canteen/app1/modules/student_modules/product_detail/utils/update_profile_popup.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class OrderFriendList extends StatelessWidget {
  final String groupid;
  final bool forOrder;
  final Products product;
  final String host;
  OrderFriendList(
      {super.key,
      required this.host,
      required this.groupid,
      this.forOrder = true,
      required this.product});
  final groupController = Get.put(GroupController());
  final addOrderControllre = Get.put(AddOrderController());
  final transctionContorller = Get.put(TransctionController());

  @override
  Widget build(BuildContext context) {
    DateTime nowUtc = DateTime.now().toUtc();
    DateTime nowNepal = nowUtc.add(Duration(hours: 5, minutes: 45));
    final todayDate = "${nowNepal.day}/${nowNepal.month}/${nowNepal.year}";

    return Stack(
      children: [
        Scaffold(
          backgroundColor: AppColors.backgroundColor,
          appBar: AppBar(
            backgroundColor: AppColors.backgroundColor,
            title: Text('Order Friend List'),
          ),
          body: StreamBuilder<List<StudentDataResponse>>(
            stream: groupController.getMemberStream(groupid),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SizedBox.shrink();
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              } else {
                final students = snapshot.data!;

                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: students.length,
                  itemBuilder: (context, index) {
                    StudentDataResponse student = students[index]!;

                    return Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
                      child: GestureDetector(
                        onTap: () {},
                        child: Container(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      student.name,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 19.0.sp,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          '${student.phone}',
                                          style: TextStyle(
                                            fontSize: 17.0.sp,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        const SizedBox(width: 5.0),
                                        student.userid == student.groupid
                                            ? const CircleAvatar(
                                                radius: 7.5,
                                                backgroundColor: Color.fromARGB(
                                                    255,
                                                    72,
                                                    2,
                                                    129), // Adjust color as needed
                                                child: Icon(
                                                  Icons.shield_outlined,
                                                  color: Colors.white,
                                                  size: 15,
                                                ),
                                              )
                                            : SizedBox.shrink()
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  addOrderControllre.isLoading.value = true;
                                  bool ispermission = await addOrderControllre
                                      .isPermission(student.userid);
                                  int tobalBalance =
                                      await transctionContorller.friendBalance(
                                          student.userid, student.schoolId);
                                  if (ispermission &&
                                      addOrderControllre.quantity.value <= 1) {
                                    if (tobalBalance <= 45) {
                                      addOrderControllre.isLoading.value =
                                          false;
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return InfoDialog(
                                            message:
                                                'Sorry no sufficient balance.',
                                          );
                                        },
                                      );
                                    } else if (student.classes == ''
                                        // ||
                                        //     student.profilePicture == ''
                                        ) {
                                      addOrderControllre.isLoading.value =
                                          false;

                                      showUpdateProfileDialog(Get.context!);
                                    } else {
                                      await addOrderControllre.addItemToOrder(
                                          Get.context!,
                                          orderby: host,
                                          groupName: student.groupname,
                                          customerImage: student.profilePicture,
                                          classs: student.classes,
                                          customer: student.name,
                                          groupid: student.groupid,
                                          cid: student.userid,
                                          productName: product.name,
                                          productImage: product.imageUrl,
                                          price: (product.price.toInt() *
                                                  addOrderControllre
                                                      .quantity.value)
                                              .toDouble(),
                                          quantity:
                                              addOrderControllre.quantity.value,
                                          groupcod: student.groupcod,
                                          checkout: 'false',
                                          mealtime:
                                              addOrderControllre.mealtime.value,
                                          date: todayDate,
                                          orderHoldTime: '',
                                          scrhoolrefrenceid: student.schoolId);
                                    }
                                  } else {
                                    addOrderControllre.isLoading.value = false;
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return InfoDialog(
                                          message:
                                              'Your order quota has been exceeded.',
                                        );
                                      },
                                    );
                                  }
                                },
                                child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5.0),
                                      color: Color(0xFF123456),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Text("Order ",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w800,
                                            fontSize: 15.0.sp,
                                          )),
                                    )),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
            },
          ),
        ),
        Positioned(
            top: 40.h,
            left: 40.w,
            child: Obx(() => addOrderControllre.isLoading.value
                ? LoadingWidget()
                : SizedBox.shrink()))
      ],
    );
  }
}
