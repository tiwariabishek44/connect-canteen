import 'package:cached_network_image/cached_network_image.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:connect_canteen/app/config/colors.dart';
import 'package:connect_canteen/app/config/style.dart';
import 'package:connect_canteen/app/models/order_response.dart';
import 'package:connect_canteen/app/modules/student_modules/order_history/order_history_controller.dart';
import 'package:connect_canteen/app/widget/custom_loging_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class OrderHistoryPage extends StatelessWidget {
  final historyController = Get.put(HistoryController());

  Future<void> _refreshData() async {
    historyController.fetchGroupHistoryOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Container(
            child: Center(
              child: IconButton(
                icon: Icon(
                  Icons.chevron_left,
                  size: 26.sp,
                ),
                onPressed: () {
                  Get.back();
                },
              ),
            ),
          ),
        ),
        centerTitle: false,
        scrolledUnderElevation: 0,
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        title: Text(
          'Order History',
          style: AppStyles.appbar,
        ),
      ),
      body: Padding(
        padding: AppPadding.screenHorizontalPadding,
        child: buildGroupOrderTab(context),
      ),
    );
  }

  Widget buildGroupOrderTab(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => _refreshData(),
      child: SizedBox(
        width: double.infinity,
        child: Obx(() {
          if (historyController.isLoading.value) {
            return LoadingWidget();
          } else {
            if (!historyController.isdata.value) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shopping_cart_outlined,
                      size: 100.0,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 20.0),
                    Text(
                      'There is no checkout till now.',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 20.0,
                      ),
                    ),
                  ],
                ),
              );
            } else {
              // Sort orders by date in descending order
              List<OrderResponse> allOrders =
                  historyController.orderHistoryResponse.value.response!;
              allOrders.sort((a, b) => b.date.compareTo(a.date));

              // Group orders by date
              Map<String, List<OrderResponse>> groupedOrders = {};
              allOrders.forEach((order) {
                String date = order.date; // Assuming date is a string
                if (!groupedOrders.containsKey(date)) {
                  groupedOrders[date] = [];
                }
                groupedOrders[date]!.add(order);
              });

              // Extract unique dates and sort them
              List<String> dates = groupedOrders.keys.toList();
              dates.sort((a, b) => b.compareTo(a));

              // Build the ListView with date headers
              return ListView.builder(
                shrinkWrap: true,
                physics: ScrollPhysics(),
                itemCount: dates.length,
                itemBuilder: (context, index) {
                  String date = dates[index];
                  List<OrderResponse> orders = groupedOrders[date]!;

                  // Build date header and order items for each date
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Date header
                      Padding(
                        padding: EdgeInsets.only(top: 2.h),
                        child: Text(
                          date,
                          style: AppStyles.listTileTitle,
                        ),
                      ),
                      // Order items
                      ...orders.map((order) => buildItemWidget(order)).toList(),
                      SizedBox(
                        height: 1.h,
                      ),
                      const Divider(
                        height: 0.3,
                        thickness: 0.1,
                        color: AppColors.iconColors,
                      )
                    ],
                  );
                },
              );
            }
          }
        }),
      ),
    );
  }

  Widget buildItemWidget(OrderResponse item) {
    return Padding(
      padding: EdgeInsets.only(top: 1.0.h),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white, // Background color of the container
              borderRadius:
                  BorderRadius.circular(10), // Border radius if needed
              boxShadow: [
                BoxShadow(
                  color: Color.fromARGB(255, 242, 240, 240)
                      .withOpacity(0.5), // Shadow color
                  spreadRadius: 5, // Spread radius
                  blurRadius: 7, // Blur radius
                  offset: Offset(0, 3), // Offset
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7),
                        color: Colors.white, // Add a background color
                      ),
                      height: 12.h,
                      width: 30.w,
                      child: ClipRRect(
                        // Use ClipRRect to ensure that the curved corners are applied
                        borderRadius: BorderRadius.circular(7),
                        child: CachedNetworkImage(
                          imageUrl: item.productImage ?? '',
                          fit: BoxFit.cover,
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error_outline, size: 40),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 2.w,
                  ),
                  Expanded(
                    flex: 7,
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.productName,
                            maxLines: 2,
                            overflow: TextOverflow
                                .ellipsis, // Use ellipsis (...) for overflow
                            style: AppStyles.listTileTitle,
                          ),
                          Text(
                            'Rs.${item.price.toStringAsFixed(2)}',
                            style: AppStyles.listTilesubTitle1,
                          ),
                          Text('${item.customer}',
                              style: AppStyles.listTilesubTitle1),
                          Text(
                            '${item.date} (${item.mealtime})',
                            style: AppStyles.listTilesubTitle1,
                          ),
                          item.holdDate != '' || item.holdDate.isNotEmpty
                              ? Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.green,
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 0.1.h, horizontal: 2.w),
                                    child: Text("Hold:${item.holdDate}",
                                        style: AppStyles.listTilesubTitle),
                                  ),
                                )
                              : Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Color.fromARGB(255, 216, 188, 27),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 0.1.h, horizontal: 2.w),
                                    child: Text(
                                      "Regular",
                                      style: AppStyles.listTilesubTitle,
                                    ),
                                  ),
                                )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 5,
            right: 5,
            child: Container(
              height: 5.h,
              width: 5.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
              ),
              child: ClipOval(
                child: CachedNetworkImage(
                  imageUrl: item.customerImage ?? '',
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) =>
                      Icon(Icons.error_outline, size: 40),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
