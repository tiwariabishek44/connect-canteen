import 'package:connect_canteen/app1/model/order_model.dart';
import 'package:connect_canteen/app1/modules/student_modules/cart/utils/emptycart.dart';
import 'package:connect_canteen/app1/modules/student_modules/order/order_controller.dart';
import 'package:connect_canteen/app1/modules/student_modules/order/utils/order_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class StudentOrdersPage extends StatelessWidget {
  final controller = Get.put(StudentOrderController());

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: _buildAppBar(context),
        body: TabBarView(
          children: [
            _buildOrdersList(isActive: true),
            _buildOrdersList(isActive: false),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      titleSpacing: 4.0.w,
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(100.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 4.0.w, bottom: 16),
              child: Text(
                'Track Your Orders',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24.sp,
                ),
              ),
            ),
            TabBar(
              labelColor: Theme.of(context).primaryColor,
              unselectedLabelColor: Colors.grey[600],
              indicatorColor: Theme.of(context).primaryColor,
              tabs: [
                Tab(text: 'Active Orders'),
                Tab(text: 'History'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrdersList({required bool isActive}) {
    return StreamBuilder<List<OrderResponse>>(
      stream: isActive
          ? controller.getActiveOrders()
          : controller.getOrderHistory(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            ),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error loading orders: ${snapshot.error}',
              style: TextStyle(
                color: Colors.red[400],
                fontSize: 16.sp,
              ),
            ),
          );
        }

        final orders = snapshot.data ?? [];
        if (orders.isEmpty) {
          return EmptyOrdersWidget(isHistory: !isActive);
        }

        return ListView.separated(
          padding: EdgeInsets.all(16),
          itemCount: orders.length,
          separatorBuilder: (context, index) =>
              Divider(height: 0, color: Colors.transparent),
          itemBuilder: (context, index) => OrderTiles(
            order: orders[index],
          ),
        );
      },
    );
  }
}
